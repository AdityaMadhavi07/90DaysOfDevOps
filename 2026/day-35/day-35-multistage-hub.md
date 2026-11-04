Task 1: The Problem with Large Images
1. Write a simple Go, Java, or Node.js app (even a "Hello World" is fine)
    in app.js:
    console.log("hello world!");

    in package.json:
    {
        "name":"hello-world",
        "version": "1.0.0",
        "main": "app.js"
    }


2. Create a Dockerfile that builds and runs it in a **single stage**
    FROM node:22-alpine
    WORKDIR /app
    COPY package.json
    COPY app.js
    CMD ["node", "app.js"]

    docker build -t hello-single .

3. Build the image and check its **size**
    docker images hello-single


Note down the size — you'll compare it later.
IMAGE                 ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-single:latest   9d695921bd49        230MB         57.4MB        

-----------------------------------------------------------------

Task 2: Multi-Stage Build
1. Rewrite the Dockerfile using **multi-stage build**:
   - Stage 1: Build the app (install dependencies, compile)
   - Stage 2: Copy only the built artifact into a minimal base image (`alpine`, `distroless`, or `scratch`)

    ----multi-stage Dockerfile:----

    Stage 1- Build
    FROM: node:22-alpine AS builder
    WORKDIR /app
    
    COPY package.json .
    COPY app.js

    Stage 2 - Runtime
    FROM: alpine:latest
    RUN apk add --no-cache nodejs

    WORKDIR /app

    COPY --from=builder /app/app.js
    COPY --from=builder /app/package.json .

    CMD ["node", "app.js"]


2. Build the image and check its size again
    docker build -t hello-multistage .
    docker images hello-multistage
    
    IMAGE                     ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-multistage:latest   95dfd0130d9e        113MB         31.1MB 

3. Compare the two sizes. Write in your notes: Why is the multi-stage image so much smaller?
   multi-stage is smaller as:
   - build tools are not included in final image
   - only the required runtime artifacts are copied
   - smaller base image
   - reduced attack surface
   - faster deployment
  
Multi-stage builds separate the build environment from the runtime environment. This allows Docker to discard all unnecessary files and dependencies from the final image, resulting in a significantly smaller, more secure, and more efficient container image.

-----------------------------------------------------------------

Task 3: Push to Docker Hub

1. login through terminal:
    echo <github token> | docker login ghcr.io -u <github_username> --password- stdin

2. Tag the Image:
    docker tag myapp:1.0 ghcr.io/yourusername/myapp:1.0

3. Push the Image:
    docker push ghcr.io/yourname/myapp:1.0

4. verify:
    docker pull ghcr.io/yourusername/myapp:1.0

-----------------------------------------------------------------

Task 4: Docker Hub Repository

1. Go to Docker Hub and check your pushed image
    docker push ghcr.io/yourusername/myapp:1.0
    package name - myapp

2. Add a **description** to the repository
    LABEL org.opencontainers.image.title="myapp"
    LABEL org.opencontainers.image.description="Simple Node.js hello-world app built with multi-stage Docker build"
    LABEL org.opencontainers.image.source="https://github.com/<your-github-username>/<your-repo-name>"
    LABEL org.opencontainers.image.version="1.0.0"

3. Explore the **tags** tab — understand how versioning works
    - tag is a label that points out a specific version to the image
    - immutable identity of an image is Digest
    - Tags points out to this digest
    - tags represent different versions of the image

    docker tag myapp ghcr.io/<your-github-username>/myapp:1.0.0
    docker tag myapp ghcr.io/<your-github-username>/myapp:latest
    docker push ghcr.io/<your-github-username>/myapp:1.0.0
    docker push ghcr.io/<your-github-username>/myapp:latest


4. Pull a specific tag vs `latest` — what happens?
    specific tag pull:
        docker pull ghcr.io/adityamadhavi07/myapp:1.0.0
    latest pull:
        docker pull ghcr.io/adityamadhavi07/myapp:latest

-----------------------------------------------------------------

Task 5: Image Best Practices
Apply these to one of your images and rebuild:

1. Use a **minimal base image** (alpine vs ubuntu — compare sizes)
ubuntu based image and alpine based image:
----
bigger image dockerfile:

FROM node:22 
WORKDIR /app
COPY package.json ./
COPY app.js ./
CMD ["node", "app.js"]

docker build -t hello-node-full -f Dockerfile.full .
----
smaller image dockerfile:

FROM node:22-alpine
WORKDIR /app
COPY package.json ./
COPY app.js ./
CMD ["node", "app.js"]

docker build -t hello-node-alpine -f Dockerfile.alpine .

Note: alpine image is usually much smaller compared to Debian/Ubuntu based image
alpine base image is lightweight, 
small image = fast pull + fast deployment + lower usage

2.  **Don't run as root** — add a non-root USER in your Dockerfile

FROM node:22-alpine
WORKDIR /app

COPY package.json ./
COPY app.js ./

RUN chown -R node:node /app
USER node

CMD ["node", "app.js"]

docker build -t hello-nonroot .
docker run --rm hello-nonroot
docker run --rm --entrypoint sh hello-nonroot -c "whoami"

note: 
non-root user reduces the attack surface area. even if container gets compromised, attacker does not get the privilage of non-root user

3. Combine `RUN` commands to **reduce layers**

RUN aprk update && apk add -no-cache nodejs npm

- each RUN creates a new layer
- write multiple cmds under single RUN to reduce the layer count
- using --no-cache in alpine is preffered as it does not store extra cache files


4. Use **specific tags** for base images (not `latest`)
FROM node:22.17.1-alpine3.22

- predictable build
- same env everytime
- less future breakage
- avoid unexpected updates coming from 'latest'


Check the size before and after.

- alpine-based image is smaller then full ubuntu/debian-based image
- running as a non-root improoves security
- combining RUN commands reduces layers
- using specific base image tags improoves reproducibility and stability
- final image becomes smaller, safer and more predictable
-----------------------------------------------------------------