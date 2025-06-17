create or replace task cricket.bronze.load_to_venue_dim
    warehouse = 'SYSADMIN_WH'
    after cricket.bronze.load_to_silver_delivery
        as 
    insert into cricket.gold.venue_dim (venue_name, city)  
    select venue, city (
        select
            venue,
            coalesce(city, 'NA') as city
        from cricket.silver.match_details_clean
    )
    group by venue, city
    minus select venue_name from cricket.gold.venue_dim
    ;