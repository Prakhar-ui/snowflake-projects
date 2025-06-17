use role sysadmin;
use warehouse sysadmin_wh;
use schema cricket.bronze;

create or replace table cricket.bronze.match_raw_tbl (
    meta object not null,
    info variant not null,
    innings array not null,
    stg_file_name text not null,
    stg_file_row_number int not null,
    stg_file_hashkey text not null,
    stg_modified_ts timestamp not null
)
comment = 'This is raw table to store all the json data file with root elements extracted'
;

copy into cricket.bronze.match_raw_tbl from (
    select 
    t.$1:meta::variant as meta,
    t.$1:info::variant as info,
    t.$1:innings::array as innings,
    --
    metadata$filename,
    metadata$file_row_number,
    metadata$file_content_key,
    metadata$file_last_modified
from @cricket.lz.my_stg/cricket/json (file_format => 'cricket.lz.my_json_format') t 
)
on_error = continue;

select count(*) from cricket.bronze.match_raw_tbl;

select * from cricket.bronze.match_raw_tbl limit 10;