# Práctica 02 — Conexiones Remotas para Bases de Datos SQL

**Alumno:** Rene David Cabrera
**Matrícula:** 240107
**Estado:** Completada

---

## Contenido de esta carpeta

| Carpeta / Archivo | Descripción |
|---|---|
| `Backups/db_test.sql` | Respaldo original de la base |
| `SCRIPTS/` | Scripts SQL, PowerShell y de terminal |
| `seeds/` | Semillas y archivos CSV de carga masiva |
| `queries/` | Consultas de verificación |

### Scripts principales (en `SCRIPTS/`)

| Archivo | Para qué sirve |
|---|---|
| `01_trazabilidades_optimizadas.sql` | Crea los índices, `entity_id` y las 4 vistas de trazabilidad |
| `02_consultas_13_14_15.sql` | Consultas 13, 14 y 15 adaptadas a esta base |
| `03_corregir_entity_id.sql` | Recrea los 6 triggers para que llenen `entity_id` |
| `04_tabla_categorias.sql` | Crea `tb_categorias` con clave foránea |
| `EVIDENCIA_Practica02.sql` | Evidencia de los pasos 2 y 3 (se abre en Workbench) |
| `verificacion_11_puntos.sql` | Los 11 puntos de verificación del profesor |
| `trazabilidad_productos.sql` | Trazabilidad de productos (corregida) |
| `evidencia.cmd` | Evidencia del paso 1 (se ejecuta en CMD normal) |
| `evidencia_terminal.sh` | Evidencia del paso 1 (se ejecuta en Git Bash) |
| `COMANDOS_SELLERS.txt` | Comandos para los vendedores remotos |
| `COMO_DEMOSTRAR.md` | Guía activity por activity |

---

## Resultados obtenidos

| Actividad | Resultado |
|---|---|
| Puerto configurado | `40107` escuchando en `0.0.0.0` |
| Firewall | Regla "MySQL Remoto 40107" (solo ese puerto) |
| Servicio | `MySQL40107` — Running / Automatic |
| Carga masiva | 5000 productos por vendedor desde su PC |
| Triggers | 9 (3 por tabla: productos, usuarios, categorías) |
| Bitácora | Más de 5000 registros |
| Vistas | 4 de trazabilidad |

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

## Verificación rápida de permisos

```sql
-- El usuario 'buyer' NO debe poder insertar (ERROR 1142 es lo esperado)
SELECT COUNT(*) FROM tb_products;
```

Esa restricción es la evidencia del paso 2.7 de la práctica.