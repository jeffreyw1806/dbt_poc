{{
    config(
        tags = ['daily_end']
      , dist = 'auto'
      , sort = ['dbt_model_name', 'dbt_run_type','start_date','start_time'] 
      , materialized='incremental'
      , unique_key='dbt_performance_measures_sk'
      , post_hook={
            "sql": "delete from {{ this }} where start_time < date(date_trunc('month',dateadd(month,-6,current_date)))",
            "transaction": False
        }
    )
}}

select
      userid
    , database
    , case
        when split_part(split_part(split_part(querytxt, '"node_id": "', 2), '"', 1),'.',1) ='model' 
            then 'run'
        when split_part(split_part(split_part(querytxt, '"node_id": "', 2), '"', 1),'.',1) ='test' 
            then 'test'
        else 'n/a'
      end as dbt_run_type
    , split_part(split_part(split_part(querytxt, '"node_id": "', 2), '"', 1),'.',3) as dbt_model_name
    , case 
        when dbt_run_type = 'run'
            then replace(split_part(split_part(querytxt, 'create table "', 2), '.', 2),'"','')
        else 'n/a'
      end as model_type
    , datediff(minute,starttime, endtime) as duration_in_minutes
    , querytxt as query
    , left(starttime, 10) as start_date
    , starttime as start_time
    , endtime as end_time
    , case 
        when aborted = 1 then 'aborted'
        else 'completed' 
      end as job_status
    , {{ dbt_utils.surrogate_key(['dbt_model_name', 'dbt_run_type', 'start_time']) }} as dbt_performance_measures_sk
from stl_query ql 
where querytxt like '/*%{"app":%"dbt"%' 
    and (dbt_run_type ='test' or (dbt_run_type ='run' and querytxt like '%create table%'  ))
    and model_type not like 'validation%' 
    and model_type not like 'performance%'                               
order by start_date desc, starttime, dbt_model_name
