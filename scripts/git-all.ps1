# Runs the same git command in every ActionGuard repository:
# the suite repository (this folder's parent) and each tool's repository.
#
# Examples (run from the actionguard folder):
#   powershell -ExecutionPolicy Bypass -File .\scripts\git-all.ps1                      # short status of every repo
#   powershell -ExecutionPolicy Bypass -File .\scripts\git-all.ps1 log --oneline -3     # last 3 commits of every repo
#   powershell -ExecutionPolicy Bypass -File .\scripts\git-all.ps1 fetch --all          # fetch every repo

param([Parameter(ValueFromRemainingArguments = $true)][string[]]$GitArgs)

if (-not $GitArgs) { $GitArgs = @('status', '--short', '--branch') }

# Use git.exe by name: on some PCs a stray file called "git" earlier in PATH shadows the real program.
$git = (Get-Command git.exe -ErrorAction Stop).Source

$root = Split-Path -Parent $PSScriptRoot
$repos = @($root) + (Get-ChildItem -Path $root -Directory |
  Where-Object { Test-Path (Join-Path $_.FullName '.git') } |
  Sort-Object Name |
  ForEach-Object { $_.FullName })

foreach ($repo in $repos) {
  Write-Host "`n=== $(Split-Path -Leaf $repo) ===" -ForegroundColor Cyan
  & $git -C $repo @GitArgs
}
