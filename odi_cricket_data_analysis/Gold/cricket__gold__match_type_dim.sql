use role sysadmin;
use warehouse sysadmin_wh;
use schema cricket.gold;

-- select distinct match_type from cricket.silver.match_details_clean;

insert into cricket.gold.match_type_dim (match_type)
select distinct match_type from cricket.silver.match_details_clean;

-- select * from cricket.gold.match_type_dim;