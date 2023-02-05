#!/bin/bash

read -p "to where?: " p

echo "scp *.vasp hailey@172.30.1.14:~/Desktop/$p"
scp *.vasp hailey@172.30.1.14:~/Desktop/$p