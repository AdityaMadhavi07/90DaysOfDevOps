
    1. Running process
        a. ps : process of current terminal
            -  ps -ef 
            - Used in production 
        b.  ps aux
            -  process of all users
            -  user-oriented format
            -  background processes
            - CPU usage, memory usage and running command
        c.  ps -ef | grep nginx
            - To check if nginx is working
        d.  ps -el:
            - Zombie/orphan process check
        e.  top:
            - Live task manger
            - Press top then
                □ M to sortby memory
                □ D to change refresh time
                □ P for CPU
                □ Q to quit


    2. Inspect one systemd service
        - System and service manager for modern linux operating system 
        - Note: services are programs that run continuously in the background 
            - Often end with d
            - D = daemon process (hidden)
        -  systemctl list-units --type service --all : command to display all the services, current state, description and if they are loaded or not
        -  systemctl: controls the services
        -  journalctl: stores system logs and display 
        -  systemd-cgls : displays the process in tree format
        -  systemadm: visual version of systemctl
        -   systemd -cgls: to see which process is consuming most resources 

        CRON (crond)
        - Bg service which runs tasks automatically on scheduled time
        - Like taking backup at 2pm daily, cleaning logs every Sunday
        -  systemctl status cron (service inspect)
            - The o/p will display if the service is: 
                □ Active 
                □ PID
                □ Loaded (file path)
        - Scheduling cronjob:
             crontab -e       --------------->(opening a crontab)
             0 2 * * *  /home/user/backup.sh       ---------------> (script will run at 2am daily)
             systemctl stsrt/stop/restart/status cron       ---------------> (managing service)
             journalctl -u cron       ---------------> checking logs 

