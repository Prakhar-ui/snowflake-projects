use role sysadmin;
use warehouse sysadmin_wh;
use schema cricket.gold;

create or replace table date_dim (
    date_id int primary key autoincrement,
    full_dt date,
    day int,
    month int,
    year int,
    quarter int,
    dayofweek int,
    dayofmonth int,
    dayofyear int,
    dayofweekname varchar(3),
    isweekend boolean
);

create or replace table referee_dim (
    referee_id int primary key autoincrement,
    referee_name text not null,
    referee_type text not null
);

create or replace table team_dim (
    team_id int primary key autoincrement,
    team_name text not null
);

create or replace table player_dim (
    player_id int primary key autoincrement,
    team_id int not null,
    player_name text not null
);

alter table cricket.gold.player_dim
add constraint fk_team_player_id
foreign key (team_id)
references cricket.gold.team_dim (team_id);

create or replace table venue_dim (
    venue_id int primary key autoincrement,
    venue_name text not null,
    city text not null,
    state text,
    country text,
    continent text,
    end_Names text,
    capacity number,
    pitch text,
    flood_light boolean,
    established_at date,
    playing_area text,
    other_sports text,
    curator text,
    latitude number(10, 6),
    longitude number(10, 6)
);

create or replace table match_type_dim (
    match_type_id int primary key autoincrement,
    match_type text not null
);

create or replace table match_fact (
    match_id INT PRIMARY KEY autoincrement,
    date_id INT NOT NULL,
    match_referee_id INT NOT NULL,
    reserve_umpire_id INT NOT NULL,
    tv_umpire_id INT NOT NULL,
    first_umpire_id INT NOT NULL,
    second_umpire_id INT NOT NULL,
    team_a_id INT NOT NULL,
    team_b_id INT NOT NULL,
    match_type_id INT NOT NULL,
    venue_id INT NOT NULL,
    total_overs number(3),
    balls_per_over number(1),

    overs_played_by_team_a number(2),
    bowls_played_by_team_a number(3),
    extra_bowls_played_by_team_a number(3),
    extra_runs_scored_by_team_a number(3),
    fours_by_team_a number(3),
    sixes_by_team_a number(3),
    total_score_by_team_a number(3),
    wicket_lost_by_team_a number(2),

    overs_played_by_team_b number(2),
    bowls_played_by_team_b number(3),
    extra_bowls_played_by_team_b number(3),
    extra_runs_scored_by_team_b number(3),
    fours_by_team_b number(3),
    sixes_by_team_b number(3),
    total_score_by_team_b number(3),
    wicket_lost_by_team_b number(2),

    toss_winner_team_id int not null,
    toss_decision text not null,
    match_result text not null,
    winner_team_id int not null,

    CONSTRAINT fk_date FOREIGN KEY (date_id) REFERENCES date_dim (date_id),

    CONSTRAINT fk_match_referee FOREIGN KEY (match_referee_id) REFERENCES referee_dim (referee_id),
    CONSTRAINT fk_reserve_umpire FOREIGN KEY (reserve_umpire_id) REFERENCES referee_dim (referee_id),
    CONSTRAINT fk_tv_umpire FOREIGN KEY (tv_umpire_id) REFERENCES referee_dim (referee_id),
    CONSTRAINT fk_first_umpire FOREIGN KEY (first_umpire_id) REFERENCES referee_dim (referee_id),
    CONSTRAINT fk_second_umpire FOREIGN KEY (second_umpire_id) REFERENCES referee_dim (referee_id),

    CONSTRAINT fk_team_a FOREIGN KEY (team_a_id) REFERENCES team_dim (team_id),
    CONSTRAINT fk_team_b FOREIGN KEY (team_b_id) REFERENCES team_dim (team_id),
    CONSTRAINT fk_match_type FOREIGN KEY (match_type_id) REFERENCES match_type_dim (match_type_id),
    CONSTRAINT fk_venue FOREIGN KEY (venue_id) REFERENCES venue_dim (venue_id),

    CONSTRAINT fk_toss_winner_team FOREIGN KEY (toss_winner_team_id) REFERENCES team_dim (team_id),
    CONSTRAINT fk_winner_team FOREIGN KEY (winner_team_id) REFERENCES team_dim (team_id)  
);



CREATE OR REPLACE TABLE delivery_fact (
    match_id INT, 
    team_id INT,
    bowler_id INT,
    batter_id INT,
    non_striker_id INT,
    over INT,
    runs INT,
    extra_runs INT,
    extra_type VARCHAR(255),
    player_out VARCHAR(255),
    wicket_type VARCHAR(255),

    CONSTRAINT fk_delivery_match_id FOREIGN KEY (match_id) REFERENCES match_fact (match_id),
    CONSTRAINT fk_delivery_team FOREIGN KEY (team_id) REFERENCES team_dim (team_id),
    
    CONSTRAINT fk_bowler FOREIGN KEY (bowler_id) REFERENCES player_dim (player_id),
    CONSTRAINT fk_batter FOREIGN KEY (batter_id) REFERENCES player_dim (player_id),
    CONSTRAINT fk_striker FOREIGN KEY (non_striker_id) REFERENCES player_dim (player_id)
);

