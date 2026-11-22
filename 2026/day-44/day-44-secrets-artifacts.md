
-------------------------------------------------------------
Task 1: gihub secrets

1. Repo -> settings -> secrets and variables -> actions- > secrets -> new repo secrets
  GitHub officially uses Secrets and variables → Actions section from repo settings.
  
2. vi secrets-demo.yml

name: Secrets-Demo

on:
  workflow_dispatch:
  push:
    paths:
      - ".github/workflows/secrets-demo.yml"

jobs:
  secret-demo:
    runs-on: ubuntu-latest

    steps:
      - name: Check whether secret is configured
        env:
          MY_SECRET_MESSAGE: ${{ secrets.MY_SECRET_MESSAGE }}
        run: |  #Shell syntax requires spaces around [ and ]:
          if [ -n "$MY_SECRET_MESSAGE" ]; then
            echo "the Secret is set: true"
          else
            echo "The secret is set: false"
            exit 1
          fi

      - name: Demonstarting Github secret Masking
        env:
          MY_SECRET_MESSAGE: ${{ secrets.MY_SECRET_MESSAGE }}
        run: |
          echo "Github masked output: $MY_SECRET_MESSAGE"
         
3. Never print secrets in CI=Logs:
   - they can be accessible to decvelopers, admins, support or externam systems
   - to avoid misuse

4. real life usecase:
   - db pwd
   - sonarqube tokens

-------------------------------------------------------------
Task 2: using secret as env variableartifacts-demo

1. vi secret-as-env-var.yml

name: secret-as-env-var.yml

on:
  workflow_dispatch:

jobs: 
  secret-demo:
    runs-on: ubuntu-latest
      
    steps:
      - name: Use secret through env variable
        env:
          MY_SECRET_MESSAGE: ${{ secrets.MY_SECRET_MESSAGE }}
        run: |
          echo "Secret length: ${#MY_SECRET_MESSAGE}"

          if [ -n "$MY_SECRET_MESSAGE" ]; then
            echo "Secret was recieved Successfully"
          else
            echo "Secret was not recived"
            exit 1
          fi

2. we can also get the length of the token

-------------------------------------------------------------
Task 3: Upload Artifacts

1. artifact: 
   - file or collection of files that produces a workflow job
   - they allow to preserve the output and also share the data between 2 diff jobs of same workflow
   - eg- test reports, logs, screenshots

vi artifacts-demo.yml

name: artifacts-demo.yml

on: 
  workflow_dispatch:

jobs:
  secret-demo:
    runs-on: ubuntu-latest


    steps:
      - name: Create Test Report
        run: |
          mkdir -p reports

          {
            echo "Day 44 test report"
            echo "============="
            echo "Status: Passed"
            echo "Runner OS: $RUNNER_OS"
            echo "Commit SHA: $GITHUB_SHA"
            echo "Workflow: $GITHUB_WORKFLOW"
            echo "Generated at: $(date -u)"
          } > reports/test-report.txt
               
      - name: Display Generated Report
        run: cat reports/test-report.txt

      - name: Upload Test Report
        uses: actions/upload-artifact@v4
        with:
          name: test-report   #artifact will be displayed with this name
          path: reports/test-report.txt
          retention-days: 7
          if-no-files-found: error

          
   
-------------------------------------------------------------
Task 4: Download Artifacts between jobs

name: artifacts-btn-jobs

on:
  workflow_dispatch:

jobs:
  generate-report:
    runs-on: ubuntu-latest

    steps:
      - name: generate deployment information
        run: |
          mkdir -p output

          {
            echo "Application: github-action-pract"
            echo "Environment: test"
            echo "Commit: $GITHUB_SHA"
            echo "build status: ready"
          } > output/build-info.txt

      - name: upload build information
        uses: actions/upload-artifact@v4
        with:
          name: build-information
          path: output/build-info.txt
          retention-days: 7
          if-no-files-found: error

  consume-report:
    runs-on: ubuntu-latest
    needs: generate-report
      
      steps:
        - name: download build information
          uses: actions/download-artifact@v4
          with:
            name: build-information
            path: downloaded-artifact
            
        - name: List downloaded files
          run: find downloaded-artifact -type f

2. artifacts are needed when:
   - pp needs to preserve or share files created during a workflow
   - test reports, coverage reports, build metadata
   - they are used when 1 job build the application and other tests/deploys same build output

-------------------------------------------------------------
Task 5: running real test in CI

-------------------------------------------------------------
Task 6: Dependency Caching

1. goal of caching is to save the dependencies from being downloaded from internet during a workflow run

