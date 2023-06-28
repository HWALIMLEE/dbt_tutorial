with customers as (
    select id as customer_id,
    first_name,
    last_name
    from `pseudolab-de4e-tutorial`.de4e.raw_customer
)
select * from customers