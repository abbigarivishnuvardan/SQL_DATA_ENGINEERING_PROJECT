--creating a star schema tables
--step 1 these is
--duckdb dw_marts.duckdb -c ".read build_marts.sql"
.read 01_create_tables_dw.sql

-- step 2: DW  - Load data from csv files
-- into tables
.read 02_Load_Schema_dw.sql
--
.read 03_create_flat_mart.sql

.read 04_create_skills_mart.sql
.read 05_create_priority_mart.sql 
.read 06_update_priority_mart.sql 