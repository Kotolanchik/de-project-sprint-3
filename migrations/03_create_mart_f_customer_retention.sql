-- Витрина возвращаемости клиентов: неделя × товар
CREATE TABLE IF NOT EXISTS mart.f_customer_retention (
    new_customers_count INTEGER NOT NULL,
    returning_customers_count INTEGER NOT NULL,
    refunded_customer_count INTEGER NOT NULL,
    period_name VARCHAR(20) NOT NULL,
    period_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    new_customers_revenue NUMERIC(10, 2) NOT NULL,
    returning_customers_revenue NUMERIC(10, 2) NOT NULL,
    customers_refunded INTEGER NOT NULL,
    CONSTRAINT f_customer_retention_item_id_fkey
        FOREIGN KEY (item_id) REFERENCES mart.d_item (item_id)
);

CREATE INDEX IF NOT EXISTS f_cr_item_id
    ON mart.f_customer_retention (item_id);

CREATE INDEX IF NOT EXISTS f_cr_period_id
    ON mart.f_customer_retention (period_id);
