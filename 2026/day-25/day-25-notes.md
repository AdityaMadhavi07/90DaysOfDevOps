
task 1: git reset

1. git add . , git commit -m "made 3 commits in file test.txt"
2. git reset --soft HEAD~1
   soft will undo the commit but will keep the changes , and file will be in staged state (added)
3. git reset --mixed HEAD~1
    mixed will: undo the last commit, will keep the changes, and file will be in untracked state(not added)
4. git reset --hard HEAD~1
   hard will remove everything - undo the last commit, remove the changes as well, the changes vanishes completly clean working tree..

5. a. all three move the current branch pointer
   b. --hard is detructive as it deleted uncommited changes in directory and staged changes. it resets your repo to match the chosen commit exactly
   c. use soft: to do squash, fix commit change, recommit immediately
        use mixed: to reorganize staging, edit files before recommiting
        use hard: throw away unwanted changes immediately, reset to a clean state
    d.  Avoid reset on pushed commits (use git revert instead)    


--------------------------------

task 2: git revert

1. did commits - git add . ; git commit -m "commit message"
2. git revert <commitid>, creates a new commit that undos the changes of old commit
   the old commit will stay in history, but the changes will be removed
   git revert internally works like merge, it applies reverse patch .if the patch overlaps with newer changes then conflict.

   we experience conflict when :
    - we revert non-latest commits
    - multiple commits touch same line
    - or changes overlap

    A revert conflict occurs when the changes being undone overlap with newer changes in the same file, so Git cannot automatically apply the reverse patch.

3. Yes the commit Y still stays in history
4. 
a. git revert and git reset:
    revert:
    - does not remove commit
    - new commit is created that undoes a previous commit
    - history is preserved
    - new commit is added
    - shared branch is safe
    - undo is possible
  
    reset:
    - moves the branch pointer forward
    - can modifty: staging area, working directory
    - rewrites history
    - history is deleted
    - no new commit
    - shared branch is unsafe
    - undo is hard

Note: git reset Y = this wont delete the Y, it will create a new commit Y' that will undo the changes done by Y. Y will always stay in history

b. git revert is safe option as:
    - it does not rewrite history
    - adds a new commit instead of deleting old ones
  
c. use case:
    - git revert: 
      - working on shared branches, 
      - changes are already pushed
      - for safe and traceable undo
  
    - git reset:
      - working on local branches
      - commits not pushed yet
      - if to remove/fix commits


---------------------------------------------

task 3:

1. what is does?
    git reset:
    - it has 3 types, all of them remove the commit from the history, and also undo the changes done by the commit. no new commit is created, history is rewritten

    git revert
    - it undoes the changes done by the last commit, and creates a new commit by the name - revert "your commit mess"


2.  removes commit from history?
    git reset: YES
    git revert: NO

    
3.  Safe for shared/pushed branches?
    git reset: NO
    git revert: YES

    
4. When to use?
    git reset: use in local branch
    git revert: can use in production, shared branch

----------------------------------------------

task 4: branching strategies

1. gitflow
    a. working
    - main: prod ready code
    - develop: integration branch
    - feature/*: for features

    b. flow

    c. usecase:
        - when project is huge 
        - we need proper release cycle

    d. pros and cons
        - clear stucture and roles
        - parallel development
      - cons: slower release, too many brnaches to manage

2. github flow
    a. working
        - only one main brnach: main
        - create short lived feature branches
        - one pull req --> review --> merge

    b. flow

    c. usecase:
        - web apps
        - ideal for fast-moving projects with daily deployment
        - continuous deployment env
        - small- medium teams

    d. pros and cons:
        - simple and easy to use
        - fast development
      - cons: less structured, risk if testing is weak, not for large release cycles

3. trunk-based development
    a. working
        - everyone works on main (trunk)
        - very small, short-lived branches (or direct commits)
        - frequent commits + feature flags

    b. flow
  
    c. usecase
        - high-performing teams
        - cont. integration systems
        - devops - driven teams
  
    d. pros and cons
        - faster integration
        - fewer merge conflicts
      - cons: requires string discipline, automated testing requires

4. a. startup shipping fast would use: GitHub Flow or Trunk-based developemnt
   b. large team with scheduled releases would use: GitFlow
   c. GitFlow
   
--------------------------------------------

task 5: cmd reference update

1. setup and config:
    git config --global user.name "your name"
    git config --global user.email "your email"

    git config --list
    git init
    git clone <repo_url>


2. basic workflow:
    git status
    git add <filename>
    git add .

    git commit -m "commit message"

    git log 
    git log --oneline

    git diff 
    git diff --staged

    git reflog

3. branching
    git branch
    git branch <branchname>

    git checkout <branchname>
    git checkout -b <branchname>

    git switch <branchname>
    git switch -c <branchname>


4. remote operations
    git remote -v
    git remote add origin <url>

    git push origin main
    git push -u origin main

    git pull origin main
    git fetch origin 

    git clone <url>


5. merging and rebasing
    git merge <branchname>
    
    git rebase <branchname>

    git rebase -i HEAD~3


6. stash and cherry-pick
    git stash
    git stash list
    git stash apply
    git stash pop
    git stash drop

    git cherry-pick <commit-id>


7. reset and revert
    git reset --soft HEAD~1
    git reset HEAD~1 or git reset --mixed HEAD~1
    git reset --hard HEAD~1

    git revert <commit_ID>

    git revert --continue
    git revert --abort
    git revert --skip







