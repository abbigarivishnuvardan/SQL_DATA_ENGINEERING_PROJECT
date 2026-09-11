--Subquery 
select * 
from (
    select * 
    from data_jobs.job_postings_fact 
    where salary_year_avg is Not null or salary_hour_avg is not null)
limit 10;

with valid_salaries as (
    select * 
    from data_jobs.job_postings_fact 
    where salary_year_avg is Not null or salary_hour_avg is not null
) 
limit 10;
select valid_salaries from data_jobs;
select * 
    from data_jobs.job_postings_fact 
    where salary_year_avg is Not null or salary_hour_avg is not null
 as valid_salaries
limit 10;
select * from information_schema.tables;
select * from information_schema.tables;
select * from jobs_mart.priority_one;
select range(101);


select * from range(9) as src(key)
where not exists(select 1 from range(6)as tgt(key)
where src.key=tgt.key);




select * from range(9) as src(key)
where exists(select 1 from range(6)as tgt(key)
where src.key=tgt.key); 
--first vales comparing hte second values
select * from job_postings_fact as tgt
where not exists(select 1 from skills_job_dim
as src
where tgt.job_id=src.job_id)
order by job_id 
limit 10;