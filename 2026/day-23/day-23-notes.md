task 1 - uderstanding branches:

1. Branch:
   branch is a light wt pointer to a specific commit in repo history
   by default git creates a branch called - master
   they allow us to isolate work without affecting the code


2. why we cant use main?
    since many other developers can have their own version of code, so to keep each code isolated we commit them in seperate branches
    - to ensure stability, collaboration and controlled releases
    - isolation of changes
    - parallel development - m21ultiple developers can work on diff ft. symultaneously

3. head in git
    - head is a pointer that refers to the current working commit in your repo.
  
4. Switching branches rewrites your local files to match the snapshot of the target branch.

--------------------------
task 2: branching commands 

1. git branch -a : to list all the git branches2. 
2. git branch <new-branch>    
3. git checkout feature-1
4. git checkout -b feature-2
5. git switch <branch-name>
6. git commit -m "message"
7. git switch master
8. git branch -d <branch-to-delete>
   
-----------------------------
task 3: 

1. on github
2. git remote add origin "....."
3. git push origin master
4. git push origin feature-1
5. changes visible
6. Answer in your notes: What is the difference between origin and upstream
    - origin:
            - your copy
            - your personal fork where you push the changes
            - points to the repo you cloned from
            - defult remote name when you clone a repo

    - upstream:
            - the source of truth
            - original repo(where you pull latest updates)
            - points to the original repo where you forked from
            - custom name commonly used in open-source
-----------------------------

task 4:

1. done
2. git pull origin master
3. git fetch vs git pull:
        - git fetch:
                  - downloads changes from the remote repo
                  - does not modify the current branch/ local working branch
                  - eg download updates but dont install
        - git pull
                  - gets updates and applies them to current branch
                  - modifies current working branch
                  - eg download updates and install updates immediately

-----------------------------

task 5:

1. git clone <url>
2. fork done
3. clone and fork:
    a. defination:
    clone: 
        - creates copy of repo in your local machine
        - no new repo is created on github
    fork:
        - creates copy of repo under github account
        - completely separate from the original repo
  
    b. usecase:
    clone:
        - when working in team repo
        - when you have the push access
  
    fork:
        - when you are to contribute to someone elses repo
        - you dont have the write access

    c. upstream sync:
        - keeping copy updated with the original
        - git remote add upstream <url>
        - git fetch upstream