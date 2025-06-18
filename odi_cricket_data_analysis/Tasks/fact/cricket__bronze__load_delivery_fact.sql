create or replace task cricket.bronze.load_delivery_fact
    warehouse = 'SYSADMIN_WH'
    after cricket.bronze.load_match_fact
        as 
    insert into cricket.gold.delivery_fact
    select a.* from (
    select
    deliveries.match_type_number as match_id,
    teams.team_id,
    bowler.player_id as bowler_id,
    batter.player_id as batter_id,
    non_striker.player_id as non_striker_id,
    deliveries.over,
    deliveries.runs,
    coalesce(deliveries.extra_runs, 0) as extra_runs,
    coalesce(deliveries.extras_type, 'None') as extras_type,
    coalesce(deliveries.player_out, 'None') as player_out,
    coalesce(deliveries.wicket_type, 'None') as wicket_type
    from 
    cricket.silver.delivery_clean_tbl deliveries
    join cricket.gold.team_dim teams on deliveries.team_name = teams.team_name
    join cricket.gold.player_dim bowler on deliveries.bowler = bowler.player_name
    join cricket.gold.player_dim batter on deliveries.batter = batter.player_name
    join cricket.gold.player_dim non_striker on deliveries.non_striker = non_striker.player_name
    ) a left join cricket.gold.delivery_fact b on a.match_id = b.match_id
    where b.match_id is null
    ;