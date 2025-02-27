-- Objective 3 Compare popularity across regions
-- Your third objective is to find the number of babies born in each region, and
-- also return the top 3 girl names and top 3 boy names within each region.

-- Task 1
-- Return the number of babies born in each of the six regions 
-- (NOTE: The state of MI should be in the Midwest region)

SELECT * FROM regions;
SELECT  distinct(Region) from regions;

with clean_regions as (Select state,
case when Region = 'New_England' then 'New England' else Region end as clean_region from regions
union
select 'MI' as State, 'Midwest' as Region)

select clean_region, sum(Births) as num_babies
from names n
left join clean_regions cr
on n.state = cr.state
group by clean_region;

-- Task 2
-- Return the 3 most popular girl names and 3 most popular boy names within each region

Select * from (
with babies_by_region as(
	with clean_regions as (Select state,
	case when Region = 'New_England' then 'New England' else Region end as clean_region from regions
	union
	select 'MI' as State, 'Midwest' as Region)

	select cr.clean_region,n.Gender, n.Name, sum(n.Births) as num_babies
	from names n
	left join clean_regions cr
	on n.state = cr.state
	group by cr.clean_region,n.Gender, n.Name)
    
Select clean_region, Gender, Name,
row_number() over(partition by clean_region, Gender order by num_babies desc) as Popularity
from babies_by_region ) as top_three
Where Popularity < 4;
