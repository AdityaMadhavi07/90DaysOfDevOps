
-------------------------------------------------------------------------------
Task 1: building own app stack

1.  creating 4 files: app.py, Dockerfile, docker-compose.yml, requirements.txt
   created dockerized 3-service app using docker-compose.
   consists of- flask web app, postgresql db and redis cache
   
   --------app.py:------------------
from flask import Flask #importing flask framework, flask is backend-framework of python
import psycopg2 #import python lib to connect to psql db
import redis #importing python lib to connect to redis cache server

app = Flask(_name_) #creating object of flask app

@app.route('/')
def home():
    db_status = "Failed"
    redis_status = "Failed"

    try:
        conn = psycopg2.connect(
            host="postgres_db",
            database="mydatabase",
            user="postgres",
            password="postgres"
        )
        db_status = "Connected"
        conn.close()
    except Exception as e:
        print(e)

    try:
        r = redis.Redis(host="redis", port=6379) #creating redis client obj
        r.ping()
        redis_status = "Connected"
    except Exception as e:
        print(e)

    return f""" #injecting dynamic values using f-string
    Hello World!<br>
    Database: {db_status}<br>
    Redis: {redis_status}
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)



   ------requirements.txt:--------------------

Flask
psycopg2-binary
redis

   ---------Dockerfile----------------------------

FROM PYTHON:3.11-slim
WORKDIR /app
COPY requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]

   ----------------docker-compose.yml---------

version: '3.8'

services:

    web:
        build: .
        container_name: flask_app
        ports:
            - "5000:5000"
        depends_on:
            - db
            - redis 
        



    db:
        image: postgres:15
        container_name: postgres_db
        environment: 
            POSTGRES_DB: mydatabase
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: postgres
        ports:
            - "5432:5432"
        volumes:
            - postgres_data:/var/lib/postgresql/data 



    redis:
        image: redis:7
        container_name: redis_cache
        ports:
            - "6379:6379"



volumes:
    postgres_data:


    -----running app----
    docker compose up --build
    ----verify-----
    http://localhost:5000


----------error resultion:---------------

to check if the port is already in use:
    sudo lsof -i <portno>
    sudo lsof -i 5432


enable the inbound rule for 5000 port
docker compose logs web

direct db check:
    docker exec -it flask_app sh

docker compose config --services

I debugged the database connectivity issue by checking Docker DNS resolution inside the Flask container. The service name db was not resolving, while postgres_db (the container name) was resolving correctly. After updating the PostgreSQL host value in the application and rebuilding the containers, the Flask application successfully connected to both PostgreSQL and Redis.
-------------------------------------------------------------------------------
Task 2: depends_on and health checks

1. depends_on:
        - db
  
2. adding helathcheck on db service:
   
web:   
   depends_on:
    db:
        condition: service_healthy
    redis:
        condition: service_started

db:
   healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres -d mydatabase"]
      interval: 5s
      timeout: 5s
      retries: 5
      start_period: 10s

I added a PostgreSQL healthcheck using pg_isready to verify that the database is actually accepting connections. Then I configured depends_on with condition: service_healthy so the Flask application starts only after the database becomes healthy. This avoids startup race conditions where the application tries to connect to the database before it is ready.

-------------------------------------------------------------------------------
Task 3: restart policies

1. Add `restart: always` to your database service
    why? - to ensure high availability, prevent app downtime 

    in docker-compose.yml:

    db:
        image:
        container_name:

        restart: always

    

2. Manually kill the database container — does it come back?
    docker kill postgres_db
    docker ps 
    expected = postgres_db = up
    container will auto-restart becasue= restart=always

    restart count:
    docker inspect postgres_db --format='{{.RestartCount}}'


3. Try `restart: on-failure` — how is it different?
    restart: on-failure
    container will restart if the app fails to load, 
    
    
    restart: always
    it will restart in all cases except for manual stop
    to keep app available

    restart: on-failure
    only on app-faiure



4. Write in your notes: When would you use each restart policy? 

    always
Behavior: Always restart the container if it stops, regardless of exit code. Ignores manual stops only until Docker daemon restart.
Use when:
Critical long-running services that must stay up (e.g., web servers, APIs).
You want the container to restart even after a clean shutdown (e.g., docker stop).
Production environments where availability is paramount.


    on-failure (optionally with :max-retries, e.g., on-failure:5)
Behavior: Restart only if the container exits with a non-zero (error) code. Limited retries prevent infinite loops.
Use when:
Background workers, queue processors, or batch jobs that should retry on crashes but stop cleanly on success.
Services prone to transient errors but that should not restart on intentional exits.

-------------------------------------------------------------------------------
Task 4: custom dockerfile in compose

1. Instead of using a pre-built image for your app, use `build:` in your compose file to build from a Dockerfile
    web:
        build: .
    this will build the dockerfile present in the current directory
    everybuild will create a fresh image

    Using build: allows Docker Compose to create the application image directly from the Dockerfile and source code. Any code changes can be rebuilt and redeployed easily without manually creating Docker images.


2. Make a code change in your app
    return f"""
    Hello World - version 2!<br>
    Database: {db_status}<br>
    Redis: {redis_status}
    """


3. Rebuild and restart with one command
    docker compose up -d --build
    curl http://localhost:5000

-------------------------------------------------------------------------------
Task 5: Named Network and Volumes

1. Define **explicit networks** in your compose file instead of relying on the default
    services:
        web:
            networks:
                - app_network

            labels:
                app: flask-app
                environment: dev
                tier: frontend 
    networks:
        app_network:
            driver: bridge

    docker network ls

    created a default network- better ctrl, used in prod.
    Created a custom bridge network (app_network) and attached all services to it for controlled inter-container communication.

2. Define **named volumes** for database data
    volumes:
        postgres_data:
        
    docker volume ls

    Created a named volume (postgres_data) to persist PostgreSQL data across container restarts and recreations.

3. Add **labels** to your services for better organization

    labels:
        app: flask_app
        environment: dev
        tier: frontend
    
    docker inspect flask_app

    service identification becomes easy
    moitoring tools and logging systems can be used
    Added labels to web, database, and Redis services for better identification, organization, monitoring, and future automation support.

-------------------------------------------------------------------------------
Task 6: Scaling

1. Try scaling your web app to 3 replicas using `docker compose up --scale`
    docker compose up -d --scale web=3
    docker ps

2. What happens? What breaks?
    Only one container will start and other 2 will fail
    docker trys to bind the pther containers to same port but one port can have one conatiner. ( ports:  - "5000:50 )
    
    scaling failed because all replicas attempted to use the same host port (5000).

3. Write in your notes: Why doesn't simple scaling work with port mapping?
    The host machine can only bind one container to port 5000 at a time. Additional replicas could not start due to port conflicts.

    In real-world deployments, multiple replicas are usually placed behind a reverse proxy or load balancer instead of exposing each replica on the same host port.

    Remove the Post Mapping to fix the error.\





