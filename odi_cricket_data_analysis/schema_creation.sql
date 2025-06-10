use role sysadmin;

use warehouse sysadmin_wh;

create database if not exists cricket;
create or replace schema cricket.lz;
create or replace schema cricket.bronze;
create or replace schema cricket.silver;
create or replace schema cricket.gold;

show schemas in database cricket;

use schema cricket.lz;

create or replace file format cricket.lz.my_json_format
type = json,
null_if = ('\\n', 'null', '')
strip_outer_array = true,
comment = 'Json File Format with outer strip array flag true';

create or replace stage cricket.lz.my_stg;

list @cricket.lz.my_stg;

list @my_stg/cricket/json/;

select 
    t.$1:meta::variant as meta,
    t.$1:info::variant as info,
    t.$1:innings::array as innings,
    metadata$filename as file_name,
    metadata$file_row_number int,
    metadata$file_content_key text,
    metadata$file_last_modified stg_modified_ts
from @my_stg/cricket/json/ (file_format => 'my_json_format') t;