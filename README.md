# Prácticas BDN — Matrícula 240107

Conexión remota a MySQL 8.0 configurada y verificada.

## Datos de conexión

| Dato | Valor |
|---|---|
| Puerto | **40107** |
| Base de datos principal | `db_test` |
| Base de datos de usuarios/roles | `db_bdn_240107` |
| IP de esta PC | **10.10.60.40** |

### Usuarios creados (contraseña = matrícula de cada quien)

| Usuario | Contraseña | Rol |
|---|---|---|
| `rene.cabrera` | `240107` | superadmin |
| `johnatan` | `240080` | admin |
| `samuel` | `240043` | seller |
| `aaron` | `240045` | buyer |
| `mario` | `23409` | guest |
| `alfonso` | `240904` | support |
| `root` (admin) | `240107` | todo (local y remoto `@%`) |

## Conectarse desde otra computadora

```bash
mysql -u rene.cabrera -h 10.10.60.40 -P 40107 -p
```

## Conectarse desde esta PC

```bash
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p240107 -h 127.0.0.1 -P 40107
```

## Tablas

| Tabla | Registros | Descripción |
|---|---|---|
| `tb_users` | 7 | Usuarios del sistema (Rene + 1 prueba + 5 creados por compañeros) |
| `tb_logs` | 66 | Bitácora: Create (59), Update (5), Delete (2) |
| `tb_products` | 50 | Inventario: Papelería, Electrónica, Útiles, Bebidas, Snacks, Limpieza, Otros |

**Columnas de `tb_logs`** (renombradas para la consulta del profesor): `id`, `table_name`, `table_operation`, `db_user`, `operation_description`, `operation_date`, `operation_status`

**Triggers (6):** `tb_users` y `tb_products` tienen AFTER INSERT/UPDATE/DELETE que escriben automáticamente en `tb_logs`.

## Archivos

- `Backups/db_test.sql` — respaldo original con `tb_users`, `tb_logs` y 3 triggers
- `SCRIPTS/practica_completa.ps1` — **script maestro**: corre todo de corrido (PowerShell)
- `SCRIPTS/practica_completa.sql` — **script SQL único** para Workbench
- `SCRIPTS/practica_productos.sql` — tabla productos + 3 triggers + 50 productos + updates/deletes
- `SCRIPTS/actualizacion_profesor.sql` — renombra columnas de `tb_logs` + regenera los 6 triggers (ejecutar una sola vez)
- `SCRIPTS/node-estudesprivileges.sql` — usuarios remotos y roles
- `SCRIPTS/queries/consulta_profesor.sql` — **consulta del profesor** (verbatim)
- `SCRIPTS/queries/consultas_verificaciones.sql` — 9 consultas de verificación
- `SCRIPTS/queries/consultas_productos.sql` — **17 consultas** de productos y bitácora
- `SCRIPTS/setup_conexion_remota.sql` — creación de bases de datos
- `SCRIPTS/configurar_remoto.ps1` — configuración general (ejecutar como Administrador)
- `SCRIPTS/verificar_conexion_remota.sql` — verificación final completa

## Estado verificado (24/09/2026)

- ✅ MySQL escuchando en `0.0.0.0:40107`
- ✅ Regla de firewall "MySQL Remoto 40107" creada
- ✅ Respaldo importado: 1 usuario, 1 log, 3 triggers
- ✅ 6 usuarios con host `%` y 8 roles creados y asignados
- ✅ Prueba remota por IP exitosa (`CONEXION_REMOTA_OK`)
