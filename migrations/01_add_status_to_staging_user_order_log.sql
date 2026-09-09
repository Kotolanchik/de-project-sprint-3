-- старые строки без статуса считаем отгруженными
ALTER TABLE staging.user_order_log
    ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'shipped';

UPDATE staging.user_order_log
SET status = 'shipped'
WHERE status IS NULL;
