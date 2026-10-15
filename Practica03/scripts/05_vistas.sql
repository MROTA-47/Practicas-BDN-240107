-- ============================================================
-- PRACTICA 03 - 05 VISTA DE CONTEO POR CATEGORIA
-- Alumno: Rene David Cabrera | Matricula: 240107
-- Base: db_test
-- ============================================================
-- La usa el punto 3 de consultas_verificacion.sql:
--   SELECT * FROM vw_total_products_by_category ...
-- Incluye categorias con 0 productos (LEFT JOIN).
-- ============================================================

USE db_test;

DROP VIEW IF EXISTS vw_total_products_by_category;

CREATE VIEW vw_total_products_by_category AS
SELECT
  c.ID AS category_id,
  c.name AS category_name,
  COUNT(t.product_id) AS total_products,
  IFNULL(SUM(p.stock), 0) AS stock_total,
  ROUND(AVG(p.price), 2) AS precio_promedio
FROM tbc_categories c
LEFT JOIN tbd_products_categories t ON t.category_id = c.ID
LEFT JOIN tb_products p ON p.ID = t.product_id
GROUP BY c.ID, c.name;

SELECT 'VISTA_CREADA' AS resultado;
SELECT * FROM vw_total_products_by_category ORDER BY category_id;
