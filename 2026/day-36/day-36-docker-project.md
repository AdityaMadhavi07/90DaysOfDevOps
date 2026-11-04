Task 1:

1. pick yr app:
-------------------

Task 2:

1. 
FROM node:18-alpine
WORKDIR  /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]

2. updating the Dockerfile to :
   - multistage
   - non-root user
   - small image (alpine)
   - .dockerignore
  
multistage file:
# STAGE 1- installing prod dependencies
FROM node:18-alpine AS deps 
WORKDIR /usr/src/app

COPY src/package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# stage 2- runtime
FROM node:18-alpine AS runner
WORKDIR /usr/src/app
ENV NODE_ENV=production

# copy only what is needed
COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY --chown=node:node src/ .

# run as non-root
USER node

EXPOSE 3000
CMD ["npm", "start"]

---------
.dockerignore

node-modules
npm-debug.log
.git
.gitignore
Dockerfile*
readme.md
.env
coverage
dist
.vscode



docker build -t demoapp:v1 .
docker run --rm -p 3000:3000 demoapp:v1 .


-------------

Task 3: 

1. docker-compose.yml

# used to define and manage multiple containers at once
# define entire infra in one file

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: demo-app
    ports:
      - 3000:3000
    env_file:
      - .env
    environment: 
      NODE_ENV: production
      DB_HOST: db
      DB_PORT: 5432
      DB_NAME: ${POSTGRES_DB}
      DB_USER: ${POSTGRES_USER}
      DB_PASSWORD: ${POSTGRES_PASSWORD}
    depends_on:
      db:
        condition: service_healthy
    networks:
      - app_net
    restart: unless-stopped

  db:
    image: 
    container_name: 
    env_file:
      - .env
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test:
      interval: 
      timeout: 
      retries: 
      start_period: 
    networks:
      - app_net
    restart: unless-stopped

volumes:
  postgres_data:

networks:
  app_net:
  driver: bridge

2. adding sensitive data in .env:
   POSTGRES_DB
   POSTGRES_USER
   POSTGRES_PASSWORD: 
   PORT = 3000

3. verify:
   docker compose ps
   docker compose up --build -d
   docker compose config

---------------------------------

Task 4:

1. Docker tagging ka matlab image ko duplicate banana nahi hai, balki same image ko alag naam/version dena hai taaki usse registry me push, version manage, aur deployment/rollback easily kiya ja sake.
   
tag:
docker tag demoapp:v1 ghcr.io/adityamadhavi07/demoapp:1.0.0
docker tag demoapp:v1 ghcr.io/adityamadhavi07/demoapp:latest

2. pushing to registry:
   
   note PAT must have write:pkg, read:pkg scopes
$env:GHCR_PAT | docker login ghcr.io -u adityamadhavi07 --password-stdin
docker push ghcr.io/adityamadhavi07/demoapp:1.0.0
docker push ghcr.io/adityamadhavi07/demoapp:latest

Docker image push fail ho raha tha because GitHub Container Registry authentication successful nahi thi. The GHCR_PAT environment variable was empty, so Docker received an empty token and login failed. After setting a valid Personal Access Token and logging in successfully, the push operation was authorized and worked correctly. 🚀
Side note: Jo PAT tumne chat mein paste kiya hai, use immediately GitHub se revoke/regenerate kar do. Token public ho gaya hai, isliye security ke liye naya token bana lena best practice hai. 🔐

3. https://github.com/users/AdityaMadhavi07/packages/container/package/demoapp
4. readme.md:
   - simple node.js app that runs on port 3000 and connects to Postgres using Docker Compose setup

   - running with docker compose:
   - create .env file: 
   - start the services: docker compose pull, docker compose up -d
   - verify; docker compose ps, docker compose logs -f app

---------------------------------------------------------------------

Task 5:

1. removing local containers, images and volumes:
   docker compose down -v --remove-orphans
   docker rm -f demo-app demo-db 2>$null
   docker rmi ghcr.io/adityamadhavi07/demoapp:1.0.0 ghcr.io/adityamadhavi07/demoapp:latest demoapp:v1 2>$n

2. pulling from docker hub:
   docker compose pull
   docker compose up -d

3. verify fresh clean up:
  - docker compose ps
  - docker compose logs -f db
  - docker compose logs -f app

-----------------------------------------------