# Creates the GitHub repositories described in docs/PUBLISHING.md, with their descriptions and topics.
# Dry run by default: it only prints what it would do. Nothing is created unless you add -Apply.
#
# Needs the GitHub CLI (winget install GitHub.cli), then: gh auth login ; gh auth setup-git
#
#   .\scripts\publish-github.ps1 -Owner my-org                         # dry run with the brand "safetycatch"
#   .\scripts\publish-github.ps1 -Owner my-org -Brand scamveto          # dry run with another brand
#   .\scripts\publish-github.ps1 -Owner my-org -Apply                   # create the nine repositories as PRIVATE
#   .\scripts\publish-github.ps1 -Owner my-org -Apply -Push             # also push each local repository
#   .\scripts\publish-github.ps1 -Owner my-org -Apply -MakePublic       # launch day: switch to public
#                                                                       # (the takedown kit stays private unless -IncludeTakedown)

param(
  [Parameter(Mandatory = $true)][string]$Owner,
  [string]$Brand = 'safetycatch',
  [string]$Homepage = '',
  [switch]$Apply,
  [switch]$Push,
  [switch]$MakePublic,
  [switch]$IncludeTakedown,
  [switch]$AllowPersonalEmail
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$plan = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $root 'docs\PUBLISHING.md')

# Folder for each proposed repository, from the "Repositories" table.
$folders = @{}
foreach ($m in [regex]::Matches($plan, '(?m)^\| `([^`]+)`[^|]*\| `(safetycatch[a-z-]*)` \|')) {
  $folders[$m.Groups[2].Value] = $m.Groups[1].Value
}

# Description and topics for each repository, from the "About" section.
$repos = foreach ($m in [regex]::Matches($plan, '(?m)^\*\*(safetycatch[a-z-]*)\*\*[^\r\n]*\r?\n> ([^\r\n]+)\r?\n\r?\nTopics: ([^\r\n]+)')) {
  $proposed = $m.Groups[1].Value
  $folder = $folders[$proposed]
  if (-not $folder) { throw "No folder listed for $proposed in docs/PUBLISHING.md." }
  [pscustomobject]@{
    Name        = $Brand + $proposed.Substring('safetycatch'.Length)
    Folder      = $(if ($folder -eq 'safetycatch') { $root } else { Join-Path $root $folder })
    Description = $m.Groups[2].Value.Trim()
    Topics      = @([regex]::Matches($m.Groups[3].Value, '`([^`]+)`') | ForEach-Object { $_.Groups[1].Value })
    Takedown    = ($proposed -eq 'safetycatch-takedown-kit')
  }
}
if (@($repos).Count -ne 9) { throw "Expected 9 repositories in docs/PUBLISHING.md, found $(@($repos).Count)." }

# Use git.exe by name: on some PCs a stray file called "git" earlier in PATH shadows the real program.
$git = (Get-Command git.exe -ErrorAction Stop).Source

if ($Apply -and -not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw 'GitHub CLI not found. Install it with: winget install GitHub.cli  then run: gh auth login'
}

# Pushing publishes the author email of every commit. Stop unless it is a GitHub no-reply address.
if ($Push -and -not $AllowPersonalEmail) {
  $emails = @($repos | ForEach-Object { & $git -C $_.Folder log --format=%ae 2>$null } | Sort-Object -Unique)
  $personal = @($emails | Where-Object { $_ -and $_ -notmatch '@users\.noreply\.github\.com$' })
  if ($personal.Count -gt 0) {
    throw "The commits record a personal email address. Once pushed (and later made public) anyone can read it. Rewrite the history to your GitHub no-reply address first, or add -AllowPersonalEmail to push anyway."
  }
}

function Invoke-Step([string]$Label, [scriptblock]$Action) {
  if ($Apply) { Write-Host "  $Label"; & $Action; if ($LASTEXITCODE) { throw "Failed: $Label" } }
  else { Write-Host "  [dry run] $Label" }
}

foreach ($r in $repos) {
  $full = "$Owner/$($r.Name)"
  Write-Host "`n=== $full   (folder: $($r.Folder))" -ForegroundColor Cyan

  if ($MakePublic) {
    if ($r.Takedown -and -not $IncludeTakedown) {
      Write-Host '  stays private until its legal templates have been reviewed (add -IncludeTakedown to override)'
      continue
    }
    Invoke-Step "gh repo edit $full --visibility public" { gh repo edit $full --visibility public --accept-visibility-change-consequences }
    continue
  }

  $createArgs = @('repo', 'create', $full, '--private', '--description', $r.Description, '--disable-wiki')
  if ($Homepage) { $createArgs += @('--homepage', $Homepage) }
  Invoke-Step "gh repo create $full --private" { gh @createArgs }
  Invoke-Step "gh repo edit $full --add-topic $($r.Topics -join ',')" { gh repo edit $full --add-topic ($r.Topics -join ',') }

  if ($Push) {
    Invoke-Step "git push -u origin main" {
      $existing = & $git -C $r.Folder remote 2>$null
      if (@($existing) -notcontains 'origin') { & $git -C $r.Folder remote add origin "https://github.com/$full.git" }
      & $git -C $r.Folder push -u origin main
    }
  }
}

if (-not $Apply) { Write-Host "`nDry run only. Add -Apply to create the repositories." -ForegroundColor Yellow }
