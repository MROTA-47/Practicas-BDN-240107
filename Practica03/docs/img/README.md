# Carpeta de imágenes — Práctica 03

Guarda aquí SOLO los PNG/JPG finales (máx. 5):

| Archivo sugerido | Cómo generarlo |
|---|---|
| `eer_db_test.png` | MySQL Workbench → Database → Reverse Engineer → selecciona `db_test` → exporta el diagrama EER a PNG |
| `docker_ps_vps.png` | En PuTTY (VPS `srv2014995`): `docker ps` (debe verse `mysql_db` en `40710` healthy) |
| `verificacion_vps.png` | En PuTTY: `mysql -h 127.0.0.1 -P 40710 -u root -p db_test < queries/consultas_verificacion.sql` |
| `triggers_12.png` | Workbench o CLI: `SHOW TRIGGERS FROM db_test;` (deben ser 12) |
| `vista_categorias.png` | `SELECT * FROM vw_total_products_by_category;` |

No subas `.html`/`.json`/`.py` de Archify ni `.sql` de respaldos:
eso es la "basura" que el `.gitignore` de esta carpeta bloquea.
Los respaldos van fuera del repo, ej: `C:\Temp\respaldo_p03_*.sql` o `/tmp/` en el VPS.
