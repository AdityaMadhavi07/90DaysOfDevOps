Day - 19 
--------------------------------------------------------------------------
Task 1:

1. 

vi log_rotate.sh && chmod +x log_rotate.sh
#!/bin/bash

set -euo pipefail

log_dir="$1"


if [[ -z "$log_dir" ]]; then
    echo "No directory name provided."
    exit 1
fi

if [[ -d "$log_dir" ]]; then
    echo "directory does not exist"
    exit 1
fi 

compressed_count=0
deleted_count=0


while IFS= read -r files_to_del; do
    gzip "$files_to_del"
    if [[ $? -eq 0 ]]; then
    (( compressed_count++ ))
    fi
done< <(find "$dir" -type f -name "*.log" -mtime +7)

while IFS= read -r deleting_files; do
    rm "$deleting_files"
    if [[ $? -eq 0 ]]; then
    ((deleted_count++))
    fi
done< <(find "$dir" -type f -name "*.gz" -mtime +30)


echo "$compressed_count files were compressed and $deleted_count were deleted."

--------------------------------------------------------------------------
Task 2:

1. 
vi backup.sh && chmod +x backup.sh


#!/bin/bash
set -euo pipefail

if [[  ! $# -eq 2 ]]; then
    echo "Enter the source directory and backup destination as arguments "
    exit 1
fi

# .tar.gz = compression and archive
#/home/ubuntu/90DaysOfDevOps/week2/     bkp_dest    source_dir

source_directory="$1"
backup_destination="$2"

echo "creating the backup of the directory in $backup_destination...."
sleep 2

if [[ ! -d "$source_directory" ]]; then
    echo "source directory not present"
    exit 1
fi

if [[ ! -d "$backup_destination" ]]; then
    echo "backup destination does not exist, creating destination path.."
    sleep 1
    mkdir -p "$backup_destination" $-p creates the parent directories also if not present
fi

timestamp=$(date +"%y-%m-%d")  # tells date how to format the output

archive_name="backup-${timestamp}.tar.gz"
archive_path="${backup_destination}/${archive_name}"

# concept of var expansion = {} and cmd substitution = ()

echo "creating backup...."
sleep 2

tar -czvf "$archive_path" "$source_directory"

if [[ ! -f "$archive_path" ]]; then
    echo "backup failed"
    exit 1
fi

size=$(du -h "$archive_path" | cut -f1)

echo "backup created successfully! Size: "$size""

echo "cleaning old backups...."
sleep 1

find "$backup_destination" -name "backup-*.tar.gz" -mtime +14 -delete
echo "old backups deleted"

------------------------------------------------------------------------

Task 3:

1. Currently no crontab scheduled for Ubuntu user

2.   *   *   *   *   *   

    min(0-59)|hr(0-23)|doM(1-31)|m(1-12)|doW(0-7)
    m   hr  dm  m   dw

    (0-59)  (0-24)  (1-31)  (1-12)  (0-7)

3.  
    *   2   *   *   * /home/ubuntu/90DaysOfDevOps/week2/log_rotate.sh   #everyday 2AM
    *   3   *   *   0 /home/ubuntu/90DaysOfDevOps/week2/backup.sh       #every sunday 3AM
    */5   *   *   *   * /home/ubuntu/90DaysOfDevOps/week2/health_check.sh #every 5 mins
   
      
4. 
#!/bin/bash

log_file="var/log/maintenance.log"

log(){
        echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"

}

log "running log rotation"

/home/ubuntu/log_rotate.sh >> "$log_file" 2>&1

log "running backup"

/home/ubuntu/backup.sh >> "$log_file" 2>&1

echo "" >> "$log_file"