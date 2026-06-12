Day 20:
-------------------------------------task 1-------------------------------------------

vi log_analyzer.sh && chmod +x log_analyzer.sh

#!/bin/bash

#input and validation-----task 1

if [[ $# -eq 0 ]]; then
    echo "No argument provided"
    exit 1
fi

file="$1"

if [[ ! -f "$file" ]]; then
    echo "File - $file does not exist"
    exit 1
fi

#error count----------------------------------task 2-------------------------------------

error_count=$(grep -c "ERROR" "$file")
failed_count=$(grep -c "FAILED" "$file")

total_error_count=$((error_count + failed_count))
echo "total error count = $total_error_count"

#critical events-------------------------------------task 3------------------------------------

echo "----------Critical Events----------"

grep -n "CRITICAL" "$file"


#Top error message--------------------------------task 4----------------------------------------------


echo "extracting error messages into a file..."
sleep 2

error_lines= grep -n "ERROR" "$file"



error_path="/home/ubuntu/90DaysOfDevOps/week2/logs/error.log"

echo "$error_lines" > "$error_path"


echo -e "\n\n"

echo "****error.log file is created on $(date), you can find it in : $error_path"
sleep 2
echo 
ls -l error.log
echo -e "\n"
echo "-----top 5 error messages-----"
sleep 2
crisp_output=$(grep -i "error" "$file" | awk '{$1=$2=$3=$4=$5=$6=$7=$8=$9=""; print}')

unique_sorting=$(echo "$crisp_output" | sort | uniq -c)

descending_order=$(echo "$unique_sorting" | sort -rn | head -n 5)

echo "$descending_order"

echo -e "\n\n  Script ends....  \n\n"

#summary report  ----------------------------------task 5--------------------------------------------

#!/bin/bash

# date of analysis
date_of_analysis=$(date +%y-%m-%d)

# logfilename
log_file=/home/ubuntu/90DaysOfDevOps/week2/logs/BGL_2k.log

# lines_processed
total_lines=$(wc -l BGL_2k.log | awk '{$2=""; print}')

# error count
error_count=$(grep -c "ERROR" "$log_file")

# Top 5 error messages with their occurrence count
top_5_error=$(
                grep -i "error" $log_file | awk '{for(i=1; i<=9; i++) $i=""; print}' | sort | uniq -c | sort -rn | head -n 5

)

# List of critical events with line numbers
critical_events=$(
                        grep -ni "critical" "$log_file" | head -n 5
)

# generating report:
report_file=log_report_"$date_of_analysis".txt

{
    echo " ******* Log analysis report: ******* "
    echo
    echo "date of analysis          : $date_of_analysis"
    echo
    echo "log filename              : $log_file"
    echo
    echo "total lines processed     : $total_lines"
    echo
    echo "total error count         : $error_count"
    echo
    echo "------------------- Top 5 error messages --------------------"
    echo
    echo "$top_5_error"
    echo
    echo "-------------------List of critical events-------------------"
    echo
    echo "$critical_events"
    echo
    echo " ******* END ******* "

} > "$report_file"


echo "loading ...."
sleep 2

echo "********** Report generated: $report_file **************"

echo

if [[ ! -d "archive" ]]; then
    mkdir -p archive
fi

mv "$report_file" archive
echo "File is been moved to archive directory."
exit 0



<<comment
read -p "Do you want to open the file? (y/n) " ans

if [[ "$ans" == "y" ]]; then
    cat $report_file
    exit 1
else
    ls -lrt
fi

comment