create or replace task cricket.bronze.load_to_silver_delivery
    warehouse = 'SYSADMIN_WH'
    after cricket.bronze.load_to_silver_player
    when system$stream_has_data ('cricket.bronze.for_delivery_stream')
        as 
    insert into cricket.silver.delivery_clean_tbl  
    select 
    info:match_type_number::int as match_type_number,
    info:event.name::text as event_name,
    coalesce(info:event.match_number::text, 
            info:event.stage::text,
            'NA') as match_stage,
    info:dates[0]::date as event_date,
    date_part('year', info:dates[0]::date) as event_year,
    date_part('month', info:dates[0]::date) as event_month,
    date_part('day', info:dates[0]::date) as event_day,
    info:match_type::text as match_type,
    info:season::text as season,
    info:team_type::text as team_type,
    info:overs::text as overs,
    coalesce(info:city::text, 'NA') as city,
    info:venue::text as venue,
    info:gender::text as gender,
    info:teams[0]::text as first_team,
    info:teams[1]::text as second_team,
    case
        when info:outcome.winner is not null then 'Result Declared'
        when info:outcome.result = 'tie' then 'Tie'
        when info:outcome.result = 'no result' then 'No Result'
        else info:outcome.result
    end as match_result,
    coalesce(info:outcome.winner, 'NA') as winner,
    info:toss.winner::text as toss_winner,
    initcap(info:toss.decision::text) as toss_decision,
    info:officials.match_referees[0]::string as match_referee,
    info:officials.reserve_umpires[0]::string as reserve_umpire,
    info:officials.tv_umpires[0]::string as tv_umpire,
    info:officials.umpires[0]::string as first_umpire,
    info:officials.umpires[1]::string as second_umpire,  
    --
    stg_file_name,
    stg_file_row_number,
    stg_file_hashkey,
    stg_modified_ts
    from
    cricket.bronze.for_delivery_stream
;