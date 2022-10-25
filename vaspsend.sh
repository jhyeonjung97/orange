#!/bin/bash

read -p "to where?: " p

echo "scp *.vasp hailey@134.79.69.172:~/Desktop/$p"
scp *.vasp hailey@134.79.69.172:~/Desktop/$p