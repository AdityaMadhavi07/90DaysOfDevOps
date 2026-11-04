Task - 1
1. what is docker?
   - open source s/w platform used to build, test and deploy apps quickly by pkging them into light wt portable units called containers
  
   - container is a lightweight, standalone and executable package of s/w that has everything needed to run an app: code, runtime, system tools, libraries and settings

   - why do we need containers:
   - solves the problem of- works on my machine
   - portability: 
   - consistency
   - fast deployment
   - light weihgt
   - isolation
   - microservices friendly

   -  VM- heavy, requires OS
   -  container- light-wt, shared OS
   -  docker achitechture:
      -  client: sends the cmd
      -  daemon: execution job
      -  image: blueprint
      -  container: running app
      -  registry: image storage
------------------------------------------------------
Task - 2. 
Install docker
    docker run hello-world 
    #docker will download this img from img registry, and will save it in local
    conatiner is created , run and output recieved
------------------------------------------------------
Task - 3. Run real containers
   
1. running nginx: docker run nginx (starts the nginx server inside the container, but we havent started it with -d, Nginx is running in foreground, and we need to enter ctrl +c to stop it)
"The output shows that the Nginx container started successfully. Docker pulled the image, created the container, and launched Nginx, which is now running and ready to serve web requests."

2.  docker run -it ubuntu
"To run an Ubuntu container in interactive mode, use docker run -it ubuntu, which starts a terminal inside the container and allows you to execute commands interactively."

3. docker ps
4. docker ps -a
5. docker rm <container id>

------------------------------------------------------
Task 4  Explore

1. docker run -d <image> 
   the terminal becomes free 

2. docker run -d --name <custom_containername> nginx
   docker run -d --name mynginx nginx

3. mapping container from host:
   docker run -d -p 8080:80 nginx , 
   maps conatiner port to host port, 8080= host port , 80 = container port

4. docker logs <container name>

5. run a cmd inside a running container;
   docker exec -it <container_name> <command>


