1. core components of linux:
    a. Linux: it is a open-source OS, used to run computers and servers. Acts as the  bridge between hardware and software
    b. kernel: core component of linux, interacts with the hardware, manages the CPU
    c. user space: part of OS where user app and programs run , isolated from kernel for security and stability
    d. init/systemd: first process started my kernel(PID 1), it initializes the system and manages system services(eg nginx, ssh and apache)


2. How process are created and managed?
    - process : running process
        - states of process: running --> ready --> waiting --> terminated
        - process creation: fork() --> exec()
    - fork(): creates new process
    - exec(): loads the program
    - in linux, process are created using system calls like fork() and exec() are managed by kernel which handles scheduling, execution and termination of process.

3. What is systemD?
    - system d refers to the baground process which is required for the further process to get executed.
    - system manager for linux, 
    - init system and service manager
    - initializes system during boot and manages system services, process and resources
    - manages the services:
            - systemctl start nginx
            - systemctl stop nginx
    - autostart enable/disable:
            - systemctl enable nginx
            - systemctl disble nginx
    - logs management:
            - journalctl

    Why?
    - faster boot time
    - parallel execution
    - better logging
    - centralized control

4. Explain process states
these are managed by the kernel
    - running: process that is currently executing on CPU
    - ready: process is ready to run waiting for CPU
    - sleeping: a process waiting for an event
    - uninterruptible sleep: i/o wait
    - stopped: temporarily paused
    - Zombie process: process that has finished execution but still has an entry in the process table, parent process fails to call wait(), dead but entry exist
    - terminated: dead.completed execution and removed from the system

 5. man -   built-in doc in Linux give detailed info about commands, their usage, options, and examples.