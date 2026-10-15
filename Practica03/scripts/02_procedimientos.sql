-- ============================================================
-- PRACTICA 03 - 02 PROCEDIMIENTOS ALMACENADOS
-- Alumno: Rene David Cabrera | Matricula: 240107
-- Base: db_test
-- ============================================================
--   sp_soft_delete_user(p_user_id)      baja logica de tb_users
--   sp_insert_product(...)              alta con validacion de categoria
--   sp_update_stock(p_id, p_delta)      mueve stock sin dejar negativo
--   sp_assign_product_category(p,c)     asigna N:M (idempotente)
-- ============================================================

USE db_test;

DROP PROCEDURE IF EXISTS sp_soft_delete_user;
DROP PROCEDURE IF EXISTS sp_insert_product;
DROP PROCEDURE IF EXISTS sp_update_stock;
DROP PROCEDURE IF EXISTS sp_assign_product_category;

DELIMITER ;;

-- Baja logica: status = 0. El trigger trg_users_after_update
-- ya deja la trazabilidad en tb_logs.
CREATE PROCEDURE sp_soft_delete_user(IN p_user_id INT)
BEGIN
  UPDATE tb_users SET status = b'0' WHERE ID = p_user_id;
  SELECT ROW_COUNT() AS filas_afectadas;
END;;

-- Alta de producto validando que la categoria exista en tb_categorias
-- (respeta la FK fk_productos_categoria creada en la Practica 02).
CREATE PROCEDURE sp_insert_product(
  IN p_sku VARCHAR(20),
  IN p_name VARCHAR(100),
  IN p_category VARCHAR(50),
  IN p_price DECIMAL(10,2),
  IN p_stock INT
)
BEGIN
  DECLARE v_existe INT DEFAULT 0;
  SELECT COUNT(*) INTO v_existe FROM tb_categorias WHERE nombre = p_category;
  IF v_existe = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Categoria inexistente en tb_categorias';
  END IF;
  INSERT INTO tb_products (sku, name, category, price, stock, status)
  VALUES (p_sku, p_name, p_category, p_price, p_stock, b'1');
  SELECT LAST_INSERT_ID() AS nuevo_id;
END;;

-- Movimiento de stock con guarda de negativos.
CREATE PROCEDURE sp_update_stock(IN p_product_id INT, IN p_delta INT)
BEGIN
  DECLARE v_stock INT;
  SELECT stock INTO v_stock FROM tb_products WHERE ID = p_product_id FOR UPDATE;
  IF v_stock IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto inexistente';
  END IF;
  IF (v_stock + p_delta) < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
  END IF;
  UPDATE tb_products SET stock = stock + p_delta WHERE ID = p_product_id;
  SELECT ID, sku, stock FROM tb_products WHERE ID = p_product_id;
END;;

-- Asignacion N:M idempotente.
CREATE PROCEDURE sp_assign_product_category(IN p_product_id INT, IN p_category_id INT)
BEGIN
  INSERT IGNORE INTO tbd_products_categories (product_id, category_id)
  VALUES (p_product_id, p_category_id);
  SELECT ROW_COUNT() AS fila_insertada;
END;;

DELIMITER ;

SELECT 'PROCEDIMIENTOS_CREADOS' AS resultado;
SHOW PROCEDURE STATUS WHERE Db = 'db_test';
