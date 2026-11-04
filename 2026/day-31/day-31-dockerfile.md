Task 1: dockerfile

1. mkdir my-first-image
   

2. Dokerfile:
#<!-- using ubuntu as base image: -->
FROM ubuntu:latest

#<!-- installing curl cmd -->
RUN apt-get update && apt-get install -y curl

#<!-- default command: -->
CMD ["echo", "Hello from my custom image!"]


3. building image and tagging it: my-ubuntu:v1
    docker build -t my-ubuntu:v1 .
    #  . =to fetch dockerfile from current folder

4. running container from image:
   docker run my-ubuntu:v1

   o/p:
   ge$ docker run my-ubuntu:v1 
Hello from my custom image!
ubuntu@ip-172-31-35-141:~/90DaysOfDevOps/docker/my-first-image$ 

Note: 
Container lives as long as PID 1 process runs, Docker container runs only as long as its main process is running. Once that process ends → container exits.

to keep container running:
a. CMD ["bash"] , docker run -it my-ubuntu:v1
b. CMD ["sleep", "infinity"]


-----------------------------------------------------
Task 2: Dockerfile instructions:

FROM — base image
RUN — execute commands during build
COPY — copy files from host to image (used to bring app code into the image)
WORKDIR — set working directory
EXPOSE — document the port
CMD — default command

*****created a folder and added app.sh file in it, added basic echo cmds in it****

#!/bin/bash
echo "🚀 App started..."
echo "Current directory: $(pwd)"
echo "Listing files:"
ls -la
echo "App is running on port 8080 (simulation)"



***Creating dockerfile:****

FROM ubuntu:latest
RUN apt-get update && apt-get install -y curl && apt-get clean
WORKDIR /app
COPY app.sh .
RUN chmod +x app.sh
EXPOSE 8080
CMD ["./app.sh"]

****building the image*****
docker build -t my-ubuntu:v2 .

****run the container******
docker run my-ubuntu:v2


Note: app.sh is the program that actually runs inside the container (mini-app)

-----------------------------------------------------

Task 3: CMD vs Entry point:

1.  using CMD:  
    FROM ubuntu:latest
    CMD ["echo", "hello"]

    docker build -t cmd-test .
    this will create an image from the Dockerfile present in the current folder and name it /tag it as: cmd-test

   running normally: docker run <imagename>
   running with custom cmd: docker run <imagename> echo hello

   observation: CMD gets overridden by command you pass at runtime

2. using EntryPoint:
    FROM ubuntu:latest
    ENTRYPOINT ["echo"]   # echo + run time argument = appending

    docker build -it <imagename>
    docker run <imagename>      --running without args--

    docker run <imagename> hello world      --running with args--
 

 Note: if you edit your Dockerfile then you must "Build" the image again, shell script is case-sensitive.
        entry point defines executable and CMD provides default arguments to it

3. use entrypoint when:
    to create fixed tool/app
    same base cmd in every run
    to lock the behaviour

    use CMD when:
    to give default cmd
    to give override access to user


-----------------------------------------------------

Task 4: building simple web app image:

1. 

FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
#default web root folder of nginx
EXPOSE 80

docker build -t my-website:v1 .

-- with port mapping and access it in your browser --
docker run -d -p 8080:80 --name mysite my-website:v1  

mysite = container name
laptops port 8080 will be connected to containers port 80

--
Since the base image nginx:alpine already contains Nginx, its configuration, and a default CMD to start the web server. We only needed to copy our index.html into Nginx's document root. RUN wasn't required because no additional packages were installed, and WORKDIR wasn't required because an absolute destination path was used in the COPY instruction

when container starts: Docker uses the inherited CMD from nginx:alpine.
RUN is only needed when you want to execute something during image build.
WORKDIR sets the current directory for future commands, Since the destination path is fully specified, Docker knows exactly where to copy the file.
did not use expose as: -p 8080:80 performs the actual port mapping, also its for documentation

-----------------------------------------------------

Task 5: dockerignore

1. create .dockerignore file
2. add 
    node_modules
    .git
    *.md
    .env
3. build the image:
   docker build -t <imagename> .
4. run the container:
   docker run -it --rm my-app:v1 sh

5. Verify:
   ls -la

-----------------------------------------------------

Task 6: Build Optimization

Docker uses layer caching. Placing frequently changing instructions near the end of the Dockerfile prevents unnecessary rebuilding of earlier layers, improving build speed.

FROM ubuntu:latest
RUN apt-get update && apt-get install -y curl
COPY app.py /app/

Put stable commands (installing packages, dependencies) first.
Put frequently changing files (COPY ., source code) last.
This maximizes cache usage and makes builds much faster.

when we re-build the image after changing any line/code/layer,
we'll notice: 

CACHED [1/4] FROM ubuntu
CACHED [2/4] RUN apt-get ...
