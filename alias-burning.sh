#!/bin/bash

alias cdw='cd ~/scratch'
alias run='sh run-burning.sh'

alias g1='qstat | grep -i "Q g1" '
alias g2='qstat | grep -i "Q g2" '
alias g3='qstat | grep -i "Q g3" '
alias g4='qstat | grep -i "Q g4" '
alias g5='qstat | grep -i "Q g5" '
alias mystat='qstat -u hyeonjung'
alias g='
g1
g2
g3
g4
g5'

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