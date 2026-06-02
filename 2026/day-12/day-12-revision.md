
    1.  ls -l  <filename>
        rather than viewing permission of directory I see permissions of particular file



    2.  suppose the service is nginx:
        sudo systemctl status nginx
        journalctl -u nginx -n 50
    - Check if the port is listening:
        netstat -tulnp | grep <port>
        sudo restart nginx
        sudo start nginx
    - Health endpoint for APIs:
        curl -f <URL>
        if it returns 200 OK, then service is healthy

    3.  chown -R user:group /var/www/app && chmod -R 750 /var/www/app

    4. Next 3 days I plan to focus on shell scripting , creating functions