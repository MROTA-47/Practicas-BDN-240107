-- ============================================================
-- PRACTICA BDN 240107 - TABLA PRODUCTOS + TRIGGERS + BITACORA
-- Base: db_test  |  Puerto: 40107
-- Genera: 50 productos + 5 actualizaciones + 2 borrados
-- Los triggers llenan tb_logs automaticamente (bitacora)
-- ============================================================
USE db_test;

-- ---------- 1. TABLA DE PRODUCTOS ----------
DROP TABLE IF EXISTS tb_products;
CREATE TABLE tb_products (
  ID            INT NOT NULL AUTO_INCREMENT,
  sku           VARCHAR(20)  NOT NULL,
  name          VARCHAR(100) NOT NULL,
  description   VARCHAR(255) DEFAULT NULL,
  category      VARCHAR(50)  NOT NULL,
  price         DECIMAL(10,2) NOT NULL,
  stock         INT NOT NULL DEFAULT 0,
  status        BIT(1) DEFAULT b'1',
  creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_update   DATETIME DEFAULT NULL,
  PRIMARY KEY (ID),
  UNIQUE KEY sku (sku),
  KEY idx_category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------- 2. TRIGGERS (escriben en tb_logs) ----------
DELIMITER ;;
CREATE TRIGGER trg_products_after_insert AFTER INSERT ON tb_products FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_products', 'Create', USER(),
        CONCAT('Producto creado. ID=', NEW.ID, ', sku=', NEW.sku,
               ', name=', NEW.name, ', price=', NEW.price,
               ', stock=', NEW.stock, ', status=', NEW.status),
        CURRENT_TIMESTAMP, b'1');
END;;
CREATE TRIGGER trg_products_after_update AFTER UPDATE ON tb_products FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_products', 'Update', USER(),
        CONCAT('Producto modificado. ID=', OLD.ID, ', sku=', OLD.sku,
               ', precio: ', OLD.price, ' -> ', NEW.price,
               ', stock: ', OLD.stock, ' -> ', NEW.stock,
               ', status: ', OLD.status, ' -> ', NEW.status),
        CURRENT_TIMESTAMP, b'1');
END;;
CREATE TRIGGER trg_products_after_delete AFTER DELETE ON tb_products FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_products', 'Delete', USER(),
        CONCAT('Producto eliminado. ID=', OLD.ID, ', sku=', OLD.sku,
               ', name=', OLD.name, ', price=', OLD.price, ', stock=', OLD.stock),
        CURRENT_TIMESTAMP, b'1');
END;;
DELIMITER ;

-- ---------- 3. CARGA DE 50 PRODUCTOS (cada uno genera 1 log) ----------
INSERT INTO tb_products (sku, name, description, category, price, stock) VALUES
-- Papeleria (10)
('PROD-001','Boligrafo azul Pilot','Tinta azul 0.7mm','Papeleria',18.50,120),
('PROD-002','Boligrafo rojo Bic','Tinta roja 0.7mm','Papeleria',18.50,95),
('PROD-003','Lapiz grafito No.2','Madera prensada','Papeleria',12.00,200),
('PROD-004','Goma de borrar','Blanca sin marcas','Papeleria',15.75,150),
('PROD-005','Tijeras escolares 5 pulgadas','Punta redonda','Papeleria',45.00,60),
('PROD-006','Pegamento en barra','22g reutilizable','Papeleria',28.90,80),
('PROD-007','Cuaderno profesional 100 hojas','Cuadriculado','Papeleria',65.00,75),
('PROD-008','Carpeta de 3 anillos','Carton 11x8.5','Papeleria',52.00,40),
('PROD-009','Resaltadores 6 colores','Fluor','Papeleria',89.90,35),
('PROD-010','Papel carta paq 100 hojas','Blanco 75g','Papeleria',95.00,30),
-- Electronica (8)
('PROD-011','Audifonos con cable','3.5mm estereo','Electronica',149.00,45),
('PROD-012','Mouse optico USB','1200 DPI','Electronica',189.00,38),
('PROD-013','Memoria USB 32GB','USB 3.0','Electronica',179.00,52),
('PROD-014','Cable USB-C 1m','Carga rapida','Electronica',99.00,60),
('PROD-015','Cargador 10W','USB 2 puertos','Electronica',249.00,25),
('PROD-016','Baterias AA paq 4','Alcalinas','Electronica',79.00,70),
('PROD-017','Parlante Bluetooth','Bateria 2000mAh','Electronica',499.00,18),
('PROD-018','Teclado membrane USB','Español','Electronica',329.00,22),
-- Utiles escolares (8)
('PROD-019','Regla 30 cm','Plastico flexible','Utiles escolares',22.00,110),
('PROD-020','Compas escolar','Metal con mina','Utiles escolares',78.00,42),
('PROD-021','Transportador 180 grados','Plastico','Utiles escolares',35.00,65),
('PROD-022','Set de colores 12 piezas','Madera','Utiles escolares',110.00,48),
('PROD-023','Acuarelas 6 colores','Con pincel','Utiles escolares',98.00,36),
('PROD-024','Pizarron blanco 40x60','Con marco','Utiles escolares',590.00,8),
('PROD-025','Marcadores pizarron paq 4','Negro azul rojo verde','Utiles escolares',120.00,30),
('PROD-026','Mochila escolar','2 compartimentos','Utiles escolares',450.00,20),
-- Bebidas (7)
('PROD-027','Agua natural 600ml','Hielo','Bebidas',22.00,144),
('PROD-028','Refresco cola 355ml','Lata','Bebidas',25.00,130),
('PROD-029','Jugo de naranja 400ml','Sin azucar','Bebidas',28.00,90),
('PROD-030','Cafe soluble 20g','Sobre individual','Bebidas',18.00,100),
('PROD-031','Te frio limon 473ml','Botella','Bebidas',32.00,72),
('PROD-032','Leche entera 1L','Caja','Bebidas',38.00,55),
('PROD-033','Energetica 250ml','Lata','Bebidas',42.00,6),
-- Snacks (7)
('PROD-034','Papitas familiar 45g','Clasicas','Snacks',35.00,88),
('PROD-035','Galletas chocolate paq','6 piezas','Snacks',45.00,64),
('PROD-036','Chocolate bar 40g','Leche','Snacks',28.00,95),
('PROD-037','Caramelos paq','Surtidos 100g','Snacks',32.00,50),
('PROD-038','Barra de granola','Avena y miel','Snacks',26.00,77),
('PROD-039','Mani salado 100g','Cacahuate','Snacks',30.00,58),
('PROD-040','Chicles paq 15g','Menta','Snacks',12.00,120),
-- Limpieza (5)
('PROD-041','Gel antibacterial 250ml','Con aloe','Limpieza',58.00,40),
('PROD-042','Panales desechables paq','100 hojas','Limpieza',34.00,66),
('PROD-043','Desinfectante 500ml','Multiusos','Limpieza',62.00,33),
('PROD-044','Toallas de papel','Rollo doble capa','Limpieza',29.00,85),
('PROD-045','Jabon de barra','150g neutro','Limpieza',24.00,70),
-- Otros (5)
('PROD-046','Llavero escolar','Acrilico','Otros',35.00,90),
('PROD-047','Botella termica 500ml','Acero inoxidable','Otros',280.00,26),
('PROD-048','Escritorio plegable','Chapa 60x40','Otros',750.00,5),
('PROD-049','Silla plastica','Apilable','Otros',340.00,15),
('PROD-050','Gafete con cordon','Incluye plastico','Otros',48.00,60);

-- ---------- 4. ACTUALIZACIONES (5 logs de tipo Update) ----------
UPDATE tb_products SET price = 16.90, last_update = CURRENT_TIMESTAMP WHERE sku = 'PROD-001';
UPDATE tb_products SET stock  = 60,    last_update = CURRENT_TIMESTAMP WHERE sku = 'PROD-011';
UPDATE tb_products SET price  = 19.00, last_update = CURRENT_TIMESTAMP WHERE sku = 'PROD-027';
UPDATE tb_products SET stock  = 75,    last_update = CURRENT_TIMESTAMP WHERE sku = 'PROD-034';
UPDATE tb_products SET status = b'0',  last_update = CURRENT_TIMESTAMP WHERE sku = 'PROD-044';

-- ---------- 5. PRODUCTOS DE PRUEBA (se borran = 2 logs de Delete) ----------
INSERT INTO tb_products (sku, name, description, category, price, stock) VALUES
('PROD-901','Producto de prueba A','Se elimina en la practica','Pruebas',1.00,1),
('PROD-902','Producto de prueba B','Se elimina en la practica','Pruebas',1.00,1);

DELETE FROM tb_products WHERE sku IN ('PROD-901','PROD-902');

-- ---------- 6. VERIFICACION RAPIDA ----------
SELECT COUNT(*) AS total_productos FROM tb_products;
SELECT COUNT(*) AS total_bitacora  FROM tb_logs;
SELECT table_operation, COUNT(*) AS cantidad FROM tb_logs GROUP BY table_operation;
