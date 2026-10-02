-- ============================================================
-- PRACTICA 02 - TABLA DE CATEGORIAS JERARQUICAS (tbc_categories)
-- Alumno: Rene David Cabrera | Matricula: 240107
-- Base: db_test | Puerto: 40107
-- Conectar como: rene.cabrera / 240107
-- ============================================================
-- ESTRUCTURA BASADA EN LA REFERENCIA DEL PROFESOR:
--
--   ID               int unsigned  AUTO_INCREMENT, PRIMARY KEY
--   name             varchar(120)  NOT NULL, UNIQUE
--   description      text
--   sup_id_category  int unsigned  -> clave foranea autoinvasiva:
--                                   una categoria puede tener subcategorias
--   status           bit(1)        NOT NULL DEFAULT b'1'
--   creation_date    datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP
--   last_update      datetime      NOT NULL ON UPDATE CURRENT_TIMESTAMP
--
-- NOTA SOBRE LA REFERENCIA:
-- El 'describe' que aparece en la imagen del profe esta desfasado
-- (dice que 'name' es int y que 'ID' es varchar). Eso se tomo antes
-- de crear la tabla. El CREATE TABLE es el que define bien:
--   ID = int unsigned AUTO_INCREMENT
--   name = varchar(120)
-- Aqui se usa la version correcta.
--
-- NOTA: no se modifica tb_categorias ni tb_products. Esta tabla
-- se crea como tabla jerarquica independiente, con su propia clave
-- foranea autoinvasiva (sup_id_category apunta a la misma tabla).
-- ============================================================

USE db_test;

-- ---------------------------------------------------------------
-- 1. Crear la tabla
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbc_categories (
  `ID`               int unsigned NOT NULL AUTO_INCREMENT,
  `name`             varchar(120) NOT NULL,
  `description`      text,
  `sup_id_category`  int unsigned DEFAULT NULL,
  `status`           bit(1)       NOT NULL DEFAULT b'1',
  `creation_date`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                   ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_superior_category` (`sup_id_category`),
  CONSTRAINT `fk_superior_category`
    FOREIGN KEY (`sup_id_category`) REFERENCES `tbc_categories` (`ID`)
      ON UPDATE CASCADE
      ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------
-- 2. Categorias raiz (sup_id_category = NULL)
-- ---------------------------------------------------------------
INSERT INTO tbc_categories (`name`, `description`, `sup_id_category`, `status`) VALUES
  ('Electronica',        'Aparatos y dispositivos electronicos', NULL, b'1'),
  ('Hogar y Cocina',     'Muebles, cocina y limpieza del hogar', NULL, b'1'),
  ('Oficina',            'Articulos de oficina y papeleria',    NULL, b'1'),
  ('Deportes',           'Equipamiento deportivo',              NULL, b'1'),
  ('Ropa',               'Prendas de vestir',                   NULL, b'1')
ON DUPLICATE KEY UPDATE `description` = VALUES(`description`);

-- ---------------------------------------------------------------
-- 3. Subcategorias (sup_id_category apunta a su categoria raiz)
--    Se usa subconsulta para no hardcodear los IDs.
-- ---------------------------------------------------------------
INSERT INTO tbc_categories (`name`, `description`, `sup_id_category`, `status`)
SELECT 'Audifonos',     'Audifonos con cable, inalambricos y gaming',
       (SELECT `ID` FROM tbc_categories WHERE `name` = 'Electronica'), b'1'
WHERE NOT EXISTS (SELECT 1 FROM tbc_categories WHERE `name` = 'Audifonos');

INSERT INTO tbc_categories (`name`, `description`, `sup_id_category`, `status`)
SELECT 'Computadoras',  'Laptops, Reward de escritorio y componentes',
       (SELECT `ID` FROM tbc_categories WHERE `name` = 'Electronica'), b'1'
WHERE NOT EXISTS (SELECT 1 FROM tbc_categories WHERE `name` = 'Computadoras');

INSERT INTO tbc_categories (`name`, `description`, `sup_id_category`, `status`)
SELECT 'Celulares',     'Telefonos inteligentes y tablets',
       (SELECT `ID` FROM tbc_categories WHERE `name` = 'Electronica'), b'1'
WHERE NOT EXISTS (SELECT 1 FROM tbc_categories WHERE `name` = 'Celulares');

INSERT INTO tbc_categories (`name`, `description`, `sup_id_category`, `status`)
SELECT 'Cables y Carga', 'Cables HDMI, USB-C, cargadores y adaptadores',
       (SELECT `ID` FROM tbc_categories WHERE `name` = 'Electronica'), b'1'
WHERE NOT EXISTS (SELECT 1 FROM tbc_categories WHERE `name` = 'Cables y Carga');

INSERT INTO tbc_categories (`name`, `description`, `sup_id_category`, `status`)
SELECT 'Cocina',        'Electrodomesticos para preparar alimentos',
       (SELECT `ID` FROM tbc_categories WHERE `name` = 'Hogar y Cocina'), b'1'
WHERE NOT EXISTS (SELECT 1 FROM tbc_categories WHERE `name` = 'Cocina');

INSERT INTO tbc_categories (`name`, `description`, `sup_id_category`, `status`)
SELECT 'Limpieza',      'Productos de limpieza del hogar',
       (SELECT `ID` FROM tbc_categories WHERE `name` = 'Hogar y Cocina'), b'1'
WHERE NOT EXISTS (SELECT 1 FROM tbc_categories WHERE `name` = 'Limpieza');

INSERT INTO tbc_categories (`name`, `description`, `sup_id_category`, `status`)
SELECT 'Papeleria',     'Papeleria basica y utiles escolares',
       (SELECT `ID` FROM tbc_categories WHERE `name` = 'Oficina'), b'1'
WHERE NOT EXISTS (SELECT 1 FROM tbc_categories WHERE `name` = 'Papeleria');

INSERT INTO tbc_categories (`name`, `description`, `sup_id_category`, `status`)
SELECT 'Utiles de Escritorio', 'Boligrafos, cuadernos, tijeras y pegamento',
       (SELECT `ID` FROM tbc_categories WHERE `name` = 'Oficina'), b'1'
WHERE NOT EXISTS (SELECT 1 FROM tbc_categories WHERE `name` = 'Utiles de Escritorio');

INSERT INTO tbc_categories (`name`, `description`, `sup_id_category`, `status`)
SELECT 'Deportes de Campo', 'Futbol, atencion y deportes al aire libre',
       (SELECT `ID` FROM tbc_categories WHERE `name` = 'Deportes'), b'1'
WHERE NOT EXISTS (SELECT 1 FROM tbc_categories WHERE `name` = 'Deportes de Campo');

INSERT INTO tbc_categories (`name`, `description`, `sup_id_category`, `status`)
SELECT 'Ropa Interior',  'Prendas interiores y ropa de dormir',
       (SELECT `ID` FROM tbc_categories WHERE `name` = 'Ropa'), b'1'
WHERE NOT EXISTS (SELECT 1 FROM tbc_categories WHERE `name` = 'Ropa Interior');

INSERT INTO tbc_categories (`name`, `description`, `sup_id_category`, `status`)
SELECT 'Zapatos',        'Calzado casual y deportivo',
       (SELECT `ID` FROM tbc_categories WHERE `name` = 'Ropa'), b'1'
WHERE NOT EXISTS (SELECT 1 FROM tbc_categories WHERE `name` = 'Zapatos');

-- ---------------------------------------------------------------
-- 4. Verificacion: jerarquia completa
-- ---------------------------------------------------------------
SELECT
    c.ID,
    c.name AS categoria,
    p.name AS pertenece_a,
    c.status,
    c.creation_date
FROM tbc_categories c
LEFT JOIN tbc_categories p ON p.ID = c.sup_id_category
ORDER BY c.sup_id_category IS NULL DESC, c.sup_id_category, c.ID;

-- ---------------------------------------------------------------
-- 5. Conteo final
-- ---------------------------------------------------------------
SELECT
    COUNT(*) AS total_categorias,
    SUM(sup_id_category IS NULL) AS categorias_raiz,
    SUM(sup_id_category IS NOT NULL) AS subcategorias
FROM tbc_categories;