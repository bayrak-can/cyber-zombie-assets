@echo off
cd /d "%~dp0"
echo.
echo [1/3] Değişiklikler hazırlanıyor...
git add .

echo.
set /p MSG="Commit mesajı (örn: Otomatik yedek): "

if "%MSG%"=="" set MSG=Otomatik yedek

echo [2/3] Commit oluşturuluyor...
git commit -m "%MSG%"

echo.
echo [3/3] GitHub'a gönderiliyor...
git push origin main

echo.
echo ✅ Yedekleme tamamlandı!
pause
