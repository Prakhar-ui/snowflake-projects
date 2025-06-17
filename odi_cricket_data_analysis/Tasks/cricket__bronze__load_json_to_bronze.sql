create or replace task cricket.bronze.load_json_to_bronze
    warehouse = 'SYSADMIN_WH'
    SCHEDULE = 'USING CRON 30 11 * * * UTC'
        as 
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