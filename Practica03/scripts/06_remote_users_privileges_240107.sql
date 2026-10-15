-- ============================================================
-- PRACTICA 03 - 06 USUARIOS Y PRIVILEGIOS REMOTOS (matricula 240107)
-- Adaptado de remote_users_privileges_creation_7A.sql del profesor
-- a la base real del alumno: db_test (puerto local 40107 / VPS 40710)
-- Alumno admin: rene.cabrera / 240107  -> superadmin
-- Profesor:     marco.ramirez          -> admin (solo calificacion)
-- ============================================================
-- Se reutilizan los roles y usuarios creados en la Practica 02.
-- Este script es idempotente: se puede correr N veces.
-- ============================================================

-- ---------------------------------------------------------------
-- 1. Usuarios (los 9 de la Practica 02 + profesor)
-- ---------------------------------------------------------------
CREATE USER IF NOT EXISTS 'rene.cabrera'@'%'   IDENTIFIED BY '240107';
CREATE USER IF NOT EXISTS 'diego.ex'@'%'       IDENTIFIED BY '240709';
CREATE USER IF NOT EXISTS 'oliver.sanchez'@'%' IDENTIFIED BY '240615';
CREATE USER IF NOT EXISTS 'brandon.torres'@'%' IDENTIFIED BY '240220';
CREATE USER IF NOT EXISTS 'aaron'@'%'          IDENTIFIED BY '240045';
CREATE USER IF NOT EXISTS 'ivan.medina'@'%'    IDENTIFIED BY '240663';
CREATE USER IF NOT EXISTS 'hector.ramos'@'%'   IDENTIFIED BY '240441';
CREATE USER IF NOT EXISTS 'karina.lopez'@'%'   IDENTIFIED BY '240333';
CREATE USER IF NOT EXISTS 'paola.serrano'@'%'  IDENTIFIED BY '240552';
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%'  IDENTIFIED BY 'qwerty123';

-- ---------------------------------------------------------------
-- 2. Roles del e-commerce (los 7 del profesor)
-- ---------------------------------------------------------------
CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'support';
CREATE ROLE IF NOT EXISTS 'common';
CREATE ROLE IF NOT EXISTS 'guest';
CREATE ROLE IF NOT EXISTS 'user_not_registered';

-- ---------------------------------------------------------------
-- 3. Privilegios a roles sobre db_test (+ tablas nuevas P03)
-- ---------------------------------------------------------------
GRANT ALL PRIVILEGES ON *.* TO 'superadmin';
GRANT ALL PRIVILEGES ON db_test.* TO 'admin';

GRANT SELECT, INSERT, UPDATE ON db_test.tb_users TO 'support';
GRANT SELECT, UPDATE ON db_test.tb_products TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test.tbc_categories TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test.tbd_products_categories TO 'support';
GRANT EXECUTE ON PROCEDURE db_test.sp_soft_delete_user TO 'support';

GRANT SELECT, INSERT, UPDATE ON db_test.tb_products TO 'seller';
GRANT SELECT ON db_test.tbc_categories TO 'seller';
GRANT SELECT ON db_test.tbd_products_categories TO 'seller';

GRANT SELECT ON db_test.tb_products TO 'buyer';
GRANT SELECT ON db_test.tbc_categories TO 'buyer';

GRANT SELECT ON db_test.tb_products TO 'guest';

-- ---------------------------------------------------------------
-- 4. Asignacion de roles (igual que Practica 02 del alumno)
-- ---------------------------------------------------------------
GRANT 'superadmin' TO 'rene.cabrera'@'%';
GRANT 'seller' TO 'diego.ex'@'%';
GRANT 'seller' TO 'oliver.sanchez'@'%';
GRANT 'seller' TO 'brandon.torres'@'%';
GRANT 'support' TO 'aaron'@'%';
GRANT 'admin' TO 'ivan.medina'@'%';
GRANT 'support' TO 'hector.ramos'@'%';
GRANT 'buyer' TO 'karina.lopez'@'%';
GRANT 'guest' TO 'paola.serrano'@'%';
GRANT 'admin' TO 'marco.ramirez'@'%';

-- ---------------------------------------------------------------
-- 5. Roles por defecto (se activan al iniciar sesion)
-- ---------------------------------------------------------------
SET DEFAULT ROLE 'superadmin' TO 'rene.cabrera'@'%';
SET DEFAULT ROLE 'seller' TO 'diego.ex'@'%';
SET DEFAULT ROLE 'seller' TO 'oliver.sanchez'@'%';
SET DEFAULT ROLE 'seller' TO 'brandon.torres'@'%';
SET DEFAULT ROLE 'support' TO 'aaron'@'%';
SET DEFAULT ROLE 'admin' TO 'ivan.medina'@'%';
SET DEFAULT ROLE 'support' TO 'hector.ramos'@'%';
SET DEFAULT ROLE 'buyer' TO 'karina.lopez'@'%';
SET DEFAULT ROLE 'guest' TO 'paola.serrano'@'%';
SET DEFAULT ROLE 'admin' TO 'marco.ramirez'@'%';

SELECT 'USUARIOS_Y_PRIVILEGIOS_OK' AS mensaje;
