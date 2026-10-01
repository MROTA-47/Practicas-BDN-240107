# Practica 02 - Conexiones Remotas para Bases de Datos SQL

**Alumno:** Rene David Cabrera
**Matrícula:** 240107

---

## Estructura de carpetas

| Carpeta | Contenido |
|---|---|
| `Backups/` | Respaldo de la base de datos |
| `SCRIPTS/` | Scripts SQL, PowerShell y de terminal |
| `seeds/` | Semillas y archivos CSV de carga masiva |
| `queries/` | Consultas de verificación |

---

## Scripts principales

| Archivo | Para qué sirve |
|---|---|
| `01_trazabilidades_optimizadas.sql` | Índices, `entity_id` y las 4 vistas de trazabilidad |
| `02_consultas_13_14_15.sql` | Consultas 13, 14 y 15 adaptadas a esta base |
| `03_corregir_entity_id.sql` | Recrea los 6 triggers para que llenen `entity_id` |
| `04_tabla_categorias.sql` | Crea `tb_categorias` con clave foránea |
| `EVIDENCIA_Practica02.sql` | Evidencia de los pasos 2 y 3 (se abre en Workbench) |
| `verificacion_11_puntos.sql` | Los 11 puntos de verificación del profesor |
| `trazabilidad_productos.sql` | Trazabilidad de productos (con la corrección del ID) |
| `evidencia.cmd` | Evidencia del paso 1 (se ejecuta en CMD normal) |
| `evidencia_terminal.sh` | Evidencia del paso 1 (se ejecuta en Git Bash) |
| `COMANDOS_SELLERS.txt` | Comandos para los vendedores remotos |
| `COMO_DEMOSTRAR.md` | Guía activity por activity |

---

## Datos de conexión

```bash
# Desde esta PC
mysql -u rene.cabrera -p240107 -h 127.0.0.1 -P 40107 db_test

# Desde otra PC de la red
mysql -u rene.cabrera -p240107 -h 10.10.154.221 -P 40107 db_test
```

| Dato | Valor |
|---|---|
| Servidor | `10.10.154.221` |
| Puerto | `40107` |
| Base principal | `db_test` |
| Motor | MySQL Community Server 8.0.46 |

---

## Resultados verificados

| Actividad | Resultado |
|---|---|
| Triggers | 9 (3 por tabla: productos, usuarios, categorías) |
| Bitácora | Más de 10000 registros |
| Carga masiva | 5000 productos por vendedor desde su PC |
| Vistas de trazabilidad | 4 |
| Tabla de categorías | `tb_categorias` con clave foránea |

---

## Cómo demostrar la práctica

```cmd
cd %USERPROFILE%\OneDrive\Desktop\Practicas-BDN-240107\Practica02\SCRIPTS
evidencia.cmd
```

No requiere permisos de administrador: solo consulta el estado.

En **MySQL Workbench** usa la conexión `db_test 240107 (local)` con usuario
`rene.cabrera` y contraseña `240107`, y abre `EVIDENCIA_Practica02.sql`.

---

## Evidencia de permisos (punto 2.7)

Un usuario con rol `buyer` debe recibir `ERROR 1142` al intentar INSERT.
Ese error **es la evidencia** de que el permiso quedó bien puesto.