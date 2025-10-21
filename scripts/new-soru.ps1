param([Parameter(Mandatory=$true)][string]$No)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$folder = Join-Path $root "para-kazanma-yollari"
$file = Join-Path $folder ("Soru-{0}.md" -f $No)

$content = @"
# Soru $No – Başlık

## Konu
(Kısa özet: Soru neyle ilgili? Amaç nedir?)

## Varsayımlar / Kısıtlar
- …
- …

## Notlar
- …
- …

## Yapılacaklar
- [ ] Adım 1
- [ ] Adım 2

## Durum
Taslak
"@

Set-Content -Path $file -Value $content -Encoding UTF8

# REVIZYON.md günlüğüne kayıt
$rev = Join-Path $root "REVIZYON.md"
$stamp = (Get-Date -Format "dd.MM.yyyy HH:mm")
Add-Content $rev "`n- [$stamp] **Soru-$No.md** oluşturuldu (Durum: Taslak)"
Write-Host "Soru-$No.md oluşturuldu ve REVIZYON.md güncellendi." -ForegroundColor Green
