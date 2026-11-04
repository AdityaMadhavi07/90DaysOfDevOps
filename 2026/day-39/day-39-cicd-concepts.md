-----------------------------------------------------------------------------
Task 1: the problem

1. if 5 developers deploy manually then:
   - different deploymnet verisons
   - certain deployment step can go missing
   - slow and inconsistent deployments
   - to track the changes
   - code conflicts, 2 developers modify the same file
   - diff env (machine with Java 17 and java 11)
   - 
2. due to the different env, it works on my machine problem occurs:
   - diff pkg versions
   - local db setup
3. like this team can safely deploy in few times a day. with CI/CD tema can deploy in dozens , hundreds and 1000s :
   - diff env versions, node.js versions, missing libs, os settings

-----------------------------------------------------------------------------
Task 2: CI vs CD

1. continuous integration:
    - every commit triggers automated build and testing to detect issues early    
    - when code is pushed to github: build runs --> unit test runs --> lint checks run
    - Build + Test

2. continuous delivery:
    - after CI, app is auto prepared and made ready for deployment
    - build --> test --> docker --> ready for prod --> human approval req
    - Production Ready

3. continuous deployment:
    - every sucessful change, auto goes to prod without human approval
    - build --> test --> deploy to prod
    - Automatically Live
-----
real-life example:

   - continuous intrgration:
     - Two developers on a payments team push changes to the same service on GitHub. Each pull request automatically runs 400 unit tests plus a linter. A PR that would break the refund calculation fails immediately with a comment on the PR — the bug never reaches main.
   - continuous development:
     - A banking app team's pipeline builds an APK, deploys it to a staging environment, and runs automated smoke tests. Every artifact that passes is release-ready, but a release manager chooses when to promote it to production — e.g., releasing once every two weeks after a compliance review.
   - continuous deployment:
     - Netflix deploys thousands of times per day. A developer merges a change to a web UI service; the pipeline builds, tests, and gradually rolls it out to production with automated health checks — if metrics degrade, the deploy auto-rolls back. No human ever "approves" the release.

-----------------------------------------------------------------------------
Task 3: Pipeline Autonomy

1. trigger
   - what starts the pp
   - git push/pull, schedule, manual click
2. stage
   - major phases of pp, (build , test , deploy)
3. job
   - unit of work inside a stage
   - specific work inside a stage
4. step
   - single cmd inside a job
   - eg - nom install, npm test
5. runner
   - m/c that executes the pp/job
   - gh hosted runner, self-hosted, jenkins agent
6. artifact
   - o/p produced by a job/pp
   - eg - jar files, docker image, zip pkg
   - final o/p generated after the build

-----------------------------------------------------------------------------
Task 4: Drawing a Pipeline

1. developer --> git push --> build --> test --> docker-build --> deploy staging
   
-----------------------------------------------------------------------------
Task 5: Explore in the Wild

1. workflows are present under .github/workflows
2. triggering factor: workflow can be triggered by
   - push: when code is pushed to the master branch
   - pull_request: when pull req is opened, updated or reopened against the master branch
   - workflow_dispatch trigger, this allows maintainers to run pp manually
      on: 
       push:
       pull_request:
       workflow_dispatch:
3. Jobs: 
   jobs:
     build:
     test:
     scan:
4. to know what the job does, look at the names:
   - builds project
   - runs test
   - performs security scanning

-----------------------------------------------------------------------------




