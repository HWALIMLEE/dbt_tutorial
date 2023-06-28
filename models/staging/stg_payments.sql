with payments as (
    select id as payment_id,
    order_id as order_id,
    payment_method,
    amount / 100 as amount
    from `pseudolab-de4e-tutorial`.de4e.raw_payments
)
select * from payments