-- ============================================================
-- PRACTICA 03 - 01 RELACION N:M PRODUCTOS <-> CATEGORIAS
-- Alumno: Rene David Cabrera | Matricula: 240107
-- Base: db_test | Local: puerto 40107 | VPS: puerto 40710
-- Rama: Practica03
-- ============================================================
-- QUE CREA:
--   tbd_products_categories(product_id, category_id)
--     product_id  INT          -> tb_products(ID)
--     category_id INT UNSIGNED -> tbc_categories(ID)
--   + 3 triggers de trazabilidad a tb_logs
--   + carga inicial repartida (1 categoria por producto)
-- ============================================================

USE db_test;

-- ---------------------------------------------------------------
-- 1. Tabla puente N:M
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbd_products_categories (
  product_id  INT NOT NULL,
  category_id INT UNSIGNED NOT NULL,
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id, category_id),
  KEY idx_tbd_product (product_id),
  KEY idx_tbd_category (category_id),
  CONSTRAINT fk_tbd_product
    FOREIGN KEY (product_id) REFERENCES tb_products (ID)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_tbd_category
    FOREIGN KEY (category_id) REFERENCES tbc_categories (ID)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------
-- 2. Triggers de trazabilidad (3 = 1 por operacion)
--    tb_logs.entity_id guarda el product_id afectado.
-- ---------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_tbd_after_insert;
DROP TRIGGER IF EXISTS trg_tbd_after_update;
DROP TRIGGER IF EXISTS trg_tbd_after_delete;

DELIMITER ;;

CREATE TRIGGER trg_tbd_after_insert AFTER INSERT ON tbd_products_categories FOR EACH ROW
BEGIN
  INSERT INTO tb_logs (table_name, entity_id, table_operation, db_user, operation_description, operation_date, operation_status)
  VALUES ('tbd_products_categories', NEW.product_id, 'Create', USER(),
    CONCAT('Asignacion creada. producto=', NEW.product_id, ', categoria=', NEW.category_id),
    CURRENT_TIMESTAMP, b'1');
END;;

CREATE TRIGGER trg_tbd_after_update AFTER UPDATE ON tbd_products_categories FOR EACH ROW
BEGIN
  INSERT INTO tb_logs (table_name, entity_id, table_operation, db_user, operation_description, operation_date, operation_status)
  VALUES ('tbd_products_categories', NEW.product_id, 'Update', USER(),
    CONCAT('Asignacion modificada. producto=', OLD.product_id, ' cat ', OLD.category_id, ' -> ', NEW.category_id),
    CURRENT_TIMESTAMP, b'1');
END;;

CREATE TRIGGER trg_tbd_after_delete AFTER DELETE ON tbd_products_categories FOR EACH ROW
BEGIN
  INSERT INTO tb_logs (table_name, entity_id, table_operation, db_user, operation_description, operation_date, operation_status)
  VALUES ('tbd_products_categories', OLD.product_id, 'Delete', USER(),
    CONCAT('Asignacion eliminada. producto=', OLD.product_id, ', categoria=', OLD.category_id),
    CURRENT_TIMESTAMP, b'1');
END;;

DELIMITER ;

-- ---------------------------------------------------------------
-- 3. Carga inicial: 1 categoria por producto (reparto round-robin)
--    Idempotente: INSERT IGNORE, se puede correr N veces.
-- ---------------------------------------------------------------
INSERT IGNORE INTO tbd_products_categories (product_id, category_id)
SELECT p.ID, c.ID
FROM tb_products p
JOIN (
  SELECT ID, ROW_NUMBER() OVER (ORDER BY ID) AS rn,
         COUNT(*) OVER () AS total
  FROM tbc_categories
) c ON c.rn = ((p.ID % c.total) + 1);

-- ---------------------------------------------------------------
-- 4. Verificacion
-- ---------------------------------------------------------------
SELECT 'TBD_CREADA' AS resultado;
SELECT COUNT(*) AS asignaciones FROM tbd_products_categories;
SELECT COUNT(DISTINCT product_id) AS productos_con_categoria FROM tbd_products_categories;
