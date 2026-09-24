-- ============================================================
-- PASO 1: CREAR BASES DE DATOS NECESARIAS
-- (db_test.sql NO trae CREATE DATABASE, hay que crearla aparte)
-- ============================================================
CREATE DATABASE IF NOT EXISTS db_test;
CREATE DATABASE IF NOT EXISTS db_bdn_240107;

-- ============================================================
-- PASO 2 (se ejecuta DESPUÉS de importar db_test.sql):
-- Copiar el contenido de node-estudesprivileges.sql aquí abajo
-- o ejecutarlo con: mysql -u root -p -D db_bdn_240107 < node-estudesprivileges.sql
-- ============================================================

-- ============================================================
-- PASO 3: USUARIO ROOT REMOTO (para administrar desde otra PC)
-- El dump de db_test.sql tiene triggers con DEFINER=root@'%',
-- así que este usuario debe existir para que no falle la importación
-- ============================================================
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'AQUI_TU_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
