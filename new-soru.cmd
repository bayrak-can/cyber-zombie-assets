@echo off
setlocal

REM Zaman damgasi (yyyy-MM-dd_HHmmss)
for /f %%i in ('powershell -NoP -C "Get-Date -Format yyyy-MM-dd_HHmmss"') do set TS=%%i

set /p TITLE=Baslik (kisa): 
if "%TITLE%"=="" set "TITLE=Yeni Soru"

REM Dosya adi icin bosluklari - yap
set "SAFE=%TITLE: =-%"

REM Hedef klasor
set "DIR=uygulama-soruları"
if not exist "%DIR%" mkdir "%DIR%"

set "FILE=%DIR%\%TS%_%SAFE%.md"

(
  echo # %TITLE%
  echo
  echo ## Notlar
  echo - [ ] Yapilacak 1
  echo - [ ] Yapilacak 2
  echo
) > "%FILE%"

REM VS Code'da ac (code yoksa hata verme)
code -r "%FILE%" 2>nul

echo Olusturuldu: %FILE%
endlocal
