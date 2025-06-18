create or replace task cricket.bronze.load_to_player_dim
    warehouse = 'SYSADMIN_WH'
    after cricket.bronze.load_to_silver_delivery
        as 
    insert into cricket.gold.player_dim (team_id, player_name)  
    select team.team_id, pl.player_name
    from cricket.silver.player_clean_tbl pl 
    join cricket.gold.team_dim team
    on pl.country = team.team_name
    group by team.team_id, pl.player_name
    minus 
    select team_id, player_name from cricket.gold.player_dim
;