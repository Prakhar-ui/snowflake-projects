create or replace stream cricket.bronze.for_match_stream  on table cricket.bronze.match_raw_tbl append_only = true;
create or replace stream cricket.bronze.for_player_stream  on table cricket.bronze.match_raw_tbl append_only = true;
create or replace stream cricket.bronze.for_delivery_stream  on table cricket.bronze.match_raw_tbl append_only = true;
create or replace stream cricket.bronze.for_referee_stream  on table cricket.bronze.match_raw_tbl append_only = true;