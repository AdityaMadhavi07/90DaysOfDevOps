Day - 16 

Task 1:
1. vi hello.sh
2. #!/bin/bash
3. echo "Hello DevOps!"
4. chmod +x hello.sh
./hello.sh
When we remove the shebang line, the output stays the same , but this line tells the interpretor that this is Bash script.

---------------------------------------------------------

Task 2:
1. vi variable.sh && chmod +x variable.sh
    name="Aditya"
    role="DevOps Engineer"
    echo "Hello, I am $name and I am a $role"
2. Single quotes does not add the real value of Variable. It considers the Variable as a String. 
    Double quote fetchs the real value of the variable.

---------------------------------------------------------


Task 3:
1. vi greet.sh && chmod +x greet.sh
read -p "Enter your name: "name
read -p "What is your favourite tool? "favtool
echo "Hello $name, your favourite tool is $favtool"

---------------------------------------------------------


Task 4:
1. vi check_number.sh && chmod +x check_number.sh
#!/bin/bash

read -p "Enter your number: " num

if [[ num -gt 0 ]]; then
        echo "Number entered is Positive"
elif [[ num -eq 0 ]]; then
        echo "Number entered is Zero"
else
        echo "Number entered is Negetive"
fi


2. vi file_check.sh && chmod +x file_check.sh
#!/bin/bash

read -p "enter the file name: " file_name

        if [[ -f "$file_name" ]]; then 
                echo "file found"
        else
                echo "file not found"
        fi

---------------------------------------------------------



Task 5:
1. vi server_check.sh && chmod +x server_check.sh
#!/bin/bash

read -p "enter the service name: " service_name

read -p "do you want to check the status? (Y/N) " ans

if [[ "$ans" == "Y" ]]; then
        systemctl status "$service_name"
else
        echo "skipped"
fi

---------------------------------------------------------

