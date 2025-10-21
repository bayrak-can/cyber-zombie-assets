# REVIZYON otomatik ozet (ASCII/UTF-8 güvenli)
$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$para = Join-Path $root 'para-kazanma-yollari'
$uyg  = Join-Path $root 'uygulama-sorulari'
$rev  = Join-Path $root 'REVIZYON.md'

# Klasor icerigi
$Sorular   = @(Get-ChildItem $para -Filter 'Soru-*.md'   -ErrorAction SilentlyContinue | Sort-Object Name)
$Gozlemler = @(Get-ChildItem $para -Filter 'Gozlem-*.md' -ErrorAction SilentlyContinue | Sort-Object Name)
$Denemeler = @(Get-ChildItem $uyg  -Filter 'Deneme-*.md' -ErrorAction SilentlyContinue | Sort-Object Name)

$now = Get-Date -Format 'dd.MM.yyyy HH:mm'

# Ozet blogu satirlari
$lines = @()
$lines += '## Otomatik Ozet — ' + $now
$lines += ''
$lines += '### Sorular'
if ($Sorular.Count -gt 0) { $Sorular   | ForEach-Object { $lines += '- ' + $_.Name } } else { $lines += '- (yok)' }
$lines += ''
$lines += '### Gozlemler'
if ($Gozlemler.Count -gt 0) { $Gozlemler | ForEach-Object { $lines += '- ' + $_.Name } } else { $lines += '- (yok)' }
$lines += ''
$lines += '### Denemeler'
if ($Denemeler.Count -gt 0) { $Denemeler | ForEach-Object { $lines += '- ' + $_.Name } } else { $lines += '- (yok)' }
$lines += ''

# REVIZYON.md oku/olustur
if (Test-Path $rev) {
    $text = Get-Content $rev -Raw
} else {
    $text = '# Revizyon Takip Dosyasi`r`n'
}

# Onceki otomatik blogu sil
$startTag = '<!-- AUTO-START -->'
$endTag   = '<!-- AUTO-END -->'
if ($text -match [regex]::Escape($startTag)) {
    $pattern = '(?s)<!-- AUTO-START -->.*?<!-- AUTO-END -->'
    $text = [regex]::Replace($text, $pattern, '')
    $text = $text.Trim() + "`r`n`r`n"
}

# Yeni blogu ekle
$auto = $startTag + "`r`n" + ($lines -join "`r`n") + "`r`n" + $endTag + "`r`n"
$text = $text.Trim() + "`r`n`r`n" + $auto

# Yaz
Set-Content -Path $rev -Value $text -Encoding UTF8
Write-Host '✅ REVIZYON.md otomatik ozet guncellendi.'
