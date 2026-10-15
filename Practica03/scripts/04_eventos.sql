-- ============================================================
-- PRACTICA 03 - 04 EVENTOS PROGRAMADOS
-- Alumno: Rene David Cabrera | Matricula: 240107
-- Base: db_test
-- ============================================================
--   ev_desactiva_sin_stock  diario: status=0 donde stock<=0
--   ev_limpieza_logs        semanal: borra bitacora > 90 dias
-- NOTA: el scheduler debe estar encendido:
--   SET GLOBAL event_scheduler = ON;
-- En el VPS (docker mysql_db) se activa igual con el mismo comando.
-- ============================================================

USE db_test;

SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS ev_desactiva_sin_stock;
DROP EVENT IF EXISTS ev_limpieza_logs;

DELIMITER ;;

CREATE EVENT ev_desactiva_sin_stock
ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP
DO
  UPDATE tb_products SET status = b'0'
  WHERE stock <= 0 AND status = b'1';;

CREATE EVENT ev_limpieza_logs
ON SCHEDULE EVERY 1 WEEK STARTS CURRENT_TIMESTAMP
DO
  DELETE FROM tb_logs WHERE operation_date < (NOW() - INTERVAL 90 DAY);;

DELIMITER ;

SELECT 'EVENTOS_CREADOS' AS resultado;
SELECT EVENT_SCHEMA, EVENT_NAME, STATUS, EVENT_DEFINITION
FROM information_schema.EVENTS WHERE EVENT_SCHEMA = 'db_test';
SELECT @@event_scheduler AS event_scheduler;
