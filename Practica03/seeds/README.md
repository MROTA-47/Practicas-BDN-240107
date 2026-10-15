# Seeds — Práctica 03 (240107)

No se duplican CSV grandes en esta carpeta (para no generar basura).

- Reutiliza los seeds que ya existen en el repo:
  - `seeds/tb_categories_100.csv`
  - `seeds/Marquitos_Productos_5000.csv`
- Referencia del profesor (no se copian, solo se documentan):
  - `categorias_ecommerce_100.csv`
  - `categorizacion_productos.csv`
  - `tb_products_10000_nuevos.csv`
  - `tbd_products_categories_10000_por_sku.csv`
  - URL: `https://github.com/MTI-MarcoRH/Praticas_BDN_MATRICULA/tree/Practica03` (carpeta `Practica03/seeds`)

La carga N:M de esta práctica se genera sola con
`scripts/01_tbd_products_categories.sql` (reparto round-robin),
así no se necesita importar el CSV de 10 000 filas para aprobar.
