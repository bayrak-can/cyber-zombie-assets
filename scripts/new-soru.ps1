param(
  [Parameter(Mandatory=$false)][string]$No
)

# Klasörler
$scriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Split-Path -Parent $scriptDir

if (-not $No -or $No -eq "") {
  Write-Host "Soru numarasi gelmedi. Ornek: 009"
  exit 1
}

# Hedef: uygulama-sorulari/Deneme-XXX/Deneme-XXX.md
$targetBase = Join-Path $projectDir 'uygulama-sorulari'
if (-not (Test-Path $targetBase)) {
  New-Item -ItemType Directory -Path $targetBase | Out-Null
}

$folderName = "Deneme-$No"
$targetDir  = Join-Path $targetBase $folderName
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

$mdPath = Join-Path $targetDir ("Deneme-$No.md")

# İçerik
$now = Get-Date -Format 'yyyy-MM-dd HH:mm'
$content = @"
# Deneme $No
Tarih: $now

## Amaç
(Bu denemenin amacini yaz)

## Adımlar
- [ ] Adım 1
- [ ] Adım 2

## Notlar
-
"@
Set-Content -Path $mdPath -Value $content -Encoding UTF8

# REVIZYON kaydı
$revPath = Join-Path $projectDir 'REVIZYON.md'
$revLine = "$($now) - Deneme-$No olusturuldu: uygulama-sorulari/$folderName/Deneme-$No.md"
Add-Content -Path $revPath -Value $revLine -Encoding UTF8

Write-Host "Olusturuldu: $mdPath"
