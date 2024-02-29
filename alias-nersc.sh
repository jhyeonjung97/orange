#!/bin/bash

alias cdw='cd /pscratch/sd/j/jiuy97'
alias cdp='cd /global/cfs/cdirs/m2997/'

alias vasp5='mv /global/homes/j/jiuy97/.local/lib/python3.11/site-packages/ase/io/vasp_parsers/vasp_outcar_parsers5.py /global/homes/j/jiuy97/.local/lib/python3.11/site-packages/ase/io/vasp_parsers/vasp_outcar_parsers.py'
alias vasp6='mv /global/homes/j/jiuy97/.local/lib/python3.11/site-packages/ase/io/vasp_parsers/vasp_outcar_parsers6.py /global/homes/j/jiuy97/.local/lib/python3.11/site-packages/ase/io/vasp_parsers/vasp_outcar_parsers.py'
alias run='sh run-nersc.sh'
alias time='grep sec OUTCAR'
alias qdel='scancel'
alias mystat='squeue -o "%.18i %.9P %.18j %.8u %.10T %.8M %.10l %.6D %R" --me --sort=i'
# alias mystat='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q" | grep jiuy97'
# alias qstat='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q"'
# alias priority='squeue -o "%.10F %.10u %.20j %.2P %.5Q %.2t %.2Y" -S "t,-Q"'
# alias p='pestat -N'