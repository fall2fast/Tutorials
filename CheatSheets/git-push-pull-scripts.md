Perfect — here’s a **compact Git toolkit** of PowerShell helper scripts you can drop into any local Git repo folder (like your `Tutorials` folder synced via Synology Drive). These are safe, one-folder-at-a-time scripts.

---

## 📁 Git PowerShell Helper Scripts for Windows

### 1️⃣ `push.ps1` — Add, Commit, and Push

```powershell
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
```

---

### 2️⃣ `pull.ps1` — Pull From Remote

```powershell
# pull.ps1
Write-Host "Pulling latest changes from origin..." -ForegroundColor Cyan
git pull
```

---

### 3️⃣ `status.ps1` — Show Current Git Status

```powershell
# status.ps1
Write-Host "Checking Git status..." -ForegroundColor Yellow
git status
```

---

### 4️⃣ `switch.ps1` — Switch Branches (optional)

```powershell
# switch.ps1
param(
    [string]$branch = "main"
)

Write-Host "Switching to branch: $branch" -ForegroundColor Cyan
git checkout $branch
```

---

### 🧠 How to Use These Scripts

1. Save each script into your repo folder (e.g. `Repos\Tutorials`)
2. Open PowerShell and `cd` into the folder
3. Run like this:

```powershell
.\status.ps1
.\pull.ps1
.\push.ps1 "added new README section"
.\switch.ps1 feature-new-stuff
```

---

### ⚙️ Optional Global Shortcuts

If you want to use them from *any* repo folder:

1. Move the scripts to a directory like `C:\GitScripts`
2. Add that directory to your `PATH` in system environment variables
3. Now you can call them from anywhere:

```powershell
push.ps1 "quick fix"
```

---

Let me know if you:

* Use branches regularly (I’ll add a branch list/display helper)
* Ever want to bulk-push all subrepos in a parent folder
* Need to add safeguards (e.g. prevent push if no changes)

Want me to zip up all these as a single `.zip` for download?
