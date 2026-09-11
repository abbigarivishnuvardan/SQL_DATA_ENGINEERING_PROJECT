create database jobs_mart;
create database  if not exists jobs_mart;
show databases;
drop database if exists jobs_mart;


--CREATING AND DELETEING A DATABASES
select * from information_schema.schemata;
create schema jobs_mart.staging;
use jobs_mart;
-- use the database

--we cannot anything id data_jobs because it is in read_mode

create schema if not exists staging;
drop schema staging;  

create table prefered_name(role_id int primary key,role_name varchar);

select * from information_schema.tables
where table_catalog='jobs_mart';

--rop table prefered_name; 

--primary kry won't allow repeated values
insert into prefered_name(role_id,role_name)
values
(9,'data engineer');,(2,'senier_data_engineer');
select * from prefered_name;
drop table prefered_name;










--------------alter commands


 alter table prefered_name
 add column prefered_role boolean;
 select * from prefered_name;


        --rename the table  name
alter table priority_name
rename to priority_one;
        --rename the column name
alter table priority_name
rename role_name to employe_name;

select * from priority_one;
            --change data type
alter table priority_one
alter column prefered_role type integer;

 drop column colum_name;



 ------update
 update prefered_name
 set prefered_role=TRUE
 where role_name='data engineer';
 select * from prefered_name;

update prefered_name
 set role_name='data_engineer'
 where role_name='data engineer';



-- delete is delete the row values from a table it is used the 
--where condition to delete the particular rows