# Práctica 03 — Manipulación, Relaciones, Procedimientos, Funciones y Eventos

**Alumno:** Rene David Cabrera · **Matrícula:** 240107
**Rama:** `Practica03` · **Base:** `db_test` · **Local:** puerto `40107` · **VPS:** puerto `40710`
**Estado:** Lista para simulación (faltan solo las 5 imágenes de `docs/img/`)

Referencia del profesor: https://github.com/MTI-MarcoRH/Praticas_BDN_MATRICULA/tree/Practica03
(se adaptaron `remote_users_privileges_creation_7A.sql` y `queries/consultas_verificacion.sql`
a `db_test` + matrícula 240107; NO se copiaron los `backups/*.sql` de 5–14 MB ni el `EER_respaldo_1410/`
de Archify para no meter basura al repo — ver `Practica03/.gitignore`).

---

## 1. Rama (la que se ve en PuTTY / `git branch -a`)

Ya estás en la rama correcta, no crees otra:

```bash
cd "C:\Users\ti_la\Desktop\waza\Practicas-BDN-240107"
git checkout Practica03
git branch -a
# * Practica03
#   remotes/origin/Practica03
```

## 2. Estructura limpia (sin respaldos)

```text
Practica03/
  scripts/01_tbd_products_categories.sql      # puente N:M + 3 triggers + carga
  scripts/02_procedimientos.sql               # sp_soft_delete_user, sp_insert_product, sp_update_stock, sp_assign_product_category
  scripts/03_funciones.sql                    # fn_categoria_total, fn_valor_inventario
  scripts/04_eventos.sql                      # ev_desactiva_sin_stock, ev_limpieza_logs
  scripts/05_vistas.sql                       # vw_total_products_by_category
  scripts/06_remote_users_privileges_240107.sql
  queries/consultas_verificacion.sql          # los 4 puntos del profesor + extras
  seeds/README.md                             # no duplica CSV grandes
  docs/img/README.md                          # guía de las 5 imágenes que faltan
  docker/docker-compose.yml + .env.example    # simulación local/VPS
  .gitignore                                  # bloquea *.sql de respaldo y EER/Archify
```

## 3. Ejecución local (puerto 40107, root/1234)

```bash
cd "C:\Users\ti_la\Desktop\waza\Practicas-BDN-240107\Practica03"
$env:MYSQL_PWD='1234'
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root --port=40107 db_test < scripts\01_tbd_products_categories.sql
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root --port=40107 db_test < scripts\02_procedimientos.sql
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root --port=40107 db_test < scripts\03_funciones.sql
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root --port=40107 db_test < scripts\04_eventos.sql
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root --port=40107 db_test < scripts\05_vistas.sql
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root --port=40107 < scripts\06_remote_users_privileges_240107.sql
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root --port=40107 db_test < queries\consultas_verificacion.sql
```

Resultado esperado: 12 triggers (9 P02 + 3 nuevos), 4 procedimientos, 2 funciones,
2 eventos, vista con conteo por categoría.

## 4. Simulación en VPS por PuTTY (srv2014995, `mysql_db` en 40710)

```bash
git clone https://github.com/MROTA-47/Practicas-BDN-240107.git
cd Practicas-BDN-240107
git checkout Practica03
git pull origin Practica03
docker ps   # debe verse mysql_db Up ... 0.0.0.0:40710->40710/tcp (healthy)
docker exec -i mysql_db mysql -u root -p1234 db_test < Practica03/scripts/01_tbd_products_categories.sql
docker exec -i mysql_db mysql -u root -p1234 db_test < Practica03/scripts/02_procedimientos.sql
docker exec -i mysql_db mysql -u root -p1234 db_test < Practica03/scripts/03_funciones.sql
docker exec -i mysql_db mysql -u root -p1234 db_test < Practica03/scripts/04_eventos.sql
docker exec -i mysql_db mysql -u root -p1234 db_test < Practica03/scripts/05_vistas.sql
docker exec -i mysql_db mysql -u root -p1234 < Practica03/scripts/06_remote_users_privileges_240107.sql
docker exec -i mysql_db mysql -u root -p1234 db_test < Practica03/queries/consultas_verificacion.sql
# Respaldo FUERA del repo (no se commitea):
docker exec mysql_db mysqldump -u root -p1234 db_test > /tmp/respaldo_p03_240107.sql
ls -lh /tmp/respaldo_p03_240107.sql
```

## 5. Imágenes que faltan

Ver `docs/img/README.md`. Son 5 PNG: EER de Workbench + 4 capturas
(PuTTY `docker ps`, verificación, 12 triggers, vista). Cuando las tengas,
guárdalas en `docs/img/` y haz `git add` + commit + push de la rama.

## 6. Subir sin basura

```bash
git status --short          # no debe listar ningun .sql grande
git add Practica03
git commit -m "Practica03: relacion N:M, procedimientos, funciones, eventos y vista (240107)"
git push origin Practica03
```
