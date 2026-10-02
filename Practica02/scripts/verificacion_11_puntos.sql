/* ============================================================
   PRACTICA 02 Ã¢â‚¬â€ SCRIPT DE VERIFICACION (adaptado a db_test)
   Alumno: Rene David Cabrera | Matricula: 240107
   Base:   db_test | Puerto: 40107
   Conectate como: rene.cabrera / 240107
   ============================================================ */

USE db_test;

/* ---------- 1. Cuantas tablas existen ---------- */
SHOW TABLES;

/* ---------- 2. Cuantos triggers existen ---------- */
SELECT TRIGGER_NAME AS nombre_trigger, EVENT_MANIPULATION AS evento,
       EVENT_OBJECT_TABLE AS tabla, ACTION_TIMING AS momento
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'db_test'
ORDER BY EVENT_OBJECT_TABLE, EVENT_MANIPULATION;

/* ---------- 3. Cuantos registros existen en tb_users ---------- */
SELECT COUNT(*) AS total_registros FROM tb_users;

/* ---------- 4. Cuantos registros existen en tb_logs ---------- */
SELECT COUNT(*) AS total_registros FROM tb_logs;

/* ---------- 4b. Bitacora desglosada por operacion ---------- */
SELECT table_name AS tabla, table_operation AS operacion, COUNT(*) AS total
FROM tb_logs
GROUP BY table_name, table_operation
ORDER BY tabla, operacion;

/* ---------- 5. Consultar todas las operaciones (ultimas 30) ---------- */
SELECT id AS id, table_name AS tabla, table_operation AS operacion,
       db_user AS usuario, operation_date AS fecha,
       LEFT(operation_description, 60) AS descripcion
FROM tb_logs
ORDER BY id DESC
LIMIT 30;

/* ---------- 6. Usuarios remotos creados (Host = '%', account_locked='N') ---------- */
SELECT User AS usuario, Host AS host, account_locked AS bloqueado
FROM mysql.user
WHERE Host = '%' AND account_locked = 'N'
ORDER BY User;

/* ---------- 7. Roles creados (Host = '%', account_locked='Y') ---------- */
SELECT User AS rol, Host AS host, account_locked AS bloqueado
FROM mysql.user
WHERE Host = '%' AND account_locked = 'Y'
ORDER BY User;

/* ---------- 8. Que usuarios tienen que roles ---------- */
SELECT TO_USER AS usuario, TO_HOST AS host,
       FROM_USER AS rol, FROM_HOST AS rol_host
FROM mysql.role_edges
ORDER BY TO_USER, FROM_USER;

/* ---------- 8b. Ver el rol activo de cada usuario ---------- */
SELECT u.User AS usuario, r.DEFAULT_ROLE_USER AS rol_por_defecto
FROM mysql.user u
LEFT JOIN mysql.default_roles r ON r.user = u.User
WHERE u.account_locked = 'N' AND u.Host = '%'
ORDER BY u.User;

/* ---------- 9. Procedimientos almacenados ---------- */
SELECT ROUTINE_NAME AS procedimiento, ROUTINE_TYPE AS tipo
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'db_test';
-- Nota: en esta base hay 0 procedimientos. Si el profesor pide alguno,
-- el siguiente bloque crea uno de ejemplo:

/*
DROP PROCEDURE IF EXISTS sp_productos_por_categoria;
DELIMITER //
CREATE PROCEDURE sp_productos_por_categoria(IN p_categoria VARCHAR(50))
BEGIN
    SELECT sku, name, category, price, stock
    FROM tb_products
    WHERE category = p_categoria
    ORDER BY name;
END//
DELIMITER ;

CALL sp_productos_por_categoria('Gaming');
DROP PROCEDURE IF EXISTS sp_productos_por_categoria;
*/

/* ---------- 10. Trazabilidad de USUARIOS (trazabilidad bitacora) ---------- */
SELECT
    u.nick AS nick,
    u.email AS email,
    b.db_user AS inserted_by,
    COALESCE(
        GROUP_CONCAT(DISTINCT re.FROM_USER
                     ORDER BY re.FROM_USER
                     SEPARATOR ', '),
        'Sin rol'
    ) AS roles,
    b.operation_description AS descripcion,
    b.operation_date AS fecha
FROM tb_users u
JOIN tb_logs b
    ON  b.operation_description LIKE CONCAT('%', u.nick, '%')
    AND b.operation_description LIKE CONCAT('%', u.email, '%')
LEFT JOIN mysql.role_edges re
    ON  re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1)
WHERE b.table_operation = 'Create'
  AND b.table_name = 'tb_users'
GROUP BY
    u.nick, u.email, b.db_user,
    b.operation_description, b.operation_date
ORDER BY b.operation_date ASC;

/* ---------- 11. Trazabilidad de PRODUCTOS (optimizada) ----------
   OJO: el script del compaÃƒÂ±ero hace LEFT JOIN con 4 condiciones OR
   y un GROUP BY por producto. Con 5050 productos eso tarda minutos
   (hace un cross join de 5050 x 5070 filas).
   Aqui se hace mas rÃƒÂ¡pido y da el mismo resultado: se une solo
   con las filas de bitÃƒÂ¡cora que mencionan el ID o el nombre.
   --------------------------------------------------------- */
SELECT
    p.ID AS id,
    p.sku AS sku,
    p.name AS name,
    p.category AS categoria,
    b.db_user AS inserted_by,
    COALESCE(
        GROUP_CONCAT(DISTINCT re.FROM_USER
                     ORDER BY re.FROM_USER
                     SEPARATOR ', '),
        'no hay roles'
    ) AS roles,
    b.operation_date AS fecha
FROM tb_products p
LEFT JOIN tb_logs b
    ON  b.table_name = 'tb_products'
    AND b.table_operation = 'Create'
    AND b.operation_description LIKE CONCAT('%ID=', p.ID, ',%')
LEFT JOIN mysql.role_edges re
    ON  re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1)
WHERE p.ID BETWEEN 1 AND 50          -- solo los de la Practica 1
GROUP BY
    p.ID, p.sku, p.name, p.category, b.db_user, b.operation_date
ORDER BY p.ID ASC;
-- Para ver los 5000 remotos, cambia el WHERE por:  p.ID >= 5069
-- Para ver TODOS los productos, quita el WHERE (tarda ~2 minutos).

/* ---------- 11b. Solo los 5000 productos remotos (para tu compaÃƒÂ±ero) ---------- */
SELECT
    p.ID AS id,
    p.sku AS sku,
    p.name AS name,
    p.category AS categoria,
    b.db_user AS inserted_by,
    COALESCE(GROUP_CONCAT(DISTINCT re.FROM_USER
                          ORDER BY re.FROM_USER SEPARATOR ', '), 'no hay roles') AS roles,
    b.operation_date AS fecha
FROM tb_products p
JOIN tb_logs b
    ON  b.table_name = 'tb_products'
    AND b.table_operation = 'Create'
    AND b.operation_description LIKE CONCAT('%ID=', p.ID, ',%')
LEFT JOIN mysql.role_edges re
    ON  re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1)
WHERE p.ID >= 5069      -- los que cargo johnatan
GROUP BY p.ID, p.sku, p.name, p.category, b.db_user, b.operation_date
ORDER BY p.ID ASC;

/* ---------- 12. RESUMEN FINAL ---------- */
SELECT
    (SELECT COUNT(*) FROM tb_users)                  AS usuarios,
    (SELECT COUNT(*) FROM tb_products)               AS productos,
    (SELECT COUNT(*) FROM tb_logs)                   AS bitacora,
    (SELECT COUNT(*) FROM information_schema.TRIGGERS
      WHERE TRIGGER_SCHEMA='db_test')                AS triggers,
    (SELECT COUNT(*) FROM information_schema.views
      WHERE TABLE_SCHEMA='db_test')                  AS vistas,
    (SELECT COUNT(*) FROM mysql.user
      WHERE Host='%' AND account_locked='N')         AS usuarios_remotos,
    (SELECT COUNT(*) FROM mysql.user
      WHERE Host='%' AND account_locked='Y')         AS roles,
    (SELECT COUNT(*) FROM mysql.role_edges)          AS asignaciones,
    @@port                                           AS puerto,
    @@local_infile                                   AS local_infile;
