
task 1: install and authenticate:

1. win + x
    gh --version 
2. gh auth login 
3. gh auth status
4. authentication methods supported by github:
    - browser based token (OAuth)
    - PAT
    - SSH auth

-------------------------------------------------
task 2: working with repositories:

1. to create a new repo from terminal and make it public with readme
    gh repo createa <reponame> --public --clone --add-readme

2. cloning a repo
    gh repo clone <username/reponame>
    git repo clone AdityaMadhavi07/brave

    automatically uses github authentication 
    no need to manually manage ssh/https

3. repo details:
    gh repo view <reponame>
    
4. list all repos:
    gh repo list
    gh repo list --limit 50

5. open repo in browser:
   gh repo view <reponame> --web  or
   gh browse  

6. deleting git repo:
   gh repo delete <reponame>
    deletes the repo permanently

-------------------------------------------------
task 3: issues:

1. creating issue on terminal and giving it a title, body and label:
    - gh issue create --title "  " --body "  " --label "  "
    - to add an issue you must be in a gh repo, so create one and then cd into that repo, do gh status, if o/p comes then good to go
  - note after creating the issue and doing gh status, assigned issues shows nothing as, it is not assigned to anyone
  - --assignee "@me"
  - gh issue create --title "Bug: Login not working" --body "user unable to login using valid credentials" --label "bug" --assignee "@me"


2. list all open issues: gh issue list
    - gh issue --assignee "@me"
    - gh issue list --state open

3. view specific issue by its number:
    - gh issue view n  (n= issue number)
    - gh issue view n --web  (to view in browser)

4. closing an issue:
    - gh issue close n 
    - gh issue close n --comment "closing message"

5. How could you use gh issue in a script or automation?
   - The gh issue command can be used in scripts or automation to programmatically create, manage, and track issues. For example, it can be integrated into CI/CD pipelines to automatically create issues when a build fails or when errors are detected. 

    if [ $? -ne 0 ]; then
      gh issue create --title "Build Failed" --body "Pipeline failed in step X"
    fi

    - usecase: 
        - ci/cd  failure automation
        - monitoring alerts
        - bug tracking automation
        - scheduled cleanup (auto identify and close issues)
        - integration with devops tools- jenkins, github actions and azure devops
        - gh issue can be used in automation scripts to dynamically create and manage issues based on events like build failures, monitoring alerts, or bug detection, enabling efficient DevOps workflows.


-------------------------------------------------
task 4: pull requests:

1. Create a branch, make a change, push it, and create a pull request entirely from the terminal

git checkout -b <branchname>
git add .
git commit -m "commit message"

git push origin <branchname>

gh pr create --title "  " --body "  " --base main --head <changedbranch>

gh pr create --title "added sample.txt" --body "to test the pull operation via terminal to remote GH" --base main --head feature-gh


2. List all open PRs on a repo
   
   - gh pr list


3. View the details of your PR — check its status, reviewers, and checks

    - gh pr view n
    - gh pr view n --web


4. Merge your PR from the terminal

    - gh pr merge n --merge
    - gh pr merge n --squash
    - gh pr merge n --rebase


5. Answer in your notes:
   
    a. What merge methods does gh pr merge support?

    - github cli supports 3 mege methods:
      - merge commit (--merge)
      - squash merge (--squash)
      - rebase merge (--rebase)
    - by default: If you execute gh pr merge without specifying any of these strategy flags, the GitHub CLI launches an interactive terminal menu. This menu prompts you to select one of the three methods listed above


    b. How would you review someone else's PR using gh?

    - I would use GitHub CLI to fetch the PR locally, review changes, and then comment or approve using CLI commands.

-------------------------------------------------
task 5: github actions and workflows:

1. gh run list --repo owner/repo
this shows the list of CI/CD workflows executed in the repo

2. view status of the specific workflow run:
gh run list --repo owner/repo   (get RUN_ID from here)
gh run view RUN_ID --repo owner/repo

To see logs: gh run view RUN_ID --log

3. How could gh run and gh workflow be useful in a CI/CD pipeline?
   - gh run and gh workflow help manage and monitor CI/CD pipelines directly from the terminal, enabling automation, debugging, and faster feedback without needing the GitHub UI.
   - Using gh run and gh workflow, we can monitor, trigger, and debug CI/CD pipelines directly from the terminal or scripts, enabling faster automation and better observability in DevOps workflows.


-------------------------------------------------

task 6:

1. gh api <arg> — make raw GitHub API calls from the terminal
2. gh gist <cmd> — create and manage GitHub Gists
    gist is small code storage to save short scripts /notes/files
    Gists are like mini Git repositories for quickly sharing and versioning small pieces of code or notes.

    to create a gist you need to have that file present already

3. gh release <cmd> — create and manage releases
4. gh alias — create shortcuts for commands you use often
    - gh alias set <alias-name> "<actualcommand>"
    - gh alias set webview "repo view --web"
  
    - gh alias delete <aliasname>
    - gh alias delete webview

5. gh search repos — search GitHub repos from the terminal
6. gh help and gh <command> --help are your best friends
7. Most gh commands work with --repo owner/repo to target a specific repo
   
8. Use --json flag with most commands to get machine-readable output (useful for scripting)
    - json makes gh CLI script-friendly by returning structured, machine-readable output.
    - gh repo list --json name,visibility,description,updatedAt


9.  gh pr create --fill auto-fills the PR title and body from your commits
