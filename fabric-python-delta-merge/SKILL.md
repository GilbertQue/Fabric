---
name: fabric-python-delta-merge
description: Pure-Python incremental merge pattern for any DataFrame into a Microsoft Fabric Lakehouse Delta table. Use when the caller already has a new pandas DataFrame and needs to upsert it via deltalake merge on a key (usually id). Supports optional watermark lookup with DuckDB delta_scan. Triggers on Fabric pure Python notebook, deltalake merge, incremental load, Lakehouse upsert, DuckDB OneLake, any source to Delta.
---

# Fabric Lakehouse – Pure Python Delta Merge (Any Source)

Reusable pattern for pure-Python Fabric notebooks.  
You prepare the new DataFrame however you like (API, file, SQL, another notebook, etc.).  
This skill only handles:

1. (Optional) Reading the current watermark from the target Delta table
2. Merging the new DataFrame into the Lakehouse table with `deltalake`

## When to Use

- Any incremental or upsert load into a Lakehouse Delta table
- Preference for pure Python (no Spark session required)
- You already have (or can easily produce) a pandas DataFrame of new/changed rows
- You want true merge semantics (`when_matched_update_all` + `when_not_matched_insert_all`)

## Required Packages

- `duckdb` (only if you need the watermark)
- `deltalake`
- `pyarrow`
- `pandas`
- `notebookutils` (built-in)

Recommended kernel: Python 3.12

## Core Pattern

### 1. Configuration

```python
workspace_guid = "FILL_ME_IN"   # change per environment
lakehouse_guid = "FILL_ME_IN"    # change per environment
TABLE_NAME     = "FILL_ME_IN"                        # target Delta table
merge_key      = "id"                                     # column used for matching

TABLE_ABFS_PATH = f"abfss://{workspace_guid}@onelake.dfs.fabric.microsoft.com/{lakehouse_guid}/Tables/{TABLE_NAME}"
```

### 2. Optional – Get watermark (MAX of a date/timestamp column, with lookback)

Use this when the upstream source supports filtering by last-updated timestamp. A lookback window
(subtracted from the watermark) re-pulls a few recent days to absorb any late-arriving/updated rows
that landed after the last run — cheaper than a full reload and still correct under MERGE semantics.

```python
from datetime import datetime, timedelta
import duckdb
import pandas as pd
import notebookutils

FALLBACK_START = datetime(2024, 1, 1)
LOOKBACK_DAYS = 3       # re-pull this many days before the watermark
FORCE_FULL = False      # set True to ignore the watermark and reload from FALLBACK_START

def get_watermark(
    table_path: str,
    watermark_col: str = "updatedAt",
    fallback_col: str = "createdAt",
    fallback: datetime = FALLBACK_START,
    lookback_days: int = LOOKBACK_DAYS,
    force_full: bool = FORCE_FULL,
):
    """
    Returns RANGE_START = MAX(watermark_col) - lookback_days.
    Falls back to fallback_col, then to `fallback`, if the table/column is empty or missing.
    One lakehouse read only (one delta_scan call per attempted column).
    """
    if force_full:
        print(f"FORCE_FULL -> {fallback}")
        return fallback

    storage_token = notebookutils.credentials.getToken("storage")
    con = duckdb.connect()
    con.execute(f"""
        SET home_directory = '';
        CREATE OR REPLACE SECRET onelake_secret (
            TYPE AZURE,
            PROVIDER ACCESS_TOKEN,
            ACCESS_TOKEN '{storage_token}'
        );
    """)

    def _max_col(col: str):
        return con.execute(f"""
            SELECT MAX(CAST({col} AS TIMESTAMP)) AS MaxDate
            FROM delta_scan('{table_path}')
            WHERE {col} IS NOT NULL
              AND CAST({col} AS VARCHAR) NOT IN ('None', '', 'NaT', 'nat', 'nan')
        """).fetchdf()

    try:
        df_max = _max_col(watermark_col)
        if df_max.empty or pd.isna(df_max["MaxDate"].iloc[0]):
            if fallback_col and fallback_col != watermark_col:
                df_max = _max_col(fallback_col)
        if df_max.empty or pd.isna(df_max["MaxDate"].iloc[0]):
            print(f"Empty watermark -> {fallback}")
            return fallback
        max_ts = pd.to_datetime(df_max["MaxDate"].iloc[0]).to_pydatetime()
        range_start = max_ts - timedelta(days=lookback_days)
        print(f"watermark={max_ts} -> RANGE_START={range_start} (lookback {lookback_days}d)")
        return range_start
    except Exception as exc:
        print(f"Watermark failed ({exc}) -> {fallback}")
        return fallback
```

Usage:

```python
RANGE_START = get_watermark(TABLE_ABFS_PATH, watermark_col="updatedAt")
# Now use RANGE_START to filter your source (API, SQL, etc.)
```

### 3. Prepare your new DataFrame

This part is **your responsibility**. Examples:

- Call an API and flatten the response
- Read a CSV / Parquet / Excel
- Query another system
- Transform data already in memory

```python
# Example only – replace with your real logic
new_df = pd.DataFrame(...)          # must contain the merge_key column
# Optional: force string types if required by downstream consumers
# new_df = new_df.astype(str)
```

### 4. Merge function (the core reusable piece)

Use the `metrics` dict returned by `.execute()` instead of reading `to_pyarrow_table().num_rows`
before/after — that avoids materializing the whole table twice just to count rows, which is the
biggest speed win for large tables.

```python
from deltalake import DeltaTable, write_deltalake
import pyarrow as pa
import notebookutils

def merge_to_lakehouse(
    new_df: pd.DataFrame,
    table_path: str,
    merge_key: str = "id",
    force_string: bool = False
):
    """
    Upsert new_df into the Delta table at table_path.
    - Matched rows  → update all columns
    - Unmatched rows → insert
    """
    if new_df is None or new_df.empty:
        print("No rows to merge.")
        return

    if force_string:
        new_df = new_df.astype(str)

    access_token = notebookutils.credentials.getToken('storage')
    storage_options = {
        "bearer_token": access_token,
        "use_fabric_endpoint": "true"
    }

    table = pa.Table.from_pandas(new_df)

    try:
        dt = DeltaTable(table_path, storage_options=storage_options)
    except Exception:
        write_deltalake(table_path, table, mode="overwrite", storage_options=storage_options)
        print(f"Created table, rows={len(new_df):,}")
        return

    # merge() metrics avoid materializing the whole table twice just to count rows
    metrics = (
        dt.merge(
            source=table,
            predicate=f"target.{merge_key} = source.{merge_key}",
            source_alias="source",
            target_alias="target",
        )
        .when_matched_update_all()
        .when_not_matched_insert_all()
        .execute()
    )
    print(
        f"MERGE in={len(new_df):,} inserted={metrics['num_target_rows_inserted']:,} "
        f"updated={metrics['num_target_rows_updated']:,} ({metrics['execution_time_ms']} ms)"
    )
```

### 5. Typical orchestration

If `your_source_function` calls an external API, re-authenticate (fetch a fresh token) before
retrying on an `HTTPError` rather than reusing the same token — a stale/expired token is a common
cause of an error that a same-token retry will never fix.

```python
# 1. Optional watermark
RANGE_START = get_watermark(TABLE_ABFS_PATH, "updatedAt")

# 2. You build the new DataFrame however you want
try:
    new_df = your_source_function(RANGE_START)   # ← your code
except requests.HTTPError as exc:
    print(f"fetch failed ({exc}); re-authenticating and retrying")
    new_df = your_source_function(RANGE_START)   # ← your code should re-fetch a fresh token internally

# 3. Merge
merge_to_lakehouse(new_df, TABLE_ABFS_PATH, merge_key="id")
```

## Design Notes & Gotchas

- **You own the DataFrame**. This skill deliberately does **not** contain source-specific extraction logic (API auth, pagination, SQL, file parsing, etc.).
- **Merge key** must exist in both the target table and the incoming DataFrame and should be unique.
- **Schema**: If you need every column as string (common for some landing tables), set `force_string=True`.
- **First load**: When the table does not exist, the function creates it with `append`. Subsequent runs do a proper merge.
- **Watermark column**: Defaults to `updatedAt`. Change the parameter if your table uses `ModifiedDate`, `last_updated`, etc.
- **Lookback window**: Subtract a few days (`LOOKBACK_DAYS`) from the watermark before filtering the source — re-pulling a short overlap is far cheaper than a full reload and MERGE makes it idempotent.
- **Merge speed**: Read `metrics['num_target_rows_inserted']` / `num_target_rows_updated']` from `.execute()` instead of calling `to_pyarrow_table().num_rows` before and after — the count-based approach materializes the whole table twice.
- **Performance**: For very large DataFrames consider partitioning or using Spark instead. This pure-Python path is ideal for moderate volumes (thousands to low hundreds of thousands of rows).
- **Testing**: Always point `TABLE_NAME` at a `_Test` or `_V2` table first.
- **Python version**: Prefer 3.12.

## Related Skills

- `microsoft-fabric` – broader Fabric architecture, governance, DirectLake, etc.
- `primeeco-fabric-incremental` – specialized version that also contains the PrimeEco API extraction logic.
