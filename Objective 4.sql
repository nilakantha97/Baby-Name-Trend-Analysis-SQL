-- Objective 4 Explore unique names in the dataset
-- Your final objective is to find the most popular androgynous names, the shortest and longest names, and
-- the state with the highest percent of babies named "Chris".

-- Task 1
-- Find the 10 most popular androgynous names (names given to both females and males)
Select Name, Count(distinct Gender) as num_genders, sum(Births) as num_babies
from names
group by Name
having num_genders >=2
order by num_babies desc
limit 10;

-- Task 2
-- Find the length of the shortest and longest names, and identify the most popular short names 
-- (those with the fewest characters) and long names (those with the most characters)

select name, length(name) as name_length from names
order by name_length; -- 2

select name, length(name) as name_length from names
order by name_length desc; -- 15

with short_long_name as (
select * from names where length(name) in (2,15)
)

select Name, sum(Births) as num_babies
FROM short_long_name
group by name
order by num_babies desc;

-- Task 3
-- The founder of Maven Analytics is named Chris. 
-- Find the state with the highest percent of babies named "Chris"

select state, num_chris/num_babies * 100 as chris_pct from
(With count_chris as(
select State, sum(Births) as num_chris
from names
where name = 'Chris'
group by State),

count_all as(
select State, sum(Births) as num_babies
from names
group by State)

select cc.state, cc.num_chris, ca.num_babies from count_chris cc inner join
count_all ca on cc.state = ca.state) as state_chris_all
order by chris_pct desc;