Choosen service - ssh (sshd)

    1. Os info : uname -a
    2. Version/flavor: cat /etc/os-release
    3. System/sanity:
        a. Creating test directory and file:
            -  mkdir /tmp/runbook-demo
            -  cp /etc/hosts /tmp/runbook-demo/hosts-copy
            -  ls -l /tmp/runbook-demo
        b. CPU and memory usage snapshot:
            -  ps -o pid,pcpu,pmem,comm -p $(pidof sshd)
        c. Memory usage: cpu and memory check
            -  free -h
        d. Disk and IO snapshot:
            -  df -h
        e. Log directory size:
            -  du -sh /var/log
        f. Network snapshot:
            -  check open ports
                □  ss -tulnp  | grep ssh
        g. Service health check:
            -  curl -I localhost
        h. Service logs:
            -  journalctl -u ssh -n 50
        i. System logs:
            -  tail -n 50 /var/log/syslog
    4. Quick findings:
        a. Ssh service is up and running
        b. No cpu/memory bottleneck
        c. Disk usage is within safe limits
        d. Network port 22 is open and listening
        e. Logs show no recent failures
    5. If this worsens:
        a. Restart the service:
            -  systemctl restart ssh
        b. Deep debugging:
            - Strace -p <PID>
-----------------------------------------------------------------

Cpu and memory check:
 free -h

 htop
Op process viewer

Disk check 
 df -h

Log check
 journalctl -u ssh -n 20
