# ============================================================
# TODO-EN-UNO: Configura la conexión remota de tu MySQL
# Puerto: 40107 | Matrícula: 240107
# Ejecutar en PowerShell COMO ADMINISTRADOR
# ============================================================

$mysqlBin = "C:\Program Files\MySQL\MySQL Server 8.0\bin"
$scriptDir = "$env:USERPROFILE\Desktop\practica\Practicas-BDN-240107\SCRIPTS"
$backupDir = "$env:USERPROFILE\Desktop\practica\Practicas-BDN-240107\Backups"

Write-Host "=== 1. Creando bases de datos ===" -ForegroundColor Cyan
& "$mysqlBin\mysql.exe" -u root -p -e "CREATE DATABASE IF NOT EXISTS db_test; CREATE DATABASE IF NOT EXISTS db_bdn_240107; SHOW DATABASES;"

Write-Host "=== 2. Importando respaldo db_test.sql ===" -ForegroundColor Cyan
& "$mysqlBin\mysql.exe" -u root -p -D db_test < "$backupDir\db_test.sql"

Write-Host "=== 3. Creando usuarios y roles (privilegios) ===" -ForegroundColor Cyan
& "$mysqlBin\mysql.exe" -u root -p -D db_bdn_240107 < "$scriptDir\node-estudesprivileges.sql"

Write-Host "=== 4. Reiniciando MySQL para tomar puerto 40107 ===" -ForegroundColor Cyan
Restart-Service MySQL80 -Force
Start-Sleep -Seconds 5

Write-Host "=== 5. Verificando puerto 40107 ===" -ForegroundColor Cyan
netstat -ano | Select-String ":40107.*LISTENING"

Write-Host "=== 6. Regla de firewall para puerto 40107 ===" -ForegroundColor Cyan
New-NetFirewallRule -DisplayName "MySQL Remoto 40107" -Direction Inbound -Protocol TCP -LocalPort 40107 -Action Allow -ErrorAction SilentlyContinue

Write-Host "=== 7. IP de esta PC para conectarse desde otras ===" -ForegroundColor Cyan
(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*"}).IPAddress

Write-Host "=== LISTO ===" -ForegroundColor Green
