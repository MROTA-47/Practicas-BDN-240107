-- ============================================================
-- PRACTICA 02 — CONSULTAS DE VERIFICACION
-- Alumno: Rene David Cabrera | Matricula: 240107
-- Base: db_test | Puerto: 40107
-- Conectarse como: rene.cabrera / 240107
-- ============================================================

USE db_test;

/* ---------- 1. Cuantas tablas existen ---------- */
SHOW TABLES;

/* ---------- 2. Cuantos triggers existen (deben ser 9: 3 por tabla) ---------- */
SELECT TRIGGER_NAME AS nombre_trigger,
       EVENT_OBJECT_TABLE AS tabla,
       EVENT_MANIPULATION AS evento,
       ACTION_TIMING AS momento
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'db_test'
ORDER BY EVENT_OBJECT_TABLE, EVENT_MANIPULATION;

/* ---------- 3. Registros en tb_users ---------- */
SELECT COUNT(*) AS total_registros FROM tb_users;

/* ---------- 4. Registros en la bitacora ---------- */
SELECT COUNT(*) AS total_registros FROM tb_logs;

/* ---------- 4b. Bitacora desglosada ---------- */
SELECT table_name AS tabla, table_operation AS operacion, COUNT(*) AS total
FROM tb_logs
GROUP BY table_name, table_operation
ORDER BY tabla, operacion;

/* ---------- 5. Operaciones mas recientes ---------- */
SELECT id AS id, table_name AS tabla, table_operation AS operacion,
       db_user AS usuario, operation_date AS fecha,
       LEFT(operation_description, 60) AS descripcion
FROM tb_logs
ORDER BY id DESC
LIMIT 30;

/* ---------- 6. Usuarios remotos creados ---------- */
SELECT User AS usuario, Host AS host, account_locked AS bloqueado
FROM mysql.user
WHERE Host = '%' AND account_locked = 'N'
ORDER BY User;

/* ---------- 7. Roles creados ---------- */
SELECT User AS rol, Host AS host, account_locked AS bloqueado
FROM mysql.user
WHERE Host = '%' AND account_locked = 'Y'
ORDER BY User;

/* ---------- 8. Que usuario tiene que rol ---------- */
SELECT TO_USER AS usuario, TO_HOST AS host,
       FROM_USER AS rol, FROM_HOST AS rol_host
FROM mysql.role_edges
ORDER BY TO_USER, FROM_USER;

/* ---------- 9. Procedimientos almacenados ---------- */
SELECT ROUTINE_NAME AS procedimiento, ROUTINE_TYPE AS tipo
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'db_test';

/* ---------- 10. Trazabilidad de USUARIOS ---------- */
SELECT u.nick, u.email, b.db_user AS inserted_by,
       COALESCE(GROUP_CONCAT(DISTINCT re.FROM_USER
                ORDER BY re.FROM_USER SEPARATOR ', '), 'Sin rol') AS roles,
       b.operation_description AS descripcion, b.operation_date AS fecha
FROM tb_users u
JOIN tb_logs b
    ON  b.operation_description LIKE CONCAT('%', u.nick, '%')
    AND b.operation_description LIKE CONCAT('%', u.email, '%')
LEFT JOIN mysql.role_edges re
    ON  re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1)
WHERE b.table_operation = 'Create' AND b.table_name = 'tb_users'
GROUP BY u.nick, u.email, b.db_user, b.operation_description, b.operation_date
ORDER BY b.operation_date ASC;

/* ---------- 11. Trazabilidad de PRODUCTOS ----------
   NOTA: el LIKE lleva coma al final ('%ID=' , ',%'). Sin ella el
   producto 1 se empareja con ID=10, ID=100, etc. Medido: 1114
   coincidencias con '%ID=1%' contra 3 con '%ID=1,%'. */
SELECT p.ID AS id, p.sku, p.name, p.category AS categoria,
       b.db_user AS inserted_by,
       COALESCE(GROUP_CONCAT(DISTINCT re.FROM_USER
                ORDER BY re.FROM_USER SEPARATOR ', '), 'Sin rol') AS roles,
       b.operation_date AS fecha
FROM tb_products p
LEFT JOIN tb_logs b
    ON  b.table_name = 'tb_products'
    AND b.table_operation = 'Create'
    AND b.operation_description LIKE CONCAT('%ID=', p.ID, ',%')
LEFT JOIN mysql.role_edges re
    ON  re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1)
WHERE p.ID BETWEEN 1 AND 50
GROUP BY p.ID, p.sku, p.name, p.category, b.db_user, b.operation_date
ORDER BY p.ID ASC;

/* ---------- 12. RESUMEN FINAL ---------- */
SELECT
    (SELECT COUNT(*) FROM tb_users)      AS usuarios,
    (SELECT COUNT(*) FROM tb_products)   AS productos,
    (SELECT COUNT(*) FROM tb_logs)       AS bitacora,
    (SELECT COUNT(*) FROM tb_categorias) AS categorias,
    (SELECT COUNT(*) FROM information_schema.TRIGGERS
      WHERE TRIGGER_SCHEMA='db_test')    AS triggers,
    (SELECT COUNT(*) FROM information_schema.VIEWS
      WHERE TABLE_SCHEMA='db_test')      AS vistas,
    (SELECT COUNT(*) FROM mysql.user
      WHERE Host='%' AND account_locked='N') AS usuarios_remotos,
    (SELECT COUNT(*) FROM mysql.user
      WHERE Host='%' AND account_locked='Y') AS roles,
    (SELECT COUNT(*) FROM mysql.role_edges)  AS asignaciones,
    @@port          AS puerto,
    @@local_infile  AS local_infile;