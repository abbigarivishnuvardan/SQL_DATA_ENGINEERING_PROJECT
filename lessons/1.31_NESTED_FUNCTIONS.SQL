--ARRAY INTRO
SELECT [1,2,3,4,5] 
select ['python','sql','r'] as skill_array;


with skills as (
    select 'python' as skill  --skills is temperary
                                   -- table table name
    union all 
    select 'sql' as temp_s
    union all 
    select 'r'
)
select skill 
from skills;


with skills as (
    select 'python' as skill  
    union all 
    select 'sql' as temp_s
    union all 
    select 'r'
),skills_array as 
(select array_agg(skill) as skills
from skills)
select 
    skills
from skills_array;


/*WITH cte_name AS (
    SELECT column1, column2
    FROM table_name
    WHERE condition
)
SELECT *
FROM cte_name
WHERE column1 = 'value';
*/

--struct 
with skill_struct as(
select 
    struct_pack(
    skill:='python',
    type:='programming'
    ) as s
)
select * 
from
skill_struct ;


with skill_struct as(
select 
    * from range(10) as s,range(10) 
    as d
)
select * 
from
skill_struct ;




with skill_struct as(
select 
    struct_pack(
    skill:='python',
    type:='programming'
    ) as s
)
select s.skill,s.type
from
skill_struct ;      

with skill_table as (
    select 'python' as skills,'programming' as types
    union all 
    select 'sql','query_languaage'
    union all                                     --entire result will come on only one line
    select 'r','programming'
),skills_array_struct 
as
(select array_agg(struct_pack(
    skill:=skills,
    type:=types )) as array_struct
from skill_table)
select array_struct[1],
array_struct[2],array_struct[3] 
from skills_array_struct;


with skill_map as 
(select map{'skill':'python','type':'coding'} as 
skill_type)
select 
    skill_type['skill'],skill_type['type']
from 
skill_map;


select {"skill":"python","type":"coding"} 
AS ::JSON kill_json;


select TO_JSON{"skill":"python","type":"coding"} 
as
kill_json;
select * from skills_dim limit 9;

--git branch   main is defalut
--git swith feature/project2-readme
--git -d feature/project2-readme it
--wont delete it will delete after swith the 
--another branch
 