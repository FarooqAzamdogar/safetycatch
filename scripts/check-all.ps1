# Builds and tests every SafetyCatch project in dependency order.
# Usage (from the safetycatch folder):  powershell -ExecutionPolicy Bypass -File .\scripts\check-all.ps1
# Optional: -Install  runs a clean dependency install (pnpm install --frozen-lockfile) before checking.
# Requires pnpm 11: npm install -g pnpm@11.29.0

param([switch]$Install)

$ErrorActionPreference = 'Continue'
$root = Split-Path -Parent $PSScriptRoot

# The engine must be built first; the other projects import it.
$order = @(
  'safetycatch-engine',
  'safetycatch-browser-extension',
  'safetycatch-scam-checker',
  'safetycatch-clipboard-guard',
  'safetycatch-mcp-guard',
  'safetycatch-photo-privacy',
  'safetycatch-takedown-kit',
  'safetycatch-stalkerware-check'
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
      pnpm install --frozen-lockfile
    }
    pnpm run check
    $ok = ($LASTEXITCODE -eq 0)
    $results += [pscustomobject]@{ Project = $name; Result = $(if ($ok) { 'PASS' } else { "FAIL (exit $LASTEXITCODE)" }) }
  } finally {
    Pop-Location
  }
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
$results | Format-Table -AutoSize
if ($results.Result -match 'FAIL') { exit 1 }
