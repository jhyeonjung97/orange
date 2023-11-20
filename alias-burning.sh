#!/bin/bash

alias cdw='cd ~/scratch'
alias run='sh run-burning.sh'

alias idle='pestat -s idle'
alias mystat='qstat -u hyeonjung'
alias mystat-g='
echo "g1"
qstat -u hyeonjung | grep --colour g1
echo "g2"
qstat -u hyeonjung | grep --colour g2
echo "g3"
qstat -u hyeonjung | grep --colour g3'
alias g1='qstat | grep -i "Q g1" '
alias g2='qstat | grep -i "Q g2" '
alias g3='qstat | grep -i "Q g3" '
alias g='
echo -e "\033[1mg1:\033[0m"
g1
echo -e "\033[1mg2:\033[0m"
g2
echo -e "\033[1mg3:\033[0m"
g3
idle'
alias ta='tail -n 6 */stdout*'
alias taa='tail -n 6 */*/stdout*'

alias p='echo "<g1>"
squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep " g1 "
echo "<g2>"
squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep " g2 "
echo "<g3>"
squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep " g3"'
alias p1='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep " g1 "'
alias p2='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep " g2 "'
alias p3='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep " g3 "'
alias pestat1='pestat -N | grep g1'
alias pestat2='pestat -N | grep g2'
alias pestat3='pestat -N | grep g3'