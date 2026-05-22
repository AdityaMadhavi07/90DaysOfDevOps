---------------------------
Hands On task:

    1.  du -sh /var/log 
        -  du = disk usage
        -  -s summary (total size , no internal breakdown)
        -  -h = human readable
        -  /var/log/* = every file under log
        - 2>/dev/null   = ignore the error part
        -  sort -h = sort in numeric form 
        -  tail -5 =  shows last 5 lines. Since the order is descending


    2.  cat /etc/hosts
        - Output= hostname
        - Server/system unique name

    3.  ls -la ~
        - This contains all the files starting with "."
        - All the hidden/daemon files
        -  -a shows all files including hidden files also
        - ~  home directory of the user
        - Show all files (including hidden) in the home directory with detailed info

---------------------------

Scenario Practice:

Check service is running:
    -  ps -ef | grep <name of service>
    -  systemctl status <servicename>
List all services:
    -  systemctl list-units --type=service
Check if service is enabled, also if this service will start after boot:, ensure that imp service get auto-start
    -  systemctl is-enabled <servicename>

                   

    1. Service not starting
    Myapp failed to start after server reboot:
        -   systemctl status myapp/server
            § To check if the app is running or not. If the application is off then the other services wont run
        -   jounrnalctl -u myapp -n 50
            § This will give the logs , and I can find the flow. This will help me troubleshoot the problem
        -   systemctl is-enabled myapp
            § To check if the service is enabled

    2. High Cpu usage 
    which proc is using high CPU?
        -  top
            § This will show the live CPU usage
            § Will update continuously 
        -  htop
            § Needs to be installed
            § Colorful gui
            § Mouse support
        -  ps aux --sort=-cpu | head -n 10
            §  ps aux = lists cpu usage of call process, with detailed structure excluding the termimal
            §  --sort=-cpu = sorts the list based on highest cou usage
            §  | head -n 10 =  gives the output of previous command and then displays top 10 lines
    

    3. Finding service logs:
    Logs of docker service (systemd service)
        -  systemctl status docker
            § This will tell if the docker is running
        -  journalctl -u docker -n 50
            § This will display the logs of the docker service
            § 50 lines
        -  journalctl -u ssh -f
            § This will show the live logs of the docker service
        
    4. File permissions Issue:
    Give the file permission to execute
        - Note execute = 1
        -  ls -lrt to see if what permissions are there for file
        -  if it has x written 3 times then we have executable permission
        -  else we need to make it executable:
            §  chmod 111 backup.sh
            §  chmod +x backup.sh
            §  runninf it: ./backup.sh
    
