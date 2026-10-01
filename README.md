# Prácticas de Bases de Datos en la Nube

**Alumno:** Rene David Cabrera
**Matrícula:** 240107
**Materia:** Prácticas de la Asignatura de Base de Datos en la Nube

---

## Ramas del repositorio

| Rama | Contenido |
|---|---|
| `main` | Estructura general del repositorio |
| `Practica03` | Práctica 03 (en preparación) |

## Carpetas

| Carpeta | Contenido | Estado |
|---|---|---|
| `Practica02/` | Scripts SQL, consultas, respaldos y semillas de la Práctica 02 | Completada |
| `Practica03/` | Scripts de la Práctica 03 | Pendiente |

---

## Datos de la conexión (Práctica 02)

| Dato | Valor |
|---|---|
| Servidor | `10.10.154.221` |
| Puerto | `40107` |
| Base principal | `db_test` |
| Base de usuarios y roles | `db_bdn_240107` |
| Motor | MySQL Community Server 8.0.46 |
| Servicio Windows | `MySQL40107` (inicio automático) |

### Usuarios

| Usuario | Contraseña | Rol |
|---|---|---|
| `rene.cabrera` | `240107` | superadmin |
| `diego.ex` | `240709` | seller |
| `oliver.sanchez` | `240615` | seller |
| `brandon.torres` | `240220` | seller |
| `aaron` | `240045` | support |
| `ivan.medina` | `240663` | admin |
| `hector.ramos` | `240441` | support |
| `karina.lopez` | `240333` | buyer |
| `paola.serrano` | `240552` | guest |

### Roles disponibles

`superadmin` · `admin` · `seller` · `buyer` · `support` · `common` · `guest` · `user_not_registered`

### Conectarse

```bash
# Desde esta PC
mysql -u rene.cabrera -p240107 -h 127.0.0.1 -P 40107 db_test

# Desde otra PC de la red
mysql -u rene.cabrera -p240107 -h 10.10.154.221 -P 40107 db_test
```

---

## Consultar rápido

```sql
-- Quién cargó cada producto y con qué rol
SELECT inserted_by, roles, COUNT(*) AS total
FROM vw_trazabilidad_productos
GROUP BY inserted_by, roles
ORDER BY total DESC;

-- Estado general de la base
SELECT
  (SELECT COUNT(*) FROM tb_products) AS productos,
  (SELECT COUNT(*) FROM tb_logs)     AS bitacora,
  (SELECT COUNT(*) FROM tb_categorias) AS categorias,
  (SELECT COUNT(*) FROM information_schema.TRIGGERS
    WHERE TRIGGER_SCHEMA='db_test')  AS triggers;
```