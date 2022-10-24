#BASIC
alias c='clear'
alias ls='/bin/ls --color=auto'
alias rm='~/bin/rm_mv'
alias remove='/bin/rm'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cal='bc -l'
alias cdw='cd ~/scratch'
alias bin='cd ~/bin'

alias zip='tar -cvzf'
alias unzip='tar -xvf'

alias vbash='vi ~/.bashrc'
alias sbash='source ~/.bashrc'

alias get='bash ~/bin/orange/get.sh'
alias send='bash ~/bin/orange/send.sh'
alias port='bash ~/bin/orange/port.sh'

alias orange='cd ~/bin/orange
git pull'
alias shoulder='cd ~/bin/shoulder
git pull'

#SSH
alias burning='ssh -X -Y hyeonjung@burning.postech.ac.kr -p 1234'
alias kisti='ssh -X -Y x2431a10@nurion.ksc.re.kr'
alias nurion='ssh -X -Y x2347a10@nurion.ksc.re.kr'
alias cori='ssh -X -Y jiuy97@cori.nersc.gov'
alias nersc='ssh -X -Y jiuy97@perlmutter-p1.nersc.gov'

alias send='python3 ~/bin/orange/send.py'
alias get='python3 ~/bin/orange/get.py'

alias token='echo jhyeonjung97
echo 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'

#ASE
alias ag='ase gui'
alias aga='ag *'
alias pos='ag POSCAR'
alias posa='ag */POSCAR'
alias pos3='ag 00/POSCAR 01/POSCAR 02/POSCAR 03/POSCAR 04/POSCAR'
alias pos5='ag 00/POSCAR 01/POSCAR 02/POSCAR 03/POSCAR 04/POSCAR 05/POSCAR 06/POSCAR'
alias con='ag CONTCAR'
alias cona='ag */CONTCAR'
alias con3='ag 00/POSCAR 01/CONTCAR 02/CONTCAR 03/CONTCAR 04/POSCAR'
alias con5='ag 00/POSCAR 01/CONTCAR 02/CONTCAR 03/CONTCAR 04/CONTCAR 05/CONTCAR 06/POSCAR'

alias pickle='python3 -m ase.io.trajectory *.traj'
