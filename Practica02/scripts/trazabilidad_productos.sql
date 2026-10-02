/* ============================================================
   PRACTICA 02 — TRAZABILIDAD DE PRODUCTOS
   Alumno: Rene David Cabrera | Matricula: 240107
   Base: db_test | Puerto: 40107 | Conectar como rene.cabrera/240107
   ============================================================
   CORRECCION IMPORTANTE sobre la consulta original:

   El JOIN usa  LIKE CONCAT('%ID=', p.ID, '%')  -- le falta la COMA.
   Eso hace que el producto 1 se empareje tambien con los registros
   ID=10, ID=11, ID=100... hasta ID=1999.

   Medido en esta base:
       con '%ID=1%'    -> 1114 coincidencias para el producto 1
       con '%ID=1,%'   ->    3 coincidencias (solo las suyas)

   Y el resultado final:
       version original   -> 19097 filas en 121 SEGUNDOS
       version corregida ->  5050 filas en  menos de 1 segundo

   La coma final es lo que cierra el numero del ID.
   ============================================================ */

USE db_test;

SELECT
    p.ID           AS id,
    p.name         AS name,
    p.description  AS description,
    b.db_user      AS inserted_by,
    COALESCE(
        GROUP_CONCAT(DISTINCT re.FROM_USER
            ORDER BY re.FROM_USER ASC
            SEPARATOR ', '),
        'Sin rol'
    )             AS roles,
    b.operation_description AS operation_description,
    b.operation_date       AS operation_date
FROM
    (tb_products p
    JOIN tb_logs b ON (b.operation_description LIKE CONCAT('%ID=', p.ID, ',%')))
    LEFT JOIN mysql.role_edges re
        ON (re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1))
WHERE
    (b.table_operation = 'Create'
        AND b.table_name = 'tb_products')
GROUP BY
    p.ID, p.name, p.description, b.db_user,
    b.operation_description, b.operation_date
ORDER BY p.ID ASC;


/* ============================================================
   VARIANTE RAPIDA — 50 productos de la Practica 1
   (si quieres ver el resultado sin esperar 2 minutos)
   ============================================================ */
SELECT
    p.ID AS id, p.sku AS sku, p.name AS name, p.category AS categoria,
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


/* ============================================================
   VARIANTE — los 5000 productos que cargo tu compañero (johnatan)
   ============================================================ */
SELECT
    p.ID AS id, p.sku AS sku, p.name AS name, p.category AS categoria,
    b.db_user AS inserted_by,
    COALESCE(GROUP_CONCAT(DISTINCT re.FROM_USER
            ORDER BY re.FROM_USER SEPARATOR ', '), 'Sin rol') AS roles,
    b.operation_date AS fecha
FROM tb_products p
JOIN tb_logs b
    ON  b.table_name = 'tb_products'
    AND b.table_operation = 'Create'
    AND b.operation_description LIKE CONCAT('%ID=', p.ID, ',%')
LEFT JOIN mysql.role_edges re
    ON  re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1)
WHERE p.ID >= 5069
GROUP BY p.ID, p.sku, p.name, p.category, b.db_user, b.operation_date
ORDER BY p.ID ASC;


/* ============================================================
   COMPROBACION DE QUE NO HAY IDs MEZCLADOS
   (esto el profe lo podria preguntar)
   ============================================================ */
SELECT
    p.ID AS id,
    p.name AS name,
    COUNT(*) AS coincidencias_correctas
FROM tb_products p
JOIN tb_logs b ON (b.operation_description LIKE CONCAT('%ID=', p.ID, ',%'))
WHERE b.table_operation = 'Create' AND b.table_name = 'tb_products'
GROUP BY p.ID, p.name
ORDER BY p.ID ASC
LIMIT 10;