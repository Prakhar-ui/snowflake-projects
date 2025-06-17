create or replace task cricket.bronze.load_to_team_dim
    warehouse = 'SYSADMIN_WH'
    after cricket.bronze.load_to_silver_delivery
        as 
    insert into cricket.gold.team_dim (team_name)  
    select distinct team_name from (
    select first_team as team_name from cricket.silver.match_details_clean
    union all
    select second_team as team_name from cricket.silver.match_details_clean
    ) 
    minus
    select team_name from cricket.gold.team_dim
;