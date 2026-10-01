-- ============================================================
-- PRACTICA 02 — CONSULTAS DE PRODUCTOS Y BITACORA
-- Alumno: Rene David Cabrera | Matricula: 240107
-- Base: db_test | Puerto: 40107
-- ============================================================

USE db_test;

/* ---------- Productos por categoria ---------- */
SELECT category AS categoria, COUNT(*) AS productos,
       ROUND(AVG(price), 2) AS precio_promedio,
       SUM(stock) AS stock_total
FROM tb_products
WHERE sku NOT LIKE 'PROD-%'
GROUP BY category
ORDER BY productos DESC;

/* ---------- Top 10 productos mas caros ---------- */
SELECT sku, name, category, price, stock
FROM tb_products
ORDER BY price DESC
LIMIT 10;

/* ---------- Productos sin existencias ---------- */
SELECT sku, name, category, stock
FROM tb_products
WHERE stock = 0
ORDER BY name
LIMIT 20;

/* ---------- Productos de la Practica 01 ---------- */
SELECT sku, name, category, price, stock, status
FROM tb_products
WHERE sku LIKE 'PROD-%'
ORDER BY sku;

/* ---------- Cuantos productos cargo cada vendedor ---------- */
SELECT inserted_by AS usuario, roles, COUNT(*) AS productos
FROM vw_trazabilidad_productos
WHERE id > 50
GROUP BY inserted_by, roles
ORDER BY productos DESC;

/* ---------- Solo los sellers (Paso 3.4) ---------- */
SELECT inserted_by AS vendedor,
       COUNT(*) AS productos_cargados,
       COUNT(DISTINCT categoria) AS categorias_distintas,
       MIN(fecha) AS primera_carga,
       MAX(fecha) AS ultima_carga
FROM vw_trazabilidad_productos
WHERE roles LIKE '%seller%'
GROUP BY inserted_by
ORDER BY productos_cargados DESC;

/* ---------- Categoria mas poblada ---------- */
SELECT c.nombre AS categoria, COUNT(p.ID) AS productos
FROM tb_categorias c
LEFT JOIN tb_products p ON p.category = c.nombre
GROUP BY c.id, c.nombre
ORDER BY productos DESC;

/* ---------- Historial completo de la bitacora ---------- */
SELECT id_log, tabla, entidad_id, operacion, usuario, roles,
       fecha
FROM vw_auditoria_completa
ORDER BY id_log DESC
LIMIT 50;

/* ---------- Actividad por usuario ---------- */
SELECT usuario, roles, tabla, operacion, operaciones,
       primera_operacion, ultima_operacion
FROM vw_actividad_por_usuario
ORDER BY operaciones DESC;