# ============================================================
# PRACTICA COMPLETA - BDN 240107 - SCRIPT MAESTRO
# Ejecutar: clic derecho > Ejecutar con PowerShell
# o:  powershell -ExecutionPolicy Bypass -File practica_completa.ps1
# ============================================================

$mysql = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
$base  = "$env:USERPROFILE\Desktop\practica\Practicas-BDN-240107"
$H     = "127.0.0.1"
$P     = "40107"

# Contraseña por variable de evitamento: OJO - con MYSQL_PWD no hay
# warning de seguridad y los errores de mysql SI se pueden ver.
$env:MYSQL_PWD = "240107"

# Ejecuta un script .sql y muestra su salida (sin ocultar errores)
function Paso($titulo, $archivo) {
    Write-Host "`n=== $titulo ===" -ForegroundColor Cyan
    if (-not (Test-Path $archivo)) { Write-Host "NO EXISTE: $archivo" -ForegroundColor Red; return }
    $sql = ($archivo -replace '\\','/')
    $salida = & $mysql -u root -h $H -P $P --force -e "source $sql"
    if ($LASTEXITCODE -ne 0) { Write-Host "ERROR mysql (exit $LASTEXITCODE)" -ForegroundColor Red }
    $salida | ForEach-Object { Write-Host $_ }
}

# ---------- 0. Servicio ----------
Write-Host "=== 0. Verificando servicio MySQL ===" -ForegroundColor Cyan
if ((Get-Service MySQL80).Status -ne 'Running') {
    Write-Host "MySQL detenido, iniciando..." -ForegroundColor Yellow
    Start-Service MySQL80; Start-Sleep 6
}
Write-Host "Servicio: $((Get-Service MySQL80).Status)" -ForegroundColor Green

# ---------- 1. Bases de datos ----------
Paso "1. Creando bases de datos" "$base\SCRIPTS\setup_conexion_remota.sql"

# ---------- 2. Respaldo (tablas + datos + triggers) ----------
Write-Host "`n=== 2. Importando respaldo db_test.sql ===" -ForegroundColor Cyan
$dump = "$base\Backups\db_test.sql"
if (-not (Test-Path $dump)) { Write-Host "NO EXISTE: $dump" -ForegroundColor Red }
else {
    # crear db_test primero por si acaso
    & $mysql -u root -h $H -P $P -e "CREATE DATABASE IF NOT EXISTS db_test"
    $salida = & $mysql -u root -h $H -P $P -D db_test --force -e "source $($dump -replace '\\','/')"
    if ($LASTEXITCODE -ne 0) { Write-Host "ERROR mysql (exit $LASTEXITCODE)" -ForegroundColor Red }
    Write-Host "Respaldo importado."
}

# ---------- 3. Usuarios y roles ----------
Paso "3. Creando usuarios y roles" "$base\SCRIPTS\node-estudesprivileges.sql"

# ---------- 4. Verificacion general ----------
Paso "4. VERIFICACION GENERAL" "$base\SCRIPTS\verificar_conexion_remota.sql"

# ---------- 5. Consultas de la practica ----------
Paso "5. Consultas de verificacion (la practica)" "$base\SCRIPTS\queries\consultas_verificaciones.sql"

# ---------- 6. Prueba de conexion REMOTA por la IP real ----------
Write-Host "`n=== 6. Prueba de conexion REMOTA ===" -ForegroundColor Cyan
$ifIndex = (Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue |
            Sort-Object RouteMetric | Select-Object -First 1).ifIndex
$ip = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $ifIndex -ErrorAction SilentlyContinue |
       Select-Object -First 1).IPAddress
if (-not $ip) {
    $ip = (Get-NetIPAddress -AddressFamily IPv4 |
           Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' } |
           Select-Object -First 1).IPAddress
}

# la prueba usa la MISMA contrasena (240107 es la de rene.cabrera tambien)
$salida = & $mysql -u rene.cabrera -h $ip -P $P --force -e "SELECT 'CONEXION_REMOTA_OK' AS resultado, CURRENT_USER() AS usuario, @@port AS puerto;"
if ($LASTEXITCODE -ne 0) { Write-Host "FALLO la conexion remota (exit $LASTEXITCODE)" -ForegroundColor Red }
$salida | ForEach-Object { Write-Host $_ }

$env:MYSQL_PWD = $null
Write-Host "`n=== LISTO ===" -ForegroundColor Green
Write-Host "IP para tus amigos: $ip  |  Puerto: $P"
Write-Host "Conexion: mysql -u rene.cabrera -h $ip -P $P -p"
