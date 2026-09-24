-- ============================================================
-- PRÁCTICA BDN — MYSQL REMOTO (USUARIOS Y ROLES)
-- ============================================================

USE  db_bdn_240107;

-- 1. ELIMINAR USUARIOS SI YA EXISTEN
DROP USER IF EXISTS 'rene.cabrera'@'%';
DROP USER IF EXISTS 'johnatan'@'%';
DROP USER IF EXISTS 'samuel'@'%';
DROP USER IF EXISTS 'aaron'@'%';
DROP USER IF EXISTS 'mario'@'%';
DROP USER IF EXISTS 'alfonso'@'%';

-- 2. ELIMINAR ROLES SI YA EXISTEN
DROP ROLE IF EXISTS 'superadmin';
DROP ROLE IF EXISTS 'admin';
DROP ROLE IF EXISTS 'seller';
DROP ROLE IF EXISTS 'buyer';
DROP ROLE IF EXISTS 'guest';
DROP ROLE IF EXISTS 'support';
DROP ROLE IF EXISTS 'common';
DROP ROLE IF EXISTS 'user_not_registered';

-- 3. CREAR USUARIOS
CREATE USER 'rene.cabrera'@'%' IDENTIFIED BY '240107';
CREATE USER 'johnatan'@'%' IDENTIFIED BY '240080';
CREATE USER 'samuel'@'%' IDENTIFIED BY '240043';
CREATE USER 'aaron'@'%' IDENTIFIED BY '240045';
CREATE USER 'mario'@'%' IDENTIFIED BY '23409';
CREATE USER 'alfonso'@'%' IDENTIFIED BY '240904';

-- 4. CREAR ROLES
CREATE ROLE 'superadmin';
CREATE ROLE 'admin';
CREATE ROLE 'seller';
CREATE ROLE 'buyer';
CREATE ROLE 'guest';
CREATE ROLE 'support';
CREATE ROLE 'common';
CREATE ROLE 'user_not_registered';

-- 5. ASIGNAR PRIVILEGIOS A LOS ROLES
GRANT ALL PRIVILEGES ON *.* TO 'superadmin' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON db_test.* TO 'admin' WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE ON db_test.* TO 'seller';
GRANT SELECT ON db_test.* TO 'buyer';
GRANT SELECT ON db_test.* TO 'guest';
GRANT SELECT, INSERT, UPDATE ON db_test.* TO 'support';
GRANT SELECT ON db_test.* TO 'common';
GRANT SELECT ON db_test.* TO 'user_not_registered';

-- 6. ASIGNAR ROLES A LOS USUARIOS
GRANT 'superadmin' TO 'rene.cabrera'@'%';
GRANT 'admin' TO 'johnatan'@'%';
GRANT 'seller' TO 'samuel'@'%';
GRANT 'buyer' TO 'aaron'@'%';
GRANT 'guest' TO 'mario'@'%';
GRANT 'support' TO 'alfonso'@'%';

-- 7. DEFINIR ROLES POR DEFECTO
SET DEFAULT ROLE 'superadmin' TO 'rene.cabrera'@'%';
SET DEFAULT ROLE 'admin' TO 'johnatan'@'%';
SET DEFAULT ROLE 'seller' TO 'samuel'@'%';
SET DEFAULT ROLE 'buyer' TO 'aaron'@'%';
SET DEFAULT ROLE 'guest' TO 'mario'@'%';
SET DEFAULT ROLE 'support' TO 'alfonso'@'%';

FLUSH PRIVILEGES;