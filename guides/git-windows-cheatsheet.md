## ✅ Step 1 — Create the folder (if not already there)

Open **PowerShell 7 (x64)** and run:

```powershell
mkdir "C:\Users\Tony\CloudStation\My Documents\Server Documents\Repos\Tutorials\guides" -Force
```

---

## ✅ Step 2 — Create the cheat sheet file

Copy/paste this **exact command** in PowerShell:

````powershell
$path = "C:\Users\Tony\CloudStation\My Documents\Server Documents\Repos\Tutorials\guides\git-windows-cheatsheet.md"
@"
# Git on Windows – Quick Cheatsheet

## Which shell to use
- Use **PowerShell 7 (x64)** or Git Bash.
- Work as **normal user** (not admin).

## Configure Git Identity (only once per machine)
```powershell
git config --global user.name "fall2fast"
git config --global user.email "tonyd.ai@icloud.com"
````

## Create SSH Key (one per PC)

```powershell
mkdir -Force $HOME\.ssh
ssh-keygen -t ed25519 -C "tonyd.ai@icloud.com" -f $HOME\.ssh\id_ed25519
```

## Add Key to GitHub

```powershell
Get-Content $HOME\.ssh\id_ed25519.pub | Set-Clipboard
```

Paste at: **GitHub → Settings → SSH and GPG Keys → New SSH Key**

## Test Authentication

```powershell
ssh -T git@github.com
```

## Clone into Synology-Synced Repo Root

```powershell
cd "C:\Users\Tony\CloudStation\My Documents\Server Documents\Repos"
git clone git@github.com:fall2fast/<repo>.git
```

## Daily Workflow

```powershell
git pull        # get latest changes
git status      # see changes
git add -A      # stage everything
git commit -m "describe what you changed"
git push        # send to GitHub
```

## Folder Naming Standard

* lowercase
* hyphens instead of spaces

Examples:

```
alexa-room-naming/
sv08-klipper/
homeassistant-automations/
```

## Rename Folder Correctly

```powershell
git mv -f OldName new-name
git commit -m "chore: rename folder"
git push
```

That's it. Repeat these steps on any PC.
"@ | Out-File -Encoding utf8 $path

````

---

## ✅ Step 3 — Commit and Push

```powershell
cd "C:\Users\Tony\CloudStation\My Documents\Server Documents\Repos\Tutorials"
git add guides/git-windows-cheatsheet.md
git commit -m "docs: add Git for Windows cheat sheet"
git push
````

---

## 🎉 Done!

You now have a **permanent copy** synced across:

* Your PCs
* Your NAS
* GitHub

Which means you **never** need to remember all this from scratch again.

---

### Want to make this even easier?

I can now create:

**A VS Code workspace** that:

* Automatically opens your Tutorials repo
* Loads Markdown preview
* Has Git panel ready
* Has navigation shortcuts for your guides

Just answer:

```
yes, create workspace
```
