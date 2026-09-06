select * from job_postings_fact limit 10;
SHOW TABLES;
SELECT 
    jpf.*,
    cd.*
FROM job_postings_fact as jpf 
left join company_dim as cd 
    on jpf.company_id=cd.company_id
limit 10;
SELECT
*
FROM job_postings_fact as jpf 
left join company_dim as cd 
    on jpf.company_id=cd.company_id
limit 10;
select jpf.*,cd.* from job_postings_fact as jpf inner join company_dim as cd
on jpf.company_id=cd.company_id limit 10;