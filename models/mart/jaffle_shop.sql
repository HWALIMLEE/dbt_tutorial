-- materialized = table -> incremental
{{
    config(
        materialized='table'
    )
}}
with import_orders as (

    select * from {{ ref('stg_orders') }}

),
aggregate_orders as (

    select

        customer_id,
        count(order_id) as count_orders

    from import_orders
    where status not in ('returned', 'return pending')
    group by 1

),
segment_users as (

    select

        *,
        case
            when count_orders >= 3 then 'super_buyer'
            when count_orders <3 and count_orders >= 2 then
                'regular_buyer'
            else 'single_buyer'
        end as buyer_type

    from aggregate_orders

)
select * from segment_users