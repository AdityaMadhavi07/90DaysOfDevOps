git init
git status
git config --global user.name "username"
git config --global user.Email "usermail"
git add <filename>
git commit -m "message"
git log 

---------
git branch -a : to list all the git branches2. 
git branch <new-branch>    
git checkout feature-1
git checkout -b feature-2
git switch <branch-name>
git commit -m "message"
git switch master
git branch -d <branch-to-delete>
------------------------------------------------------------------------------------

Repo management:
git init : initialize a new repo
git clone <repo> : clone an existing repo
git remote -v : view remote repo details
git remote add origin <url> : link local repo to remote

adding and commiting:
git add <file> : save changes for commit
git commit -m "message" : commit changes with commit
git commit --amend : edit the last commit

branching and merging:
git branch : list branches
git checkout -b <branch> : create and switch to a new branch

log and history:
git log --oneline : view history in oneline
git diff : view staged changes

undo changes:
git reset <file> unstages a file
git restore <file> restores file to last commited state
git revert <commit> new commit that undoes prev. commit

pushing and pulling:
git push origin <branch> : pushes changes to remote repo
git pull origin <branch> : pulls chanegs from remote repo

log git config commands:
git config --global user.name "<name>" : sets global username for git commits
git config --global user.email "<email>" :  sets global useremail for git commits
git config --list

git status
git fetch

------advanced commands:

Stashing:
git stash: saves changes to stash
git stash list: list all stashes

rebase and cherry pick:
git rebase <branch_name> : replays current branch commit on top of <branch_name>
git rebase --abort : cancels the ongoing rebase
git cherry-pick <commit_hash> : applies specific commit from another branch to current branch

tagging:
git tag <tag> : create light wt tag
git push origin --tags : push tags to remote