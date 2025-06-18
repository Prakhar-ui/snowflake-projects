create or replace task cricket.bronze.load_to_silver_delivery
    warehouse = 'SYSADMIN_WH'
    after cricket.bronze.load_to_silver_player
    when system$stream_has_data ('cricket.bronze.for_delivery_stream')
        as 
    insert into cricket.silver.delivery_clean_tbl  
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
    extras.key::text as extras_type,
    extras.value::number as extra_runs,
    wickets.value:kind::text as wicket_type,
    wickets.value:player_out::text as player_out,
    fielders.value:name::text as fielder_name,
    --
    m.stg_file_name,
    m.stg_file_row_number,
    m.stg_file_hashkey,
    m.stg_modified_ts
 from cricket.bronze.for_delivery_stream as m
 , lateral flatten(input => m.innings) innings
 , lateral flatten(input => innings.value:overs) overs
 , lateral flatten(input => overs.value:deliveries) deliveries
 , lateral flatten(input => deliveries.value:extras, outer => True) extras
 , lateral flatten(input => deliveries.value:wickets, outer => True) wickets
 , lateral flatten(input => wickets.value:fielders, outer => True) fielders
;