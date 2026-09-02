# Copilot Skills Backup

Daily backup of GitHub Copilot / VS Code agent **skills** and VS Code **MCP server configs** from this PC into this project folder.

| | |
|---|---|
| **Last backup** | 2026-09-03 09:30:37 |
| **Schedule** | Every day at **8:05 AM** (Windows Task Scheduler) |
| **Task name** | `CopilotSkillsDailyBackup` |
| **Source skills** | `C:\Users\gilbertque\.copilot\skills` |
| **Source plugins** | `C:\Users\gilbertque\.copilot\installed-plugins` |
| **Source MCP configs** | `%APPDATA%\Code\User\mcp.json` and `%USERPROFILE%\.copilot\mcp.json` |
| **Backup skills** | `backup\skills` |
| **Backup plugins** | `backup\installed-plugins` |
| **Backup MCP configs** | `backup\mcp` |

---

## What is backed up

1. **User / resolved skills** - `%USERPROFILE%\.copilot\skills`  
   These are the skill folders Copilot loads (including marketplace-resolved copies).
2. **Installed plugins (with embedded skills)** - `%USERPROFILE%\.copilot\installed-plugins`  
   Plugin packs that ship their own `SKILL.md` definitions.
3. **VS Code / Copilot MCP configs** - `%APPDATA%\Code\User\mcp.json` and `%USERPROFILE%\.copilot\mcp.json`  
   These are the local MCP server configuration files used by VS Code and Copilot.

Each run **mirrors** the sources into `backup\` (adds, updates, and removes files that no longer exist at the source). A machine-readable inventory is written to `backup\manifest.json`. Logs append to `logs\backup.log`.

---

## Skills inventory (from `.copilot\skills`)

**Count:** 95

| Skill | Description |
|-------|-------------|
| `activator-authoring-cli` | Create alerts, notifications, and automated actions on Fabric data and events via Fabric REST API and `az rest` CLI. **Invoke this skill** whenever the user wants to: (1) create, update, or delete an alert or notifica... |
| `activator-cli` | Create and inspect Fabric Activator (Reflex) alerts end to end: author rules, sources and actions, or decode an existing ReflexEntities definition read-only. Streaming topology is eventstream-cli. Triggers:create aler... |
| `activator-consumption-cli` | Inspect existing alerts, notifications, and automated actions in Fabric via read-only REST API calls using `az rest` CLI. **Invoke this skill** whenever the user wants to: (1) list existing alerts in a workspace, (2) ... |
| `audit-tenant-settings` | Automatically invoke this skill whenever the user asks about Fabric tenant settings or Power BI tenant settings or auditing tenant settings. You can use this skill if the user mentions "Fabric administration". |
| `azmon-mirroredcatalogs-operations-cli` | Onboard Azure Monitor / Application Insights observability data into Microsoft Fabric and guide business-impact insights by correlating telemetry with business data, Eventhouse external delta tables, verified schemas,... |
| `bpa-rules` | Interactive BPA rule generation for Power BI semantic models; guided discovery, model investigation, and expert rule authoring. Automatically invoke when the user mentions "BPA rule", "Best Practice Analyzer", or asks... |
| `check-updates` | Check for skills-for-fabric marketplace updates at session start. Compares local version against GitHub releases and shows changelog if updates are available. Use when the user wants to: (1) check for skill updates, (... |
| `chrome-devtools-mcp-2df60288` | (no SKILL.md) |
| `connect-pbid` | TOM and ADOMD.NET guidance via PowerShell for connecting to Power BI Desktop's local Analysis Services instance. Covers model enumeration, DAX queries, metadata modification, annotations, calendar definitions, field p... |
| `create-pbi-report` | Step-by-step workflow for creating complete Power BI reports from scratch using pbir CLI. Covers model discovery, report creation, page layout, theme setup, visual placement, field binding, filtering, formatting, vali... |
| `c-sharp-scripting` | Writing and executing C# scripts and macros against Power BI semantic models using Tabular Editor 2/3. Automatically invoke when the user mentions "C# script", "Tabular Editor script", "TOM scripting", "MacroActions.j... |
| `c--users-gilbertque--grok-marketplace-cache-783232b622f8182e-external-plugins-github-375d8163` | (no SKILL.md) |
| `c--users-gilbertque--grok-marketplace-cache-783232b622f8182e-external-plugins-playwright-2cb42e46` | (no SKILL.md) |
| `c--users-gilbertque--grok-marketplace-cache-783232b622f8182e-plugins-claude-code-setup-983654c9` | (no SKILL.md) |
| `c--users-gilbertque--grok-marketplace-cache-783232b622f8182e-plugins-code-modernization-5db1a6b3` | (no SKILL.md) |
| `c--users-gilbertque--grok-marketplace-cache-783232b622f8182e-plugins-code-review-8dc363e5` | (no SKILL.md) |
| `c--users-gilbertque--grok-marketplace-cache-783232b622f8182e-plugins-code-simplifier-7dd7eefa` | (no SKILL.md) |
| `databricks-migration` | Port Databricks notebooks and jobs to Microsoft Fabric. Provides an exhaustive dbutils to notebookutils substitution table: fs operations (runtime mounts or OneLake Shortcuts), secret scope to Key Vault URL conversion... |
| `dataflows-authoring-cli` | Create, update, delete, and refresh Fabric Dataflows Gen2 via write-side CLI against Fabric Items and Connections APIs. Builds mashup.pq + queryMetadata definitions, triggers parameterized refreshes, manages connectio... |
| `dataflows-cli` | Author, inspect and upgrade Fabric Dataflow Gen2: connection and output setup, M preview via executeQuery, saved definition and refresh-history inspection, and Gen1-to-Gen2 save-as upgrades. Pipeline JSON is pipeline-... |
| `dataflows-consumption-cli` | Monitor, inspect, and query saved Fabric Dataflows Gen2 via read-only CLI. List dataflows, decode base64 definitions (mashup.pq, queryMetadata.json, .platform), discover parameters, retrieve refresh status and job his... |
| `dataflows-save-as-authoring-cli` | Copy, clone, duplicate, rebind, and execute Gen1 dataflow save-as upgrade operations via CLI (az rest / curl) against Power BI REST and Fabric REST APIs. Covers Gen1 to Gen2.1 upgrade save-as, cross-workspace Gen1-to-... |
| `dax` | DAX performance optimization for semantic models. Automatically invoke when the user asks to "optimize DAX", "fix slow DAX", "DAX performance", "tune a measure", "debug a measure", "DAX anti-patterns", or mentions slo... |
| `deneb-visuals` | Deneb visual creation, Vega/Vega-Lite spec authoring, and Deneb best practices for PBIR reports. Automatically invoke whenever the user mentions "Deneb" in any context, or asks about Vega/Vega-Lite specs in Power BI, ... |
| `deployment-pipelines-authoring-cli` | Automate Microsoft Fabric deployment pipelines (ALM promotion across dev/test/prod stages) via the Fabric core REST API from agentic CLI environments. Use when the user wants to: (1) create or update a deployment pipe... |
| `duckdb-skills-104bff13` | (no SKILL.md) |
| `e2e-fabric-cost-estimation` | Estimate Microsoft Fabric capacity costs before migration by analyzing existing workload profiles (Spark, SQL, Power BI, Real-Time Intelligence) and recommending optimal SKU sizing, billing modes, and Reserved Instanc... |
| `e2e-medallion-architecture` | Plan and implement end-to-end Microsoft Fabric data platforms and Medallion Architecture (Bronze/Silver/Gold) lakehouse patterns using PySpark, Delta Lake, Lakehouse/Warehouse items, Fabric Pipelines, and semantic-mod... |
| `eventhouse-authoring-cli` | Execute KQL management commands (table management, ingestion, policies, functions, materialized views) against Fabric Eventhouse and KQL Databases via CLI. Use when the user wants to: 1. Create or alter KQL tables, co... |
| `eventhouse-cli` | Author and query Fabric Eventhouse / KQL databases: create tables, functions, policies, materialized views and ingestion, or run read-only KQL for real-time and time-series analytics. Ingestion topology is eventstream... |
| `eventhouse-consumption-cli` | Run KQL queries against Fabric Eventhouse for real-time intelligence and time-series analytics using `az rest` against the Kusto REST API. Covers KQL operators (where, summarize, join, render), Eventhouse schema disco... |
| `eventschemaset-cli` | Author and inspect Microsoft Fabric Event Schema Sets (centralized catalogs of event types and message schemas) via the Fabric Items REST API with az rest: create, rename, override the definition or delete one; or lis... |
| `eventstream-authoring-cli` | Create, wire, and publish Fabric Eventstream real-time streaming topologies via the Items REST API. Build definitions with 25 source types (Event Hubs, IoT Hub, CDC, Kafka, SampleData), 8 operators (Filter, Aggregate,... |
| `eventstream-cli` | Build and inspect Fabric Eventstream topologies: sources, operators, destinations and stream routing, plus read-only topology, retention, throughput and connection-string inspection. Querying landed events uses eventh... |
| `eventstream-consumption-cli` | List, inspect, and monitor Fabric Eventstream real-time ingestion pipelines via the Items REST API. Discover Eventstreams across workspaces, decode base64 graph topologies tracing event flow from source through operat... |
| `executing-spark` | Execute arbitrary Python or PySpark code on Fabric Spark compute without creating a notebook artifact; ephemeral Livy sessions with full Delta table access. Automatically invoke when the user asks to "run PySpark in F... |
| `fabric` | (no SKILL.md) |
| `fabric-cli` | Expert guidance for using the Fabric CLI (`fab`) to fully interact with Fabric workspaces, items, and configuration. Automatically invoke this skill whenever the user mentions "Fabric" or "Power BI Service" or a "Fabr... |
| `fabriciq` | Answer natural-language business questions over existing Power BI reports and semantic models through the FabricIQ MCP endpoint. Orchestrates artifact discovery, schema inspection, entity resolution, DAX generation, a... |
| `fabriciq-ontology-authoring-cli` | Create and evolve Fabric IQ Ontology (preview) items from CLI — define entity types, properties (including timeseries), relationship types, and bind them to OneLake lakehouse tables (static + timeseries) or Eventhouse... |
| `fabriciq-ontology-cli` | Author and explore Fabric IQ Ontology items: entity and relationship types, data bindings and definition updates, or schema, lineage, grounding and graph-walk exploration. Power BI report Q&A is fabriciq. Triggers:cre... |
| `fabriciq-ontology-consumption-cli` | Explore Fabric IQ Ontology (preview) items (read-only) from the CLI to ground an agent before it queries data. Explore, describe, and summarize what an ontology exposes — its entity types, keys, relationships, and the... |
| `fabric-key-vault-pure-python` | Use Azure Key Vault secrets from a Microsoft Fabric pure Python notebook using notebookutils.credentials.getSecret. Includes a required fill-in template for key vault URL and secret names before execution. Triggers: a... |
| `fabric-python-delta-merge` | Pure-Python incremental merge pattern for any DataFrame into a Microsoft Fabric Lakehouse Delta table. Use when the caller already has a new pandas DataFrame and needs to upsert it via deltalake merge on a key (usuall... |
| `fabric-python-delta-write` | Pure-Python pattern to write any pandas DataFrame to a Microsoft Fabric Lakehouse Delta table using deltalake. Supports overwrite and append modes, optional schema, and ABFS path construction. Triggers on write DataFr... |
| `git-integration-operations-cli` | Automate the Microsoft Fabric Git integration lifecycle from CLI environments using the Fabric CLI (fab api), with az rest as a fallback. Use when the user wants to connect a workspace to Azure DevOps or GitHub, commi... |
| `hdinsight-migration` | Port Azure HDInsight Spark clusters and Hive workloads to Microsoft Fabric. Replaces legacy HiveContext and standalone SparkContext constructors with the pre-instantiated SparkSession. Converts WASB and ABFS storage p... |
| `help-me-get-started` | Friendly, jargon-free onboarding for people new to coding agents and Power BI agentic development. Invoke for setup, prerequisites, tool installation, terminal guidance, safety questions, or explanations of models, co... |
| `improve-my-agent-setup` | Audit and improve an entire agentic-development setup, including skills, context, memory, tools, models, permissions, hooks, workflow habits, and secrets hygiene. Invoke for setup reviews, workflow grading, Goblin Mod... |
| `lineage-analysis` | Trace relationships between semantic models and downstream reports across Fabric workspaces. Automatically invoke when the user asks to "find downstream reports", "show report lineage", "impact analysis", "what depend... |
| `mlv-operations-cli` | Manage refresh schedules and job execution for an EXISTING Microsoft Fabric Materialized Lake View (MLV) via REST APIs: create, update, and delete refresh schedules (interval-based: hourly, daily, weekly), trigger on-... |
| `modifying-theme-json` | Design, enforce, audit, and validate Power BI report themes. This skill MUST be invoked when a report uses the default or built-in theme, has a minimal custom theme (few or no visualStyles), or has accumulated many vi... |
| `paginated-report` | Author, validate, publish, and test Power BI paginated reports in the RDL format. Automatically invoke when the user mentions "paginated report", "RDL", ".rdl", "Report Builder", "Power BI Report Builder", "SSRS repor... |
| `pbip` | Expert guidance for the Power BI Project (PBIP) file format; project structure, cross-cutting operations (renames, forking), and PBIX extraction/conversion. Automatically invoke when the user mentions PBIP, PBIX, .pbi... |
| `pbir-cli` | This skill should be used whenever the user mentions "pbir", "pbir-cli", "Power BI reports", or "PBI reports", works with .pbir, .pbip, or .pbix files, or wants to refresh, screenshot, or visually verify a report that... |
| `pbi-report-design` | The Power BI report design canon covering design identity, visual hierarchy and the 3-30-300 rule, layout/spacing/alignment, color discipline, chart selection, KPI and card design, tables and matrices, accessibility, ... |
| `pbir-format` | Format reference for Power BI Enhanced Report (PBIR) JSON schemas and patterns. Automatically invoke when the user asks about PBIR JSON structure, visual.json properties, PBIR expressions, objects vs visualContainerOb... |
| `pipeline-migration` | Migrate Synapse Data Factory pipeline artifacts to Microsoft Fabric Data Factory. Handles: linked services → Fabric connections, dataset definitions inlined into pipeline activities, global parameters → Variable Libra... |
| `powerbi-custom-visuals` | Power BI custom visual (.pbiviz) development with the pbiviz toolchain and its MCP server. Automatically invoke when the user mentions "custom visual", "pbiviz", "develop a Power BI visual", "powerbi-visuals-tools", "... |
| `powerbi-optimization` | Expert Power BI optimization: DAX performance, semantic model design, report UX, query performance. Analyzes measures, relationships, visuals, storage modes. Detects iterators, context transitions, schema anti-pattern... |
| `powerbi-report-authoring` | Create and modify Power BI report files in PBIR/PBIP format using the `powerbi-report-author` and `powerbi-desktop` CLIs. Use when the user wants to: (1) implement an approved report spec or design brief, (2) add or e... |
| `powerbi-report-design` | Generate Power BI report visual design guidance before PBIR files are written. Use when the user wants to: (1) choose tone, signature, page archetypes, chart types, layout, color, typography, theme direction, or acces... |
| `powerbi-report-management` | Manage Power BI report workspace items and PBIR definitions in Microsoft Fabric via `az rest` CLI against the Fabric REST API. Use when the user wants to: (1) upload or publish a PBIR/report definition to Fabric, (2) ... |
| `powerbi-report-planning` | Build a guided requirements-to-implementation workflow for new Power BI reports and dashboards from semantic models, datasets, or PBIP projects. Use when the user wants to: (1) plan then implement a report, (2) define... |
| `power-query` | Author, validate, and test Power Query M expressions in semantic model partitions. Automatically invoke when the user mentions "Power Query", "M code", "M expression", "partition expression", "query folding", or asks ... |
| `python-visuals` | Python visual creation and matplotlib/seaborn patterns for PBIR reports. Automatically invoke when the user mentions "Python visual", "matplotlib in Power BI", "seaborn in Power BI", "pythonVisual", or asks to "create... |
| `refresh-semantic-model` | Automatically invoke this skill whenever the user asks to refresh a semantic model or a dataset. Can also be used to manage, optimize, troubleshoot, or configure a refresh or a refresh schedule. |
| `review-report` | Actionable feedback on the quality, usage, and effectiveness of Power BI reports. Automatically invoke when the user asks to "review a report", "audit a report", "report usage analysis", "report health check", "find u... |
| `r-visuals` | R visual creation and ggplot2 patterns for PBIR reports. Automatically invoke when the user mentions "R visual", "ggplot2", "ggplot in Power BI", or asks to "create an R visual", "add an R chart", "write an R visual s... |
| `search-consumption-cli` | Search the Microsoft Fabric catalog across workspaces using the Fabric Catalog Search API. Use when the user wants to: (1) find an item by display name when the workspace is unknown, (2) list or discover items of a sp... |
| `semantic-model` | This skill should be used whenever the user mentions a "semantic model", "data model", or "dataset", or asks to "build", "model", "design", "optimize", "review", or "audit" one, or to "add a measure", "add a relations... |
| `semantic-model-authoring` | Author and inspect Power BI semantic models and their metadata: list tables, columns, measures, relationships; create, edit, deploy, refresh, and manage models; optimize DAX; build Import, DirectQuery, and Direct Lake... |
| `semantic-model-consumption` | Execute raw DAX queries and inspect metadata of Microsoft Fabric Power BI semantic models via the MCP server ExecuteQuery tool. Use when the user already knows the DAX to write, wants to run EVALUATE statements, or ne... |
| `spark-authoring-cli` | Author Fabric notebook cell code; run a notebook by name and report its status; and author/create Materialized Lake View (MLV) definitions (CREATE MATERIALIZED LAKE VIEW). Use for writing notebook cell code (PySpark, ... |
| `spark-cli` | Author, run and diagnose Fabric Spark: notebook cell code (%%configure, %%sql, PySpark, notebookutils), named notebook runs, Livy-session ad-hoc calculations, Spark failure triage, and the whole Materialized Lake View... |
| `spark-consumption-cli` | Interactive ad-hoc Spark analysis through Fabric Lakehouse Livy API sessions ONLY. This skill NEVER authors or runs a notebook: any notebook cell (%%sql/%%configure) or a notebook-run-by-name (and reporting its run st... |
| `spark-operations-cli` | Diagnose failed Spark jobs, unhealthy Livy sessions, and performance bottlenecks in Microsoft Fabric via read-only CLI triage. Use ONLY for FAILED/unhealthy runs; running a notebook and reporting its success status is... |
| `sqldb-authoring-cli` | Create and manage SQL database in Fabric items, author T-SQL DDL/DML with constraints, foreign keys, triggers, indexes, and vector columns. Deploy schema via SqlPackage (.dacpac/.bacpac), configure source control, CI/... |
| `sqldb-cli` | Design, read and troubleshoot a Fabric SQL database item (OLTP, SQL Server engine): schema with constraints, indexes and vector columns; sqlcmd lookups including temporal and similarity search; Query Store, blocking a... |
| `sqldb-consumption-cli` | Query SQL database in Fabric via sqlcmd: interactive exploration, vector similarity, JSON, temporal queries, and security policy inspection on the OLTP and SQL analytics endpoints. For schema changes see the sqldb-aut... |
| `sqldb-operations-cli` | Diagnose SQL database in Fabric performance via sqlcmd against Query Store, DMVs, sys.dm_db_resource_stats, and Extended Events on the OLTP endpoint. Identifies the top resource-consuming, slowest, or most expensive q... |
| `sqldw-authoring-cli` | Execute authoring T-SQL (DDL, DML, data ingestion, transactions, schema changes) against Microsoft Fabric Data Warehouse and SQL endpoints from agentic CLI environments. Use when the user wants to: (1) create/alter/dr... |
| `sqldw-cli` | Author, query and diagnose Fabric Warehouse, Lakehouse SQL endpoints and Mirrored Databases: DDL/DML and COPY INTO ingestion, read-only T-SQL SELECT and row counts over lakehouse tables, and queryinsights performance ... |
| `sqldw-consumption-cli` | Execute read-only T-SQL queries against Fabric Data Warehouse, Lakehouse SQL Endpoints, and Mirrored Databases via CLI. Default skill for any lakehouse data query (row counts, SELECT, filtering, aggregation) unless th... |
| `sqldw-operations-cli` | Analyze Fabric Data Warehouse performance via CLI using sqlcmd and queryinsights views. Diagnose slow queries, SQL pool pressure, cache coldness, and recommend clustering keys. Triggers: "DW slow query analysis", "slo... |
| `standardize-naming-conventions` | Interactive naming convention standardization for TMDL-based Power BI semantic models. Automatically invoke when the user asks to "standardize naming conventions", "fix naming conventions", "clean up model names", "ap... |
| `superpowers-21e2a56d` | (no SKILL.md) |
| `svg-visuals` | SVG generation via DAX measures and extension measures with ImageUrl data category for inline visualizations in PBIR reports. Automatically invoke when the user mentions "SVG visual", "DAX sparkline", "SVG measure", "... |
| `synapse-migration` | Port Azure Synapse Analytics Spark workloads to Microsoft Fabric. Translates mssparkutils calls to notebookutils (including the env→runtime namespace change), replaces Linked Services with Fabric Data Connections and ... |
| `te2-cli` | CLI syntax reference for Tabular Editor 2 (TabularEditor.exe); deployment, scripting, BPA analysis, and CI/CD integration. Automatically invoke when the user mentions "TabularEditor.exe", TE2 CLI flags (-D, -S, -A, -B... |
| `te-cli` | Expert guidance for the cross-platform Tabular Editor CLI (the `te` binary, currently in preview) that manages Power BI / Analysis Services semantic models from the terminal on macOS, Linux, and Windows. Use when the ... |
| `te-docs` | Tabular Editor documentation search and configuration file guidance (.tmuo, Preferences.json, UiPreferences.json, Layouts.json). Automatically invoke when the user asks about "TE docs", "Tabular Editor features", "TE3... |
| `tmdl` | Direct TMDL file authoring and BIM-to-TMDL conversion for semantic models in PBIP projects. Automatically invoke when the user asks to "edit TMDL", "add a measure in TMDL", "TMDL syntax", "fix formatString", "fix summ... |
| `using-duckdb` | Query Fabric lakehouse and warehouse data using DuckDB, either locally or inside a Fabric notebook. Automatically invoke when the user mentions "DuckDB", "query Delta tables locally", or asks to "attach DuckDB to a la... |
| `variable-library-cli` | Create, wire and operate Microsoft Fabric Variable Library items via Fabric REST API, az rest, curl, and jq. Use when the user wants to: (1) create or update a VariableLibrary definition, variables, settings.json, or ... |

---

## Plugin-embedded skills (from `installed-plugins`)

Unique skill names discovered under installed plugins. **Count (unique):** 57

| Skill | Description |
|-------|-------------|
| `activator-authoring-cli` | Create alerts, notifications, and automated actions on Fabric data and events via Fabric REST API and `az rest` CLI. **Invoke this skill** whenever the user wants to: (1) create, update, or delete an alert or notifica... |
| `activator-consumption-cli` | Inspect existing alerts, notifications, and automated actions in Fabric via read-only REST API calls using `az rest` CLI. **Invoke this skill** whenever the user wants to: (1) list existing alerts in a workspace, (2) ... |
| `bpa-rules` | This skill should be used when the user asks to "create a BPA rule", "write a Best Practice Analyzer rule", "improve a BPA expression", "fix expression for BPA", "analyze BPA annotations", "check model for best practi... |
| `check-updates` | Check for skills-for-fabric marketplace updates at session start. Compares local version against GitHub releases and shows changelog if updates are available. Use when the user wants to: (1) check for skill updates, (... |
| `connect-pbid` | This skill should be used when the user asks to "connect to Power BI Desktop", "query PBI Desktop with DAX", "modify PBI Desktop model", "find the Analysis Services port", "use TOM with Power BI Desktop", "add a measu... |
| `create-pbi-report` | This skill should be used when the user asks to 'create a new report', 'build a Power BI report from scratch', 'make a dashboard', 'set up a report with KPIs', 'create an executive dashboard', 'add pages and visuals t... |
| `c-sharp-scripting` | This skill should be used when the user asks to "write a C# script", "create a Tabular Editor script", "automate model changes", "bulk update measures", "create calculation groups", "format DAX expressions", "manage m... |
| `databricks-migration` | Port Databricks notebooks and jobs to Microsoft Fabric. Provides an exhaustive dbutils to notebookutils substitution table: fs operations (mount removal via OneLake Shortcuts), secret scope to Key Vault URL conversion... |
| `dataflows-authoring-cli` | Create, update, delete, and refresh Fabric Dataflows Gen2 via write-side CLI against Fabric Items and Connections APIs. Builds mashup.pq + queryMetadata definitions, triggers parameterized refreshes, manages connectio... |
| `dataflows-consumption-cli` | Monitor, inspect, and query saved Fabric Dataflows Gen2 via read-only CLI. List dataflows, decode base64 definitions (mashup.pq, queryMetadata.json, .platform), discover parameters, retrieve refresh status and job his... |
| `dataflows-save-as-authoring-cli` | Assess, plan, and execute dataflow Gen1 → Gen2.1 CI/CD save-as operations via CLI (az rest / curl) against Power BI REST and Fabric REST APIs. Scan workspaces or entire tenants for Gen1 dataflows, evaluate save-as rea... |
| `deneb-visuals` | This skill should be used whenever the user mentions 'Deneb' in any context, or asks to 'create a Deneb visual', 'add a Vega-Lite chart', 'inject a Deneb spec', 'inject a Vega spec', 'build a custom visualization with... |
| `e2e-medallion-architecture` | Implement end-to-end Medallion Architecture (Bronze/Silver/Gold) lakehouse patterns in Microsoft Fabric using PySpark, Delta Lake, and Fabric Pipelines. Use when the user wants to: (1) design a Bronze/Silver/Gold data... |
| `eventhouse-authoring-cli` | Execute KQL management commands (table management, ingestion, policies, functions, materialized views) against Fabric Eventhouse and KQL Databases via CLI. Use when the user wants to: 1. Create or alter KQL tables, co... |
| `eventhouse-consumption-cli` | Run KQL queries against Fabric Eventhouse for real-time intelligence and time-series analytics using `az rest` against the Kusto REST API. Covers KQL operators (where, summarize, join, render), Eventhouse schema disco... |
| `eventstream-authoring-cli` | Create, wire, and publish Microsoft Fabric Eventstream real-time event streaming topologies via the Fabric Items REST API. Build graph-based definitions with 25 source types (Event Hubs, IoT Hub, CDC connectors, Kafka... |
| `eventstream-consumption-cli` | List, inspect, and monitor Microsoft Fabric Eventstream real-time event ingestion pipelines via the Fabric Items REST API. Discover Eventstreams across workspaces, decode base64-encoded graph topologies to trace event... |
| `fabric-cli` | This skill should be used when the user asks to "use the Fabric CLI", "run fab commands", "deploy Fabric items", "manage Fabric workspaces", "query a lakehouse", "query lakehouse data", "query OneLake", "check data fr... |
| `fabriciq` | Answer business questions by querying Power BI reports and dashboards through the FabricIQ MCP endpoint. Orchestrates: discover Power BI artifacts, inspect report/model schemas, resolve entity values, generate DAX, ex... |
| `fabriciq-ontology-authoring-cli` | Create and evolve Fabric IQ Ontology (preview) items from CLI — define entity types, properties (including timeseries), relationship types, and bind them to OneLake lakehouse tables (static + timeseries) or Eventhouse... |
| `fabriciq-ontology-consumption-cli` | Explore Fabric IQ Ontology (preview) items (read-only) from the CLI to ground an agent before it queries data. Explore, describe, and summarize what an ontology exposes — its entity types, keys, relationships, and the... |
| `hdinsight-migration` | Port Azure HDInsight Spark clusters and Hive workloads to Microsoft Fabric. Removes legacy HiveContext and standalone SparkContext constructors, replacing them with the pre-instantiated SparkSession. Converts WASB and... |
| `lineage-analysis` | This skill should be used when the user asks to 'find downstream reports', 'what reports use this model', 'show report lineage', 'which reports are connected', 'find connected reports', 'get model dependencies', 'cros... |
| `mlv-operations-cli` | Manage Microsoft Fabric Materialized Lake View (MLV) refresh schedules and job execution via REST APIs. Create, update, and delete refresh schedules (interval-based: hourly, daily, weekly). Trigger on-demand refreshes... |
| `modifying-theme-json` | This skill should be used when the user asks to 'create a theme', 'design a theme', 'build a theme from scratch', 'apply a theme to the report', 'enforce theme compliance', 'audit theme adherence', 'push formatting to... |
| `pbip` | This skill should be used when the user asks about "PBIP project structure", "PBIP vs PBIX", "thin report vs thick report", "rename a table", "rename a measure", "fork a PBIP project", "cascade rename", "fix broken re... |
| `pbir-cli` | Advanced Power BI report manipulation using pbir CLI and object model. Auto-triggers on (1) Power BI report operations (.pbir/.pbip/.pbix), (2) visual/page/theme creation or modification, (3) DAX measures and conditio... |
| `pbi-report-design` | This skill should be used when the user asks about "report layout", "report design best practices", "visual hierarchy", "3-30-300 rule", "KPI card design", "table formatting", "matrix formatting", "page layout", "repo... |
| `pbir-format` | This skill should be used when the user asks about 'PBIR format', 'PBIR JSON structure', 'what does this visual.json property mean', 'how do PBIR expressions work', 'objects vs visualContainerObjects', 'theme inherita... |
| `pipeline-migration` | Migrate Synapse Data Factory pipeline artifacts to Microsoft Fabric Data Factory. Handles: linked services → Fabric connections, dataset definitions inlined into pipeline activities, global parameters → Variable Libra... |
| `powerbi-authoring-cli` | Create, manage, and deploy Power BI semantic models inside Microsoft Fabric workspaces via `az rest` CLI against Fabric and Power BI REST APIs. Use when the user wants to: (1) create a semantic model from TMDL definit... |
| `powerbi-consumption-cli` | The ONLY supported path for read-only Microsoft Fabric Power BI semantic model (formerly "Power BI dataset") query interactions. Execute DAX queries via the MCP server ExecuteQuery tool to: (1) discover semantic model... |
| `powerbi-report-authoring` | Create and modify Power BI report files in PBIR/PBIP format using the `powerbi-report-author` and `powerbi-desktop` CLIs. Use when the user wants to: (1) implement an approved report spec or design brief, (2) add or e... |
| `powerbi-report-design` | Generate Power BI report visual design guidance before PBIR files are written. Use when the user wants to: (1) choose tone, signature, page archetypes, chart types, layout, color, typography, theme direction, or acces... |
| `powerbi-report-management` | Manage Power BI report workspace items and PBIR definitions in Microsoft Fabric via `az rest` CLI against the Fabric REST API. Use when the user wants to: (1) upload or publish a PBIR/report definition to Fabric, (2) ... |
| `powerbi-report-planning` | Build a guided requirements-to-implementation workflow for new Power BI reports and dashboards from semantic models, datasets, or PBIP projects. Use when the user wants to: (1) plan then implement a report, (2) define... |
| `powerbi-semantic-model-authoring` | Develops and manages Power BI Semantic Models. Handles connecting to semantic models for analysis and all development operations including (1) Creating new models, (2) Creating/editing measures using DAX, (3) Creating... |
| `python-visuals` | This skill should be used when the user asks to 'create a Python visual', 'add a matplotlib chart', 'inject a Python script into Power BI', 'use seaborn in Power BI', 'add a Python chart to a report', 'write a Python ... |
| `refreshing-semantic-model` | This skill should be used when the user asks to "refresh a semantic model", "trigger a dataset refresh", "refresh specific tables", "refresh partitions", "check refresh status", "monitor refresh history", "do a data-o... |
| `review-report` | This skill should be used when the user asks to "review a report", "evaluate report quality", "audit a report", "check if a report is being used", "report usage analysis", "report health check", "assess report perform... |
| `review-semantic-model` | This skill should be used when the user asks to "review a semantic model", "audit a semantic model", "check model quality", "optimize my model", "validate model design", "run a best practice check", "check AI readines... |
| `r-visuals` | This skill should be used when the user asks to 'create an R visual', 'add a ggplot2 chart', 'inject an R script into Power BI', 'use ggplot in Power BI', 'add an R chart to a report', 'write an R visual script', or n... |
| `search-consumption-cli` | Find and discover Microsoft Fabric items across workspaces when the workspace is unknown. Use when the user wants to: (1) find an item by name across workspaces, (2) list items of specific type across workspaces, (3) ... |
| `semantic-model-authoring` | Develops and manages Power BI semantic models across Desktop, PBIP projects, and Fabric Service. Handles: (1) creating new models (Import, DirectQuery, Direct Lake), (2) editing existing models (e.g. measures, tables,... |
| `semantic-model-consumption` | Execute raw DAX queries and inspect metadata of Microsoft Fabric Power BI semantic models via the MCP server ExecuteQuery tool. Use when the user already knows the DAX to write, wants to run EVALUATE statements, or ne... |
| `spark-authoring-cli` | Develop Microsoft Fabric Spark/data engineering workflows and write code in Fabric Notebook cells with intelligent routing to specialized resources. Provides workspace/lakehouse management, notebook code authoring (Py... |
| `spark-consumption-cli` | Analyze lakehouse data interactively using Fabric Lakehouse Livy API sessions and PySpark/Spark SQL for advanced analytics, DataFrames, cross-lakehouse joins, Delta time-travel, and unstructured/JSON data. Use when th... |
| `spark-operations-cli` | Diagnose failed Spark jobs, unhealthy Livy sessions, and performance bottlenecks in Microsoft Fabric via read-only CLI triage. Use when the user wants to: (1) diagnose why a Spark job, notebook run, or Lakehouse job f... |
| `sqldw-authoring-cli` | Execute authoring T-SQL (DDL, DML, data ingestion, transactions, schema changes) against Microsoft Fabric Data Warehouse and SQL endpoints from agentic CLI environments. Use when the user wants to: (1) create/alter/dr... |
| `sqldw-consumption-cli` | Execute read-only T-SQL queries against Fabric Data Warehouse, Lakehouse SQL Endpoints, and Mirrored Databases via CLI. Default skill for any lakehouse data query (row counts, SELECT, filtering, aggregation) unless th... |
| `sqldw-operations-cli` | Analyze Fabric Data Warehouse performance via CLI using sqlcmd and queryinsights views. Diagnose slow queries, SQL pool pressure, cache coldness, and recommend clustering keys. Triggers: "DW slow query analysis", "slo... |
| `standardize-naming-conventions` | This skill should be used when the user asks to "standardize naming conventions", "fix naming conventions", "rename measures", "rename columns", "clean up model names", "fix table names", "apply naming standards", "au... |
| `svg-visuals` | This skill should be used when the user asks to 'create an SVG visual', 'add a DAX sparkline', 'create an SVG measure', 'add inline graphics with DAX', 'create a progress bar in DAX', 'use SVG in Power BI', 'add a bul... |
| `synapse-migration` | Port Azure Synapse Analytics Spark workloads to Microsoft Fabric. Translates mssparkutils calls to notebookutils (including the env→runtime namespace change), replaces Linked Services with Fabric Data Connections and ... |
| `te2-cli` | This skill should be used when the user asks to "run TabularEditor.exe", "deploy a model via CLI", "use Tabular Editor 2 command line", "set up CI/CD for Power BI", "automate model deployment", "run BPA from command l... |
| `te-docs` | This skill should be used when the user asks about 'Tabular Editor documentation', 'TE docs', 'how to do X in Tabular Editor', 'Tabular Editor features', 'TE3 features', '.tmuo files', 'Tabular Editor user options', '... |
| `tmdl` | This skill should be used as a last resort when the Tabular Editor CLI, Power BI MCP server, or connect-pbid skill are not available. Use when the user asks to "edit TMDL", "add a measure in TMDL", "add a column descr... |

---

## MCP config inventory (from VS Code / Copilot)

**Count:** 2

| Backup path | Source |
|------------|--------|
| `AppData/Roaming/Code/User/mcp.json` | `C:\Users\gilbertque\AppData\Roaming\Code\User\mcp.json` |
| `.copilot/mcp.json` | `C:\Users\gilbertque\.copilot\mcp.json` |

---

## Manual backup

From PowerShell:

```powershell
cd "C:\Users\username\company.com\Internal - Documents\Agentic\Copilot Skills Backup"
.\scripts\Backup-CopilotSkills.ps1
```

Optional:

```powershell
# Backup only (do not rewrite README)
.\scripts\Backup-CopilotSkills.ps1 -SkipReadme
```

---

## Schedule (daily 8:05 AM)

Register or refresh the Windows scheduled task:

```powershell
cd "C:\Users\username\company.com\Internal - Documents\Agentic\Copilot Skills Backup"
.\scripts\Register-CopilotSkillsBackupTask.ps1
```

Useful checks:

```powershell
Get-ScheduledTask -TaskName 'CopilotSkillsDailyBackup'
Get-ScheduledTaskInfo -TaskName 'CopilotSkillsDailyBackup'
# Run once now:
Start-ScheduledTask -TaskName 'CopilotSkillsDailyBackup'
```

Unregister:

```powershell
Unregister-ScheduledTask -TaskName 'CopilotSkillsDailyBackup' -Confirm:$false
```

---

## How to restore (new PC or recovery)

Use this when you move to another machine, reinstall VS Code / Copilot, or accidentally delete skills or MCP config files.

### Prerequisites on the target PC

1. Install **Visual Studio Code**.
2. Install the **GitHub Copilot** and **GitHub Copilot Chat** extensions (and any Fabric / Power BI agent extensions you use).
3. Sign in to GitHub / Microsoft accounts as you normally do for Copilot.
4. Copy this entire project folder to the new PC (OneDrive / git / USB - wherever you keep it).

### Option A - Full restore script (recommended)

On the **target** PC, open PowerShell and run:

```powershell
cd "<path-to-this-project>"
# Preview only:
.\scripts\Restore-CopilotSkills.ps1 -WhatIf

# Apply restore:
.\scripts\Restore-CopilotSkills.ps1
```

This copies:

- `backup\skills\*` -> `%USERPROFILE%\.copilot\skills\`
- `backup\installed-plugins\*` -> `%USERPROFILE%\.copilot\installed-plugins\`
- `backup\mcp\*` -> the original VS Code / Copilot MCP config locations

Then **fully quit and restart VS Code** so Copilot reloads skills and MCP server settings.

### Option B - Manual copy

1. Close VS Code completely (all windows).
2. Ensure these folders exist:
   - `%USERPROFILE%\.copilot\skills`
   - `%USERPROFILE%\.copilot\installed-plugins`
3. Copy contents:

```powershell
$src = "<path-to-this-project>\backup"
$dst = "$env:USERPROFILE\.copilot"
New-Item -ItemType Directory -Force -Path "$dst\skills", "$dst\installed-plugins" | Out-Null
robocopy "$src\skills" "$dst\skills" /E
robocopy "$src\installed-plugins" "$dst\installed-plugins" /E
```

4. Restart VS Code.
5. In Copilot Chat, confirm skills appear (or ask the agent to list available skills).

### Option C - Restore a single skill

```powershell
$name = "sqldw-consumption-cli"   # example
$src  = "<path-to-this-project>\backup\skills\$name"
$dst  = "$env:USERPROFILE\.copilot\skills\$name"
Copy-Item -Path $src -Destination $dst -Recurse -Force
```

Restart VS Code after copying.

### After restore checklist

- [ ] `%USERPROFILE%\.copilot\skills` contains the expected skill folders  
- [ ] Plugin packs under `installed-plugins` are present if you use them  
- [ ] MCP config files under `backup\mcp` were restored to the original VS Code / Copilot locations  
- [ ] VS Code restarted  
- [ ] Copilot Chat can invoke a known skill (e.g. a Fabric or Power BI skill you use daily)  
- [ ] Re-register the daily backup task on the new PC: `.\scripts\Register-CopilotSkillsBackupTask.ps1`

### Notes / caveats

- **Marketplace plugins** may also reinstall via Copilot's plugin UI; this backup is a safety net for local skill files and custom/direct installs.
- VS Code MCP configs are backed up as files, not as live server processes.

---

## Project layout

```
Copilot Skills Backup/
  README.md                          # this file (auto-updated on backup)
  scripts/
    Backup-CopilotSkills.ps1         # daily backup + README refresh
    Restore-CopilotSkills.ps1        # restore to .copilot and VS Code MCP config locations
    Register-CopilotSkillsBackupTask.ps1
  backup/
    skills/                          # mirror of .copilot\skills
    installed-plugins/               # mirror of .copilot\installed-plugins
    mcp/                             # mirror of VS Code / Copilot MCP config files
    manifest.json                    # last run metadata + inventory
  logs/
    backup.log
```

---

*Generated automatically by `scripts\Backup-CopilotSkills.ps1` on 2026-09-03 09:30:37.*
