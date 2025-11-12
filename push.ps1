# push.ps1
param([string]$message = "update")
$ErrorActionPreference = 'Stop'

# Show where we are
$repoRoot = (git rev-parse --show-toplevel)
Write-Host "Repo: $repoRoot" -ForegroundColor Cyan
Set-Location $repoRoot
$branch = (git rev-parse --abbrev-ref HEAD).Trim()
Write-Host "Branch: $branch" -ForegroundColor Cyan

Write-Host "`nStaging changes..." -ForegroundColor Yellow
git add -A
$changes = git status --porcelain

if (-not $changes) {
  Write-Host "No changes to commit. Nothing to push." -ForegroundColor Magenta
  git status -sb
  return
}

Write-Host "Committing: $message" -ForegroundColor Green
git commit -m "$message"

# If no upstream set, push with -u; else normal push
try {
  $null = git rev-parse --abbrev-ref --symbolic-full-name "@{u}"
  $hasUpstream = $true
} catch {
  $hasUpstream = $false
}

if ($hasUpstream) {
  git push
} else {
  git push -u origin $branch
}

Write-Host "`nLast commit:" -ForegroundColor Cyan
git log -1 --name-status
