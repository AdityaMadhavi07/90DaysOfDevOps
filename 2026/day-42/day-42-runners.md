Runners:
    It is a machine that executes the steps defined inside a Github Actions Workflow
Github Hosted Runner:
    - temporary virtual machine provided and managed by Github.
    - creates VM, installs tools, maintains OS
    - applies updates
Self-Hosted Vendor:
    - this is our own machine connected to github actions
    - this can be local linux computer,aws ec2 instance, azure vm , on-prem server
    - container or k8s based runner
----------------------------------------------------------------------
Task 1: Github Hosted runners

1. github hosted runners:

hosted-runners.yml

name: Github Hosted runners Demo

on:
  workflow_dispatch:
  push:

jobs:
  ubuntu-latest:
    name: Ubuntu Runner
    runs-on: ubuntu-latest

    steps:
      - name: Print Ubuntu runner info
        shell: bash
        run: |
          echo "Operating System:"
          uname -a

          echo "Hostname:"
          hostname

          echo "Current-User:"
          whoami

  windows-latest:
    name: Windows-Server
    runs-on: windows-latest
    steps:
      - name: Print Windows runner info
        shell: pwsh
        run: |
          write-Host "Operating system:"
          Get-CimInstance Win32_OperatingSystem |
          Select-Object Caption, Version, OSArchitecture

          Write-Host "Hostname:"
          hostname

          Write-Host "Current-User:"
          whoami          

  macos-latest:
    name: MacOS Runner
    runs-on: macos-latest
    steps:
      - name: Print macos runner info
        shell: bash
        run: |
          echo "Operating System:"
          sw_vers

          echo "Hostname:"
          hostname

          echo "Current user"
          whoami
        
  

----------------------------------------------------------------------
Task 2: Exploring what is pre-installed

1. adding a job under- ubuntu-latest runner


preinstalled-tools:
    name: Check pre-installed tools
    runs-on: ubuntu-latest

    steps:
      - name: Print Tool Versions
        run: |
          echo: "Docker-Version:"
          docker --version

          echo: "Python-Version: $(python --version)"

          echo: "Node Version:"
          node --version

          echo: "Git Version:"
          git --version


indentation must be like:

jobs:
  ubuntu-job:
    # steps

  windows-job:
    # steps

  macos-job:
    # steps

  preinstalled-tools:
    # steps

Note: 
- if your local is behind the remote , then do 
    git fetch origin
    git status
    git pull origin main

- importance of pre-installed  tools:
    reduce set-up time, makes build faster
    reduce workflow complexity
    provide easy to use CI/CD env

-if app needs specific version then:
    actions/setup-node
    actions/setup-java

- to start the runner: sudo ./svc.sh start
- to stop the runner: sudo ./svc.sh stop

----------------------------------------------------------------------
Task 4: Using self-hosted runner

1. vi self-hosted.yml

name: Self-Hosted Runner Demo

on:
  workflow_dispatch:

jobs:
  self-hosted-job:
    name: Run on my linux machine
    runs-on: self-hosted

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Print machine information
        shell: bash
        run: |
          echo "Runner name: $RUNNER_NAME"
          echo "Runner OS: $RUNNER_OS"
          echo "Runner architecture: $RUNNER_ARCH"

          echo "Machine Hostname: $(hostname)"
          echo "Current User: $(whoami)"
          echo "Current Working Directory: $(pwd)"

      - name: Create Verification File
        shell: bash
        run: |
          echo "Created by GitHub Actions" > self-hosted-proof.txt
          echo "Runner: $RUNNER_NAME" >> self-hosted-proof.txt
          echo "Repository: $GITHUB_REPOSITORY" >> self-hosted-proof.txt
          echo "Workflow run ID: $GITHUB_RUN_ID" >> self-hosted-proof.txt
          echo "Created at: $(date)" >> self-hosted-proof.txt

      - name: Verify File
        shell: bash
        run: | 
          echo "File Details:"
          ls -l self-hosted-proof.txt

          echo "File contents:"
          cat self-hosted-proof.txt


Note:
- It won't start by itself. That's the whole difference between GitHub-hosted vs self-hosted. GitHub-hosted (ubuntu-latest): GitHub starts a VM for you on every run. Self-hosted (self-hosted): You have to start the runner. If it's Offline, GitHub cannot start it.
- do .run.sh in cd ~/gitactions/github-actions-practice/actions-runner
- this will start the runner
- ./run.sh = foreground job - you stop it with Ctrl+C in terminal
- sudo ./svc.sh start = background service via systemd - Ctrl+C does NOT stop it
- we can find the file under: cat _work/REPOSITORY_NAME/REPOSITORY_NAME/self-hosted-proof.txt
  - why path is repeated? One directory is the runner pipeline workspace, and the next is the actual checked-out repository working directory. Runner directory commonly follows this structure
- do not treat self-hosted runner workspace as permanent storage as: Ephemeral runners may be deleted after one job.
  
----------------------------------------------------------------------
Task 5: Adding labels

Github uses labels and groups to route a job to an online and idle matching runner

1. add a new label: my-linux-runner from the Github

2. Ealier: 
   runs-on: self-hosted
   Now:
   runs-on: [self-hosted, linux, my-linux-server]

   now for the job to be executed by the runner, the label present in the runs-on line must be added in the self-hosted runner

Note:

1. Labels are useful when you have multiple runners with different operating systems, tools, environments or hardware.
2. Labels are identifiers used to describe runners and route jobs to machines with matching characteristics.
3. A runner need to match every label in runs-on
4. Default labels: self-hosted, OS label, Architechture label
   
----------------------------------------------------------------------
Task 6: 

GitHub-Hosted vs Self-Hosted
Area	GitHub-hosted	Self-hostedWho manages it?	GitHub	User or organization
Cost	Based on repository type, plan, allowances, and runner usage	Machine cost and maintenance are paid by the owner
Pre-installed tools	Many tools are provided	User installs and manages tools
Good for	Standard CI, builds and tests	Custom software, private networks and special hardware
Maintenance	GitHub manages it	User manages OS, software, capacity and updates
Customization	Limited	High
File persistence	Normally temporary	Files may remain unless cleaned
Security concern	Secrets and workflow permissions	Untrusted code, retained files, internal network and machine credentials

