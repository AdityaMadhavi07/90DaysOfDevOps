Day-11

    1.  ls -l
        i. Owner and group for all files are respective owners of file.
            like owner and group for tokyo directory is tokyo itself
        ii. Difference between owner and group:
        Owner:
            - User who owns the file/directory
            - One who created the file
        Group:
            - Collection of users
            - Users of group can get shared access to a file
            - Permissions applied to group will be applicable to users also
        
    2. Basic chown operations:
        i.  touch devops-file.txt
        ii.  ls -l devops-file.txt
                owner = ubuntu (since ubuntu user created the file)
        iii.  sudo chown tokyo:ubuntu devops-file.txt
        iv.  sudo chown berlin:ubuntu devops-file.txt

        
    3. Basic chgrp operations
        i.  touch team-notes.txt
        ii.   ls -l (current grp = ubuntu)
        iii.   sudo groupadd heist-team
        iv.  cat /etc/group
            we see heist-team added in the list at the bottom
    
    4. Combined Owner and Group change:
        i.  touch project-config.yaml
        ii.  sudo chown professor:heist-team project-config.yaml
        iii.  mkdir app-logs 
        iv.  sudo chown berlin:heist-team app-logs


    5. Recursive Ownership:
    -p = creates missing parent directories, create full path safely
        i. Created directory structure
        ii.  sudo groupadd planners
            cat /etc/group
        iii.  sudo chown -R professor:planners heist-project/
        iv.  ls -lr heist-project
        
    
    
    6. Practice Challenge:
        i.  sudo useradd -m tokyo
            sudo useradd -m berlin
            sudo useradd -m nairobi
        ii.  sudo groupadd vault-team
            sudo groupadd tech-team
        iii.  mkdir bank-heist
        iv. Created files in bank-heist directory
        v. Setting ownership:
          sudo chown tokyo:vault-team access-codes.txt 
          sudo chown berlin:tech-team blueprints.pdf 
          sudo chown nairobi:vault-team escape-plan.txt
        vi.  ls -l bank-heist/
        
       
