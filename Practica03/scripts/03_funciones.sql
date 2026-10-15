-- ============================================================
-- PRACTICA 03 - 03 FUNCIONES
-- Alumno: Rene David Cabrera | Matricula: 240107
-- Base: db_test
-- ============================================================
--   fn_categoria_total(p_category_id)  cuantos productos hay en la categoria
--   fn_valor_inventario(p_product_id)  price * stock del producto
-- ============================================================

USE db_test;

DROP FUNCTION IF EXISTS fn_categoria_total;
DROP FUNCTION IF EXISTS fn_valor_inventario;

DELIMITER ;;

CREATE FUNCTION fn_categoria_total(p_category_id INT)
RETURNS INT
DETERMINISTIC READS SQL DATA
BEGIN
  DECLARE v_total INT DEFAULT 0;
  SELECT COUNT(*) INTO v_total
  FROM tbd_products_categories WHERE category_id = p_category_id;
  RETURN v_total;
END;;

CREATE FUNCTION fn_valor_inventario(p_product_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC READS SQL DATA
BEGIN
  DECLARE v_valor DECIMAL(12,2) DEFAULT 0.00;
  SELECT price * stock INTO v_valor
  FROM tb_products WHERE ID = p_product_id;
  RETURN IFNULL(v_valor, 0.00);
END;;

DELIMITER ;

SELECT 'FUNCIONES_CREADAS' AS resultado;
SHOW FUNCTION STATUS WHERE Db = 'db_test';
SELECT fn_categoria_total(1) AS ejemplo_categoria_1;
