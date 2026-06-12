task 1: git merge

1. git checkout main
   git branch fetaure-login

2. git checkout main
    git merge feature-login

3. git does a fast-forward merge

Fast-forward
 ft_login.txt | 5 +++++
 1 file changed, 5 insertions(+)
 create mode 100644 ft_login.txt

4. git checkout feature-signup
    git add 
    git commit -m "message"

    
git merge feature-signup 
Auto-merging ft_signup
CONFLICT (add/add): Merge conflict in ft_signup
Automatic merge failed; fix conflicts and then commit the result.

5. Conflict appears
   
6. 
    a. fast-forward merge: the pointer simply moves forward, happens when the target branch hasn't diverted from the source branch. (master branch has not made any commits)

    b. Git creates a merge commit when both brnaches have new commits (have diverged)

    c. merge commit occurs when git cannot automatically resolve the differences between branches - when same line in a file is modified in both brnaches

    resolving conflict:

    git log --merge
    go to the file that caused the conflict and edit the file
    add and then commit again
    merge again 
    conflict resolved

---------------------

task 2: git rebase

1. git checkout master
   git checkout -b feature-dashboard
   git add 
   git commit -m "message"

2. git checkout master  
   new commit added

3. git checkout feature-dashboard
   git rebase master

4. after rebase history is linear (no merge commits)
   with merge history would show a branch + merge commit

5. 
    a. rebase moves/replays your commits onto a new base(latest master)
        creates new commits, preserving the changes but changing the commit Ids
    b. history is different from merge as: it has linear, clean history and no merge commits
        preserves branch structure includes merge commit
    c. rebase rewrites history so, breaking others history lead to conflicts
    d. use rebase - before merging, for clean history
        use merge - for shared/public branches to store the history safely

-----------------------
task 3: squash

1. git checkout -b feature-profile
2. to use squash, i need to go in master branch and then run 
    git merge --squash <branchname>
    git merge --squash feature-profile
    after this command the changes gets added and the file is in staged state (no commit done yet)
    we now add a commit 
    git commit -m "squashed commit"
3. only one commit was added to master 
4. git checkout -b feature-settings
    did some commits
5. git branch master
   git merge feature-settings
   this has all the commit history
6. -
    a. squash merge combines all commits from a branch into one single commit when merging
    b. use squash merge for clean, simple history
        use regular merge to preserve full commit history
    c. trade-off of squashing = cleaner history

-----------------------
task 4: stash

1. making changes
2. when we try to switch branch after just making changes:
git checkout devops 
error: Your local changes to the following files would be overwritten by checkout:
        new
Please commit your changes or stash them before you switch branches.
Aborting
3. git stash
4. git switch devops
    did some work, git switch master
5. git stash pop
6. git stash list
7. git stash apply stash@{2}
8. a. stash apply and stash pop:
        stash apply: applies the stashed changes, keeps the stash in list to reuse
        stash pop: applies the stashed changes, removes the stash after applying (one-time use)
    b. usecase of stash:
        - Switching branches to fix a urgent bug
        - Pulling latest changes but your work is incomplete
        - Experimenting but not ready to commit
        - Cleaning working directory temporarily

Note: after stash the git status appears to be neat and clean, working tree clean , nothing to commit
stash with note/message: git stash push -m "message"

--------------------------------------
task 5:  cherry picking

1.  git cherry-pick <commit ID>
    git add <filename>
    git commit -m "message"

    after doing cherry-pick, do commit the changes

    note: 
    1. chery pick copies a specific commit from one branch and applies it to another
    2. use it when you want to apply hot fix from one branch to another
    3. reuse commit from another branch
    4. what can go wrong:
            - merge conflicts
            - duplicate commits
            - history gets messy


cmd to force delete a branch : git branch -D <branchname>