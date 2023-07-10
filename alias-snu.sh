#!/bin/bash

alias cdw='cd ~/scratch'
alias run='sh run-burning.sh'

alias idle='pestat -s idle'
alias mystat='qstat -u hyeonjung'
alias mystat-g='
echo "g1"
qstat -u hyeonjung | grep --colour g1'
alias g1='qstat | grep -i "Q g1" '
alias g='
echo -e "\033[1mg1:\033[0m"
g1
echo -e "\033[1midle:\033[0m"
idle'
alias ta='tail -n 6 */stdout*'
alias taa='tail -n 6 */*/stdout*'

alias p='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep g1'