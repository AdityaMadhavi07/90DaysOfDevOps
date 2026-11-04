
---------------------------------------------------------------------------
Task 1: trigger on pull request

1.  
Github fires a synchronize event whenever you push new commits to an existing Pull request. If you want your workflow to run during specific actions- like when someone pushes new code- you use the "types" filter to isolate the specific activity
pull_request:
    types: [synchronize]


#creating new branch:
git checkout -b day-41-pr-trigger

vi pr-check.yml

name: Pull Request Check

on:
  pull_request:
    branches:
      - main #this checks the target/base branch

    types:
      - opened #runs when PR is created/Run
      - synchronize  

jobs:
  pr-check:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository  # name adds a label to the step in Actions Log
        uses: actions/checkout@v4

      - name: Print Pull request branch
        run: echo "PR check running for Branch: ${{ github.head_ref }}"

        # github.head_ref this gives the source branch name

Note:
The colon in Branch: can confuse YAML because run was unquoted. Quote the whole command:
This makes YAML treat it as a single string

2. git push -u origin day-41-pr-trigger
Git will know which remote branch to push to or pull from. You typically only need -u the first time you push a new local branch.
   
3. now when we push, the pipeline runs, and when we go to the Pull_request Tab on Github

---------------------------------------------------------------------------
Task 2: Scheduled Trigger

1. trigger should run the pp everyday at midnight UTC
   0 0 * * * 

vi schedule.yml

name: Daily Schedule Workflow

on:
  schedule:
    - cron: "0 0 * * *"

  workflow_dispatch:    #allows to manually test the workflow

jobs:
  schdeuled-job:
    runs-on: ubuntu-latest

    steps:
      - name: Print Scheduled Message
        run: echo "This workflow is scheduled to run at midnight UTC"

      - name: Print Current date and time
        run: date


2. Scheduled workflows generally run from the default branch, so ensure schedule.yml is eventually present on main.

3. if you add wrong name to the file then the trigger event wont take place.
   Any schedule will only work on default brnach like main/master
---------------------------------------------------------------------------
Task 3: Manual Trigger with Input

1. vi manual.yml, this must: run manually, ask for env, print the selected value

name: Manual Trigger Pipeline

on:
  workflow_dispatch:
    inputs:     # defines the values user must provide before starting the workflow
      environment:      # input name
        description: Select the target Environment
        required: true
        default: staging
        type: choice        # shows a dropdown
        options:        # values in dropdown
          - staging
          - production

jobs:
  show-environment:
    runs-on: ubuntu-latest

    steps:
      - name: Print selected environment
        run: echo "Selected environment is ${{ inputs.environment }}"
  

Note: 
- input name can be referenced as: ${{ inputs.environment }}
- If the Run workflow button is not visible, verify that manual.yml has been pushed to the repository's default branch, normally main.

---------------------------------------------------------------------------
Task 4: Matrix Builds

- Matrix lets you execute same job with different configs
  
1.  vi matrix.yml

name: Matrix Build

on:
  push:
    paths:
      - ".github/workflows/matrix.yml"    
      # this is path filter, workflow will run only if changes are made in the matrix.yml file
  
  workflow_dispatch:
    
jobs: 
  test-python:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        python-version:
          - "3.10"  # "" quoting ensures, yaml treats version as string
          - "3.11"
          - "3.12"
    
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Install Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Print Python Version
        run: Python --version

Note: Understanding the code
    1. github creates one job for every value (each version)
    2. value of python version: matrix.python-version
    3. in github Actions, strategy controls how a job runs. A matrix under it tells GitHub to create a separate run of that job for each value or combination

2. adding 2 OS:
   
name: Python Matrix Build

on:
  push:
    paths:
     - ".github/workflows/matrix.yml"
  
  workflow_dispatch:

jobs:
  test-python:
    name: Python ${{ matrix.version }} on ${{ matrix.os }}

---------------------------------------------------------------------------
Task X:




---------------------------------------------------------------------------
Task X:




---------------------------------------------------------------------------
Task X:




---------------------------------------------------------------------------
Task X:




