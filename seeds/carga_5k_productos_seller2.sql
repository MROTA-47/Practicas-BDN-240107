-- ============================================================
-- PRACTICA 02 - PASO 3: IMPORTACION MASIVA DE 5000 PRODUCTOS
-- Vendedor 2: samuel        Matricula: 240107
-- Base: db_test              Puerto: 40107
-- ============================================================
-- Metodo: LOAD DATA LOCAL INFILE (carga desde un origen remoto).
-- Requiere local_infile=1 en el SERVIDOR (ya configurado en my.ini)
-- y --local-infile=1 en el CLIENTE.
--
-- Ejecutar SIENDO samuel (rol 'seller'), no como root:
--   si se corre como root, el trigger guarda USER()=root
--   y la vista vw_trazabilidad_productos mostrara 'Sin rol'.
--
--   mysql -u samuel -p240043 -h 127.0.0.1 -P 40107 --local-infile=1 db_test
--
-- El CSV del profesor (5000_productos.csv) tiene 9 columnas:
--   id,sku,name,description,current_price,current_stock,status,creation_date,last_update
-- y NO trae 'category', que en tb_products es NOT NULL.
-- La categoria se deriva del prefijo del SKU (10 categorias):
--   ENE=Energia  OFI=Oficina  ELE=Electronica  AUD=Audio  ACC=Accesorios
--   MOV=Moviles  HOG=Hogar     RED=Redes         ALM=Almacenamiento  GAM=Gaming
-- ============================================================

LOAD DATA LOCAL INFILE 'C:/ruta/al/seeds/5000_productos.csv'
INTO TABLE tb_products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@id, sku, name, description, @precio, @stock, @status, @fecha, @upd)
SET price        = @precio,
    stock        = @stock,
    status       = IF(@status = '1', b'1', b'0'),
    category     = CASE LEFT(sku, 3)
                      WHEN 'ENE' THEN 'Energia'
                      WHEN 'OFI' THEN 'Oficina'
                      WHEN 'ELE' THEN 'Electronica'
                      WHEN 'AUD' THEN 'Audio'
                      WHEN 'ACC' THEN 'Accesorios'
                      WHEN 'MOV' THEN 'Moviles'
                      WHEN 'HOG' THEN 'Hogar'
                      WHEN 'RED' THEN 'Redes'
                      WHEN 'ALM' THEN 'Almacenamiento'
                      WHEN 'GAM' THEN 'Gaming'
                      ELSE 'Otros'
                   END,
    creation_date = STR_TO_DATE(@fecha, '%d/%m/%Y %H:%i'),
    last_update   = STR_TO_DATE(@upd,  '%d/%m/%Y %H:%i');

-- ============================================================
-- VERIFICACION (Paso 3.5 y 3.6)
-- ============================================================

-- Total esperado: 5050 (50 de la practica 1 + 5000 de este archivo)
SELECT COUNT(*) AS total_productos FROM tb_products;

-- Los 5000 de este archivo.
-- OJO: el formato de SKU NO es uniforme. Hay marcas de 2 letras (ELE-HP-...),
-- de 3 (AUD-EDI-...) y con guiones extra (HOG-T-F-00265-Y822), asi que un
-- regex de segmentos fijos NO sirve. El dato comun es el numero de 5 digitos.
SELECT COUNT(*) AS productos_cargados
FROM tb_products
WHERE sku REGEXP '^[A-Z]{3}-.*[0-9]{5}-';

-- Cualquier SKU que no sea de este CSV ni de la practica 1 (debe ser 0)
SELECT COUNT(*) AS huerfanos
FROM tb_products
WHERE sku NOT LIKE 'PROD-%'
  AND sku NOT REGEXP '^[A-Z]{3}-.*[0-9]{5}-';

-- Distribucion por categoria
SELECT category, COUNT(*) AS productos
FROM tb_products
WHERE sku NOT LIKE 'PROD-%'
GROUP BY category ORDER BY productos DESC;

-- La auditoria del trigger debe registrar 5000 altas de samuel
SELECT db_user, COUNT(*) AS operaciones
FROM tb_logs
WHERE table_name = 'tb_products' AND table_operation = 'Create'
GROUP BY db_user;
