--f_sales

delete from mart.f_sales
where date_id in (
    select date_id
    from mart.d_calendar
    where date_actual = '{{ds}}'::date
);

insert into mart.f_sales (date_id, item_id, customer_id, city_id, quantity, payment_amount, status)
select
    dc.date_id,
    uol.item_id,
    uol.customer_id,
    uol.city_id,
    case when coalesce(uol.status, 'shipped') = 'refunded' then -uol.quantity else uol.quantity end,
    case when coalesce(uol.status, 'shipped') = 'refunded' then -uol.payment_amount else uol.payment_amount end,
    coalesce(uol.status, 'shipped')
from staging.user_order_log as uol
inner join mart.d_calendar as dc
    on uol.date_time::date = dc.date_actual
where uol.date_time::date = '{{ds}}'::date;
