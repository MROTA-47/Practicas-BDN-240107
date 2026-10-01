-- ============================================================
-- PRACTICA 02 - Correccion de la columna entity_id
-- Para que la trazabilidad muestre el ROL de quien inserta.
-- ============================================================
-- PROBLEMA QUE RESUELVE
-- La vista vw_trazabilidad_productos une con:
--       b.entity_id = p.ID
-- pero la columna entity_id solo se habia llenado con un UPDATE
-- manual hecho una vez. Las filas nuevas que insertan los sellers
-- quedan con entity_id = NULL, y la vista devuelve:
--       inserted_by = NULL   roles = "Sin rol"   fecha = NULL
--
-- SOLUCION: que los TRIGGERS llenen entity_id al escribir.
-- Asi cada alta futura queda con su ID y su rol correctamente.
-- ============================================================

USE db_test;

-- ---------------------------------------------------------------
-- 1. Rellenar entity_id en las filas historicas que esten NULL
-- ---------------------------------------------------------------
UPDATE tb_logs
SET entity_id = CAST(
        SUBSTRING_INDEX(SUBSTRING_INDEX(operation_description, 'ID=', -1), ',', 1)
        AS UNSIGNED)
WHERE entity_id IS NULL
  AND operation_description LIKE '%ID=%';

-- ---------------------------------------------------------------
-- 2. Recrear los 6 triggers para que tambien llenen entity_id
-- ---------------------------------------------------------------

-- ---------- PRODUCTOS ----------
DROP TRIGGER IF EXISTS trg_products_after_insert;
DROP TRIGGER IF EXISTS trg_products_after_update;
DROP TRIGGER IF EXISTS trg_products_after_delete;

DELIMITER ;;
CREATE TRIGGER trg_products_after_insert AFTER INSERT ON tb_products FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, entity_id, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_products', NEW.ID, 'Create', USER(),
        CONCAT('Producto creado. ID=', NEW.ID, ', sku=', NEW.sku,
               ', name=', NEW.name, ', price=', NEW.price,
               ', stock=', NEW.stock, ', status=', NEW.status),
        CURRENT_TIMESTAMP, b'1');
END;;
CREATE TRIGGER trg_products_after_update AFTER UPDATE ON tb_products FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, entity_id, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_products', NEW.ID, 'Update', USER(),
        CONCAT('Producto modificado. ID=', OLD.ID, ', sku=', OLD.sku,
               ', precio: ', OLD.price, ' -> ', NEW.price,
               ', stock=', OLD.stock, ' -> ', NEW.stock,
               ', status=', OLD.status, ' -> ', NEW.status),
        CURRENT_TIMESTAMP, b'1');
END;;
CREATE TRIGGER trg_products_after_delete AFTER DELETE ON tb_products FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, entity_id, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_products', OLD.ID, 'Delete', USER(),
        CONCAT('Producto eliminado. ID=', OLD.ID, ', sku=', OLD.sku,
               ', name=', OLD.name, ', price=', OLD.price, ', stock=', OLD.stock),
        CURRENT_TIMESTAMP, b'1');
END;;

-- ---------- USUARIOS ----------
DROP TRIGGER IF EXISTS trg_users_after_insert;
DROP TRIGGER IF EXISTS trg_users_after_update;
DROP TRIGGER IF EXISTS trg_users_after_delete;

CREATE TRIGGER trg_users_after_insert AFTER INSERT ON tb_users FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, entity_id, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_users', NEW.ID, 'Create', USER(),
        CONCAT('Usuario creado. ID=', NEW.ID, ', email=', NEW.email,
               ', nick=', NEW.nick, ', creation_date=', NEW.creation_date,
               ', status=', NEW.status),
        CURRENT_TIMESTAMP, b'1');
END;;
CREATE TRIGGER trg_users_after_update AFTER UPDATE ON tb_users FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, entity_id, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_users', NEW.ID, 'Update', USER(),
        CONCAT('Usuario modificado. ID=', OLD.ID, ', nuevo_email=', NEW.email,
               ', nuevo_nick=', NEW.nick, ', nuevo_status=', NEW.status),
        CURRENT_TIMESTAMP, b'1');
END;;
CREATE TRIGGER trg_users_after_delete AFTER DELETE ON tb_users FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, entity_id, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_users', OLD.ID, 'Delete', USER(),
        CONCAT('Usuario eliminado. ID=', OLD.ID, ', email=', OLD.email,
               ', nick=', OLD.nick),
        CURRENT_TIMESTAMP, b'1');
END;;
DELIMITER ;

-- ---------------------------------------------------------------
-- 3. Verificacion
-- ---------------------------------------------------------------
SELECT COUNT(*) AS total_logs FROM tb_logs;
SELECT COUNT(*) AS logs_sin_entity_id FROM tb_logs WHERE entity_id IS NULL;
SELECT TRIGGER_NAME, EVENT_OBJECT_TABLE FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'db_test' ORDER BY EVENT_OBJECT_TABLE, EVENT_MANIPULATION;