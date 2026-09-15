-- =========================================
-- CREACION DE USUARIOS
-- =========================================

CREATE USER IF NOT EXISTS 'Aaron'@'%' IDENTIFIED BY '240045';
CREATE USER IF NOT EXISTS 'Samuel'@'%' IDENTIFIED BY '240023';


-- =========================================
-- ASIGNACION DE PRIVILEGIOS A USUARIOS
-- =========================================

GRANT ALL PRIVILEGES ON bd_test.* TO 'Samuel'@'%';

GRANT SELECT, UPDATE, INSERT, DELETE
ON bd_test.* TO 'Aaron'@'%';


-- =========================================
-- CREACION DE ROLES
-- =========================================

CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'guest';
CREATE ROLE IF NOT EXISTS 'support';
CREATE ROLE IF NOT EXISTS 'user_not_registres';


-- =========================================
-- ASIGNACION DE PRIVILEGIOS A LOS ROLES
-- =========================================

-- ADMIN
GRANT ALL PRIVILEGES ON bd_test.* TO 'admin';

-- SELLER
GRANT SELECT, INSERT, UPDATE
ON bd_test.* TO 'seller';

-- BUYER
GRANT SELECT
ON bd_test.* TO 'buyer';

-- GUEST
GRANT SELECT
ON bd_test.* TO 'guest';

-- SUPPORT
GRANT SELECT, UPDATE
ON bd_test.* TO 'support';

-- USUARIO NO REGISTRADO
GRANT SELECT
ON bd_test.* TO 'user_not_registres';


-- =========================================
-- ASIGNACION DE ROLES A USUARIOS
-- =========================================

GRANT 'admin' TO 'Samuel'@'%';
GRANT 'seller' TO 'Aaron'@'%';

FLUSH PRIVILEGES;
- Creación de usuarios remotos

CREATE USER IF NOT EXISTS 'Aaron'@'%' IDENTIFIED BY '240045';

CREATE USER IF NOT EXISTS 'Samuel'@'%' IDENTIFIED BY '240023';


-- Asignación de privilegios

GRANT ALL PRIVILEGES ON bd_test.* TO 'Aaron'@'%';

GRANT ALL PRIVILEGES ON bd_test.* TO 'Samuel'@'%';

FLUSH PRIVILEGES;

