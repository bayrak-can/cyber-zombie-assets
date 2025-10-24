@echo off
setlocal enableextensions
cd /d "%~dp0"
chcp 65001 >NUL

rem ▼ Otomatik commit mesajı
set "MSG=OPS: %DATE% %TIME% otomatik push"

rem ▼ Değişiklik yoksa çık
git add -A
git diff --cached --quiet && (
  echo [Push] Commitlenecek degisiklik bulunamadi. 
  goto :eof
)

rem ▼ Commit + rebase pull + push
git commit -m "%MSG%" >NUL
git pull --rebase origin main >NUL 2>&1
git push origin main

echo [Push] GitHub'a gonderildi.
endlocal
