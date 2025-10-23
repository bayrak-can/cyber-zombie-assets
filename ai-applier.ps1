# ai-applier.ps1  (proje kökünde dursun)

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Inbox = Join-Path $Root ".ai_inbox"
$Done  = Join-Path $Root ".ai_processed"
$Fail  = Join-Path $Root ".ai_failed"

# Klasörler yoksa oluştur
$null = New-Item -ItemType Directory -Force -Path $Inbox,$Done,$Fail

function Log($msg){ Write-Host ("[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"), $msg) }

# Git var mı? Yoksa ops.json işlemlerinde sadece dosya yaz/ekle yapacağız.
$Git = Get-Command git -ErrorAction SilentlyContinue

function Apply-Patch($filePath){
  if (-not $Git) {
    Log "PATCH uygulanamadı: 'git' bulunamadı. (GitHub Desktop kuruluysa PATH ekle.)"
    Move-Item -Force "$filePath" (Join-Path $Fail (Split-Path $filePath -Leaf))
    return
  }
  Push-Location $Root
  try {
    git apply --whitespace=fix --reject "$filePath"
    if ($LASTEXITCODE -ne 0) { throw "git apply başarısız" }
    git add -A
    $msg = "AI patch: " + (Split-Path $filePath -Leaf)
    git commit -m "$msg" | Out-Null
    Log "PATCH uygulandı ve commitlendi: $msg"
    Move-Item -Force "$filePath" (Join-Path $Done (Split-Path $filePath -Leaf))
  } catch {
    Log "PATCH hata: $($_.Exception.Message)"
    Move-Item -Force "$filePath" (Join-Path $Fail (Split-Path $filePath -Leaf))
  } finally { Pop-Location }
}

function Apply-Ops($filePath){
  try {
    $ops = Get-Content -Raw -Path $filePath | ConvertFrom-Json
  } catch {
    Log "JSON okunamadı: $filePath"
    Move-Item -Force $filePath (Join-Path $Fail (Split-Path $filePath -Leaf))
    return
  }

  foreach($op in $ops){
    $path = Join-Path $Root $op.path
    $dir = Split-Path $path -Parent
    New-Item -ItemType Directory -Force -Path $dir | Out-Null

    switch ($op.type) {
      "write"   { Set-Content -Path $path -Value $op.content -NoNewline:$false }
      "append"  { Add-Content -Path $path -Value "`r`n$($op.content)" }
      "replace" {
        if (-not (Test-Path $path)) { throw "replace hedefi yok: $($op.path)" }
        $txt = Get-Content -Raw -Path $path
        $txt = $txt -replace [regex]::Escape($op.find), $op.replace
        Set-Content -Path $path -Value $txt -NoNewline:$false
      }
      "insert_after" {
        if (-not (Test-Path $path)) { throw "insert_after hedefi yok: $($op.path)" }
        $txt = Get-Content -Raw -Path $path
        $anchor = $op.anchor
        if ($txt -notlike "*$anchor*") { throw "anchor bulunamadı: $anchor" }
        $txt = $txt -replace [regex]::Escape($anchor), ($anchor + "`r`n" + $op.content)
        Set-Content -Path $path -Value $txt -NoNewline:$false
      }
      default { throw "Bilinmeyen op.type: $($op.type)" }
    }
    Log "OP OK: $($op.type) → $($op.path)"
  }

  # Git varsa commit; yoksa sadece dosyalar yazılmış olur.
  try {
    if ($Git) {
      Push-Location $Root
      git add -A
      git commit -m ("AI ops: " + (Split-Path $filePath -Leaf)) | Out-Null
      Pop-Location
      Log "OPS commitlendi."
    } else {
      Log "Git bulunamadı: commit atlanıyor (dosyalar yazıldı)."
    }
    Move-Item -Force $filePath (Join-Path $Done (Split-Path $filePath -Leaf))
  } catch {
    Log "OPS commit hatası: $($_.Exception.Message)"
    Move-Item -Force $filePath (Join-Path $Fail (Split-Path $filePath -Leaf))
  }
}

Log "AI Applier başladı. Klasör izleniyor: $Inbox"
while ($true) {
  Get-ChildItem $Inbox -File | ForEach-Object {
    $ext = $_.Extension.ToLower()
    if ($ext -eq ".patch")      { Apply-Patch $_.FullName }
    elseif ($ext -eq ".json")   { Apply-Ops   $_.FullName }
    else {
      Log "Desteklenmeyen dosya: $($_.Name)"
      Move-Item -Force $_.FullName (Join-Path $Fail $_.Name)
    }
  }
  Start-Sleep -Milliseconds 800
}
