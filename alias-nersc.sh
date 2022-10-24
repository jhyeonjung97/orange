alias pestat='squeue --me'
alias qstat='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q"'
alias mystat='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep jiuy97'
alias qdel='scancel'
alias priority='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q"'
alias p='pestat -N'

alias cdw='/global/cscratch1/sd/jiuy97'