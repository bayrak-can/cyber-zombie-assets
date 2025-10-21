param([Parameter(Mandatory=$true)][string]$No)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$folder = Join-Path $root "para-kazanma-yollari"
$file = Join-Path $folder ("Gozlem-{0}.md" -f $No)

$content = @"
# Gözlem $No

## Konu
(Kısa özet: Bu gözlem neyle ilgilidir? Hangi denemeyle veya süreçle bağlantılı?)

## Gözlem Süreci
1. Adım
2. Adım
3. Adım

## Bulgular
(Burada test veya saha gözlemleri detaylandırılır.)

## Sonuç ve Değerlendirme
(Kısa özet: Bu gözlemden çıkarılan sonuçlar nelerdir?)

## Durum
Taslak
"@

Set-Content -Path $file -Value $content -Encoding UTF8

# REVIZYON.md güncellemesi
$revizyon = Join-Path $root "REVIZYON.md"
$timestamp = Get-Date -Format "dd.MM.yyyy HH:mm"
Add-Content -Path $revizyon -Value "[${timestamp}] **Gozlem-$No.md** oluşturuldu (Durum: Taslak)"

Write-Host "✅ Gozlem-$No.md oluşturuldu ve REVIZYON.md güncellendi."
