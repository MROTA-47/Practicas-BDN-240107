-- ============================================================
-- CONSULTA DEL PROFESOR (verbatim) - BDN 240107
-- Corres despues de actualizacion_profesor.sql
-- ============================================================
USE db_test;

SELECT u.nick, u.email, b.db_user AS inserted_by,
       GROUP_CONCAT(DISTINCT re.FROM_USER ORDER BY re.FROM_USER SEPARATOR ', ') AS roles,
       b.operation_description,
       b.operation_date
FROM tb_users u
JOIN tb_logs b
    ON b.operation_description LIKE CONCAT('%', u.nick, '%')
    AND b.operation_description LIKE CONCAT('%', u.email, '%')
LEFT JOIN mysql.role_edges re
    ON re.TO_USER = SUBSTRING_INDEX(b.db_user, '@', 1)
WHERE b.table_operation = 'Create'
    AND b.table_name = 'tb_users'
GROUP BY u.nick, u.email, b.db_user, b.operation_description, b.operation_date
ORDER BY b.operation_date ASC;
