 use role sysadmin;
 use warehouse sysadmin_wh;
 use schema cricket.silver;

--  select
--     m.info:match_type_number::int as match_type_number,
--     m.innings
--  from cricket.bronze.match_raw_tbl as m;

 
--  select
--     m.info:match_type_number::int as match_type_number,
--     innings.value:team::text as team_name,
--     innings.value as innings,
--     innings.value:"overs"
--  from cricket.bronze.match_raw_tbl as m
--  , lateral flatten(input => m.innings) innings
--  where match_type_number = '3836';

--  select
--     m.info:match_type_number::int as match_type_number,
--     innings.value:team::text as team_name,
--     overs.value as deliveries
--  from cricket.bronze.match_raw_tbl as m
--  , lateral flatten(input => m.innings) innings
--  , lateral flatten(input => innings.value:overs) overs
--  where match_type_number = '3836';

--  select
--     m.info:match_type_number::int as match_type_number,
--     innings.value:team::text as team_name,
--     deliveries.value as delivery
--  from cricket.bronze.match_raw_tbl as m
--  , lateral flatten(input => m.innings) innings
--  , lateral flatten(input => innings.value:overs) overs
--  , lateral flatten(input => overs.value:deliveries) deliveries
--  where match_type_number = '3836';

--  select
--     m.info:match_type_number::int as match_type_number,
--     innings.value:team::text as team_name,
--     overs.value:over::int as over,
--     deliveries.value:batter::text as batter,
--     deliveries.value:bowler::text as bowler,
--     deliveries.value:non_striker::text as non_striker,
--     deliveries.value:runs:batter as runs,
--     deliveries.value:runs:extras as extras,
--     deliveries.value:runs:total as total
--  from cricket.bronze.match_raw_tbl as m
--  , lateral flatten(input => m.innings) innings
--  , lateral flatten(input => innings.value:overs) overs
--  , lateral flatten(input => overs.value:deliveries) deliveries
--  where match_type_number = '3836';

--  select
--     m.info:match_type_number::int as match_type_number,
--     innings.value:team::text as team_name,
--     overs.value:over::int + 1 as over,
--     deliveries.value:batter::text as batter,
--     deliveries.value:bowler::text as bowler,
--     deliveries.value:non_striker::text as non_striker,
--     deliveries.value:runs:batter as runs,
--     deliveries.value:runs:extras as extras,
--     deliveries.value:runs:total as total,
--     case when deliveries.value:runs:extras > 0
--     then extras.key
--     else 'NA'
--     end as extras_variant
    
--  from cricket.bronze.match_raw_tbl as m
--  , lateral flatten(input => m.innings) innings
--  , lateral flatten(input => innings.value:overs) overs
--  , lateral flatten(input => overs.value:deliveries) deliveries
--  , lateral flatten(input => deliveries.value:extras, outer => True) extras
--  where match_type_number = '3836';

--  select
--     m.info:match_type_number::int as match_type_number,
--     innings.value:team::text as team_name,
--     overs.value:over::int + 1 as over,
--     deliveries.value:batter::text as batter,
--     deliveries.value:bowler::text as bowler,
--     deliveries.value:non_striker::text as non_striker,
--     deliveries.value:runs:batter as runs,
--     deliveries.value:runs:extras as extras,
--     deliveries.value:runs:total as total,
--     extras.key as extras_type,
--     wickets.value as wickets,
--     wickets.value:kind::text as wicket_type,
--     wickets.value:player_out::text as player_out
    
--  from cricket.bronze.match_raw_tbl as m
--  , lateral flatten(input => m.innings) innings
--  , lateral flatten(input => innings.value:overs) overs
--  , lateral flatten(input => overs.value:deliveries) deliveries
--  , lateral flatten(input => deliveries.value:extras, outer => True) extras
--  , lateral flatten(input => deliveries.value:wickets, outer => True) wickets
--  where match_type_number = '3836'
--  and wickets is not null;

--  select
--     m.info:match_type_number::int as match_type_number,
--     innings.value:team::text as team_name,
--     overs.value:over::int + 1 as over,
--     deliveries.value:batter::text as batter,
--     deliveries.value:bowler::text as bowler,
--     deliveries.value:non_striker::text as non_striker,
--     deliveries.value:runs:batter as runs,
--     deliveries.value:runs:extras as extras,
--     deliveries.value:runs:total as total,
--     extras.key as extras_type,
--     wickets.value:kind::text as wicket_type,
--     wickets.value:player_out::text as player_out,
--     fielders.value:name::text as fielder_name
--  from cricket.bronze.match_raw_tbl as m
--  , lateral flatten(input => m.innings) innings
--  , lateral flatten(input => innings.value:overs) overs
--  , lateral flatten(input => overs.value:deliveries) deliveries
--  , lateral flatten(input => deliveries.value:extras, outer => True) extras
--  , lateral flatten(input => deliveries.value:wickets, outer => True) wickets
--  , lateral flatten(input => wickets.value:fielders, outer => True) fielders
--  where match_type_number = '3836';

 create or replace table cricket.silver.delivery_clean_tbl as
 select
    m.info:match_type_number::int as match_type_number,
    innings.value:team::text as team_name,
    overs.value:over::int + 1 as over,
    deliveries.value:batter::text as batter,
    deliveries.value:bowler::text as bowler,
    deliveries.value:non_striker::text as non_striker,
    deliveries.value:runs:batter as runs,
    deliveries.value:runs:extras as extras,
    deliveries.value:runs:total as total,
    extras.key as extras_type,
    wickets.value:kind::text as wicket_type,
    wickets.value:player_out::text as player_out,
    fielders.value:name::text as fielder_name
 from cricket.bronze.match_raw_tbl as m
 , lateral flatten(input => m.innings) innings
 , lateral flatten(input => innings.value:overs) overs
 , lateral flatten(input => overs.value:deliveries) deliveries
 , lateral flatten(input => deliveries.value:extras, outer => True) extras
 , lateral flatten(input => deliveries.value:wickets, outer => True) wickets
 , lateral flatten(input => wickets.value:fielders, outer => True) fielders
;

-- select distinct match_type_number from cricket.silver.delivery_clean_tbl;

-- desc table cricket.silver.delivery_clean_tbl;

alter table cricket.silver.delivery_clean_tbl
modify column match_type_number set not null;

alter table cricket.silver.delivery_clean_tbl
modify column team_name set not null;

alter table cricket.silver.delivery_clean_tbl
modify column over set not null;

alter table cricket.silver.delivery_clean_tbl
modify column bowler set not null;

alter table cricket.silver.delivery_clean_tbl
modify column batter set not null;

alter table cricket.silver.delivery_clean_tbl
modify column non_striker set not null;

alter table cricket.silver.delivery_clean_tbl
add constraint fk_delivery_match_id
foreign key (match_type_number)
references cricket.silver.match_details_clean (match_type_number);
