# Builds and tests every ActionGuard project in dependency order.
# Usage (from the actionguard folder):  powershell -ExecutionPolicy Bypass -File .\scripts\check-all.ps1
# Optional: -Install  runs a clean dependency install (npm ci) before checking.

param([switch]$Install)

$ErrorActionPreference = 'Continue'
$root = Split-Path -Parent $PSScriptRoot

# The engine must be built first; the other projects import it.
$order = @(
  'actionguard-engine',
  'actionguard-browser',
  'actionguard-mobile',
  'actionguard-desktop',
  'actionguard-agent',
  'actionguard-photo',
  'actionguard-takedown',
  'actionguard-phone'
)

$results = @()
foreach ($name in $order) {
  $dir = Join-Path $root $name
  if (-not (Test-Path (Join-Path $dir 'package.json'))) {
    $results += [pscustomobject]@{ Project = $name; Result = 'not built yet' }
    continue
  }
  Write-Host "`n=== $name ===" -ForegroundColor Cyan
  Push-Location $dir
  try {
    if ($Install -or -not (Test-Path 'node_modules')) {
      if (Test-Path 'package-lock.json') { npm ci --no-audit --no-fund } else { npm install --no-audit --no-fund }
    }
    npm run check
    $ok = ($LASTEXITCODE -eq 0)
    $results += [pscustomobject]@{ Project = $name; Result = $(if ($ok) { 'PASS' } else { "FAIL (exit $LASTEXITCODE)" }) }
  } finally {
    Pop-Location
  }
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
$results | Format-Table -AutoSize
if ($results.Result -match 'FAIL') { exit 1 }
