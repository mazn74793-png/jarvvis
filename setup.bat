@echo off
REM JARVIS Windows - Kurulum & Baslatma Scripti
REM Calistir: setup.bat

setlocal enabledelayedexpansion

echo.
echo ========================================
echo    J.A.R.V.I.S  Windows Kurulum
echo ========================================
echo.

REM Python kontrolu
where python >nul 2>nul
if errorlevel 1 (
    echo HATA: Python bulunamadi. https://www.python.org/downloads/windows/ adresinden Python 3.10+ kur.
    pause
    exit /b 1
)

for /f "tokens=*" %%v in ('python --version') do set "PYVERSION=%%v"
echo Python: %PYVERSION%

REM Virtual environment
if not exist "venv\" (
    echo Virtual environment olusturuluyor...
    python -m venv venv
)

call venv\Scripts\activate.bat

REM API key dosyasi
if not exist "config\api_keys.json" (
    if exist "config\api_keys.example.json" (
        copy /Y "config\api_keys.example.json" "config\api_keys.json" >nul
        echo config\api_keys.json olusturuldu - Gemini API anahtarini buraya gir.
    )
)

REM Fontlari kullanici dizinine kopyala
if exist "Fonts\" (
    echo Grift fontlari kuruluyor...
    powershell -NoProfile -Command "$d = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'; New-Item -ItemType Directory -Force -Path $d | Out-Null; Get-ChildItem -Path '.\Fonts\*.ttf' | ForEach-Object { $t = Join-Path $d $_.Name; if (-not (Test-Path $t)) { Copy-Item $_.FullName $t -Force } }"
)

echo.
echo Paketler yukleniyor...
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

echo.
echo PyAudio kurulamadiysa: pip install pipwin && pipwin install pyaudio
echo.
echo ========================================
echo        Kurulum Tamamlandi
echo ========================================
echo.
echo JARVIS'i baslatmak icin:
echo    venv\Scripts\activate
echo    python main.py
echo.

set /p choice="Simdi baslatilsin mi? (e/h): "
if /i "!choice!"=="e" (
    python main.py
)

endlocal
