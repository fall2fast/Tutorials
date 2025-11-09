# push.ps1
param(
    [string]$message = "update"
)

Write-Host "Adding all changes..." -ForegroundColor Cyan
git add -A

Write-Host "Committing with message: $message" -ForegroundColor Yellow
git commit -m "$message"

Write-Host "Pushing to origin..." -ForegroundColor Green
git push
