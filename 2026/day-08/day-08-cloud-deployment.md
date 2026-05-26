    
    1. Commands used:
        i.  ssh
        ii.  sudo apt-get update
        iii.  sudo apt-get upgrade
        iv.  sudo apt-get install nginx
        v.  sudo apt update && apt install docker.io
        vi.  awk '{print $1,$2}' <file> > <newfile>
             awk '{print $1, $3, $6}' access.log > samplelogs.txt
        vii.  systemctl status docker



    2. Challenges faced:
        i. While making changes to the webpage of nginx, I had to switch to root user 
        ii. While installing the docker: 
            - I faced issues as there is no official package named docker in ubuntu repos 
            - Docker pkg available in ubuntu repo: docker.io
            - Old cmd: sudo apt-get install docker
            - New cmd: 
                □ sudo apt update && apt install docker.io
                □  sudo apt update && apt install -y docker.io




    3. What I learnt:
        i. Docker is an engine
        ii. We need to run a container to see something in browser
        
