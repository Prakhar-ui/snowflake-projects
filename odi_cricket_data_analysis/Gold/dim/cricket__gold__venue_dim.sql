use role sysadmin;
use warehouse sysadmin_wh;
use schema cricket.gold;

-- select distinct venue, city 
-- from cricket.silver.match_details_clean;

insert into cricket.gold.venue_dim (venue_name, city)
select 
    distinct
    venue as venue_name,
    city
from cricket.silver.match_details_clean;

-- select * from cricket.gold.venue_dim  where city = 'Bengaluru';

-- select city from cricket.gold.venue_dim group by city having count(1) > 1;