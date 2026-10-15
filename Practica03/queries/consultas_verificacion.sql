-- ============================================================
-- PRACTICA 03 - CONSULTAS DE VERIFICACION
-- Equivalente a consultas_verificacion.sql del profesor,
-- apuntando a db_test (matricula 240107).
-- ============================================================
USE db_test;

/* 1. Cuantas tablas tenemos? (P03 agrega tbd_products_categories) */
SHOW TABLES;

/* 2. Cuantos triggers tenemos? (9 de P02 + 3 de la puente = 12) */
SHOW TRIGGERS FROM db_test;

/* 3. Cuantos productos por categoria */
SELECT * FROM vw_total_products_by_category ORDER BY category_id IS NULL;

/* 4. Procedimientos de la base */
SHOW PROCEDURE STATUS WHERE Db = 'db_test';

/* 5. Funciones y eventos (extra P03: Funciones y Eventos) */
SHOW FUNCTION STATUS WHERE Db = 'db_test';
SELECT EVENT_SCHEMA, EVENT_NAME, STATUS FROM information_schema.EVENTS
WHERE EVENT_SCHEMA = 'db_test';

/* 6. Conteos rapidos */
SELECT (SELECT COUNT(*) FROM tb_products) AS productos,
       (SELECT COUNT(*) FROM tbc_categories) AS categorias_jerarquicas,
       (SELECT COUNT(*) FROM tbd_products_categories) AS asignaciones,
       (SELECT COUNT(*) FROM tb_logs) AS bitacora;
