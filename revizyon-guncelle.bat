@echo off
REM === Klasörü bu dosyanın bulunduğu dizine çek ===
cd /d "%~dp0"

REM === REVIZYON otomatik özet scriptini çalıştır ===
powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\sync-revizyon.ps1"

REM === Hata olduysa beklet ve çık ===
if errorlevel 1 (
  echo Hata olustu. Pencereyi kapatmadan once bir tusa basin...
  pause
  exit /b
)

REM === REVIZYON.md dosyasını ac ===
start notepad ".\REVIZYON.md"

REM === GitHub Desktop'i ac (varsayilan kurulum yolu) ===
start "" "%LOCALAPPDATA%\GitHubDesktop\GitHubDesktop.exe"
