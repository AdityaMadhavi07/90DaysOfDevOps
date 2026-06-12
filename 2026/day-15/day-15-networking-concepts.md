
Task 1: DNS
    1. How names become IPs
    - When you enter the domain name , browser asks the DNS server about the IP address .
    - DNS server converts the domain name into an IP address 
    - Browser then sends request to the Ip address where the google server exists
    - Server sends response and we get the home page of google

    2. DNS record types
    - A record: maps domain with the ipv4 address
    - AAAA record: maps domain with ipv6 address
    - CNAME: alias 
    - MX record: defines email servers for mail delivery 
    - NS record: specifies the nameservers handled by domain 

    3.  dig google.com 
- TTL - time to live: duration for which the DNS record will stay in cache

Task 2: IP Addressing
 
    1. Ipv4:
        - Unique address that identifies every device on the network
        - This is of 32-bit and divided into 4 parts (octets) each part - (0-255)
        -  xxx.xxx.xxx.xxx (each xxx= 0-255)
        - Device address in network = ipv4
    2. Public vs private IP
        - Public IP:
            - Globally unique over internet
            - Provided by ISP (internet service provider)
            - Directly accessible on internet
        - Private IP:
            - Used locally in office and home
            - Not accessible on internet
            - Internet access is provided through router via NAT (network address translation)
    3. Private IP ranges:
        - 10.x.x.x = 10.0.0.0 - 10.255.255.255.255
        - 172.16.x.x - 172.31.x.x = 172.16.0.0 - 172.31.255.255
        - 192.168.x.x = 192.168.0.0 - 192.168.255.255
    4. Identify which Ips are Private:
        - 


Task 3: CIDR & Subnetting:
    
    1. /24 meaning:
        - The ipv4 address is of 32 bits
        - /24 means - 32-8=24
        - 24 bits = network part, remaining 8 bits = host (devices)
    2. Number of unstable hosts:
        - Total Ips = 2(host bits)  
        - Usable Ips = total -2 (network + broadcast address)
        - For /24 = 28 = 256 = total Ips, usable Ips = 256-2=254
        - /16 = 216 = 65536, usable = 65534 
            - In one network we can have 65k devices connected
        - /28 = 24 = 16 
            - 192.168.1.0/28 , range for this: 192.168.1.1 - 192.168.1.14
        
    3. Why subnetting?
        - Subnetting is used to break network into smaller parts
        - Proper management of network
        - Less traffic , better performance
        - more security 
        - Efficient use of IP address
        
    4. Exercise table:
    CIDR	Subnet Mask	Total IPs	Usable Hosts
    /24	255.255.255.0	256	254
    /16	255.255.0.0	65,536	65,534
    /28	255.255.255.240	16	14
    

Task 4: Ports:

    1. What are ports? Why?
        - Logical number that decides data goes to which application/service
        - Ports help in assuring that the data is sent to correct service
        Why?
            - So we can run multiple services on single IP
            - To make multiple services run on single system
            - To organize the network traffic
        
    2. Common ports:
    Port	Service
    22	SSH (Secure Shell – remote login)
    80	HTTP (normal websites)
    443	HTTPS (secure websites)
    53	DNS (domain resolution)
    3306	MySQL (database)
    6379	Redis (in-memory cache DB)
    27017	MongoDB (NoSQL database)
    
    3.  ss -tulpn 
        
Task 5: putting it together:

    1. curl http://myapp.com:8080
- networking concepts involved:
        - Dns resolution
        - Port usage: request is going to specific 8080 port
        - Tcp connection (http): client establishes TCP connection with the server and sends HTTP request

    2. App can't reach the DB , possible reasons:
        - Network connectivity: ping/route cmd to see if IP is reahable
        - Port & service: mysql (3306) is running and listed
        - Firewall/security rules: check if 3306 port is blocked


