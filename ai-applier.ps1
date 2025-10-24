# AI Applier v2.0 (Otomatik işlem + GitHub push)

$ErrorActionPreference = "Stop"
$base = Split-Path -Parent $MyInvocation.MyCommand.Path
$inbox = Join-Path $base ".ai_inbox"
$processed = Join-Path $base ".ai_processed"
$failed = Join-Path $base ".ai_failed"
$revizyon = Join-Path $base "REVIZYON.md"

Write-Host ("[{0}] AI Applier başlatıldı. Klasör izleniyor: {1}" -f (Get-Date -Format "HH:mm:ss"), $inbox)

# JSON dosyalarını izle
while ($true) {
    $files = Get-ChildItem $inbox -File -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        try {
            $ops = Get-Content $file.FullName -Raw | ConvertFrom-Json
            foreach ($op in $ops) {
                $path = Join-Path $base $op.path
                switch ($op.type) {
                    "write"   { Set-Content -Path $path -Value $op.content -Encoding UTF8 }
                    "append"  { Add-Content -Path $path -Value "`n$($op.content)" -Encoding UTF8 }
                    default   { Write-Host ("[{0}] Bilinmeyen op.type: {1}" -f (Get-Date -Format "HH:mm:ss"), $op.type) -ForegroundColor Yellow }
                }
                Write-Host ("[{0}] OP OK: {1} → {2}" -f (Get-Date -Format "HH:mm:ss"), $op.type, $op.path) -ForegroundColor Green
            }

            # Git işlemleri
            cd $base
            git add -A | Out-Null
            git commit -m ("OPS commitlendi ({0})" -f (Get-Date -Format "HH:mm:ss")) | Out-Null

            # ✅ GitHub push işlemini otomatik başlat
            try {
                Start-Process -FilePath "cmd.exe" `
                    -ArgumentList '/c','push-github.bat' `
                    -WorkingDirectory $base `
                    -NoNewWindow -Wait
                Write-Host ("[{0}] GitHub push OK." -f (Get-Date -Format "HH:mm:ss")) -ForegroundColor Cyan
            }
            catch {
                Write-Host ("[{0}] GitHub push HATA: {1}" -f (Get-Date -Format "HH:mm:ss"), $_.Exception.Message) -ForegroundColor Red
            }

            Move-Item $file.FullName (Join-Path $processed $file.Name) -Force
        }
        catch {
            Write-Host ("[{0}] HATA: {1}" -f (Get-Date -Format "HH:mm:ss"), $_.Exception.Message) -ForegroundColor Red
            Move-Item $file.FullName (Join-Path $failed $file.Name) -Force
        }
    }
    Start-Sleep -Seconds 3
}
