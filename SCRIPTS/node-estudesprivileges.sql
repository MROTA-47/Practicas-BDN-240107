
-- =========================================
-- CREACION DE USUARIOS
-- =========================================

CREATE USER IF NOT EXISTS 'Aaron'@'%' IDENTIFIED BY '240045';
CREATE USER IF NOT EXISTS 'Samuel'@'%' IDENTIFIED BY '240023';


-- =========================================
-- ASIGNACION DE PRIVILEGIOS
-- =========================================

-- Privilegios de superusuario para Samuel
GRANT ALL PRIVILEGES ON . TO 'Samuel'@'%';

-- Privilegios de SELECT, INSERT, UPDATE y DELETE para Aaron
GRANT SELECT, INSERT, UPDATE, DELETE
ON bd_test.* TO 'Aaron'@'%';


-- =========================================
-- CREACION DE ROLES
-- =========================================

CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'guest';
CREATE ROLE IF NOT EXISTS 'support';
CREATE ROLE IF NOT EXISTS 'common';
CREATE ROLE IF NOT EXISTS 'user_not_registered';


-- =========================================
-- PRIVILEGIOS DE LOS ROLES
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
GRANT SELECT, UPDATE, INSERT
ON bd_test.* TO 'support';

-- COMMON
GRANT SELECT
ON bd_test.* TO 'common';

-- USUARIO NO REGISTRADO
GRANT SELECT
ON bd_test.* TO 'user_not_registered';


-- =========================================
-- ASIGNACION DE ROLES A USUARIOS
-- =========================================

GRANT 'admin' TO 'Samuel'@'%';
GRANT 'seller' TO 'Aaron'@'%';

FLUSH PRIVILEGES;
