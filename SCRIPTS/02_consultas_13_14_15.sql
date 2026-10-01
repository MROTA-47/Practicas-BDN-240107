USE db_test;

-- ============================================================
-- PRACTICA 02 - Consultas 13, 14 y 15 corregidas para db_test
-- Alumno: Rene David Cabrera | Matricula: 240107
-- Conectar como: rene.cabrera / 240107
-- ============================================================
-- AJUSTES NECESARIOS (porque el script original es de otra base):
--
--  a) El nombre real de la vista es  vw_trazabilidad_usuarios
--     (en el script decia  vw_trazabilidad_users  -> no existe)
--
--  b) La columna de fecha se llama  fecha,  no  operation_date
--     (las vistas que se tenian antes no la tenian)
--
--  c) Agregamos la vista  vw_actividad_por_usuario  para el punto 14,
--     que agrupa por usuario en vez de listar una fila por usuario.
-- ============================================================


/* ============================================================
   13. Trazabilidad de los productos (10 mas recientes)
   ============================================================ */
SELECT * FROM vw_trazabilidad_productos ORDER BY fecha DESC LIMIT 10;


/* ============================================================
   14. Trazabilidad de usuarios
   En vez de una fila por usuario, muestra el resumen:
   cuantos registro inserto cada quien y con que rol.
   ============================================================ */
SELECT
    usuario,
    roles,
    tabla,
    operacion,
    operaciones,
    primera_operacion,
    ultima_operacion
FROM vw_actividad_por_usuario
ORDER BY operaciones DESC;


/* ============================================================
   15. Cuantos productos cargo cada usuario
   ============================================================ */
SELECT COUNT(*) AS total_productos, vp.inserted_by AS usuario
FROM vw_trazabilidad_productos vp
GROUP BY vp.inserted_by
ORDER BY total_productos DESC;


/* ============================================================
   15b. Con rol y total de filas (mas completo que el 15)
   ============================================================ */
SELECT
    inserted_by AS usuario,
    roles,
    COUNT(*) AS total_productos,
    MIN(fecha) AS primera_carga,
    MAX(fecha) AS ultima_carga
FROM vw_trazabilidad_productos
GROUP BY inserted_by, roles
ORDER BY total_productos DESC;


/* ============================================================
   15c. Solo los sellers (lo que pidio la practica)
   Muestra quien es seller y cuantos productos cargo cada uno.
   ============================================================ */
SELECT
    inserted_by AS vendedor,
    COUNT(*) AS productos_cargados,
    COUNT(DISTINCT categoria) AS categorias_distintas
FROM vw_trazabilidad_productos
WHERE roles LIKE '%seller%'
GROUP BY inserted_by
ORDER BY productos_cargados DESC;


/* ============================================================
   15d. Detalle: todo el historial de la bitacora
   ============================================================ */
SELECT *
FROM vw_auditoria_completa
ORDER BY id_log DESC
LIMIT 20;