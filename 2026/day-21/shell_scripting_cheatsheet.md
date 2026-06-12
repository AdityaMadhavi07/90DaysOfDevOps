
-------------------------------Task-1 Basics ------------------------------
1. Shebang (`#!/bin/bash`) — what it does and why it matters
    - it is considered as the entry point of script
    - the kernel understands which kind of interpeter is used to run this script(bash or shell)
    - it is a comment so adding it or removing it wont make any difference

2. Running a script — `chmod +x`, `./script.sh`, `bash script.sh`
    - chmod +x helps to run the file, it makes it executable
    - ./ is the command used to actually run the file, here it is imp to mention the shebang line 
    -  bash script.sh here we explicitly ask the interpreter to use the bash to run, shebang is not important

3. Comments — single line (`#`) and inline
    - commments are used to make the script readable 

4. Variables — declaring, using, and quoting (`$VAR`, `"$VAR"`, `'$VAR'`)
    - '$var'- when you wan to add $ as a symbol
    - "$var" - expands the variable
    - $var - simple access
    - ${var} - command output
    - ` ` - backticks are also used to run a command and store the value in variable (old-style)
  
5. Reading user input — `read`
    - read is used to fetch the user input and it is in string 
    - read -p "what is your name? " ans 
      - -p is with prompt
    - read -a array_name
  
6. Command-line arguments — `$0`, `$1`, `$#`, `$@`, `$?`
    - $0 = the 0th argument which is the name of script itself
    - $1 = the first argument (name after the script)
    - $# = count of arguments
    - $@ = list of all  arguments (used in loops)
    - $? = exit status (output of the previous statement/process)

--------------------------Task-2 Operators and Conditionals------------------------

1. String comparisons — `=`, `!=`, `-z`, `-n`
    - = ,assignment operator to give value to a variable 
    - != , not equal to
    -z and -n = conditional string operators, while using you must add "" to the variable
        -z "$var"     |   -z "$var"
    - -z , checks if string length is zero(empty), used for defaults 
    - -n checks if string length is non-zero, used for validation

2. Integer comparisons — `-eq`, `-ne`, `-lt`, `-gt`, `-le`, `-ge`
    - -eq , similiar operator
    - -ne , not equal to
    - -lt , less than
    - -gt , greater than
    - -le , less than or equal to
    - -ge , greater than or equal to
    
3. File test operators — `-f`, `-d`, `-e`, `-r`, `-w`, `-x`, `-s`
    - -f , checks if the input is a file
    - -d , checks if the input is a directory
    - -e , checks if the input exists
    - -r , checks if the input has read permissions
    - -w , checks if the input has write permissions
    - -x , checks if the input has execute permissions
    - -s , checks if the file size is > 0 , used to check non-empty files
    
4. `if`, `elif`, `else` syntax
   -  if [[ condition ]]; then
        echo "this will fall under if condition"
      elif
        echo "this will fall under elif condition"
      else 
        echo "this will fall under else condition"
      fi

    if-else in shell-scripting is used for decision making.


5. Logical operators — `&&`, `||`, `!`
   - && = logical and = it is used to execute two commands
        -  vi script.sh && chmod +x script.sh
        -  used in chain commands
        -  after execution of first command, second command will run
        -  both commands must be true
   - || = logical OR = this is used when first command is failed
        -  used to fallback
  
   - ! = logical not = used to negate the condition
   
6. Case statements — `case ... esac`
    - advanced version of if-else condition
    - used in menu seletion
    - case var in  = start case check; esac = end case block

-------------------------------Task-3 Loops------------------------------

1. `for` loop — list-based and C-style
        - list based = iterates over list of values: (space separated)
            for i in apple banana lemon
        - C cycle = numeric loop
            for (( i=0; i<=3; i++ ));do

2. `while` loop
        - repeats till the condition *is* true
        
3. `until` loop
        - repeats until the condition *becomes* true
        - opposite of while loop
        
4. Loop control — `break`, `continue`
   - break = gets out from the loop, the loop stops/terminates
   - continue = skips the current iteration and switchs to next iteration

        
5. Looping over files — `for file in *.log`
        - iterates over matching files in directory
        
6. Looping over command output — `while read line`
        - reads command output line by line
        

-------------------------------Task-4 Functions------------------------------

1. Defining a function — `function_name() { ... }`
    - function is used to reduce the repitative task
    -  add(){
        ans=$(( $1 + $2 ))
        echo "addition of sums: $ans"
        }


2. Calling a function
    - add 


3. Passing arguments to functions — `$1`, `$2` inside functions
    - add 2 3
    - these are space separated


4. Return values — `return` vs `echo`
    - return gives exite code , status, success/failure, has 0-255 only
    - echo gives actual value, any number/text


5. Local variables — `local`
    - these variable are accessible inside a function only


-------------------------Task-5 Text Processing Commands---------------------------

1. `grep` — search patterns, `-i`, `-r`, `-c`, `-n`, `-v`, `-E`
    - -i = case insensitive
    - -r = recursive, when searching in directories
    - -c = counts, shows cout only , grep -c "word", shows occurance
    - -n = shows line numbers, grep -n "text", shows occurance with line number
    - -v = invert match (not), grep -v "red" colors.txt, this will display all colors except red
    - -E = extended regex , grep -E "[0-9]", grep -E "pattern" filename


2. `awk` — print columns, field separator, patterns, `BEGIN/END`
    - custom filtered text, to process text column-wise
    - default seperator = space
    - echo "a,b,c" | awk -F"," '{print $2}' # made comma as the feild seperator
    - begin/end = runs before and after file processing
    - 

3. `sed` — substitution, delete lines, in-place edit
    - echo "hello world" | sed -s/world/linux #replaces world with linux
    - sed '2d' file.txt $ deletes 2nd line from file.txt
    - sed -i 's/world/linux' file.txt


4. `cut` — extract columns by delimiter
    - to consider fixed position based column
    - echo "a,b,c" | cut -d"," -f2 # we get the second column as output


5. `sort` — alphabetical, numerical, reverse, unique
    - alphabetical sort = sort file.txt
    - numeric sort = sort -n numbers.txt
    - reverse sort = sort -r file.txt
    - reverse numberic = sort -rn numbers.txt
    - unique sort = sort -u file.txt (removes duplicate)


6. `uniq` — deduplicate, count
    - uniq file.text = adjusts/removes duplicate
    - uniq -c file.txt = shows count of duplicates 


7. `tr` — translate/delete characters
    - used to replace lowercase with uppercase and vice-versa:
        echo "hello" | tr 'a-z' 'A-Z' # HELLO
    - used to delete the characters:
        echo "hello123" | tr -d '123' or tr -d '0-9' # hello


8. `wc` — line/word/char count
    - wc file.txt # shows number of lines in file.txt


9. `head` / `tail` — first/last N lines, follow mode
    - shows starting and ending lines
        head -n 5 file.txt
        tail -n 5 file.txt


------------------------Task-6 Useful Patterns and One-Liners -------------------------

Include at least 5 real-world one-liners you find useful. Examples:
- Find and delete files older than N days
- Count lines in all `.log` files
- Replace a string across multiple files
- Check if a service is running
- Monitor disk usage with alerts
- Parse CSV or JSON from command line
- Tail a log and filter for errors in real time





--------------------------Task-7 Error Handling and Debugging---------------------------

Document with examples:
1. Exit codes — `$?`, `exit 0`, `exit 1`
        - $? we get the return code/status of previos process
        - exit 0 , thisis treated as success code
        - ecit 1 this is treated as failure code

2. `set -e` — exit on error
        - as soon as the script encounters an error/any command fails the script stops
  
3. `set -u` — treat unset variables as error
        - the script must have no unset or undefined variable

4. `set -o pipefail` — catch errors in pipes
        - exit code of entire pipeline is checked

5. `set -x` — debug mode (trace execution)
        - ./script -x , this prints all the logs on the run in the screen, along with the output
        - this helps to debug and troubleshoot the error

6. Trap — `trap 'cleanup' EXIT`
        - used to make scripts detect special signals and take action on them
        - trap 'commands' signals
        - takes 2 arguments: code to run and the signal 
        - Trap is used to
              - resource management 
              - clean up - temp files,locks and connections. if we do ctrl-c / the script fails then the garbage remains in the system. with trap the cleanup happens automatically
              - signal handling
              - error tracking
                  - trap 'rm -f "$temp1" "$temp2" '
                  - trap cleanup exit # cleanup = function
                  - trap shutdown INT TERM Quit # gracefull shutdown
        - signals: INT, EXIT, ERR, DEBUG
        - SIGNLAS messages coming from OS that tell the script that some event occured


-----------------------Task-8 Bonus — Quick Reference Table--------------------------

Create a summary table like this at the top of your cheat sheet:

| Topic | Key Syntax | Example |
|-------|-----------|---------|
| Variable | `VAR="value"` | `NAME="DevOps"` |
| Argument | `$1`, `$2` | `./script.sh arg1` |
| If | `if [ condition ]; then` | `if [ -f file ]; then` |
| For loop | `for i in list; do` | `for i in 1 2 3; do` |
| Function | `name() { ... }` | `greet() { echo "Hi"; }` |
| Grep | `grep pattern file` | `grep -i "error" log.txt` |
| Awk | `awk '{print $1}' file` | `awk -F: '{print $1}' /etc/passwd` |
| Sed | `sed 's/old/new/g' file` | `sed -i 's/foo/bar/g' config.txt` |T