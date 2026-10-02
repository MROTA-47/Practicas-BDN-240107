-- ============================================================
-- PRACTICA 02 - TRAZABILIDADES OPTIMIZADAS
-- Alumno: Rene David Cabrera | Matricula: 240107
-- Base: db_test | Puerto: 40107
-- Conectarse como: rene.cabrera / 240107
-- ============================================================
-- CORRECCION PRINCIPAL
-- La consulta original del profesor usaba:
--       LIKE CONCAT('%ID=', p.ID, '%')      <-- le falta la COMA
-- Eso hace que el producto 1 se empareje tambien con ID=10, ID=11,
-- ID=100... hasta ID=1999.
-- Medido en esta base:
--       '%ID=1%'   -> 1114 coincidencias para el producto 1
--       '%ID=1,%'  ->    3 coincidencias (solo las suyas)
-- Resultado final: la original daba 19097 filas en 121 SEGUNDOS.
-- ============================================================

USE db_test;

-- ---------------------------------------------------------------
-- OPTIMIZACION 1: indice compuesto en tb_logs
-- Sin esto, cada consulta de trazabilidad escanea los 5000+ logs.
-- ---------------------------------------------------------------
CREATE INDEX idx_logs_trazabilidad
    ON tb_logs (table_name, table_operation, db_user);

-- ---------------------------------------------------------------
-- OPTIMIZACION 2: columna extraible del ID dentro de la descripcion
-- Se agrega una columna que guarda el ID del producto/usuario afectado,
-- para poder unir por igualdad (usa el indice) en vez de por LIKE.
-- Es la solucion real al problema de rendimiento.
-- ---------------------------------------------------------------
ALTER TABLE tb_logs
    ADD COLUMN entity_id INT NULL COMMENT 'ID de la entidad afectada (producto o usuario)'
    AFTER db_user;

-- Llenar la columna a partir de las descripciones existentes
UPDATE tb_logs
SET entity_id = CAST(
        SUBSTRING_INDEX(SUBSTRING_INDEX(operation_description, 'ID=', -1), ',', 1)
        AS UNSIGNED)
WHERE operation_description LIKE '%ID=%'
  AND entity_id IS NULL;

CREATE INDEX idx_logs_entity ON tb_logs (entity_id);

-- ---------------------------------------------------------------
-- TRAZABILIDAD 1: productos (OPTIMIZADA con indice, sin LIKE)
-- ---------------------------------------------------------------
DROP VIEW IF EXISTS vw_trazabilidad_productos;
CREATE VIEW vw_trazabilidad_productos AS
SELECT
    p.ID                     AS id,
    p.sku                    AS sku,
    p.name                   AS name,
    p.category               AS categoria,
    p.price                  AS precio,
    p.stock                  AS stock,
    b.db_user                AS inserted_by,
    COALESCE(
        GROUP_CONCAT(DISTINCT re.FROM_USER
                     ORDER BY re.FROM_USER ASC SEPARATOR ', '),
        'Sin rol'
    )                       AS roles,
    b.operation_description  AS descripcion,
    b.operation_date         AS fecha
FROM tb_products p
LEFT JOIN tb_logs b
    ON  b.table_name = 'tb_products'
    AND b.table_operation = 'Create'
    AND b.entity_id = p.ID
LEFT JOIN mysql.role_edges re
    ON  re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1)
GROUP BY
    p.ID, p.sku, p.name, p.category, p.price, p.stock,
    b.db_user, b.operation_description, b.operation_date;

-- ---------------------------------------------------------------
-- TRAZABILIDAD 2: usuarios (OPTIMIZADA)
-- ---------------------------------------------------------------
DROP VIEW IF EXISTS vw_trazabilidad_usuarios;
CREATE VIEW vw_trazabilidad_usuarios AS
SELECT
    u.ID                     AS id,
    u.nick                   AS nick,
    u.email                  AS email,
    b.db_user                AS inserted_by,
    COALESCE(
        GROUP_CONCAT(DISTINCT re.FROM_USER
                     ORDER BY re.FROM_USER ASC SEPARATOR ', '),
        'Sin rol'
    )                       AS roles,
    b.operation_description  AS descripcion,
    b.operation_date         AS fecha
FROM tb_users u
LEFT JOIN tb_logs b
    ON  b.table_name = 'tb_users'
    AND b.table_operation = 'Create'
    AND b.entity_id = u.ID
LEFT JOIN mysql.role_edges re
    ON  re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1)
GROUP BY
    u.ID, u.nick, u.email, b.db_user,
    b.operation_description, b.operation_date;

-- ---------------------------------------------------------------
-- TRAZABILIDAD 3: resumen por usuario de la base
-- Cuanto inserto cada quien, en que tabla y con que rol.
-- ---------------------------------------------------------------
DROP VIEW IF EXISTS vw_actividad_por_usuario;
CREATE VIEW vw_actividad_por_usuario AS
SELECT
    b.db_user                                            AS usuario,
    SUBSTRING_INDEX(b.db_user, '@', 1)                  AS usuario_sin_host,
    COALESCE(GROUP_CONCAT(DISTINCT re.FROM_USER
                     ORDER BY re.FROM_USER SEPARATOR ', '), 'Sin rol') AS roles,
    b.table_name                                         AS tabla,
    b.table_operation                                    AS operacion,
    COUNT(*)                                             AS operaciones,
    MIN(b.operation_date)                                AS primera_operacion,
    MAX(b.operation_date)                                AS ultima_operacion
FROM tb_logs b
LEFT JOIN mysql.role_edges re
    ON re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1)
GROUP BY
    b.db_user, SUBSTRING_INDEX(b.db_user, '@', 1),
    b.table_name, b.table_operation
ORDER BY operaciones DESC;

-- ---------------------------------------------------------------
-- TRAZABILIDAD 4: auditoria completa (todo el historial)
-- ---------------------------------------------------------------
DROP VIEW IF EXISTS vw_auditoria_completa;
CREATE VIEW vw_auditoria_completa AS
SELECT
    b.id                   AS id_log,
    b.table_name           AS tabla,
    b.entity_id            AS entidad_id,
    b.table_operation      AS operacion,
    b.db_user              AS usuario,
    SUBSTRING_INDEX(b.db_user, '@', 1) AS usuario_sin_host,
    COALESCE(GROUP_CONCAT(DISTINCT re.FROM_USER
                     ORDER BY re.FROM_USER SEPARATOR ', '), 'Sin rol') AS roles,
    b.operation_description AS descripcion,
    b.operation_date       AS fecha
FROM tb_logs b
LEFT JOIN mysql.role_edges re
    ON re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1);

-- ---------------------------------------------------------------
-- VERIFICACION
-- ---------------------------------------------------------------
SELECT TABLE_NAME AS vista, VIEW_DEFINITION IS NOT NULL AS creada
FROM information_schema.VIEWS WHERE TABLE_SCHEMA = 'db_test';

-- Consulta rapida: los 5000 que cargo cada seller
SELECT inserted_by AS usuario, roles, COUNT(*) AS productos
FROM vw_trazabilidad_productos
WHERE id > 50
GROUP BY inserted_by, roles;