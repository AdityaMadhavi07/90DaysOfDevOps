Docker Compose:

------------------------------------------------------------------------
Task 1: install + verify

1. docker compose version

------------------------------------------------------------------------
Task 2: compose file

1. docker-compose.yml

2.    services:
        nginx:
            image: nginx:latest
            container_name: nginx-server
            ports:
                - "8080:80"

    docker compose is used to run multiple containers in one go.
    docker compose contains a docker-compose.yml file

    docker compose up -d
    docker compose is a way to merge multiple containers in one file

    under services we write the containers: nginx, postgres, redis container

    services:
        nginx:
        database:

------------------
    services:
        nginx:
            image: nginx:latest
--------
    is same as
--------
    docker run nginx:latest

    docker compose up -d
    docker compose down
    docker compose logs
    docker compose ps

3. docker compose up -d
   docker ps   

4. docker compose down

------------------------------------------------------------------------
Task 3: docker-compose.yml

1. docker-compose.yml
services:
    db:
        image: mysql:8.0
        container_name: wordpress-db
        restart: always
        environment: 
            MYSQL_DATABASE: wordpress
            MYSQL_USER: wpuser
            MYSQL_PASSWORD: wppassword
            MYSQL_ROOT_PASSWORD: rootpassword
        volumes:
            - mysql_data:/var/lib/mysql

    wordpress:
        image: wordpress:latest
        container_name: wordpress-app
        restart: always
        ports:
            - "8080:80"
        environment:
            WORDPRESS_DB_HOST: db:3306
            WORDPRESS_DB_USER: wpuser
            WORDPRESS_DB_PASSWORD: wppassword
            WORDPRESS_DB_NAME: wordpress
        depends_on:
            - db

volumes:
    mysql_data:        

----
2. docker compose up -d
   docker ps
----
3. docker compose down
   docker compose up -d

   http://localhost:8080

summary:
1. we ran 2 containers: mysql (for db) and wordpress (for website)
2. docker compose will bring both the container under same network so they can call each other by their container names.
3. we created a named volume for my-sql so that the data will remain safe even after container restart/delete
4. will bring the containers up: docker compose up -d
5. set the data/sign in
6. docker compose down to stop/remove the container
7. docker compose up to to restart the app
8. we need not sign in , rather login as the data is persisted in the volume
   

------------------------------------------------------------------------
Task 4: Compose Commands

1. Start services in **detached mode**
    docker compose up -d
    this will make the terminal free for execution

2. View running services
   docker compose ps

3. View **logs** of all services
    docker compose logs

4. View logs of a **specific** service
    docker compose logs <service_name>

5. **Stop** services without removing
    docker compose stop

6. **Remove** everything (containers, networks)
    docker compose down  -- this will clean the set up--

7. **Rebuild** images if you make a change
    docker compose up --build
    docker compose up --build -d
    docker compose logs -f <service_name>
    -f = follow

------------------------------------------------------------------------
Task 5: Env Variables

1. Add environment variables directly in your `docker-compose.yml`

    services:
        app:
            image: nginx
            environment:
                APP_NAME: MyApp
                APP_ENV: development

    we can define env-var directly inside the docker-compose.yml file. these will be available at the time of container start


2. Create a `.env` file and reference variables from it in your compose file

    vi .env

    APP_NAME=MyApp
    APP_ENV=development

    new docker-compose.yml:

    services:
        app:
            image: nginx
            environment:
                APP_NAME: ${APP_NAME}
                APP_ENV: ${APP_ENV}


    Note:
    place the senistive or reusable values in .env file, compose automatically reads the.env file and replaces the variable

3. Verify the variables are being picked up

    docker compose config
    docker compose exec app env

    docker compose exec app printenv APP_NAME












