use role sysadmin;
use warehouse sysadmin_wh;
use schema cricket.gold;

-- select
--     * 
-- from cricket.silver.delivery_clean_tbl
-- where match_type_number = 4686;

-- select
--     d.match_type_number as match_id,
--     td.team_id
-- from 
-- cricket.silver.delivery_clean_tbl d
-- join team_dim td on d.team_name = td.team_name
-- where match_type_number = 4686;

-- select
--     deliveries.match_type_number as match_id,
--     teams.team_id,
--     bowler.player_id as bowler_id,
--     deliveries.bowler,
--     batter.player_id as batter_id,
--     deliveries.batter,
--     non_striker.player_id as non_striker_id,
--     deliveries.non_striker,
--     deliveries.over,
--     deliveries.runs,
--     coalesce(deliveries.extra_runs, 0) as extra_runs,
--     coalesce(deliveries.extras_type, 'None') as extras_type,
--     coalesce(deliveries.player_out, 'None') as player_out,
--     coalesce(deliveries.wicket_type, 'None') as wicket_type
-- from 
--     cricket.silver.delivery_clean_tbl deliveries
--     join team_dim teams on deliveries.team_name = teams.team_name
--     join player_dim bowler on deliveries.bowler = bowler.player_name
--     join player_dim batter on deliveries.batter = batter.player_name
--     join player_dim non_striker on deliveries.non_striker = non_striker.player_name
-- where deliveries.match_type_number = 4686 ;

INSERT INTO delivery_fact 
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
    join team_dim teams on deliveries.team_name = teams.team_name
    join player_dim bowler on deliveries.bowler = bowler.player_name
    join player_dim batter on deliveries.batter = batter.player_name
    join player_dim non_striker on deliveries.non_striker = non_striker.player_name
;
