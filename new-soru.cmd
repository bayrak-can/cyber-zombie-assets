@echo off
setlocal
REM Bu .bat hangi klasördeyse oraya geç
cd /d "%~dp0"

set /p NO=Olusturulacak Soru numarasi (ornegin 008):

"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\new-soru.ps1" %NO%

endlocal
pause
