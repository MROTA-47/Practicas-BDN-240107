# CÓMO DEMOSTRAR LA PRÁCTICA 02

Todo lo que hiciste **se demuestra, no se cuenta**. Tienes dos archivos, y cada
actividad del profesor tiene su prueba en uno de los dos.

| Archivo | Dónde se abre | Qué demuestra |
|---|---|---|
| `SCRIPTS/EVIDENCIA_Practica02.sql` | **MySQL Workbench** | Paso 2 y Paso 3 (la base de datos) |
| `SCRIPTS/evidencia_terminal.sh` | **Git Bash** | Paso 1 (el servidor) + pruebas de conexión remota |

## Cómo se usa

**En Workbench** (para el SQL):
1. Abre la conexión `db_test 240107 (local)` — usuario `rene.cabrera`
2. Contraseña: `240107`
3. `File → Open` → `EVIDENCIA_Practica02.sql`
4. Dale al rayito ⚡ (Execute) y toma captura de los resultados

**En Git Bash** (para la terminal):
```bash
cd ~/OneDrive/Desktop/Practicas-BDN-240107/SCRIPTS
bash evidencia_terminal.sh
```

## Por qué está partido en dos

El profesor te pide dos cosas distintas y **cada una se demuestra en un lugar
distinto**:

- El **Paso 1** habla del *servidor* (puerto, firewall, servicio, git). Eso no
  vive dentro de MySQL, se ve en la terminal o en PowerShell.
- Los **Pasos 2 y 3** hablan de la *base de datos* (usuarios, roles, productos).
  Eso se demuestra dentro de Workbench.

## Actividad por actividad

### PASO 1 — en `evidencia_terminal.sh`

| # | Qué demuestra | Salida esperada |
|---|---|---|
| 1 | Puertos | `0.0.0.0  40107` |
| 2 | Firewall | regla "MySQL Remoto 40107", Enabled True, Allow |
| 3 | Servicio | `MySQL40107  Running  Automatic` |
| 4 | Credenciales Git | `Rene David Cabrera` / `240107@utxicotepec.edu.mx` |
| 5 | Credenciales GitHub | `gh version 2.101.0` |
| 6 | Repo clonado | rama `Practica02` |
| 7 | Servidor funciona | `OK local -> rene.cabrera@% \| puerto 40107` |

### PASO 2

| # | Dónde | Qué demuestra |
|---|---|---|
| 1 | SQL | Tablas importadas: `tb_users`, `tb_products`, `tb_logs` |
| 2 | SQL | Usuarios remotos (`Host = %`) |
| 3 | SQL | Roles creados |
| 4 | SQL | `SHOW GRANTS` de cada rol + `mysql.role_edges` |
| 5 | SQL | `local_infile`, `max_allowed_packet` |
| 6 | **Terminal** | `CONEXION_REMOTA_OK` con tu IP de red |
| 7 | **Terminal** | El error de `aaron` (permiso mal puesto) |

### PASO 3

| # | Dónde | Qué demuestra |
|---|---|---|
| 1 | SQL | `@@local_infile = 1` |
| 2 | SQL | Las 10 categorías con sus conteos |
| 3 | SQL | 5000 del CSV + 50 de la Práctica 1 |
| 4 | SQL | La bitácora muestra `samuel@localhost` con 5005 altas |
| 5 | SQL | `TOTAL = 5050` |
| 6 | **Terminal** | Los 5050 vistos **desde la red** |

## La prueba que más vale: el error de aaron

En el Paso 2.7 lo importante **no es que funcione, es que falle**. Si el
profesor pregunta "¿cómo compruebas que los permisos están bien?", la respuesta
es: un usuario sin permiso **no puede** hacer la operación.

```
ERROR 1142 (42000): INSERT command denied to user 'aaron'@'CRAZY-DAVE'
```

Ese error **es la evidencia** de que el permiso está correctamente restringido.
No lo borres de la captura.

## Lo único que falta

`gh auth login` — el repositorio es público, así que ya pudiste clonarlo sin
cuenta. Pero la actividad 1.5 pide credenciales de GitHub, y eso solo lo
validas tú:

```bash
gh auth login
```

Hazlo desde tu cuenta para que el token no quede en un chat.

## Nota sobre la IP

Tu IP es `10.10.154.221` **hoy**. Ha cambiado dos veces durante la sesión. Si
mañana la terminal marca error de conexión, no es la base: es la IP. Ábrela con

```bash
hostname -I
```

y actualiza la variable en el script. Lo ideal es pedir una IP fija al profesor.
