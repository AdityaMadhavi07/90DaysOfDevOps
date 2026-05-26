    1.  sudo useradd -m tokyo
        sudo useradd -m berlin
        sudo useradd -m professor
    
    
    2. Creating groups:
        sudo groupadd developers
        sudo groupadd admins
            
    
    3. Assign to groups:
         sudo usermod -aG developers tokyo
         sudo gpasswd -a berlin developers 
         sudo gpasswd -a berlin admins
         sudo gpasswd -a professor admins
        
        To check the membership:
        cat /etc/group
        
        
        
    4. Shared Directory:
        i.  mkdir /opt/ dev-project
        ii.  sudo chown root:developers dev-project
        iii.  sudo chmod 775 dev-project
        iv.  sudo touch tokyo berlin
        
        
    5. Team workspace:
        i.  sudo useradd -m nairobi
        ii.  sudo groupadd project-team
        iii.  sudo usermod -aG project-team
                sudo gpasswd -a tokyo project-team
        iv.  sudo mkdir /opt/team-workspace
        v.  sudo chown root:project-team team-workspace
         sudo chmod 775 team-workspace
