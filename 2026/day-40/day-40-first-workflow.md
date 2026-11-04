
-----------------------------------------------------------
Task 1:

github actions is stored in .github/workflows folder of repository. workflow is triggered by events like push and executes job on runner machine

1. cloned a github repo and created a folder structure: .github/workflow
   
-----------------------------------------------------------
Task 2:

1. hello.yml:
<!-- #no identation req to name the workflow -->
name: Hello GitHub Actions

<!-- tells when the workflow should run -->
on:
 push:

<!-- job tells what the workflow should do, there can be more than 1 jobs -->
jobs:
 greet:   <!-- creates an ephermal container with ubuntu running>
  runs-on: ubuntu-latest

  steps:    <!-- ephermal container will have steps to execute>
   - name: Checkout repository code
     uses: actions/checkout@v4

   - name: Pring Greeting message
     runs: echo "Hello from GitHub Actions!"
  
2. workflow explained:
   code pushed --> github detects hello.yml --> workflow starts --> greet job gets started on ubuntu runner --> repo code gets checkedout --> greeting mess is printed --> pp becomes green

    repo code gets checkedout: means the CI/CD pipeline downloads a fresh copy of your source code from GitHub onto the build server so it can be tested and built.

3. every matching push event creates a new workflow run-trigger. Github actions executes workflow into jobs and steps 
   
-----------------------------------------------------------
Task 3: Understanding the workflow anatomy:

name: Hello Github Actions
- this defines the display name of the workflow. this is seen in actions tab of github repo

on:
- defines workflow trigger. this answers- when should workflow run

jobs:
- collection of jobs excuted under workflow, here the job id- greet

runs-on: ubuntu-latest
- job will execute on which type of runner-machine/OS

steps:
- these are the tasks that are sequentially executed in a Job

name(on a step): (step level name)
- provides a readable display name to the step in action Logs

uses: actions/checkout@v4
- executes an existing reusable github action

run:
- this executes command on shell of runner machine
- runs the cmd on terminal of runner machine

-----------------------------------------------------------
Task 4: adding more steps

1. 
name: Hello GitHub Actions
 
on: push

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository Code
        uses: actions/checkout@v4

      - name: Print greeting message
        run: echo "Hello from Github Actions!"

      - name: Display Date and Time
        run: date

      - name: Display Branch name
        run: echo "Triggered from branch ${{ github.ref_name }}"

      - name: Listing Files in Repo
        run: ls -la

      - name: Display runners OS
        run: echo "Runner OS is $RUNNER_OS"


  **Note: 
    "uses" is only for github actions or reusable actions not for shell commands
    "run" executes all shell commands
    github provides built-in variables like ${{ github.ref_name }} for branch name
     
-----------------------------------------------------------
Task 5: Breaking pp on purpose

1. A failed GitHub Actions workflow is shown as unsuccessful in the Actions tab. To troubleshoot it, I open the failed workflow, select the failed job, and expand the failed step. The logs show the executed command and the associated error/exit code, which helps identify the root cause.
