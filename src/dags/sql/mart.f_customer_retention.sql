--f_customer_retention
delete from mart.f_customer_retention
where period_name = 'weekly'
  and period_id = (
      select year_actual * 100 + week_of_year
      from mart.d_calendar
      where date_actual = '{{ds}}'::date
  );

insert into mart.f_customer_retention (
    new_customers_count,
    returning_customers_count,
    refunded_customer_count,
    period_name,
    period_id,
    item_id,
    new_customers_revenue,
    returning_customers_revenue,
    customers_refunded
)
with customer_item_week as (
    select
        fs.item_id,
        fs.customer_id,
        dc.year_actual * 100 + dc.week_of_year as period_id,
        count(*) filter (where coalesce(fs.status, 'shipped') = 'shipped') as orders_count,
        coalesce(sum(fs.payment_amount) filter (where coalesce(fs.status, 'shipped') = 'shipped'), 0) as revenue,
        count(*) filter (where fs.status = 'refunded') as refund_count,
        coalesce(sum(abs(fs.quantity)) filter (where fs.status = 'refunded'), 0) as refund_qty
    from mart.f_sales as fs
    inner join mart.d_calendar as dc
        on dc.date_id = fs.date_id
    where dc.year_actual = (select year_actual from mart.d_calendar where date_actual = '{{ds}}'::date)
      and dc.week_of_year = (select week_of_year from mart.d_calendar where date_actual = '{{ds}}'::date)
    group by fs.item_id, fs.customer_id, dc.year_actual, dc.week_of_year
)
select
    count(*) filter (where orders_count = 1)::int,
    count(*) filter (where orders_count > 1)::int,
    count(*) filter (where refund_count > 0)::int,
    'weekly',
    period_id,
    item_id,
    coalesce(sum(revenue) filter (where orders_count = 1), 0),
    coalesce(sum(revenue) filter (where orders_count > 1), 0),
    coalesce(sum(refund_qty), 0)::int
from customer_item_week
group by period_id, item_id;
