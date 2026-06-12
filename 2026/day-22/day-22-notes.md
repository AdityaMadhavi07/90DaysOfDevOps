
------------------------------------------------------------------------------------------------
task 1:

1. mkdir wk 3
2. git init
3. git status

------------------------------------------------------------------------------------------------
task 2:

1. mkdir devops-git-practice
2. git init
3. git status
4. ll ;  cd .git/ ;  ls -lrt ;  
   - this stores the meta data + history + configuration of the git repository
   - description: simple text file, stores description of the repo
   - config: contains repo specific settings
   - HEAD: pointer for current branch, lets git know about the current working branch, used at the time of checkout/commit
   -  refs: stores the pointers of branches and tags, nick names for commit hashes.
   -  objects: actual DB of git, all commits , files and tress are stored here
   -  hooks: contains custom script that runs on git events: pre-commit, post-commit, pre-push. like triggering CI/CD, automating testing
   -  info: stores extra info of the repo

------------------------------------------------------------------------------------------------
task 3:

1. 
    a. set up and config
        - git init : this initializes the github repo
        - git config --global user.name "username"
          git config --global user.Email "usermail"
          through the above 2 commands we connect the local git to the remote github, we give the credentials to connect the github

    b. basic workflow
        - vi samplefile.txt
                - a file is created .. goes in untracked state (red)
        - git add <filename>
                - file gets ready to be saved. (not saved), this is still not added to the history
                - file goes to staged state (green)
        - git commit -m "message"
                - file gets saved/commmited to github
                - tracked state

    c. viewing changes
        - git status



------------------------------------------------------------------------------------------------

task 4:

1. done in task 3
   
------------------------------------------------------------------------------------------------

task 5:

done

------------------------------------------------------------------------------------------------

task 6:

1. git add and git commit
    - git add : it moves the changes from untracked to staged state
    - git commit : it moves the changes from staged to the trakced state
  
2. staging area appears after git add. git does not commit directly as we can still undo the chanegs /staged state (git restore --staged). this allows us to save changes intensionally . Not all changes we do are to be commited. So with staging state we can add only selected changes and not all changes at once.

3. git log shows us the commit history of the repo, auther name , time and commit message

4. the .git/ folder is the heart of git repository, if we delete it, the folder becomes normal, no version tracking is possible. no  git operations can be performed

5. 
working directory: current project folder
staging area: temporary area where we decide change commits
repo: permanent storage of commits

------------------------------------------------------------------------------------------------





