@echo off
setlocal enabledelayedexpansion

:: Kullanıcıdan başlık al
set /p "title=Başlık (kısa): "

:: Tarih ve saat değişkenleri
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set datetime=%%i
set datestamp=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2!_!datetime:~8,2!!datetime:~10,2!!datetime:~12,2!

:: Dosya adı
set filename=uygulama-sorulari\!datestamp!_%title%.md

:: Dosya oluştur
echo # %title%> "!filename!"
echo 📅 Tarih: %date% – %time:~0,5%>> "!filename!"
echo 🧩 Konu: %title%>> "!filename!"
echo.>> "!filename!"
echo ## Notlar>> "!filename!"
echo - [ ] Yapılacak 1>> "!filename!"
echo - [ ] Yapılacak 2>> "!filename!"

echo.
echo ✅ Dosya oluşturuldu: !filename!

pause
