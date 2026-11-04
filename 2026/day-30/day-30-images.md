Task 1:

1. to download images from dockerhub is called Pull:
    docker pull nginx
    docker pull ubuntu
    docker pull alpine

2. docker images
    highest  = more than 219mb
    lowest = 25.9kb

3. ubuntu vs alpine
   ubuntu has multiple packages and dependencies included, alpine is lightweight (minimal OS) only basic requirements are present
   ubuntu has full-featured OS with many libraries and packages, alpine contains only essential components, this results in significantly smaller image sizes, making Alpine more suitable for optimized Docker containers.

4. docker inspect <image>
    docker inspect command provides detailed information about an image in JSON format:
    It includes metadata such as layers, configuration, environment variables, entrypoint, creation time, and other low-level details useful for debugging and understanding the image structure.

5. docker rmi <image_ID/img _name>
   remove the unwanted images

---------------------------------------------------------------------------
Task 2: image layers

1. docker image history nginx
   
2. each row defines a layer, some layer has size in MB some in 0B
    Mbs = actual files, 0B = metadata chanegs = (CMD, ENV)

3. docker image history nginx:
   we see a list of layers thatmake up the image. each line corresponds to a layer created during the image build process.

   Docker images are composed of multiple layers. each layer represents a set of filesystem changes, these layers are created by instrutions in dockerfile such as RUN, COPY or ADD

   Docker uses layers for:
   caching and faster builds: cache re-use
   storage efficiency: same layer is used to create multiple images
   version control: layered architechture for easy rollback

---------------------------------------------------------------------------
Task 3: container lifecycle

1. creating a container:
   docker create --name mycontainer nginx
   this will just create a container, it wont run the container. state = created

2. starting the container:
   docker start containeradi

3. pause it and check status:
   docker pause containerAdi

4. unpause it
   docker unpause containerAdi

5. stop it:
   docker stop containerAdi

6. restart it
   docker restart containerAdi

7. kill it:
   docker kill containerAdi
   The docker kill command forcefully stops the container by sending a SIGKILL signal, immediately terminating it.

8. remove it:
   docker rm containerAdi

---------------------------------------------------------------------------
Task 4: working with running containers:

1. Running nginx in detached mode:
   docker run -d --name mynginx -p 8080:80 nginx
   -p 8080:80 maps port 8080 on the host to port 80 inside the container.

2. logs:
   docker log <containerID>

3. real-time logs:
   docker log -f <containerID>

4. exec into the container and look around system:
   docker exec -it <containerID> /bin/bash
    interactive access to a running container. It opens a shell session where we can explore the filesystem and debug issues.

5. run cmd into conatiner without entering:
   docker exec <containerID> ls /
   
6. inspect the container: ip addr, port mappings and mounts:
   docker inspect <containerID>
   Ip address: Inside Networks: Ip Address
   Port Mapping: HostConfig → PortBindings
   Mounts/Volumes: mounts
   
   These commands demonstrate how to manage a running container, inspect its behavior, access its environment, and troubleshoot issues—key skills in Docker-based development and DevOps workflows.


---------------------------------------------------------------------------
Task 5: CleanUp:

1. stop all running containers:
   docker stop $(docker ps -q)
   this is command substitution. docker ps -q --> fetches all running container IDs
   note: -q → only running containers
   -aq → all containers (running + stopped)

2. remove all stopped conatiners:
   docker conatiner prune

3. remove unused conatiners:
   docker image prune
   docker image prune -a

   The docker image prune command removes unused or dangling images.
   Using -a removes all images that are not currently used by any container.

4. check how much disk space docker is using:
   docker system -df
   command shows Docker disk usage, including space consumed by images, containers, volumes, and build cache. It helps identify resources that can be cleaned up.