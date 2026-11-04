---------------------------------------------------------------------------
data persistence and container communication
Containers are ephemeral — they lose data when removed. And by default, containers can't easily talk to each other
---------------------------------------------------------------------------
Task 1: 

1. By default, container data is stored in the container's writable layer. When the container is removed (docker rm), that layer is deleted along with all data stored inside it.
   
2. docker run -d --name pg-demo -e POSTGRES_PASSWORD=password -p 5432:5432 postgres
    # start the postgres SQL DB container in BG, name it pg-demo, set the pwd as 'password' connect the port 5432 of laptop/server to port 5432 of container
    hostport : containerport
    container name: pg-demo
   
   note: already a service is running on 5432 port:
   sudo lsof -i :5432
   sudo systemctl stop postgresql

   docker exec -it pg-demo psql -U postgres
    psql= command line client of PostgreSQL

    \l  list the db tables         --list the databases--
    CREATE DATABASE testdb;     --create database--
    \c testdb   --change the database--
    create table....

---------------------------------------------------------------------------
Task 2: Named Volumes

1. creating volume:
   docker volume create pgdata
   docker volume ls

2. Start a PostgreSQL container using the volume:
   
   docker run -d --name pg-demo-task -e POSTGRES_PASSWORD=password -v pgdata:/var/lib/postgresql/data postgres

    note: pgdata = docker volume, location in container: /var/lib/postgresqldata/data
            -v VolumeName : ContainerPath

3. Adding data in the volume:
   
   docker exec -it pg-demo-task psql -U postgres

   Stop and remove the container:   docker stop postgresql, docker rm postgresql
   verify if the volume exists:     docker volume ls,   docker volume inspect pgdata

4. Run brand new container with same volume:
   
   docker run -d --name postgresnew -e POSTGRES_PASSWORD=password -v pgdata:/var/lib/postgresql/data postgres
   OR
   docker run -d \
  --name postgresnew \
  -e POSTGRES_PASSWORD=password \
  -v pgdata_v18:/var/lib/postgresql \
  postgres:latest
   or
   docker run -d \
  --name postgres2 \
  -e POSTGRES_PASSWORD=password \
  -v pgdata:/var/lib/postgresql/data \
  postgres

5. Verify the data:
   docker exec -it postgresnew psql -U postgres

 the data remains available after removing and recreating the container because the named volume persists independently of the container lifecycle. This is the recommended way to store database data in Docker.


---------------------------------------------------------------------------
Task 3: Bind Mounts

1. mkdir nginx-site
cd nginx-site

echo "<h1>Hello from Bind Mount!</h1>" > index.html

2. running nginx container with Bind Mount:
   
   docker run -d --name nginx-demo-bindmount -p 8080:80 -v $(pwd):/usr/share/nginx/html nginx
    # image will come from dockerhub anf local folder will "bind" with the webiste folder in the container. if you change the index.html in local then website will change immediately.
    # nginx won't use the default web files. it will use the files from Host folder

3. http://localhost:8080
4. edit the index.html file in the local 
5. refresh the url --> new data is visible in browser
   (no need to restart the container)

named volume:
  docker run -d \
  -v pgdata:/var/lib/postgresql/data \
  postgres  
-manged by docker itself
-location: /var/lib/docker/volumes/
-container removed, still data persists

- Named Volume is docker managed storage, used for db and persistant app data

bind mount:
  docker run -d \
  -v $(pwd):/usr/share/nginx/html \
  nginx
-managed by user/host os
-host folder --> container folder (direct mapping)
-real-time changes
-useful in source code mounting

- Bind Mount mounts actual folder of the host machine inside the container, changes made in file are reflected in container

Database data ⇒ Named Volume
Application code / HTML files ⇒ Bind Mount

---------------------------------------------------------------------------

Task 4: Docker networking basics

1. docker network ls
bridge → Default network for containers
host → Container shares host's network stack
none → No networking

2. docker network inspect bridge
What you'll see

Network Name
Driver type
Subnet range
Gateway IP
Connected containers

3. running 2 containers on default bridge:
docker run -dit --name container1 ubuntu bash 
docker run -dit --name container2 ubuntu bash
# detached,interactive terminal
# both containers will be under same network(bridge)/Subnet and will have unique Ip address

# cmd to see the network details of container:
docker inspect <containerID>
# cmd to check the list of containers network holds
docker network inspect bridge

ping each other by name:
docker exec -it container1 bash
ping container2
---fails---


ping by Ip:
docker inspect container1 | grep IpAddress -- get the IP (A)
docker inspect container2 | grep IpAddress -- get the IP (Z)

# install the ping cmd in container:
apt update
apt install -y iputils-ping

from container 1 
ping Z
ping -c 4 <ip_addr>

WOKRS!

Note: Default bridge network has no built-in container name resolution.
when both containers are attached to same bridge network, they can communicate using their IP address as they are under same bridge subnet


---------------------------------------------------------------------------
Task 5: Custom Networks

1. creating custom bridge network:
   docker network create my-app-net
   docker network ls

2. running containers on network:
   docker run -dit --name container1 --network my-app-net ubuntu bash
   docker run -dit --name container2 --network my-app-net ubuntu bash

3. ping by container name:
   docker exec -it container1 bash

   apt update
   apt install -y iputils-ping 

   ping container2
   or
   ping -c 4 container2

4. containers can now ping each other by container name
   docker DNS resolution is working
   we can communicate with container name on custom networks
   
   default bridge follows the OLD Docker Behaviour where containers recieve IP addr, and comm is possible via IP, no auto DNS resolution

   while using custom network:
   docker creates ingternal DNS service
   each container maintains a hostname
   conatiners auto-maps the names to the IP addresses


---------------------------------------------------------------------------
Task 6: putting it together

1. docker network create my-network
2. running db container on network with vol for data:
   
   creating a named volume:
   docker volume create postgres-data-task

   docker run -d --name postgres-db --network my-network -e POSTGRES_PASSWORD=password -e POSTGRES_DB=test_db -v postgres-data-task:/var/lib/postgresql/data postgres

   docker ps

   Note: the new version is 18, so now the data is stored in /var/lib/postgresql/data/v18
   so:
   docker run -d --name postgres-db --network my-network -e POSTGRES_PASSWORD=password -e POSTGRES_DB=test_db -v postgres-data-task:/var/lib/postgresql/data/v18 postgres


3. adding data:
   docker exec -it postgres-db psql -U postgres -d testdb


   running app container on same network:
   docker run -dit --name app-container --network my-network ubuntu bash
   docker exec -it app-container bash

   apt update
   apt install -y iputils-ping

4. verifying connectivity by container-name:
   ping postgres-db

Note: docker network inspect my-network
    both containers under same network, docker auto-created DNS enteries
    db container became reachable using hostname
    




