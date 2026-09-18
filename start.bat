@echo off
REM JARVIS Windows - Hizli Baslatma
REM Kurulum yapilmissa direkt calistirir. Calistir: start.bat

setlocal

if not exist "venv\Scripts\activate.bat" (
    echo HATA: venv bulunamadi. Once setup.bat calistir.
    pause
    exit /b 1
)

call venv\Scripts\activate.bat
python main.py

endlocal
