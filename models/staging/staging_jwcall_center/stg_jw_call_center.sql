{{ config(materialized='table') }}

with source as (

    select *
    from {{ source('src_snowflake_samples', 'call_center') }}

),

final as(
    select  cc_call_center_id, cc_name, cc_class, CC_EMPLOYEES, cc_manager
    from source
    where cc_division = 1
)

select * from final
