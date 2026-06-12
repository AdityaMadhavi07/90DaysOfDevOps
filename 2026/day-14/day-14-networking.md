    
    
1. OSI vs TCP/IP Stack
    - OSI model:
        -  Breaks networking into 7 detailed layers: PDNTSPA
        -  Phy-datalink-ntw-transport-session-presentation-app
    - TCP/IP model:
        -  Simplified real-world model used on the internet: LITA 
        -  Link-internet-transport-app

2.  - Ip (osi layer 3 -ntw)
    Provides addressing and routes packets across ntw
    - Tcp/udp (osi layer 4 -transport)
    Reliable, ordered delivery, fast but no guarantee, used for streaming
    - Http/https (osi layer 7 - application)
    Http is plain, https is secured (encrypted)
    - DNS (osi layer 7 - application)
    Converts domain names to IP addresses

3. curl https://example.com - app --> transport --> internet --> link

4. networking cmds:
   
- hostname -I / ip addr show

Shows your system’s IP address on the network.
Helps confirm your machine is connected and what IP it’s using.

- ping <target>

Sends small packets to check if the target is reachable.
Gives latency (ms) and packet loss info.

- traceroute <target> / tracepath

Shows the path (hops) packets take to reach the destination.
Helps identify slow or broken points in the route.

- ss -tulpn / netstat -tulpn

Lists all listening ports and services on your system.
Useful to check if a service (like SSH, web server) is running.

- dig <domain> / nslookup <domain>

Converts domain name → IP address (DNS lookup).
Helps verify if DNS resolution is working.

- curl -I <url>

Sends a request and shows only the HTTP response headers.
Used to quickly check server response (200, 404, 500, etc.).


- netstat -an | head

Shows a snapshot of active and listening connections.
Helps see how many connections are open (ESTABLISHED vs LISTEN).

5. if not reachable - systemstl status ssh
   
6. reflection:
    - ss -tulpn
    - Dns fails = check App layer 
    - follow-up task: service + firewall