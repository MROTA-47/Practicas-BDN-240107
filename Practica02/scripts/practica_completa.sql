-- ============================================================
-- PRACTICA COMPLETA - BDN 240107 - SCRIPT SQL UNICO
-- Puerto: 40107 | Host: 127.0.0.1 (o 10.10.60.40 remoto)
-- Ejecutar con:  mysql -u root -p240107 -P 40107 < practica_completa.sql
-- o en MySQL Workbench (conexion puerto 40107)
-- ============================================================

-- ---------- 1. BASES DE DATOS ----------
CREATE DATABASE IF NOT EXISTS db_test;
CREATE DATABASE IF NOT EXISTS db_bdn_240107;

-- ============================================================
-- NOTA: las tablas tb_users, tb_logs y los 3 triggers
-- se cargan desde Backups/db_test.sql (IMPORTAR CON):
--   mysql -u root -p240107 -P 40107 -D db_test < Backups\db_test.sql
-- (abajo va el resumen de lo que contiene)
-- ============================================================

-- Tablas creadas por el respaldo:
--   db_test.tb_users  (ID, email, nick, password, creation_date, last_update, last_login, status)
--   db_test.tb_logs   (id, table_name, table_operation, db_user, operation_description, operation_date, operation_status)
-- Triggers:
--   trg_users_after_insert / trg_users_after_update / trg_users_after_delete

USE db_bdn_240107;

-- ---------- 2. USUARIOS REMOTOS ----------
DROP USER IF EXISTS 'rene.cabrera'@'%';
DROP USER IF EXISTS 'johnatan'@'%';
DROP USER IF EXISTS 'samuel'@'%';
DROP USER IF EXISTS 'aaron'@'%';
DROP USER IF EXISTS 'mario'@'%';
DROP USER IF EXISTS 'alfonso'@'%';

-- ---------- 3. ROLES ----------
DROP ROLE IF EXISTS 'superadmin';
DROP ROLE IF EXISTS 'admin';
DROP ROLE IF EXISTS 'seller';
DROP ROLE IF EXISTS 'buyer';
DROP ROLE IF EXISTS 'guest';
DROP ROLE IF EXISTS 'support';
DROP ROLE IF EXISTS 'common';
DROP ROLE IF EXISTS 'user_not_registered';

-- ---------- 4. CREAR USUARIOS ----------
CREATE USER 'rene.cabrera'@'%' IDENTIFIED BY '240107';
CREATE USER 'johnatan'@'%' IDENTIFIED BY '240080';
CREATE USER 'samuel'@'%' IDENTIFIED BY '240043';
CREATE USER 'aaron'@'%' IDENTIFIED BY '240045';
CREATE USER 'mario'@'%' IDENTIFIED BY '23409';
CREATE USER 'alfonso'@'%' IDENTIFIED BY '240904';

-- ---------- 5. CREAR ROLES ----------
CREATE ROLE 'superadmin';
CREATE ROLE 'admin';
CREATE ROLE 'seller';
CREATE ROLE 'buyer';
CREATE ROLE 'guest';
CREATE ROLE 'support';
CREATE ROLE 'common';
CREATE ROLE 'user_not_registered';

-- ---------- 6. PRIVILEGIOS A ROLES ----------
GRANT ALL PRIVILEGES ON *.* TO 'superadmin' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON db_test.* TO 'admin' WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE ON db_test.* TO 'seller';
GRANT SELECT ON db_test.* TO 'buyer';
GRANT SELECT ON db_test.* TO 'guest';
GRANT SELECT, INSERT, UPDATE ON db_test.* TO 'support';
GRANT SELECT ON db_test.* TO 'common';
GRANT SELECT ON db_test.* TO 'user_not_registered';

-- ---------- 7. ASIGNAR ROLES ----------
GRANT 'superadmin' TO 'rene.cabrera'@'%';
GRANT 'admin' TO 'johnatan'@'%';
GRANT 'seller' TO 'samuel'@'%';
GRANT 'buyer' TO 'aaron'@'%';
GRANT 'guest' TO 'mario'@'%';
GRANT 'support' TO 'alfonso'@'%';

-- ---------- 8. ROLES POR DEFECTO ----------
SET DEFAULT ROLE 'superadmin' TO 'rene.cabrera'@'%';
SET DEFAULT ROLE 'admin' TO 'johnatan'@'%';
SET DEFAULT ROLE 'seller' TO 'samuel'@'%';
SET DEFAULT ROLE 'buyer' TO 'aaron'@'%';
SET DEFAULT ROLE 'guest' TO 'mario'@'%';
SET DEFAULT ROLE 'support' TO 'alfonso'@'%';

FLUSH PRIVILEGES;

-- ---------- 9. VERIFICACION ----------
SHOW DATABASES;

SELECT User, Host FROM mysql.user WHERE Host = '%' ORDER BY User;

SELECT TO_USER AS usuario, FROM_USER AS rol
FROM mysql.role_edges ORDER BY TO_USER, FROM_USER;

SHOW GRANTS FOR 'rene.cabrera'@'%';
