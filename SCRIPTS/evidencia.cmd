@echo off
REM ==============================================================
REM  PRACTICA 02 - EVIDENCIA DE TERMINAL (version CMD / Windows)
REM  Alumno: Rene David Cabrera | Matricula: 24007
REM  Puerto: 40107
REM
REM  USO: abrir CMD normal (NO administrador) y ejecutar:
REM       cd %USERPROFILE%\OneDrive\Desktop\Practicas-BDN-240107\SCRIPTS
REM       evidencia.cmd
REM
REM  No necesita permisos de administrador: solo consulta estado.
REM ==============================================================

setlocal enabledelayedexpansion

set "MYSQL=C:\Users\eviux\AppData\Local\Programs\MySQL\mysql-8.0.46-winx64\bin\mysql.exe"
set "GIT=C:\Program Files\Git\cmd\git.exe"
set "GH=C:\Program Files\GitHub CLI\gh.exe"

REM La IP se obtiene con un script aparte: meter pipes de PowerShell
REM dentro de un for de CMD es fragile por el escape de ^
set "IPFILE=%TEMP%\_ip_24107.txt"
powershell -NoProfile -Command "(Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notmatch '^127\.|^169\.254\.' } | Select-Object -First 1).IPAddress" > "%IPFILE%"
set "IP="
for /f "usebackq tokens=* delims=" %%i in ("%IPFILE%") do set "IP=%%i"
del "%IPFILE%" 2>nul
if "%IP%"=="" (
  echo   [AVISO] No se pudo detectar la IP. Abrir CMD como administrador.
  echo   Si la IP cambio, editarla al inicio de este archivo.
)

echo ==============================================================
echo   PRACTICA 02 - EVIDENCIA DE TERMINAL
echo   Alumno: Rene David Cabrera ^| Matricula: 240107
echo   IP actual de esta PC: %IP%
echo ==============================================================

echo.
echo ########## PASO 1.1 - PUERTOS CONFIGURADOS ##########
powershell -NoProfile -Command "Get-NetTCPConnection -State Listen -LocalPort 40107 | Select-Object LocalAddress,LocalPort | Format-Table -AutoSize"
echo   (0.0.0.0 = escucha en todas las tarjetas, no solo local)
echo.

echo ########## PASO 1.2 - FIREWALL PERMITIENDO 40107 ##########
powershell -NoProfile -Command "Get-NetFirewallRule -DisplayName 'MySQL Remoto 40107' | Select-Object DisplayName,Enabled,Direction,Action,Profile | Format-List"
echo   (Solo el puerto 40107. El firewall general NO se desactivo.)
echo.

echo ########## PASO 1.3 - SERVICIO / DAEMON DE LA BD ##########
powershell -NoProfile -Command "Get-Service MySQL40107 | Select-Object Name,Status,StartType | Format-Table -AutoSize"
echo   (Running = arriba. Automatic = arranca solo al prender la PC)
echo.

echo ########## PASO 1.4 - CREDENCIALES DE GIT ##########
"%GIT%" config --global user.name
"%GIT%" config --global user.email
echo.

echo ########## PASO 1.5 - CREDENCIALES DE GITHUB ##########
"%GH%" --version
"%GH%" auth status
echo   (si dice 'not logged in', ejecuta:  gh auth login )
echo.

echo ########## PASO 1.6 - REPOSITORIO DEL PROFESOR CLONADO ##########
cd /d "%USERPROFILE%\OneDrive\Desktop\Practicas_BDN_MATRICULA" 2>nul
if exist .git (
  "%GIT%" branch --show-current
  "%GIT%" remote -v
  "%GIT%" log --oneline -3
) else (
  echo   NO CLONADO - revisa la ruta
)
cd /d "%USERPROFILE%\OneDrive\Desktop\Practicas-BDN-240107\SCRIPTS"
echo.

echo ########## PASO 1.7 - SERVIDOR LOCAL FUNCIONA ##########
"%MYSQL%" -u rene.cabrera -p240107 -h 127.0.0.1 -P 40107 -N -e "SELECT CONCAT('OK local -> ',CURRENT_USER(),' | puerto ',@@port,' | ',@@version);"
echo.

echo ########## PASO 2.6 - PRUEBAS DE CONEXION REMOTA ##########
echo -- 2.6.a  Tu usuario (superadmin) por IP de red:
"%MYSQL%" -u rene.cabrera -p240107 -h %IP% -P 40107 -N -e "SELECT CONCAT('   ',CURRENT_USER(),' | ve ',COUNT(*),' productos | CONEXION_REMOTA_OK') FROM db_test.tb_products;"
echo -- 2.6.b  Vendedor 2 (samuel) por IP de red:
"%MYSQL%" -u samuel -p240043 -h %IP% -P 40107 -N -e "SELECT CONCAT('   ',CURRENT_USER(),' | ve ',COUNT(*),' productos | CONEXION_REMOTA_OK') FROM db_test.tb_products;"
echo -- 2.6.c  Un companero usaria EXACTAMENTE esto:
echo       mysql -u samuel -p240043 -h %IP% -P 40107 db_test
echo.

echo ########## PASO 2.7 - PERMISOS: LO QUE CADA ROL PUEDE Y NO PUEDE ##########
echo -- buyer (aaron) SOLO lectura -- el INSERT debe ser RECHAZADO:
"%MYSQL%" -u aaron -p240045 -h %IP% -P 40107 db_test -e "INSERT INTO tb_products (sku,name,description,category,price,stock) VALUES ('PRUEBA','No debe entrar','x','Otros',1,1);" 2>&1 | findstr /i "denied ERROR"
echo   (lo de arriba DEBE decir 'command denied' = permiso bien puesto)
echo.

echo -- seller (samuel) SI puede insertar y actualizar:
"%MYSQL%" -u samuel -p240043 -h %IP% -P 40107 db_test -e "INSERT INTO tb_products (sku,name,description,category,price,stock) VALUES ('PRUEBA-SELLER','Prueba de permiso','verificacion','Otros',10,1);"
echo   (sin error = permitido)
"%MYSQL%" -u samuel -p240043 -h %IP% -P 40107 db_test -e "UPDATE tb_products SET price=20 WHERE sku='PRUEBA-SELLER';"
echo   UPDATE sin error = permitido
"%MYSQL%" -u samuel -p240043 -h %IP% -P 40107 db_test -e "SELECT CONCAT('   UPDATE aplicado: sku=',sku,' precio ahora ',price) FROM tb_products WHERE sku='PRUEBA-SELLER';"
echo   (seller NO tiene DELETE, por eso la limpieza la hace superadmin)
echo.

echo -- superadmin (tu usuario) control total: borra la fila de prueba
"%MYSQL%" -u rene.cabrera -p240107 -h %IP% -P 40107 db_test -e "DELETE FROM tb_products WHERE sku='PRUEBA-SELLER';"
echo   (DELETE permitido para superadmin)
echo.

echo ########## PASO 3.6 - DATOS DISPONIBLES EN LA BASE REMOTA ##########
"%MYSQL%" -u rene.cabrera -p240107 -h %IP% -P 40107 db_test -e "SELECT COUNT(*) AS 'P3.5 Total de productos vistos DESDE LA RED' FROM tb_products; SELECT COUNT(*) AS 'P3.5 De los 5000 del CSV, vistos DESDE LA RED' FROM tb_products WHERE sku REGEXP '^[A-Z]{3}-.*[0-9]{5}-';"
echo.

echo ==============================================================
echo   FIN DE LA EVIDENCIA
echo ==============================================================

pause
