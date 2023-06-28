with orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (

    select * from {{ ref('stg_payments') }}
),

order_payments as (

    select
        order_id,
        SUM(CASE WHEN payment_method = 'credit_card' THEN amount ELSE 0 END) AS credit_card_amount,
        SUM(CASE WHEN payment_method = 'coupon' THEN amount ELSE 0 END) AS coupon_amount,
        SUM(CASE WHEN payment_method = 'bank_transfer' THEN amount ELSE 0 END) AS bank_transfer_amount,
        SUM(CASE WHEN payment_method = 'gift_card' THEN amount ELSE 0 END) AS gift_card_amount,
        SUM(amount) AS total_amount

    from payments

    group by order_id

),
customers as (
    select * from {{ ref('stg_customer') }}
),

final as (

    select
        orders.order_id,
        orders.customer_id,
        customers.last_name || customers.first_name as customer_name,
        orders.order_date,
        orders.status,
        order_payments.credit_card_amount,
        order_payments.coupon_amount,
        order_payments.bank_transfer_amount,
        order_payments.gift_card_amount,
        order_payments.total_amount as amount

    from orders

    left join order_payments using (order_id)
    left join customers on orders.customer_id = customers.customer_id

)

select * from final