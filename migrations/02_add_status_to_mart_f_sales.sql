-- В витрине продаж все исторические факты без статуса считаем shipped
ALTER TABLE mart.f_sales
    ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'shipped';

UPDATE mart.f_sales
SET status = 'shipped'
WHERE status IS NULL;
