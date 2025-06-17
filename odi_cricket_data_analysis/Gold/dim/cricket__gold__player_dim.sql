use role sysadmin;
use warehouse sysadmin_wh;
use schema cricket.gold;

-- select * from cricket.silver.player_clean_tbl limit 10;

-- select country, player_name 
-- from cricket.silver.player_clean_tbl
-- group by country, player_name
-- order by country, player_name;

-- select
--     pl.country,
--     team.team_id,
--     pl.player_name
-- from cricket.silver.player_clean_tbl pl join
-- cricket.gold.team_dim team
-- on pl.country = team.team_name
-- group by pl.country, team.team_id, pl.player_name
-- order by pl.country, pl.player_name;

insert into cricket.gold.player_dim (team_id, player_name)
select
    team.team_id,
    pl.player_name
from cricket.silver.player_clean_tbl pl join
cricket.gold.team_dim team
on pl.country = team.team_name
group by team.team_id, pl.player_name
order by team.team_id, pl.player_name; 

-- select * from cricket.gold.player_dim;







