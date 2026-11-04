-----------------------------------------------------------------
Task 1: key-value pairs

vi person.yaml

name: Aditya Madhavi
role: software developer & ai engineer
experience_years: 2
learning: true
-----------------------------------------------------------------
Task 2: lists

<!-- creating list: -->
tools:
    - Jenkins
    - Gitactions, 
    - jira
    - kubernetes
    - telemetry


<!-- creating list using inline format -->
hobbies: [cricket, coding, singing]

#2 ways of writing lists: block style and inline style
inline used for short lists
block style used for long lists
-----------------------------------------------------------------
Task 3: nested objects

vi server.yaml

server:
  name: web-server
  ip: 192.168.1.10
  port: 8080

database:
  host: localhost
  name: appdb

  credentials:
    user: admin 
--
indentation defines the parent-child relationship
always use 2 spaces for indentation
YAML strictly forbids the use of the Tab key character for indentation. If you use a physical tab, the parser will throw a critical syntax error and fail to read the file.

-----------------------------------------------------------------
Task 4: multi-line strings

using | (block style)

startup_script_preserve: |
  #!/bin/bash
  echo "Starting app"
  java -jar app.jar


using > (fold-style)

startup_script_folded: >
  This application
  starts automatically
  after boot.

  when we use: >
  new lines get converted in one single line


--
use | :
- shell scripts
- sql scripts
- config scripts
- preserve line breaks

use > :
- long descriptions
- documentation text
- paragraphs

-----------------------------------------------------------------
Task 5: Validating Yaml

installing online validator: 
sudo apt update # this refreshes our package index, no install/upgrade
sudo apt install yamllint -y

yamllint --version

yamllint person.yaml
yamllint server.yaml

errors are displayed here

-----------------------------------------------------------------
Task 6: Spoting the diff

- the indentation plays an important part in creating the yaml files
- use spaces only(2-spaces), no tabs
- string dont need quotes unless they have special characters
- indentation defines hierarchy

-----------------------------------------------------------------

for the reader:

- yaml is a human-readable serialization language.
- most devops tools, use yaml to define infra and automation workflows

