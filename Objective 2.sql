-- Objective 2 Compare popularity across decades
-- Your second objective is to find the top 3 girl names and
-- top 3 boy names for each year, and also for each decade.

-- For each year, return the 3 most popular girl names and 3 most popular boy names

Select * from (With babies_by_year as (SELECT Year, Gender, Name, sum(Births) as num_babies
FROM names 
group by Year,Gender,Name)

Select Year, Gender, Name, num_babies,
row_number() over(partition by Year, Gender order by num_babies desc) as Popularity
from babies_by_year) as top_three
Where Popularity < 4;

-- For each decade, return the 3 most popular girl names and 3 most popular boy names

Select * from (With babies_by_decade as (SELECT 
(Case 
when year between 1980 and 1989 then 'Eighties'
when year between 1990 and 1999 then 'nineties'
when year between 2000 and 2009 then 'Two Thousands'
else 'none'
end
) as decade,
Gender, Name, sum(Births) as num_babies
FROM names 
group by decade,Gender,Name)

Select decade, Gender, Name, num_babies,
row_number() over(partition by decade, Gender order by num_babies desc) as Popularity
from babies_by_decade) as top_three
Where Popularity < 4;