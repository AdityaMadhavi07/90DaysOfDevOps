Linux Commands:

        a. Process management
                        -  accton: enables process accounting, tracks cmd used by user
                            □ Sudo accton /var/log/account/pacct
                            □ Sudo accton off
                        -  bg: runs any suspended/stopped job in bg
                        -  chrt: changes the real-time scheduling policy and priority(sudo chrt -f 99 ./script.sh, sudo chrt -p 80  1234)
                        -   fg: background job --> foreground
                        -  kill: to stop a running process
                        -  mpstat: performance and report of CPU core
                        -  pidof: to find the process ID of running program
                        -  ps: snapshot of active process in shell
                        -  top: system resource usage of real-time process
                        -  htop: interactive version of top
                        -  strace: to track the system calls and signals 
                        -  time: time taken to complete a command (time find . -name "*.log)
                        -  watch: runs a cmd multiple times and shows the live output
                            □ Watch df -h
                            □  watch-n 5 df -h
                        -  vmstat: report of system virtual memory, CPU activity (vmstat 2)
                        -  uptime: avg load on a system 
                        -  w: list of login users and task they perform
        b. File system
                        -  ln: used to create shortcut link for file/folder (ln -s abc.txt abc_short.txt)
                        -  less: to read contents of big files pg by pg
                        -  ip addr: displays all the network interfaces of system
                        -  more: used to read large files at one time , screen by screen
                        -  head: shows first 10 lines of the file
                        -  tail: shows last 10 lines of the file
                        -  touch: creates empty file
                        -  df -h <fname>: displays empty space in the hard disk
                        -  du -h<fname>: displays the space taken by file/folder in the disk
                        -  mount: attaches file system to the directory tree
                        -  fsck: filesystem check : check and repairs the error of filesystem
                        -  mkfs: makefile systems: org data and creates file system structure
                        -  find: searches files and folders in entire system (find . -name "*.txt")
                        -  grep: used to find particular string in file (grep "abcd" file.txt)
                        -  locate: faster way of searching a file in Db




        c. Networking troubleshooting
                        -  ping: checks if website is live 
                        -  nslookup: to find ip address of a domain-name (NS= DNS)
                        -  traceroute: list of routers crossed by data while reaching to the destination
                        -  host: converter for domain name to IP address and vice versa
                        -  netstat: nw tables, routing tables and interface stats
                            □ Netstat -tulnp
                        -  netstat -r: routing table for kernel
                        -  ifconfig: info about the network interfaces
                        -  dig: to find the detailed info about DNS records
                        -  route -n: to check the IP routing table and to make changes
                        -  route add: to add a new route to the routing table
                        -  ethtool: speed of NIC (nw card)
                        -  hostname: name of current network 
                        -  hostnamectl: to check/change the hostname and related details- 
                           Sudo oldHostName set-hostname newhostname



        d. Networking Commands
                        -  arp: devices reachable in our LAN, hw address of devices on nw
                        -  curl: used to send/receive data, API testing
                        -  iftop: nw traffic per interface
                        -  ifup: activates CNI config nw interface
                        -  ipcrm: deletes IPC resources to free system memory
                        -  ip: detailed info about nw stack
                        -  ipcs: info about IPC resources
                        -  iptables: configure and monitor firewall rules
                        -  iptables-save: export current iptables config to a file
                        -  iwconfig: troubleshoot wireless conn or monitoring wifi nw
                        -  nc (netcat): used to read/write data over tcp/udp connections
                        -  netstat: display all active connections along with their status
                        -  nmcli: control nw interfaces- ethernet and wifi
                        -  rcp: copy files btwn 2 remote systems over a network
                        -  rsync: copying and synchronizing files and directories between local and remote systems
                        -  scp: same like rcp but secured (encrypts the data)
                        -  ssh: secure shell cmd used to securely connect remote systems over network
                        -  tracepath: shows  network path  (simplified version)(usually pre-installed)(MTU - max transmission unit check)
                        -  traceroute: shows network path (hops)
                        -  vnstat: data transmitted and received over network interfaces
                        -  wget: downloads files from internet to the local system