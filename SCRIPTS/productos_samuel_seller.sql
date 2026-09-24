-- ============================================================
-- PRODUCTOS DEL SELLER (samuel)  |  db_test  |  Puerto 40107
-- ============================================================
-- SAMUEL: conectate a la base de Rene desde TU PC con:
--
--     mysql -u samuel -h 10.10.60.40 -P 40107 -p
--     (contraseña: 240043)
--
--     USE db_test;
--     SOURCE C:/ruta/a/productos_samuel_seller.sql;
--
-- IMPORTANTE: tiene que correr ESTANDO LOGUEADO COMO samuel.
-- Si lo corre alguien como root, el trigger guarda USER()=root
-- y en la vista aparecera 'Sin rol' en vez de 'seller'.
-- ============================================================
USE db_test;

INSERT INTO tb_products (sku, name, description, category, price, stock) VALUES
('PROD-053','Teclado inalambrico',   'Bluetooth, layout espanol, recargable',      'Electronica',420.00, 28),
('PROD-054','Webcam 1080p con microfono','Full HD, enfoque automatico, USB',        'Electronica',590.00, 18),
('PROD-055','Cable HDMI 2.0 de 2 m', 'Soporta 4K a 60 Hz',                         'Electronica',120.00, 55),
('PROD-056','Almohadilla para mouse XL','Antideslizante 30 x 25 cm',               'Otros',      180.00, 45),
('PROD-057','Audifonos con cable 3.5 mm','Diadema acolchada con microfono',         'Electronica',210.00, 33);

-- Verificacion (con la misma sesión de samuel):
-- SELECT * FROM db_test.vw_trazabilidad_productos;
