1. What is the difference between an image and a container?
docker image is a read-only template that contains app code, dependencies and config.
container is running instance of that image with its own writable layer and runtime state


2. What happens to data inside a container when you remove it?
data stored in container's writable layer is LOST when container is removed. we use docker volumes to store it permanently


3. How do two containers on the same custom network communicate?
containers on same custom Docker Network can communicate using container names as hostnames because Docker provides built-in DNS resolution


4. What does `docker compose down -v` do differently from `docker compose down`?
docker compose down removes containers and networks, while docker compose down -v removes associated volumes and their stored data


5. Why are multi-stage builds useful?
multi-stage build allows separating build dependencies from the final runtime image resulting in smaller, more secure and optimized docker images


6. What is the difference between `COPY` and `ADD`?
copy = only copies files and directories
add = does auto-tar extraction and URL support. copy used for simplicity and predictibility


7. What does `-p 8080:80` mean?
maps port 8080 in the host machine to the port 80 inside the container allowing external access to the application


8. How do you check how much disk space Docker is using?
docker system df -v 
to view disk usage, including images, congtainers, volumes and build cache.

--------------------------

# 🐳 Docker Cheat Sheet

## Container Commands
* `docker run -d --name <name> -p <host>:<container> <image>` — Run a container in detached mode with mapped ports.
* `docker ps -a` — List all running and stopped containers.
* `docker stop <id/name>` — Gracefully stop a running container.
* `docker rm <id/name>` — Delete a stopped container.
* `docker exec -it <id/name> /bin/bash` — Open an interactive terminal session inside a running container.
* `docker logs -f <id/name>` — Follow the real-time logs of a container.

## Image Commands
* `docker build -t <username>/<repo>:<tag> .` — Build an image from a Dockerfile in the current directory.
* `docker pull <image>:<tag>` — Download an image from Docker Hub.
* `docker push <username>/<repo>:<tag>` — Upload an image to a registry.
* `docker tag <source> <username>/<repo>:<tag>` — Create a new tag referencing an existing image.
* `docker images` — List all locally stored images.
* `docker rmi <image_id>` — Remove a local image.

## Volume Commands
* `docker volume create <name>` — Create a persistent volume.
* `docker volume ls` — List all existing volumes.
* `docker volume inspect <name>` — Display detailed configuration data of a volume.
* `docker volume rm <name>` — Delete a specific volume.

## Network Commands
* `docker network create --driver <bridge|overlay> <name>` — Create a new network for container communication.
* `docker network ls` — List all networks.
* `docker network inspect <name>` — Display detailed information about a network.
* `docker network connect <network> <container>` — Connect a running container to a network.

## Compose Commands
* `docker compose up -d` — Build, create, and start all services defined in `compose.yml` in the background.
* `docker compose down` — Stop and remove containers, networks, volumes, and images created by `up`.
* `docker compose ps` — List the status of containers managed by the current compose file.
* `docker compose logs -f <service>` — Tail the output logs of a specific service.
* `docker compose build --no-cache` — Force rebuild the services defined in the compose file without using cache.

## Cleanup Commands
* `docker system prune -a --volumes` — Wipe all unused containers, networks, images, and volumes to free up space.
* `docker system df` — Display Docker disk usage breakdown.

## Dockerfile Instructions
* `FROM <image>:<tag>` — Sets the base image for subsequent instructions.
* `RUN <command>` — Executes commands in a new layer and commits the results (used to install packages).
* `COPY <src> <dest>` — Copies files or directories from the host machine into the container filesystem.
* `WORKDIR /path` — Sets the working directory for any RUN, CMD, ENTRYPOINT, COPY, and ADD instructions.
* `EXPOSE <port>` — Informs Docker that the container listens on the specified network ports at runtime.
* `CMD ["exec", "param"]` — Provides default commands or arguments for an executing container (easily overridden).
* `ENTRYPOINT ["exec", "param"]` — Configures a container that will run as an executable (not easily overridden).

