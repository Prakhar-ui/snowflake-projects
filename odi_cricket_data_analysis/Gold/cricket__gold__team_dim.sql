use role sysadmin;
use warehouse sysadmin_wh;
use schema cricket.gold;

-- select distinct team_name from (
-- select first_team as team_name 
-- from cricket.silver.match_details_clean
-- union all
-- select second_team as team_name
-- from cricket.silver.match_details_clean
-- );

insert into cricket.gold.team_dim (team_name)
select distinct team_name from (
select first_team as team_name 
from cricket.silver.match_details_clean
union all
select second_team as team_name
from cricket.silver.match_details_clean
) order by team_name;