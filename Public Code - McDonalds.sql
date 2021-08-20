#create the database
drop database if exists MickeyD;
create database MickeyD;
use MickeyD;

#create the table
drop table if exists McMenu;
create table if not exists McMenu #noPkey to start
(
category varchar(100),
item varchar(100),
serving_size varchar(100),
calories numeric,
calories_from_fat numeric,
total_fat numeric,
total_fat_DV decimal (5,2),
saturated_fat numeric,
saturated_fat_DV decimal (5,2),
trans_fat numeric,
cholesterol numeric,
cholesterol_DV decimal (5,2),
sodium numeric,
sodium_DV decimal (5,2),
carbs numeric,
carbs_DV decimal (5,2),
fiber numeric,
fiber_DV decimal (5,2),
sugars numeric,
protein numeric,
vit_a_DV decimal (5,2),
vit_c_DV decimal (5,2),
calcium_DV decimal (5,2),
iron_DV decimal (5,2)
);

#import the data
#use the handy wizard thing to the right (right click on table)

#check it out to make sure it worked
select *
from McMenu
limit 3;

#check the amount of rows is correct - should be 260
use MickeyD;
select count(*)
from McMenu;

#add the pkey
alter table McMenu
add column item_id int primary key auto_increment;

#check it out to make sure it worked
select *
from McMenu
where item_id >250;

#create a view that shows breakfast
create view breakfast as 
select * from McMenu
where McMenu.category like "breakfast";
#check it works
select * from breakfast;

#create a view that shows distinct categories
create view categories as 
select distinct category from McMenu;
#check it works
select * from categories;

#create a view for everything that is liquid/drinkable
#cup,carton, fl oz
create view potable as
select * from McMenu
where serving_size regexp "cup|carton|fl oz";
#check it works
select * from potable;

#create a column that asks if you can drink it
alter table McMenu
add column Potable boolean;
set SQL_Safe_updates = 0;
update McMenu
set Potable = case
	when serving_size regexp "cup|carton|fl oz" then 1
    else 0
    end;
#check it works
select * from McMenu;


#create the other table

#create category ID and category ID table
drop table if exists McCategories;
create table McCategories (
category_ID varchar(10),
category_name varchar(100)
);

#add the index to McMenu
#so can add FK to McCategories

#then add the FK constraint to McCat

#now insert the distinct category names
insert into McCategories(category_name)
select distinct category from McMenu;
#check it works
select * from McCategories;

#now create unique category_ID for each
set SQL_Safe_updates = 0;
update McCategories
set category_id = concat("CLASS",left(category_name,4));
select * from McCategories;
#check it works
select * from McCategories;
#make it the PK via Wizard


#add average caloric count column
alter table McCategories
add column mean_calories numeric (5,2);
set SQL_Safe_updates = 0;
update McCategories as MCC
inner join (select category,avg(calories) as avg_calories
from McMenu
group by category) as MCM
on MCC.category_name=MCM.category
set MCC.mean_calories = MCM.avg_calories;
#check if works
select * from McCategories;




#if you need it
set SQL_Safe_updates = 0;