
Task 1: Multijob Workflow

1. 
name: Multi-Job Workflow

on:
  push:
  workflow_dispatch:


jobs:
  build:
    runs-on: ubuntu-latest


    steps:
      - name: Build Process of Application
        run: echo "Building the app"
        
  test:
    runs-on: ubuntu-latest
    needs: build

    steps:
      - name: Testing the application
        run: echo "Running tests"

  deploy:
    runs-on: ubuntu-latest
    needs: test

    steps:
      - name: Deploying application
        run: echo "Deploying....."


Note:
- install actionlint to catch all the small mistakes
  
---------------------------------------------------------------------------------------

Task 2: Env variables

1. 
name: Environment Variables

on: 
  push:
  workflow_dispatch:

env:
  APP_NAME: myapp

jobs:
  show-env variables:
    runs-on: ubuntu-latest

    env: 
      ENVIRONMENT: staging

    steps:
      - name: Print all Env_variables
        env:
          VERSION: 1.0.0
        run: |
          echo "Application name: $APP_NAME"
          echo "Environment: $ENVIRONMENT"
          echo "Version: $VERSION"


      - name: Print Github Context Variables
        run: |
          echo "Commit SHA: ${{ github.sha }}"
          echo "Triggered by: ${{ github.actor }}"

---------------------------------------------------------------------------------------

Task 3: Passing Outputs between Jobs

1. 

name: Job Outputs

on:
  workflow_dispatch:
  push:

jobs:
  generate-date:
    runs-on: ubuntu-latest

    #converting step output into a job output
    outputs:
      current-date: ${{ steps.date-step.outputs.date }}

    steps:
      - name: Generate Todays Date
        id: date-step
        run: echo "date= $(date '+%Y-%m-%d')"  >> "$GITHUB_OUTPUT"

      - name: Print date in producer job
        run: echo "Generated date is ${{ steps.date-step.outputs.date }}"

  display-output:
    runs-on: ubuntu-latest
    needs: generate-date

    steps:
      - name: Print date from previous job
        run: echo "Date recieved from first job is ${{ needs.generate-date.outputs.current-date }}"

Note:
- if output of a step is to be referenced then it must have an ID
- Job outputs allow one job to generate a value and make it available to dependent jobs. This is useful when later jobs need information calculated during an earlier job, such as an application version, Docker image tag, deployment environment, artifact name, release number, or build result.
- Each GitHub Actions job normally runs on a separate runner. Therefore, regular shell variables created in one job are not automatically available in another job.
- job o/p = small text values, artifacts = files, cache = reusable dependencies, secrets = sensitive info

---------------------------------------------------------------------------------------

Task 4: Conditionals

1. 
name: Conditionals Practice

on:
  push:
  pull_request:
  workflow_dispatch:

jobs:
  conditional-steps:
    runs-on: ubuntu-latest

    steps:
      - name: Run only on main branch
        if: github.ref == 'refs/heads/main' #for a dev branch ref= refs/heads/feature/dev
        run: echo "i am running on main branch"

      - name: Stimulating a non-blocking failure
        id: risky-step
        continue-on-error: true
        run: |
          echo "this step will fail but the job will continue"
          exit 1    #this goes as the outcome

      - name: Run only when a step is failed
        if: steps.risky-step.outcome == 'failure'
        run: echo "This step is running because the previous risky step failed"

      - name: Final Step
        run: echo "workflow continued after the allowed failure"

  push-only-job:
    if: github.event_name == 'push'     #what are other github events?
    runs-on: ubuntu-latest

    steps:
      - name: Confirm Push event
        run: echo "This job runs only for push events"


Note:
- below can be used to run a step on detecting failure:
- name: Run when failure detected/earlier step fails
  if: failure()
  run: echo "One of the previous steps failed"

- continue-on-error: this is useful for optional code-quality checks, experimental tests

---------------------------------------------------------------------------------------

Task 5: Smart Pipeline

1.
name: Smart Pipeline

on:
  workflow_dispatch:
  push:
    branches:
      - "**"    #will run on pushing to any branch

jobs:
  lint:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v4

      - name: Run Lint
        run: |
          echo "Running lint checks"
          echo "Lint completed successfully"
          
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repo
        uses: actions/checkout@v4

      - name: Run Tests
        run: |
          echo "Running tests"
          echo "Tests completed successfully"

        
  summary:
    runs-on: ubuntu-latest
    needs: [lint, test]

    steps:
      - name: Print branch type
        run: |
          if [ "${{ github.ref }} == "refs/heads/main "]; then
            echo "this is a main branch push"
          else
            echo "this is a feature branch push"
          fi

      - name: Print commit information
        env:
          COMMIT_MESSAGE: ${{ github.event.head_commit.message }}
        run: |
          echo "Commit message: $COMMIT_MESSAGE"
          echo "Triggered by: ${{ github.actor }}"
          echo "Branch: ${{ github.ref_name }}"
          echo "Commit SHA: ${{ github.sha }}"

      - name: Print Job results
        run: |
          echo "Lint result: ${{ needs.lint.result }}"
          echo "Test result: ${{ needs.test.result }}"
