DAY-10

    1. Create Files:
        i.  touch devops.txt
        ii.  cat > notes.txt  ctrl+c
             echo > notes.txt
        iii.  vi script.sh
                <press i> --insert mode--
                echo "Hello DevOps"
                esc + :wq
                        
    2. Read Files:
        i.  cat notes.txt
        ii.  vi script.sh
                :q! enter
                OR
                vi -r script.sh
        iii.  head /etc/passwd -n 5
        iv.  tail /etc/passwd -n 5
        

    3. Understand Permissions:
        i.  devops.txt
            664 
        User = read+write
        Group = read+write
        Others = read
 
        ii.  notes.txt
            664 
        User = read+write
        Group = read+write
        Others = read
        
        iii.  script.sh
            664 
        User = read+write
        Group = read+write
        Others = read
        
        
        
    4. Modify Permissions:
        i.  chmod +x script.sh
        ii.  chmod -w devops.txt
        iii.  chmod 640 notes.txt
        iv.  mkdir project
            chmod 755 project
        
            
    5. Set Permissions:
        i. It shows that this is a directory 
        bash: file.txt: Permission denied
        A warning is popped at start : changing read-only file

        ii. Permission denied error
        bash: ./script.sh: Permission denied
        
        iii.  Linux strictly enforces permissions: no w → no write, no x → no execution
            a. Writing to read-only file:
            bash: file.txt: Permission denied
            b. Appending to read-only file: 
                bash: file.txt: Permission denied
            c. Executing file without execute permission: 
                bash: ./script.sh: Permission denied
            
