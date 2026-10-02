-- ============================================================
-- VERIFICACIÓN FINAL DE LA PRÁCTICA (ejecutar después de todo)
-- ============================================================

-- 1. Puerto y bind del servidor
SHOW VARIABLES LIKE 'port';
SHOW VARIABLES LIKE 'bind_address';

-- 2. Bases de datos creadas
SHOW DATABASES;

-- 3. Tablas y triggers de db_test
USE db_test;
SHOW TABLES;
SHOW TRIGGERS FROM db_test;
SELECT COUNT(*) AS usuarios FROM tb_users;
SELECT COUNT(*) AS logs FROM tb_logs;
SELECT * FROM tb_logs;

-- 4. Usuarios remotos creados (host='%')
SELECT User, Host, account_locked FROM mysql.user WHERE Host = '%' ORDER BY User;

-- 5. Roles creados
SELECT DISTINCT FROM_USER AS rol FROM mysql.role_edges ORDER BY FROM_USER;

-- 6. Asignación de roles a usuarios
SELECT TO_USER AS usuario, FROM_USER AS rol
FROM mysql.role_edges
ORDER BY TO_USER, FROM_USER;

-- 7. Privilegios de tu usuario
SHOW GRANTS FOR 'rene.cabrera'@'%';

-- 8. Que root remoto exista
SHOW GRANTS FOR 'root'@'%';
