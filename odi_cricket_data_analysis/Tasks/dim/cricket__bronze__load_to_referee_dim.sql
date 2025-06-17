create or replace task cricket.bronze.load_to_referee_dim
    warehouse = 'SYSADMIN_WH'
    after cricket.bronze.load_to_silver_delivery
    when system$stream_has_data ('cricket.bronze.for_referee_stream')
        as 
    insert into cricket.gold.referee_dim (REFEREE_NAME, REFEREE_TYPE)
    with officials_flat as (
    select distinct
        info:officials.match_referees[0]::string as referee_name,
        'match_referee' as referee_type
    from cricket.bronze.for_referee_stream
    where info:officials.match_referees[0] is not null

    union

    select distinct
        info:officials.reserve_umpires[0]::string as referee_name,
        'reserve_umpire' as referee_type
    from cricket.bronze.for_referee_stream
    where info:officials.reserve_umpires[0] is not null

    union

    select distinct
        info:officials.tv_umpires[0]::string as referee_name,
        'tv_umpire' as referee_type
    from cricket.bronze.for_referee_stream
    where info:officials.tv_umpires[0] is not null

    union

    select distinct
        info:officials.umpires[0]::string as referee_name,
        'first_umpire' as referee_type
    from cricket.bronze.for_referee_stream
    where info:officials.umpires[0] is not null

    union

    select distinct
        info:officials.umpires[1]::string as referee_name,
        'second_umpire' as referee_type
    from cricket.bronze.for_referee_stream
    where info:officials.umpires[1] is not null
)
select distinct
    referee_name,
    referee_type
from officials_flat;