create or replace task cricket.bronze.load_match_fact
    warehouse = 'SYSADMIN_WH'
    after cricket.bronze.load_to_team_dim, cricket.bronze.load_to_player_dim, cricket.bronze.load_to_venue_dim, cricket.bronze.load_to_referee_dim
        as 
    insert into cricket.gold.match_fact
    select a.* from (
    select 
    m.match_type_number as match_id,
    dd.date_id,
    m.match_referee,
    m.reserve_umpire,
    m.tv_umpire,
    m.first_umpire,
    m.second_umpire,
    ft.team_id as team_a_id,
    st.team_id as team_b_id,
    mt.match_type_id,
    vn.venue_id,
    50 as total_overs,
    6 as balls_per_overs,
    
    max(case when d.team_name = m.first_team then d.over else 0 end) as OVERS_PLAYED_BY_TEAM_A,
    sum(case when d.team_name = m.first_team then 1 else 0 end) as BALLS_PLAYED_BY_TEAM_A,
    sum(case when d.team_name = m.first_team then d.extras else 0 end) as extra_BALLS_PLAYED_BY_TEAM_A,
    sum(case when d.team_name = m.first_team then d.extra_runs else 0 end) as extra_runs_scored_by_team_A,
    sum(case when d.team_name = m.first_team and d.runs = 4 then 1 else 0 end) as fours_by_team_A,
    sum(case when d.team_name = m.first_team and d.runs = 6 then 1 else 0 end) as sixes_by_team_A,
    (
        sum(case when d.team_name = m.first_team then d.runs else 0 end) + 
        sum(case when d.team_name = m.first_team then d.extra_runs else 0 end)
    ) as total_runs_scored_by_team_A,
    sum(case when d.team_name = m.first_team and player_out is not null then 1 else 0 end) as wicket_list_by_team_a,
    
    max(case when d.team_name = m.second_team then d.over else 0 end) as OVERS_PLAYED_BY_TEAM_B,
    sum(case when d.team_name = m.second_team then 1 else 0 end) as BALLS_PLAYED_BY_TEAM_B,
    sum(case when d.team_name = m.second_team then d.extras else 0 end) as extra_BALLS_PLAYED_BY_TEAM_B,
    sum(case when d.team_name = m.second_team then d.extra_runs else 0 end) as extra_runs_scored_by_team_B,
    sum(case when d.team_name = m.first_team and d.runs = 4 then 1 else 0 end) as fours_by_team_B,
    sum(case when d.team_name = m.first_team and d.runs = 6 then 1 else 0 end) as sixes_by_team_B,
    (
        sum(case when d.team_name = m.second_team then d.runs else 0 end) + 
        sum(case when d.team_name = m.second_team then d.extra_runs else 0 end)
    ) as total_runs_scored_by_team_B,
    sum(case when d.team_name = m.second_team and player_out is not null then 1 else 0 end) as wicket_list_by_team_b,
    
    case when m.toss_winner = ft.team_name then ft.team_id else st.team_id end as toss_winner_team_id,
    m.toss_decision as toss_decision,
    m.match_result,
    case when m.winner = ft.team_name then ft.team_id else st.team_id end as winner_team_id
    from 
    cricket.silver.match_details_clean m
    join cricket.gold.date_dim dd on m.event_date = dd.full_dt
    join cricket.gold.team_dim ft on m.first_team = ft.team_name
    join cricket.gold.team_dim st on m.second_team = st.team_name
    join cricket.gold.match_type_dim mt on m.match_type = mt.match_type
    join cricket.gold.venue_dim vn on m.venue = vn.venue_name
    join cricket.silver.delivery_clean_tbl d on m.match_type_number = d.match_type_number
    group by 
    m.match_type_number,
    dd.date_id,
    m.match_referee,
    m.reserve_umpire,
    m.tv_umpire,
    m.first_umpire,
    m.second_umpire,
    ft.team_id,
    st.team_id,
    mt.match_type_id,
    vn.venue_id,
    m.toss_winner,
    m.toss_decision,
    m.match_result,
    m.winner,
    ft.team_name
    ) a left join cricket.gold.match_fact b on a.match_id = b.match_id
    where b.match_id is null
    ;