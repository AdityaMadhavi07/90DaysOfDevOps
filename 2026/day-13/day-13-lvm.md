
---------------------------------------------
task 1: check current storage

1. lsblk , pvs ,vgs, lvs, df -h 

---------------------------------------------   
task 2: creating phy volume:

pvcreate /dev/nvme1n1
pvs

---------------------------------------------   
task 3: creating vol grp:

vgcreate devops-vg /dev/nvme1n1
vgs

---------------------------------------------   
task 4: creating logical vol:

lvcreate -L 500M -n app-data devops-vg
lvs

---------------------------------------------   
task 5: format and mount:

mkfs.ext4 /dev/devops-vg/app-data
mkdir -p /mnt/app-data
mount /dev/devops-vg/app-data /mnt/app-data
df -h /mnt/app-data

---------------------------------------------   
task 6: extend the volume:

lvextend -L +200M /dev/devops-vg/app-data
df -h /mnt/app-data

---------------------------------------------   