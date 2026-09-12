🏗️ SQL Data Engineering — Data Warehouse & Data Marts

An end-to-end SQL data engineering project built with DuckDB, where
raw job-posting data is transformed into a structured data warehouse
and then used to create analytical data marts.

The project focuses on practical data-engineering concepts such as
star schema modeling, ETL, data quality, incremental loading, CTEs,
MERGE operations, and analytical SQL.

────────

### 📌 Project Overview

![project1_pic](../IMAGES\sql_database_2.png)
The source job-posting data is available as CSV files in cloud storage.
Instead of repeatedly querying raw files, the project organizes the data
into a warehouse and then creates purpose-built marts for analysis.

```text
Raw CSV Data
     │
     ▼
Data Loading & Transformation
     │
     ▼
Data Warehouse
   Star Schema
     │
     ▼
Data Marts
 ┌───┼──────────────┐
 ▼   ▼              ▼
Flat Skills      Priority
Mart  Mart         Mart
     │
     ▼
Analytics / BI
```

────────

🎯 Project Goals

The main goals of this project are to:

• Build a reusable SQL data warehouse
• Design a star schema for analytical workloads
• Separate facts, dimensions, and many-to-many relationships
• Create data marts for specific analytical requirements
• Practice incremental data processing with MERGE
• Add validation checks to identify data-quality issues
• Manage the project using Git and GitHub

────────

🧰 Technology Stack

Technology                      Usage

────────

DuckDB                      Analytical database
SQL                         DDL, DML and transformations
Google Cloud Storage        Source CSV data
VS Code                     SQL development
Git / GitHub                Version control
Power BI / Excel / Python   Possible downstream analysis

────────

📂 Repository Structure

```text
2_DW_Mart_Build/
│
├── 01_create_tables_dw.sql
├── 02_Load_Schema_dw.sql
├── 03_create_flat_mart.sql
├── 04_create_skills_mart.sql
├── 05_create_priority_mart.sql
├── 06_update_priority_mart.sql
├── build_marts.sql
├── dw_marts.duckdb
├── .gitignore
└── README.md
```

> The DuckDB database file is generated locally. The `.gitignore` file
> can be used to prevent generated database files from being committed
> if desired.

────────

🗄️ 1. Data Warehouse

The warehouse provides the central analytical layer of the project.

Core tables

```text
company_dim
skills_dim
job_postings_fact
skills_job_dim
```

Star schema concept

```text
                 company_dim
                      │
                      │
                      ▼
skills_dim ───► job_postings_fact
                      ▲
                      │
                skills_job_dim
```

The fact table stores job-posting information, while dimensions provide
descriptive attributes.

Data Warehouse Schema

────────

☁️ 2. Load Source Data

SQL file

```text
02_Load_Schema_dw.sql
```

This step extracts source CSV data and loads it into the warehouse after
applying the required transformations and data types.

Example:

```sql
SELECT *
FROM read_csv(
    'https://storage.googleapis.com/your-source-file.csv',
    AUTO_DETECT = true
);
```

The general flow is:

```text
CSV
 │
 ▼
Read Source
 │
 ▼
Transform
 │
 ▼
Validate
 │
 ▼
Load into Warehouse
```

────────

📊 3. Flat Mart

SQL file

```text
03_create_flat_mart.sql
```

The Flat Mart combines information from the warehouse into a more
convenient structure for ad-hoc analysis.

Instead of repeatedly joining several warehouse tables, analysts can
query the denormalized mart directly.

```text
Warehouse Tables
       │
       ▼
     JOINs
       │
       ▼
   Flat Mart
```

Example:

```sql
SELECT *
FROM flat_mart.job_postings_flat
LIMIT 10;
```

Flat Mart

────────

🧠 4. Skills Mart

SQL file

```text
04_create_skills_mart.sql
```

The Skills Mart is designed for understanding skill demand.

It can help answer questions such as:

• Which skills appear most frequently?
• How does demand change over time?
• Which skills are associated with particular job roles?

Example analytical query:

```sql
SELECT
    skill_id,
    month_start_date,
    job_title_short,
    COUNT(*) AS job_count
FROM skills_mart.skill_demand
GROUP BY
    skill_id,
    month_start_date,
    job_title_short
ORDER BY job_count DESC;
```

The intended grain is:

```text
skill + month + job role
```

Skills Mart

────────

⭐ 5. Priority Mart

SQL file

```text
05_create_priority_mart.sql
```

The Priority Mart focuses on selected roles that are important for
analysis.

For example:

```text
Data Engineer          → Priority 1
Data Scientist         → Priority 2
Software Engineer      → Priority 3
Senior Data Engineer   → Priority 4
```

This makes it possible to analyze selected job roles without repeatedly
applying the same filtering logic.

Priority Mart

────────

🔄 6. Incremental Priority Mart

SQL file

```text
06_update_priority_mart.sql
```

This step demonstrates incremental processing.

Instead of rebuilding the entire mart whenever data changes, the source
records are compared with the target table.

```text
                Source
                  │
                  ▼
            Compare Keys
             /         \
            /           \
       Existing          New
          │               │
          ▼               ▼
        UPDATE           INSERT
```

A MERGE statement can handle both cases.

```sql
MERGE INTO priority_mart.priority_roles AS target
USING src_priority_jobs AS source
ON target.role_id = source.role_id

WHEN MATCHED THEN
    UPDATE SET
        role_name = source.role_name,
        priority_lvl = source.priority_lvl

WHEN NOT MATCHED THEN
    INSERT (
        role_id,
        role_name,
        priority_lvl
    )
    VALUES (
        source.role_id,
        source.role_name,
        source.priority_lvl
    );
```

────────

⚠️ Duplicate-Key Consideration

During incremental processing, an existing primary key should not be
inserted again.

For example, if:

```text
role_id = 4
```

already exists, running the same plain INSERT again can produce:

```text
Duplicate key error
```

This is a database execution issue, not a Git issue.

The SQL file can still be committed to Git, but the script should be
corrected so that it can be safely executed according to the intended
workflow.

For repeated incremental loads, use an appropriate MERGE, existence
check, or other upsert strategy.

────────

▶️ How to Run the Project

Open Git Bash and move to the project directory:

```bash
cd ~/Downloads/CSV_DATA/SQL_DATA_ENGINEERING_PROJECT/2_DW_Mart_Build
```

Check the current directory:

```bash
pwd
```

Check the files:

```bash
ls
```

Open the DuckDB database:

```bash
duckdb dw_marts.duckdb
```

Run the SQL scripts:

```sql
.read 01_create_tables_dw.sql
.read 02_Load_Schema_dw.sql
.read 03_create_flat_mart.sql
.read 04_create_skills_mart.sql
.read 05_create_priority_mart.sql
```

For incremental processing:

```sql
.read 06_update_priority_mart.sql
```

Check the available tables:

```sql
SHOW TABLES;
```

────────

🔍 Data Validation

Validation queries are used to make sure the generated marts contain the
expected data.

Check row count

```sql
SELECT COUNT(*)
FROM priority_mart.priority_roles;
```

Inspect records

```sql
SELECT *
FROM priority_mart.priority_roles
ORDER BY priority_lvl;
```

Check duplicate role IDs

```sql
SELECT
    role_id,
    COUNT(*) AS record_count
FROM priority_mart.priority_roles
GROUP BY role_id
HAVING COUNT(*) > 1;
```

These checks help identify problems before the mart is used for
analysis.

────────

🧩 SQL Concepts Practiced

DDL

```sql
CREATE TABLE
DROP TABLE
CREATE SCHEMA
```

DML

```sql
INSERT INTO
UPDATE
MERGE
```

Transformations

```sql
CASE
CAST
DATE_TRUNC
EXTRACT
REPLACE
STRING_AGG
```

Query Techniques

```sql
JOIN
CTE
EXISTS
NOT EXISTS
GROUP BY
ORDER BY
```

Data Engineering Concepts

• Star schema
• Fact tables
• Dimension tables
• Bridge tables
• Data grain
• ETL
• Incremental processing
• Data validation
• Idempotent processing
• Analytical data marts

────────

🖼️ Project Visuals

Pipeline Architecture

Project Pipeline

The complete workflow can be summarized as:

```text
             RAW CSV DATA
                   │
                   ▼
          Extract / Load
                   │
                   ▼
          Data Warehouse
            Star Schema
                   │
                   ▼
             Transform
                   │
        ┌──────────┼──────────┐
        ▼          ▼          ▼
      Flat       Skills    Priority
      Mart        Mart       Mart
        │          │          │
        └──────────┼──────────┘
                   ▼
             BI / Analytics
```

────────

📈 Business Questions Supported

The resulting warehouse and marts can be used to investigate questions
such as:

Skills

• What skills are most requested?
• Which skills are growing in demand?
• Which skills are associated with specific roles?

Jobs

• Which job roles have the highest posting volume?
• How does demand change over time?
• What salary patterns exist across roles?

Companies

• Which companies have the highest hiring activity?
• How does hiring vary by location?
• Which roles are most common for a company?

────────

🚀 Future Improvements

Possible improvements include:

• Add automated data-quality tests
• Add pipeline logging
• Connect the marts to Power BI
• Add scheduled incremental loads
• Add additional analytical marts
• Add automated SQL execution
• Containerize the development environment
• Add CI checks for SQL scripts

────────

👨‍💻 Project Takeaway

This project helped me understand how SQL can be used beyond individual
queries to build a complete analytical data workflow.

The key learning was connecting:

```text
SQL
 ↓
ETL
 ↓
Data Modeling
 ↓
Warehouse
 ↓
Data Marts
 ↓
Incremental Processing
 ↓
Analytics
```

The project demonstrates practical experience with SQL, DuckDB,
dimensional modeling, ETL, data marts, Git/GitHub, and incremental data
processing.