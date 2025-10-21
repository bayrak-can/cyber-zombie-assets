param([Parameter(Mandatory=$true)][string]$No)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$folder = Join-Path $root "uygulama-sorulari"
$file = Join-Path $folder ("Deneme-{0}.md" -f $No)

$content = @"
# Deneme $No

## Konu
(Kısa özet: Bu deneme hangi fikir veya gözlemle ilgilidir?)

## Deneme Süreci
1. Adım
2. Adım
3. Adım

## Bulgular
(Burada test sonuçları veya gözlemler yazılır.)

## Durum
Taslak
"@

Set-Content -Path $file -Value $content -Encoding UTF8

# REVIZYON.md güncellemesi
$revizyon = Join-Path $root "REVIZYON.md"
$timestamp = Get-Date -Format "dd.MM.yyyy HH:mm"
Add-Content -Path $revizyon -Value "`n[$timestamp] **Deneme-$No.md** oluşturuldu (Durum: Taslak)"

Write-Host "✅ Deneme-$No.md oluşturuldu ve REVIZYON.md güncellendi."
