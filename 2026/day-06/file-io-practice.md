practice basic file read/write using only fundamental commands.

    1. Creating a file: mkdir demo
        a.  touch abc.txt
        b.  touch abc --> here abc will be regular file - .txt
    2. Heredoc: for multiline content
        cat << EOF > config.conf
        PORT=8080
        ENV=prod
        DB_HOST=localhost
        EOF
        ``
    3. Appending new lines:
        -  echo "This is replacing line"  > newfile.txt
        -  echo "This is appending line"  >> newfile.txt
        - Cat  > file.txt ,  hello this is new text , ctrl+d

    4.  tee command:
        - Displays the output on screen and also saves it in file
        -  ls -lrt | tee list.txt
        -  echo "testing the tee command" | tee latestfile.txt , this works like > command
-----------------------

    1.  vi notes 
    2.  this is ln 1 with vi editor
    3.  this is ln 2 with vi editor
    4.  this is ln 3 with vi editor

    1.  touch notes2.txt
    2.  echo "this is ln 1 with cmd" >> notes2.txt
    3.  echo "this is ln 2 with cmd" >> notes2.txt
    4.  echo "this is ln 3 with cmd" >> notes2.txt



 head notes2.txt - shows starting 10 lines
 tail notes2.txt - shows ending 10 lines
 tail -f /var/log/syslog = check the logs live
 tail -n 11 notes.txt
