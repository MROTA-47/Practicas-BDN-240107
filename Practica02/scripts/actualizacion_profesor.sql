-- ============================================================
-- ACTUALIZACION - COLUMNAS DE tb_logs PARA LA CONSULTA DEL PROFE
-- *** EJECUTAR UNA SOLA VEZ (si ya se corrio, no volver a correr) ***
-- Cambios:
--   operation        -> table_operation
--   description      -> operation_description
-- Se eliminan y recrean los 6 triggers con los nuevos nombres
-- ============================================================
USE db_test;

-- ---------- 1. ELIMINAR LOS 6 TRIGGERS EXISTENTES ----------
DROP TRIGGER IF EXISTS trg_users_after_insert;
DROP TRIGGER IF EXISTS trg_users_after_update;
DROP TRIGGER IF EXISTS trg_users_after_delete;
DROP TRIGGER IF EXISTS trg_products_after_insert;
DROP TRIGGER IF EXISTS trg_products_after_update;
DROP TRIGGER IF EXISTS trg_products_after_delete;

-- ---------- 2. RENOMBRAR COLUMNAS DE tb_logs ----------
ALTER TABLE tb_logs
    CHANGE operation   table_operation      VARCHAR(20) NOT NULL,
    CHANGE description operation_description TEXT NOT NULL;

-- ---------- 3. RECREAR TRIGGERS DE tb_users ----------
DELIMITER ;;
CREATE TRIGGER trg_users_after_insert AFTER INSERT ON tb_users FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_users', 'Create', USER(),
        CONCAT('Usuario creado. ID=', NEW.ID, ', email=', NEW.email,
               ', nick=', NEW.nick, ', creation_date=', NEW.creation_date,
               ', status=', NEW.status),
        CURRENT_TIMESTAMP, b'1');
END;;
CREATE TRIGGER trg_users_after_update AFTER UPDATE ON tb_users FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_users', 'Update', USER(),
        CONCAT('Usuario modificado. ID=', OLD.ID, ', nuevo_email=', NEW.email,
               ', nuevo_nick=', NEW.nick, ', nuevo_status=', NEW.status),
        CURRENT_TIMESTAMP, b'1');
END;;
CREATE TRIGGER trg_users_after_delete AFTER DELETE ON tb_users FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_users', 'Delete', USER(),
        CONCAT('Usuario eliminado. ID=', OLD.ID, ', email=', OLD.email,
               ', nick=', OLD.nick),
        CURRENT_TIMESTAMP, b'1');
END;;
DELIMITER ;

-- ---------- 4. RECREAR TRIGGERS DE tb_products ----------
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

-- ---------- 5. VERIFICACION ----------
DESCRIBE tb_logs;
SHOW TRIGGERS FROM db_test;
