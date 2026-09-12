-- Step 6: Mart - Incrementally update priority roles mart
-- Execute this section after completing Step 5
-- This script demonstrates how incremental changes are applied to the priority mart

-- Step 1: Modify an existing priority role
-- Set the priority level of Data Engineer to 1
UPDATE priority_mart.priority_roles
SET priority_lvl = 1
WHERE role_name = 'Data Engineer';

-- Step 2: Add a new priority role
-- Insert Data Scientist as a new priority role with level 2
INSERT INTO priority_mart.priority_roles (role_id, role_name, priority_lvl)
VALUES (4, 'Data Scientist', 2);

-- Step 3: Build a temporary source table
-- This table represents the latest priority job information from the data warehouse
CREATE OR REPLACE TEMP TABLE src_priority_jobs AS
SELECT
jpf.job_id,
jpf.job_title_short,
cd.name AS company_name,
jpf.job_posted_date,
jpf.salary_year_avg,
r.priority_lvl,
CURRENT_TIMESTAMP AS updated_at
FROM
job_postings_fact AS jpf                          -- use the main schema
LEFT JOIN company_dim AS cd                           -- use the main schema
ON jpf.company_id = cd.company_id
INNER JOIN priority_mart.priority_roles AS r               -- use the priority_mart schema
ON jpf.job_title_short = r.role_name;

-- Step 4: Merge the latest data into the snapshot table
-- This MERGE statement handles:
-- - Updating existing jobs when their priority level changes
-- - Inserting newly identified priority jobs
-- - Removing jobs that are no longer present in the source
MERGE INTO priority_mart.priority_jobs_snapshot AS tgt     -- use the priority_mart schema
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
UPDATE SET
priority_lvl = src.priority_lvl,
updated_at = src.updated_at

WHEN NOT MATCHED THEN
INSERT (
job_id,
job_title_short,
company_name,
job_posted_date,
salary_year_avg,
priority_lvl,
updated_at
)
VALUES (
src.job_id,
src.job_title_short,
src.company_name,
src.job_posted_date,
src.salary_year_avg,
src.priority_lvl,
src.updated_at
)

WHEN NOT MATCHED BY SOURCE THEN DELETE;

-- Verify that the priority mart contains the updated records
SELECT 'Priority Roles Dimension' AS table_name, COUNT(*) as record_count FROM priority_mart.priority_roles
UNION ALL
SELECT 'Priority Jobs Snapshot', COUNT(*) FROM priority_mart.priority_jobs_snapshot;

-- Display sample records from the priority mart tables
SELECT '=== Priority Roles Dimension Sample ===' AS info;
SELECT * FROM priority_mart.priority_roles;

SELECT '=== Priority Jobs Snapshot Sample ===' AS info;
SELECT
job_title_short,
COUNT(*) AS job_count,
MIN(priority_lvl) AS priority_lvl,
MIN(updated_at) AS updated_at
FROM priority_mart.priority_jobs_snapshot          -- use the priority_mart schema
GROUP BY job_title_short
ORDER BY job_count DESC;
