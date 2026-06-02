DAY-17:

----------------------------------------------------

Task 1:
1. for_loop.sh
#!/bin/bash

for i in apple banana custurd dragonfruit pear; do
        echo "$i"
done


2. count.sh
#!/bin/bash

for i in {1..10}; do
        echo "$i"
done

----------------------------------------------------

Task 2:
1. countdown.sh
#!/bin/bash

read -p "give a number: " num
        while [[ num -gt 0 ]]; do
                echo $num
                ((num--))
                sleep 1
done

echo "Done!"

----------------------------------------------------

Task 3:
1. greet.sh
#!/bin/bash

#read -p "Enter your name: " name
#read -p "What is your favourite tool? " tool
#echo "Hello $name, your favourite tool is $tool"

if [[ -z "$1" ]]; then
        echo "Usage:./greet.sh"
else 
        echo "Hello, $1"
fi

2. args_demo.sh
#!/bin/bash

echo "Total number of arg: $#"
echo "the args are as follows: $@"
echo "the script name: $0"

----------------------------------------------------
Task 4:
1. install_packages.sh
#!/bin/bash
        for pkg in nginx curl wget; do
                if dpkg -s "$pkg" >/dev/null 2>&1 || rpm -q "$pkg" >/dev/null 2>&1; then
                        echo "$pkg is already installed.."
                        sleep 2
                        systemctl status "$pkg" >/dev/null 1>&2
                else
                echo "installing $pkg......"
                sleep 2
                apt install -y "$pkg" >/dev/null 2>&1
                echo "$pkg installed"
                fi
        done


----------------------------------------------------
Task 5:
1. safe_script.sh
#!/bin/bash

set -e

mkdir /tmp/devops-test || echo "Directory already exists"

cd /tmp/devops-test

touch file.txt 
echo "this is sample file" >> file.txt


cat file.txt

ls -l file.txt

2. install_packages.sh
#!/bin/bash
if [[ "$EUID" -ne 0 ]]; then
        echo "Run the script with ROOT user"
        exit 1
else
        for pkg in nginx curl wget; do
                if dpkg -s "$pkg" >/dev/null 2>&1 || rpm -q "$pkg" >/dev/null 2>&1; then
                        echo "$pkg is already installed.."
                        sleep 2
                        systemctl status "$pkg" >/dev/null 1>&2
                else
                echo "installing $pkg......"
                sleep 2
                apt install -y "$pkg" >/dev/null 2>&1
                echo "$pkg installed"
                fi
                done
fi

----------------------------------------------------
























