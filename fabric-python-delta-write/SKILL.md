---
name: fabric-python-write-delta
description: Pure-Python pattern to write any pandas DataFrame to a Microsoft Fabric Lakehouse Delta table using deltalake. Supports overwrite and append modes, optional schema, and ABFS path construction. Triggers on write DataFrame to Lakehouse, pure Python notebook write, deltalake write_deltalake, Fabric overwrite table, staging table load.
---

# Fabric Lakehouse – Pure Python Write DataFrame to Delta

Reusable pattern for writing **any** pandas DataFrame into a Microsoft Fabric Lakehouse Delta table using pure Python (`deltalake` + `notebookutils`). No Spark session required.

## When to Use

- You already have a pandas DataFrame in a pure-Python Fabric notebook
- You want to land it as a Delta table (overwrite or append)
- Prefer simple, reliable writes without Spark
- Staging tables, report tables, or one-off loads

## Required Packages

- `deltalake`
- `pyarrow`
- `pandas`
- `notebookutils` (built-in)
- `duckdb` (optional – only if you want an intermediate SQL step)

Recommended kernel: Python 3.12

## Core Pattern

### 1. Configuration

```python
WORKSPACE_ID   = "FILL_ME_IN"   # change per environment
LAKEHOUSE_ID   = "FILL_ME_IN"    # change per environment
SCHEMA_NAME    = "FILL_ME_IN"                                     # optional – set to "staging" etc. or leave None
TABLE_NAME     = "Report_User_Access"                     # target table name

# Build ABFS path
if SCHEMA_NAME:
    table_path = f"abfss://{WORKSPACE_ID}@onelake.dfs.fabric.microsoft.com/{LAKEHOUSE_ID}/Tables/{SCHEMA_NAME}/{TABLE_NAME}"
else:
    table_path = f"abfss://{WORKSPACE_ID}@onelake.dfs.fabric.microsoft.com/{LAKEHOUSE_ID}/Tables/{TABLE_NAME}"
```

### 2. Write function (recommended reusable helper)

```python
from deltalake import write_deltalake
import pyarrow as pa
import pandas as pd
import notebookutils

def write_df_to_lakehouse(
    df: pd.DataFrame,
    table_path: str,
    mode: str = "overwrite",          # "overwrite" | "append"
    force_string: bool = False,
    allow_unsafe_rename: bool = True
):
    """
    Write any pandas DataFrame to a Fabric Lakehouse Delta table.
    
    Parameters
    ----------
    df : pd.DataFrame
        The data to write
    table_path : str
        Full ABFS path to the target table
    mode : str
        "overwrite" (default) or "append"
    force_string : bool
        Convert every column to string before writing (useful for mixed-type landing tables)
    allow_unsafe_rename : bool
        Passes allow_unsafe_rename=true – often needed for clean overwrites in Fabric
    """
    if df is None or df.empty:
        print("⚠️ DataFrame is empty – nothing written.")
        return

    if force_string:
        df = df.astype(str)

    access_token = notebookutils.credentials.getToken('storage')
    storage_options = {
        "bearer_token": access_token,
        "use_fabric_endpoint": "true",
    }
    if allow_unsafe_rename:
        storage_options["allow_unsafe_rename"] = "true"

    # Convert to PyArrow Table (most reliable path)
    arrow_table = pa.Table.from_pandas(df, preserve_index=False)

    write_deltalake(
        table_path,
        arrow_table,
        mode=mode,
        storage_options=storage_options
    )

    print(f"✅ Successfully wrote {len(df):,} rows to {table_path} (mode={mode})")
```

### 3. Minimal usage

```python
# Assume you already have a DataFrame called `df`
write_df_to_lakehouse(df, table_path, mode="overwrite")
```

### 4. Optional – DuckDB intermediate step

Only needed if you want to apply SQL transformations before writing:

```python
import duckdb

# Register the DataFrame and run SQL
arrow_result = duckdb.sql("SELECT * FROM df").arrow()

# Then write the Arrow table directly
access_token = notebookutils.credentials.getToken('storage')
storage_options = {
    "bearer_token": access_token,
    "use_fabric_endpoint": "true",
    "allow_unsafe_rename": "true"
}

write_deltalake(
    table_path,
    arrow_result,
    mode="overwrite",
    storage_options=storage_options
)
```

## Design Notes & Gotchas

- **Mode choice**
  - `"overwrite"` – replaces the entire table (most common for staging / report tables)
  - `"append"` – adds rows (use carefully – no deduplication)
- **Schema folders**: If you use schemas (e.g. `Tables/staging/MyTable`), include the schema name in the path.
- **force_string**: Useful when the source has mixed types or you want a pure string landing zone.
- **allow_unsafe_rename**: Frequently required in Fabric pure-Python overwrites. Leave it `True` unless you have a reason not to.
- **Empty DataFrame**: The helper skips writing and prints a warning.
- **First write**: If the table does not exist, `write_deltalake` creates it automatically.
- **Large DataFrames**: For millions of rows consider Spark or partitioning. This pure-Python path is ideal up to a few hundred thousand rows.
- **Testing**: Always write to a `_Test` or `_Staging` table first.

## Related Skills

- `fabric-python-delta-merge` – for **upsert / incremental merge** (when you need `when_matched` / `when_not_matched`)
- `microsoft-fabric` – broader Fabric architecture and governance guidance
- `primeeco-fabric-incremental` – specialized PrimeEco extraction + merge pattern
