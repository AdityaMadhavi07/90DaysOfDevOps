

-------------------------------------------------------
Task 1: Prepare

1. vi main.py
   
from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def home():
    return jsonify(
        message="Day 45 Docker CI/CD pipeline is working!",
        status="healthy"
    )

@app.get("/health")
def health():
    return jsonify(status="UP"), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

2.  vi test_app.py

from app.main import app


def test_home_endpoint():
    client = app.test_client()

    response = client.get("/")

    assert response.status_code == 200
    assert response.get_json()["status"] == "healthy"


def test_health_endpoint():
    client = app.test_client()

    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json()["status"] == "UP"

3. adding dependencies:
   
   vi requirements.txt

   Flask==3.1.2
   pytest==9.0.1
   gunicorn==23.0.0

4. creating dockerfile 


from python:3.12-slim #using lightwt python base image

workdir /app

copy requirements.txt . #dependencies are first installed/copied for better caching

run pip install --no-cache-dir -r requirements.txt

copy app/ ./app/ #app code getting copied to container

expose 5000

cmd["gunicorn", "--blind", "0.0.0.0:5000", "app.main:app"] 

#Gunicorn (Green Unicorn) is a production-grade WSGI HTTP server used to run Python web applications like Flask. 


5. creating dockerignore:
   .dockerignore

6. testing before CI (local Build):
   python -m pip install -r requirements.txt
   pytest -v

   docker build -t day45-docker-app:local

   docker images

7. running containers:
   docker run -d \ 
   --name day-45-app \
   -p 5000:5000 \
   day45-docker-app:local


8. health check: curl http://localhost:5000/health
9. docker logs day45-app
10. cleanup:
    docker stop day45-app
    docker rm day45-app

-------------------------------------------------------
Task 2: build docker image in CI

1. vi docker-publish.yml

name: Docker Build and Publish to GHCR

on:
  workflow_dispatch:

#defining gh token permissions of workflow
permissions:
  contents: read
  packages: write

env: 
  REGISTRY: ghcr.io

jobs:
  test-build-publish:
    name: Test,Build and Publish
    runs-on: ubuntu-latest

    steps:
      - name: Checkout source code
        uses: actions/checkout@v4

      - name: Prepare image name #this is to generate lowercase ghcr img name
        id: image
        shell: bash
        run: |
          echo "name=${IMAGE_NAME}" >> "$GITHUB_OUTPUT"
          echo "Image: ghcr.io/${IMAGE_NAME}"

      - name: Generate short commit SHA
        id: commit
        shell: bash
        run: |
          echo "short_sha=${SHORT_SHA}" >> "$GITHUB_OUTPUT" #we create this as o/p for later workflow steps
          echo "Short SHA: ${SHORT_SHA}"

      - name: Set up Docker Buildx #this is to configure the builder
        uses: docker/setup-buildx-action@v3

      - name: Build image without publishing
        if: github.event_name == 'pull_request' || github.ref != 'refs/heads/main'
        uses: docker/build-push-action@v6
        with: #we define the inputs here
          context: .
          file: ./Dockerfile #uses dockerfile of root directory
          push: false
          tags: ghcr.io/${{ steps.image.outputs.name }}:validation-${{ steps.commit.outputs.short_sha }}
          #giving a meaningful tag to the validation
          cache-from: type=gha #gh actions docker-layer will restore the cache
          cache-to: type=gha,mode=max #updated docker layer will be saved in cache

-------------------------------------------------------
Task 3: push image to GHCR

1. why we upload the docker image in ghcr?
   - same tested image can be pulled by server, k8 cluster or another machine
  
2. adding logging step in .yml workflow

    - name: Login to GHCR
      if: github.event_name == 'push' && github.ref == 'refs/heads/main'
      uses: docker/login-action@v3
      with: #defining logging inputs
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{secrets.GITHUB_TOKEN }}

    why we do this?
    - registry credentials can only be shared with trusted main push, not with featured branch or PRs

3. pushing sha tags:
   
   - name: build and push image to GHCR
     if: github.event_name == 'push' && github.ref == 'refs/heads/main'
     uses: docker/build-push-action@v6
     with: 
       context: . #repo root is made the build context
       file: ./Dockerfile
       push: true
       tags: |
         ghcr.io/${{ steps.image.outputs.name }}:sha-${{ steps.commit.outputs.short_sha }}
       cache-from: type=gha #downloading earlier cache from gh actions server
       cache-to: type=gha,mode=max 
       #cache from current build to be saved in gh actions server, by default mode=min, docker saves only those img that are part of final image. mode=max includes all intermediate layers

4. adding files like:
   git add .github/workflows/docker-publish.yml Dockerfile .dockerignore
       
5. how to verify GHCR image:
   - check in pkg section the expected tags
   - check local commit SHA; 
     - git rev-parse --short HEAD 
    
-------------------------------------------------------
Task 4: Push only from main

1. creating a feature branch:
   git checkout main
   git pull origin main
   git checkout -b branch_name

-------------------------------------------------------
Task 5: Adding status badge

1. badge readme shows CI pp status quickly

-------------------------------------------------------
Task 6: Pull and run GHCR image

2. pulling public image:
   docker pull ghcr.io/GITHUB_USERNAME/github-actions-practice:latest

3. running image:
   docker run -d \
     -name day45-ghcr-app \
     -p 5000:5000 \
     ghcr.io/GITHUB_USERNAME/github-actions-practice:latest

  verification step:
  docker ps
  curl http://localhost:5000/health
  docker logs day45-ghcr-app

-------------------------------------------------------





