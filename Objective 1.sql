-- Objective 1 Track changes in name popularity
-- Your first objective is to see how the most popular 
-- names have changed over time, and also to identify the names
-- that have jumped the most in terms of popularity.

-- 1 Find the overall most popular girl and boy names and 
-- show how they have changed in popularity rankings over the years

SELECT * FROM names;

SELECT Name, sum(Births) as num_babies
FROM names where Gender = 'F'
group by Name
order by num_babies DESC
LIMIT 1; -- Jessica

SELECT Name, sum(Births) as num_babies
FROM names where Gender = 'M'
group by Name
order by num_babies DESC
LIMIT 1; -- Michael


Select * from (With girl_names as (SELECT Year, Name, sum(Births) as num_babies
FROM names 
where Gender = 'F'
group by Year,Name)

Select Year, Name, num_babies,
row_number() over(partition by Year order by num_babies desc) as Popularity
from girl_names) as popular_girl_name where Name = "Jessica";


Select * from (With boy_names as (SELECT Year, Name, sum(Births) as num_babies
FROM names 
where Gender = 'M'
group by Year,Name)

Select Year, Name, num_babies,
row_number() over(partition by Year order by num_babies desc) as Popularity
from boy_names) as popular_boy_name where Name = "Michael";

-- 2 Find the names with the biggest jumps in popularity from 
-- the first year of the data set to the last year

with names_1980 as (
With all_names as (SELECT Year, Name, sum(Births) as num_babies
FROM names 
group by Year,Name)

Select Year, Name, num_babies,
row_number() over(partition by Year order by num_babies desc) as Popularity
from all_names where Year= 1980),

names_2009 as(
With all_names as (SELECT Year, Name, sum(Births) as num_babies
FROM names 
group by Year,Name)
Select Year, Name, num_babies,
row_number() over(partition by Year order by num_babies desc) as Popularity
from all_names where Year= 2009)

Select t1.Name, t1.Year, t1.Popularity, t2.Name, t2.Year, t2.Popularity,
cast(t2.Popularity as signed) - cast(t1.Popularity as signed) as diff
from names_1980 t1 inner join names_2009 t2 
on t1.Name=t2.Name 
order by diff;