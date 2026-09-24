USE db_test;

/* 1. Cuántas tablas existen en la base de datos */
SHOW TABLES;

/* 2. Cuántos triggers existen en la base de datos */ 
SHOW TRIGGERS FROM db_test;

/* 3. Cuántos registros existen en la tabla usuarios */
SELECT COUNT(*) AS total_registros FROM tb_users;

/* 4. Cuántos registros existen en la tabla bitácora */
SELECT COUNT(*) AS total_registros FROM tb_logs;

/* 5. Consultar todas las operaciones registradas */
SELECT id, table_name, table_operation, db_user, operation_date FROM tb_logs;

/* 6. Verificar que los usuarios remotos hayan sido creados */
SELECT User, Host FROM mysql.user WHERE Host = '%' AND account_locked = 'N';

/* 7. Verificar roles creados */
SELECT User, Host FROM mysql.user WHERE Host = '%' AND account_locked = 'Y';

/* 8. Verificar asignación de roles a usuarios */
SELECT 
    TO_USER AS usuario, 
    TO_HOST AS host, 
    FROM_USER AS rol, 
    FROM_HOST AS rol_host 
FROM mysql.role_edges 
ORDER BY TO_USER, FROM_USER;

/* 9. Verificar privilegios de tu usuario */
SHOW GRANTS FOR 'rene.cabrera'@'%';