alter task cricket.bronze.load_delivery_fact resume;
alter task cricket.bronze.load_match_fact resume;
alter task cricket.bronze.load_to_venue_dim resume;
alter task cricket.bronze.load_to_team_dim resume;
alter task cricket.bronze.load_to_player_dim resume;
alter task cricket.bronze.load_to_silver_delivery resume;
alter task cricket.bronze.load_to_silver_player resume;
alter task cricket.bronze.load_to_silver_match resume;
alter task cricket.bronze.load_json_to_bronze resume;


alter task cricket.bronze.load_json_to_bronze suspend;
alter task cricket.bronze.load_to_silver_match suspend;
alter task cricket.bronze.load_to_silver_player suspend;
alter task cricket.bronze.load_to_silver_delivery suspend;
alter task cricket.bronze.load_to_player_dim suspend;
alter task cricket.bronze.load_to_team_dim suspend;
alter task cricket.bronze.load_to_venue_dim suspend;
alter task cricket.bronze.load_match_fact suspend;
alter task cricket.bronze.load_delivery_fact suspend;