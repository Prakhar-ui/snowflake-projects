create or replace task cricket.bronze.load_to_silver_player
    warehouse = 'SYSADMIN_WH'
    after cricket.bronze.load_to_silver_match
    when system$stream_has_data ('cricket.bronze.for_player_stream')
        as 
    insert into cricket.silver.player_clean_tbl  
    select
    bronze.info:match_type_number::int as match_type_number,
    p.key::text as country,
    team.value::text as player_name,
    --
    stg_file_name,
    stg_file_row_number,
    stg_file_hashkey,
    stg_modified_ts
    from 
    cricket.bronze.for_player_stream,
    lateral flatten (input => bronze.info:players) p,
    lateral flatten (input => p.value) team
;