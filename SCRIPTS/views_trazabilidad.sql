-- ============================================================
-- VISTAS DE TRAZABILIDAD  |  db_test  |  Puerto 40107
-- ============================================================
-- DEFINER = root@localhost + SQL SECURITY DEFINER  =>  la vista
-- puede leer mysql.role_edges aunque la consulte un usuario normal
-- (seller, buyer, guest...) que no tiene acceso a mysql.*
--
-- INSERTAR PRODUCTOS COMO 'seller' O 'superadmin':
--   NO los insertes desde Workbench logueado como root, porque
--   el trigger guarda USER() y quedaria 'Sin rol'.
--   Conectate como tu usuario (rene.cabrera / samuel).
-- ============================================================
USE db_test;

-- ---------- 1. VISTA DE PRODUCTOS ----------
CREATE OR REPLACE ALGORITHM = UNDEFINED
DEFINER = `root`@`localhost`
SQL SECURITY DEFINER
VIEW `db_test`.`vw_trazabilidad_productos` AS
SELECT
    `p`.`ID`                      AS `id`,
    `p`.`name`                    AS `name`,
    `p`.`description`             AS `description`,
    `b`.`db_user`                 AS `inserted_by`,
    COALESCE(GROUP_CONCAT(DISTINCT `re`.`FROM_USER`
                ORDER BY `re`.`FROM_USER` ASC SEPARATOR ', '),
             'Sin rol')           AS `roles`,
    `b`.`operation_description`   AS `operation_description`,
    `b`.`operation_date`          AS `operation_date`
FROM `db_test`.`tb_products` `p`
JOIN `db_test`.`tb_logs` `b`
  ON `b`.`operation_description` LIKE CONCAT('%ID=', `p`.`ID`, ',%')
LEFT JOIN `mysql`.`role_edges` `re`
  ON `re`.`TO_USER` = SUBSTRING_INDEX(`b`.`db_user`, '@', 1)
WHERE `b`.`table_operation` = 'Create'
  AND `b`.`table_name` = 'tb_products'
GROUP BY `p`.`ID`, `p`.`name`, `p`.`description`, `b`.`db_user`,
         `b`.`operation_description`, `b`.`operation_date`
ORDER BY `b`.`operation_date` ASC;

-- ---------- 2. VISTA DE USUARIOS ----------
CREATE OR REPLACE ALGORITHM = UNDEFINED
DEFINER = `root`@`localhost`
SQL SECURITY DEFINER
VIEW `db_test`.`vw_trazabilidad_usuarios` AS
SELECT
    `u`.`nick`                    AS `nick`,
    `u`.`email`                   AS `email`,
    `b`.`db_user`                 AS `inserted_by`,
    COALESCE(GROUP_CONCAT(DISTINCT `re`.`FROM_USER`
                ORDER BY `re`.`FROM_USER` ASC SEPARATOR ', '),
             'Sin rol')           AS `roles`,
    `b`.`operation_description`   AS `operation_description`,
    `b`.`operation_date`          AS `operation_date`
FROM `db_test`.`tb_users` `u`
JOIN `db_test`.`tb_logs` `b`
  ON `b`.`operation_description` LIKE CONCAT('%', `u`.`email`, '%')
 AND `b`.`operation_description` LIKE CONCAT('%', `u`.`nick`, '%')
LEFT JOIN `mysql`.`role_edges` `re`
  ON `re`.`TO_USER` = SUBSTRING_INDEX(`b`.`db_user`, '@', 1)
WHERE `b`.`table_operation` = 'Create'
  AND `b`.`table_name` = 'tb_users'
GROUP BY `u`.`nick`, `u`.`email`, `b`.`db_user`,
         `b`.`operation_description`, `b`.`operation_date`
ORDER BY `b`.`operation_date` ASC;

-- ---------- 3. VERIFICACION ----------
SHOW FULL TABLES IN db_test WHERE Table_type = 'VIEW';
