-- ============================================================
-- PRACTICA BDN 240107 - CONSULTAS DE PRODUCTOS Y BITACORA
-- Base: db_test  |  Puerto: 40107
-- ============================================================
USE db_test;

-- 1. Ver todos los productos
SELECT * FROM tb_products ORDER BY ID;

-- 2. Estructura de la tabla
DESCRIBE tb_products;

-- 3. Total de productos y registros en bitacora
SELECT (SELECT COUNT(*) FROM tb_products) AS productos,
       (SELECT COUNT(*) FROM tb_logs)    AS bitacora;

-- 4. Productos por categoria (conteo, stock total, precio promedio)
SELECT category                                AS categoria,
       COUNT(*)                                AS cantidad,
       SUM(stock)                              AS stock_total,
       ROUND(AVG(price), 2)                    AS precio_promedio
FROM tb_products
GROUP BY category
ORDER BY cantidad DESC;

-- 5. Bitacora por tipo de operacion
SELECT table_operation AS operacion, COUNT(*) AS cantidad
FROM tb_logs
GROUP BY table_operation;

-- 6. Bitacora por tabla afectada
SELECT table_name AS tabla, COUNT(*) AS cantidad
FROM tb_logs
GROUP BY table_name;

-- 7. Ultimos 17 registros de la bitacora
SELECT id, table_name AS tabla, table_operation AS operacion, db_user AS usuario_db,
       operation_date AS fecha
FROM tb_logs ORDER BY id DESC LIMIT 17;

-- 8. Verificar que la bitacora tenga al menos 17 registros
SELECT IF(COUNT(*) >= 17, 'CUMPLE', 'FALTA') AS bitacora_minima,
       COUNT(*) AS total
FROM tb_logs;

-- 9. Productos con stock bajo (10 o menos)
SELECT sku, name AS producto, stock
FROM tb_products
WHERE stock <= 10 AND status = b'1'
ORDER BY stock ASC;

-- 10. Productos mas caros (top 5)
SELECT name AS producto, category AS categoria, price AS precio
FROM tb_products
ORDER BY price DESC
LIMIT 5;

-- 11. Valor total del inventario
SELECT ROUND(SUM(price * stock), 2) AS valor_inventario,
       COUNT(*)                     AS productos
FROM tb_products;

-- 12. Productos inactivos (status = 0)
SELECT sku, name AS producto, status
FROM tb_products
WHERE status = b'0';

-- 13. Bitacora: que operaciones se hicieron sobre productos
SELECT table_operation AS operacion, operation_date AS fecha, operation_description AS detalle
FROM tb_logs
WHERE table_name = 'tb_products'
ORDER BY id DESC
LIMIT 20;

-- 14. Bitacora: todo lo que le paso a un producto especifico
SELECT table_operation AS operacion, operation_date AS fecha, operation_description AS detalle
FROM tb_logs
WHERE operation_description LIKE '%PROD-001%'
ORDER BY id;

-- 15. Triggers activos en la base
SHOW TRIGGERS FROM db_test;

-- 16. Usuarios remotos y sus roles
SELECT TO_USER AS usuario, FROM_USER AS rol
FROM mysql.role_edges
ORDER BY TO_USER;

-- 17. Resumen final de la practica
SELECT 'Tablas'              AS elemento, COUNT(*) AS cantidad FROM information_schema.tables     WHERE table_schema = 'db_test'
UNION ALL
SELECT 'Triggers',                  COUNT(*) FROM information_schema.triggers WHERE trigger_schema = 'db_test'
UNION ALL
SELECT 'Productos',                 COUNT(*) FROM db_test.tb_products
UNION ALL
SELECT 'Registros bitacora',        COUNT(*) FROM db_test.tb_logs
UNION ALL
SELECT 'Usuarios remotos',          COUNT(*) FROM mysql.user  WHERE Host = '%'
UNION ALL
SELECT 'Roles asignados',           COUNT(*) FROM mysql.role_edges;
