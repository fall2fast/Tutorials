# Git Cheatsheet (Windows / PowerShell)

## First time on a machine
git config --global user.name  "fall2fast"
git config --global user.email "tonyd.ai@icloud.com"
ssh -T git@github.com   # should say "Hi fall2fast!"

## Daily
git status
git add -A
git commit -m "note what changed"
git pull --rebase
git push

## New branch
git switch -c feature/my-change
# ... edits ...
git push -u origin feature/my-change

## Recover oops
git checkout -- path\to\file     # discard unstaged
git restore --staged .           # unstage
git log --oneline --graph --decorate --all
