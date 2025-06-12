use role sysadmin;
use warehouse sysadmin_wh;
use schema cricket.silver;

--extract players
-- select
--     bronze.info:match_type_number::int as match_type_number,
--     bronze.info:players,
--     bronze.info:teams
-- from cricket.bronze.match_raw_tbl bronze;

-- select
--     bronze.info:match_type_number::int as match_type_number,
--     bronze.info:players,
--     bronze.info:teams
-- from cricket.bronze.match_raw_tbl bronze
-- where match_type_number = 3836;

-- select
--     bronze.info:match_type_number::int as match_type_number,
--     -- p.*,
--     p.key::text as country
-- from cricket.bronze.match_raw_tbl bronze,
-- lateral flatten (input => bronze.info:players) p
-- where match_type_number = 3836;

-- select
--     bronze.info:match_type_number::int as match_type_number,
--     p.key::text as country,
--     -- team.*,
--     team.value::text as player_name
-- from cricket.bronze.match_raw_tbl bronze,
-- lateral flatten (input => bronze.info:players) p,
-- lateral flatten (input => p.value) team,
-- where match_type_number = 3836;

create or replace table cricket.silver.player_clean_tbl as 
select
    bronze.info:match_type_number::int as match_type_number,
    p.key::text as country,
    team.value::text as player_name,
    --
    stg_file_name,
    stg_file_row_number,
    stg_file_hashkey,
    stg_modified_ts
from cricket.bronze.match_raw_tbl bronze,
lateral flatten (input => bronze.info:players) p,
lateral flatten (input => p.value) team;

-- desc table cricket.silver.player_clean_tbl;
-- select get_ddl('table', 'cricket.silver.player_clean_tbl');

alter table cricket.silver.player_clean_tbl
modify column match_type_number set not null;

alter table cricket.silver.player_clean_tbl
modify column country set not null;

alter table cricket.silver.player_clean_tbl
modify column player_name set not null;

alter table cricket.silver.match_details_clean
add constraint pk_match_type_number primary key (match_type_number);

alter table cricket.silver.player_clean_tbl
add constraint fk_match_id
foreign key (match_type_number)
references cricket.silver.match_details_clean (match_type_number);