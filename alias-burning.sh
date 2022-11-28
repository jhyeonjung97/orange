#!/bin/bash

alias cdw='cd ~/scratch'
alias run='sh run-burning.sh'

alias idle='pestat -s idle'
alias mystat='qstat -u hyeonjung | grep --colour g1
qstat -u hyeonjung | grep --colour g2
qstat -u hyeonjung | grep --colour g3
qstat -u hyeonjung | grep --colour g4
qstat -u hyeonjung | grep --colour g5
qstat -u hyeonjung | grep --colour gpu'
alias g1='qstat | grep -i "Q g1" '
alias g2='qstat | grep -i "Q g2" '
alias g3='qstat | grep -i "Q g3" '
alias g4='qstat | grep -i "Q g4" '
alias g5='qstat | grep -i "Q g5" '
alias g='
echo -e "\033[1mg1:\033[0m"
g1
echo -e "\033[1mg2:\033[0m"
g2
echo -e "\033[1mg3:\033[0m"
g3
echo -e "\033[1mg4:\033[0m"
g4
echo -e "\033[1mg5:\033[0m"
g5
echo -e "\033[1midle:\033[0m"
idle'

alias priority='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q"'
alias p1='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep g1'
alias p2='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep g2'
alias p3='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep g3'
alias p4='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep g4'
alias p5='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep g5'
alias p='pestat -N'
alias pestat1='pestat -N | grep g1'
alias pestat2='pestat -N | grep g2'
alias pestat3='pestat -N | grep g3'
alias pestat4='pestat -N | grep g4'
alias pestat5='pestat -N | grep g5'