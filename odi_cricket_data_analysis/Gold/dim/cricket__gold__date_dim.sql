use role sysadmin;
use warehouse sysadmin_wh;
use schema cricket.gold;

-- select 
--     min(event_date), -
--     max(event_date)
-- from cricket.silver.match_details_clean;

insert into cricket.gold.date_dim (DATE_ID, DAY, DAYOFMONTH, DAYOFWEEK, DAYOFWEEKNAME, DAYOFYEAR, FULL_DT, ISWEEKEND, MONTH, QUARTER, YEAR)
with date_range as (
SELECT DATEADD('day', SEQ4(), DATE '2000-01-01') as new_date
FROM TABLE(GENERATOR(ROWCOUNT => 20000))
where new_date < '2051-01-01'
order by new_date asc
)

select 
    row_number() over (order by new_date) as DATE_ID,
    EXTRACT(DAY FROM new_date) AS DAY,
    EXTRACT(DAY FROM new_date) AS DAYOFMONTH,
    DAYOFWEEKISO(new_date) AS DAYOFWEEK,
    DAYNAME(new_date) AS DAYOFWEEKNAME,
    DAYOFYEAR(new_date) AS DAYOFYEAR,
    new_date as FULL_DT,
    CASE WHEN DAYNAME(new_date) IN ('Sat', 'Sun') THEN 1 ELSE 0 END AS ISWEEKEND,
    EXTRACT(MONTH FROM new_date) AS MONTH,
    CASE 
    WHEN EXTRACT(QUARTER FROM new_date) IN (1, 2, 3, 4) 
    THEN EXTRACT(QUARTER FROM new_date)
    END AS QUARTER,
    EXTRACT(YEAR FROM new_date) AS YEAR
from date_range;

-- select * from cricket.gold.date_dim;