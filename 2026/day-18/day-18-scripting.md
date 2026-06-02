Day - 18
--------------------------------------------------------------------------
Task 1:

1. 
#!/bin/bash
ste -euo pipefail

greet(){
    read -p "Enter your good name: " name
    echo "Hello, $name!"
}

add(){
    read -p "Enter 1st number: " num1
    read -p "Enter 2nd number: " num2
    ans=$((num1+num2))
    echo "sum of the numbers is: $ans "
}

greet
add

--------------------------------------------------------------------------
Task 2:

1. 
#!/bin/bash
set -euo pipefail

check_disk(){
 used=$(df -h | awk 'NR==2 {print $3}')
 echo "disk usage is $used"

}

check_disk

check_memory(){
    free_memory=$(free -h | awk 'NR==2 {print $4}')
    echo "free memory is: $free_memory"
}

check_memory

main(){
    echo " Providing the Disk Details..."
    sleep 1
    check_disk
    sleep 1
    check_memory
}

main 
--------------------------------------------------------------------------
Task 3:

1. 
#!/bin/bash

#set -euo pipefail
#set -u
#set -e
set -o pipefail

#n1=7
#echo "the number is $n2"

name=Alpha
echo "name: $name"

#use=df -h |awk 'NR==2 print{$3}'
#echo "$use"



--------------------------------------------------------------------------
Task 4:

1. 
#!/bin/bash

set -euo pipefail

hello(){
    name=Alex_Local
    local age=23
   # echo "Name: $name"
}

hello 

echo "name is $name"
echo "age is $age"


--------------------------------------------------------------------------
Task 5:

1. 
#!/bin/bash
set -euo pipefail

hostos_info(){
    echo "hostname: "
    hostname
}

osinfo(){
    echo "Os info: "
    cat /etc/os-release | awk 'NR==2, NR==4'
}

show_uptime(){
    echo "Uptime:"
    uptime -p
}

disk_usage(){
    du -sh | sort -hr | head -5
}

memory_usage(){
    free -h
}

cpu_comsuming_proc(){
    ps aux --sort=-%cpu | head -6
}

main(){
    echo "Displaying the Hostname and OS info: "
    hostos_info
    osinfo
    
    echo "----------------------------"
    sleep 1
    
    show_uptime

    echo "----------------------------"
    sleep 1
    
    echo "Disk usage: (top-5)"
    disk_usage
    
    echo "----------------------------"
    sleep 1
    
    echo "Memory Usage: "
    memory_usage
    
    echo "----------------------------"
    sleep 1
    
    echo "Top 5 CPU-consuming processes: "
    cpu_comsuming_proc
}

main