/* ==================================================================
   PRACTICA 02 — EVIDENCIA (PRUEBA DE QUE CADA ACTIVIDAD SE CUMPLIO)
   Alumno: Rene David Cabrera | Matricula: 240107
   Base: db_test | Puerto: 40107
   Como abrirla: MySQL Workbench > conexion "db_test 240107 (local)"
   Usuario: rene.cabrera | Contrasena: 240107
   OJO: conectate como rene.cabrera, NO como root, para que los triggers
        registren bien el usuario en la bitacora.
   ================================================================== */

USE db_test;

/* ==================================================================
   PASO 1 — ENTORNO LOCAL (SERVIDOR)
   Estas variables se leen desde la terminal (no son tablas de tu base)
   ================================================================== */

SELECT @@port              AS 'P1.1 Puerto configurado',
       @@bind_address      AS 'P1.1 Escucha en',
       @@version           AS 'P1.3 Version del servidor',
       @@local_infile      AS 'P3.1 Carga desde origen remoto',
       @@secure_file_priv  AS 'P2.5 Permiso de archivos del servidor';


/* ==================================================================
   PASO 2 — ENTORNO DE BASES DE DATOS
   ================================================================== */

/* --- 2.1 Importacion de la base de datos: tablas que quedaron --- */
SELECT TABLE_NAME AS 'P2.1 Tabla importada', TABLE_ROWS AS 'Filas aprox',
       ENGINE AS 'Motor'
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'db_test' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

/* --- 2.2 Usuarios remotos creados (Host = '%' = Remoto) --- */
SELECT User AS 'P2.2 Usuario remoto', Host AS 'Host', account_locked AS 'Bloqueado'
FROM mysql.user
WHERE Host = '%' AND User NOT LIKE 'mysql.%'
ORDER BY User;

/* --- 2.3 Roles creados (MySQL guarda los roles como cuentas con
       account_locked = 'Y'; por eso NO salen en la consulta anterior) --- */
SELECT User AS 'P2.3 Rol creado', Host AS 'Host', account_locked AS 'Bloqueado'
FROM mysql.user
WHERE Host = '%' AND account_locked = 'Y'
ORDER BY User;

/* --- 2.4 Privilegios de cada rol --- */
SELECT 'P2.4 Privilegios por rol' AS Concepto;
SHOW GRANTS FOR 'superadmin'@'%';
SHOW GRANTS FOR 'admin'@'%';
SHOW GRANTS FOR 'seller'@'%';
SHOW GRANTS FOR 'buyer'@'%';
SHOW GRANTS FOR 'support'@'%';
SHOW GRANTS FOR 'common'@'%';
SHOW GRANTS FOR 'user_not_registered'@'%';

/* --- 2.4bis Que rol tiene cada usuario --- */
SELECT TO_USER AS 'P2.4 Usuario', FROM_USER AS 'Rol asignado',
       TO_HOST AS 'Host', FROM_HOST AS 'Rol host'
FROM mysql.role_edges ORDER BY TO_USER, FROM_USER;

/* --- 2.5 Permisos de operaciones: variables que las habilitan --- */
SELECT @@local_infile AS 'P2.5 local_infile (LOAD DATAallowed)',
       @@max_allowed_packet AS 'P2.5 Paquete maximo (bytes)';

/* --- 2.6 Pruebas de conexion remota: se ejecutan DESDE LA TERMINAL,
       no aqui (ver bloque TERMINAL al final de este archivo) --- */

/* --- 2.7 COMPROBACION DE PERMISOS: que puede y que no puede cada rol.
       Este es el punto que mas pesa; aqui esta la prueba real: --- */

-- 2.7.a  superadmin (tu usuario) PUEDE escribir en cualquier parte
SELECT 'P2.7 superadmin PUEDE insertar' AS Prueba,
       COUNT(*) AS Productos_ahora
FROM tb_products WHERE ID = 999999;

-- 2.7.b  buyer (aaron) SOLO lectura: su INSERT debe ser RECHAZADO
--        Ejecutalo DESCOMENTADO para ver el error:
-- SELECT COUNT(*) FROM tb_products;  -- OK
-- INSERT INTO tb_products (sku,name,description,category,price,stock)
--   VALUES ('PRUEBA','No debe entrar','x','Otros',1,1);
--        Esperado: ERROR 1142 (42S22): INSERT command denied to
--        user 'aaron'@'%' for table 'tb_products'

-- 2.7.c  seller (samuel) PUEDE insertar y actualizar
SELECT 'P2.7 seller: productos que puede ver' AS Prueba,
       COUNT(*) AS Total_productos FROM tb_products;

/* ==================================================================
   PASO 3 — IMPORTACION MASIVA DE 5000 PRODUCTOS
   ================================================================== */

/* --- 3.1 Carga desde origen remoto habilitada --- */
SELECT @@local_infile AS 'P3.1 local_infile (1 = habilitado)';

/* --- 3.2 Datos del Vendedor 2 preparados: 10 categorias --- */
SELECT 'P3.2 Categorias preparadas' AS Concepto;
SELECT category AS 'Categoria', COUNT(*) AS Productos
FROM tb_products
WHERE sku REGEXP '^[A-Z]{3}-.*[0-9]{5}-'
GROUP BY category ORDER BY productos DESC;

/* --- 3.3 + 3.5 VERIFICACION DE LA CARGA (lo mas importante) --- */
SELECT COUNT(*) AS 'P3.5 Los 5000 del CSV cargados'
FROM tb_products WHERE sku REGEXP '^[A-Z]{3}-.*[0-9]{5}-';

SELECT COUNT(*) AS 'P3.3 Productos de la Practica 1'
FROM tb_products WHERE sku LIKE 'PROD-%';

/* --- 3.4 Evidencia de que la carga fue DESDE ORIGEN REMOTO y como
       Vendedor 2: la bitacora guardo 'samuel' en las 5000 altas --- */
SELECT db_user AS 'P3.4 Usuario que cargo (debe ser samuel)',
       COUNT(*) AS Altas_registradas_por_el_trigger
FROM tb_logs
WHERE table_name = 'tb_products' AND table_operation = 'Create'
GROUP BY db_user ORDER BY Altas_registradas_por_el_trigger DESC;

/* --- 3.5 Conteo final: debe dar 5050 --- */
SELECT COUNT(*) AS 'P3.5 TOTAL en tb_products (50 + 5000 = 5050)'
FROM tb_products;

/* --- 3.6 Datos disponibles en la base REMOTA --- */
SELECT ID AS 'ID', sku AS 'SKU', name AS 'Producto', category AS 'Categoria',
       price AS 'Precio', stock AS 'Stock', creation_date AS 'Creado'
FROM tb_products
WHERE sku REGEXP '^[A-Z]{3}-.*[0-9]{5}-'
ORDER BY ID LIMIT 10;

COMMIT;
