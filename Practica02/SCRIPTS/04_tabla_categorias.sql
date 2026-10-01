-- ============================================================
-- PRACTICA 02 - TABLA DE CATEGORIAS
-- Alumno: Rene David Cabrera | Matricula: 240107
-- Base: db_test | Puerto: 40107
-- Conectar como: rene.cabrera / 240107
-- ============================================================
-- QUE HACE ESTE SCRIPT
-- Crea la tabla  tb_categorias  con clave primaria y nombre unico,
-- la llena con las categorias que YA existen en tb_products,
-- y agrega la clave foranea para que no se pueda escribir una
-- categoria que no exista en la tabla.
--
-- DISEÑO
--   id          INT          clave primaria, autoincrement
--   nombre      VARCHAR(50)  unico, no puede repetirse
--   descripcion VARCHAR(255) opcional
--   activo      BIT(1)       permite desactivar sin borrar
--   creation_date / last_update  auditoria
--
--   tb_products.category  ->  tb_categorias.nombre
--   (se mantiene el nombre de texto en vez de cambiar a id numerico
--    para no romper las consultas y vistas que ya tienes)
-- ============================================================

USE db_test;

-- ---------------------------------------------------------------
-- 1. Crear la tabla de categorias
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tb_categorias (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(50)  NOT NULL,
  descripcion   VARCHAR(255) DEFAULT NULL,
  activo        BIT(1)       DEFAULT b'1',
  creation_date DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_update   DATETIME     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_categorias_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------
-- 2. Llenarla con las categorias que YA existen en los productos
--    (para que la clave foranea no falle)
-- ---------------------------------------------------------------
INSERT IGNORE INTO tb_categorias (nombre, descripcion) VALUES
  ('Ropa y Moda',         'Prendas de vestir, calzado y accesorios'),
  ('Hogar y Cocina',      'Aparatos del hogar, cocina y limpieza'),
  ('Deportes y Exterior', 'Articulos deportivos y actividades al aire libre'),
  ('Oficina y Papeleria', 'Papeleria, utiles y equipamiento de oficina'),
  ('Electronica',        'Computadoras, audio, video y dispositivos'),
  ('Papeleria',          'Papeleria basica de la Practica 01'),
  ('Utiles escolares',   'Utiles escolares de la Practica 01'),
  ('Bebidas',            'Bebidas de la Practica 01'),
  ('Snacks',             'Snacks y golosinas de la Practica 01'),
  ('Limpieza',           'Productos de limpieza de la Practica 01'),
  ('Otros',              'Productos que no encajan en otra categoria');

-- ---------------------------------------------------------------
-- 3. Clave foranea: no se puede usar una categoria inexistente
--    (solo la agregar si no existe todavia; si ya esta, da error,
--     por eso se comenta si la corriste dos veces)
-- ---------------------------------------------------------------
ALTER TABLE tb_products
  ADD CONSTRAINT fk_productos_categoria
  FOREIGN KEY (category) REFERENCES tb_categorias(nombre)
  ON UPDATE CASCADE
  ON DELETE RESTRICT;

-- ---------------------------------------------------------------
-- 4. Trigger para que tb_categorias tambien quede en la bitacora
--    (para que el profesor vea que la tabla nueva tambien se audita)
-- ---------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_categorias_after_insert;
DROP TRIGGER IF EXISTS trg_categorias_after_update;
DROP TRIGGER IF EXISTS trg_categorias_after_delete;

DELIMITER ;;
CREATE TRIGGER trg_categorias_after_insert AFTER INSERT ON tb_categorias FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, entity_id, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_categorias', NEW.id, 'Create', USER(),
        CONCAT('Categoria creada. ID=', NEW.id, ', nombre=', NEW.nombre,
               ', descripcion=', NEW.descripcion, ', activo=', NEW.activo),
        CURRENT_TIMESTAMP, b'1');
END;;
CREATE TRIGGER trg_categorias_after_update AFTER UPDATE ON tb_categorias FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, entity_id, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_categorias', NEW.id, 'Update', USER(),
        CONCAT('Categoria modificada. ID=', OLD.id, ', nombre: ', OLD.nombre, ' -> ', NEW.nombre),
        CURRENT_TIMESTAMP, b'1');
END;;
CREATE TRIGGER trg_categorias_after_delete AFTER DELETE ON tb_categorias FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, entity_id, table_operation, db_user, operation_description, operation_date, operation_status)
    VALUES ('tb_categorias', OLD.id, 'Delete', USER(),
        CONCAT('Categoria eliminada. ID=', OLD.id, ', nombre=', OLD.nombre),
        CURRENT_TIMESTAMP, b'1');
END;;
DELIMITER ;

-- ---------------------------------------------------------------
-- 5. VERIFICACION
-- ---------------------------------------------------------------
SELECT 'CATEGORIAS CREADAS' AS resultado;

SELECT c.id, c.nombre, c.activo,
       COUNT(p.ID) AS productos_asociados
FROM tb_categorias c
LEFT JOIN tb_products p ON p.category = c.nombre
GROUP BY c.id, c.nombre, c.activo
ORDER BY c.id;

SELECT COUNT(*) AS total_categorias FROM tb_categorias;