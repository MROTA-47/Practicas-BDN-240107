# Entrega Practica 02 - Rene David Cabrera (240107)

## Ramas del repositorio
| Rama | Contenido |
|---|---|
| `master` | Linea principal, incluye la fusion de Practica02 |
| `Practica02` | Commits de la Practica 02 |
| `Practica03` | Parte de Practica02, para la Practica 03 |

## Datos de conexion
| Dato | Valor |
|---|---|
| Servidor | `10.10.154.221` |
| Puerto | `40107` |
| Base | `db_test` |
| Usuario principal | `rene.cabrera` / `240107` |

## Resultados verificados
| Actividad | Resultado |
|---|---|
| Triggers | 9 (3 por tabla) |
| Bitacora | mas de 10000 registros |
| Carga masiva | 5000 productos por vendedor desde su PC |
| Vistas de trazabilidad | 4 |
| Tabla de categorias | `tb_categorias` con clave foranea |

## Evidencia de permisos (punto 2.7)
Un usuario con rol `buyer` recibe `ERROR 1142` al intentar INSERT.
Ese error ES la evidencia de que el permiso quedo bien puesto.
