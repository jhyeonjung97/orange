#BASIC
alias c='clear'
alias ls='ls --color=auto'
alias rm='~/bin/rm_mv'
alias remove='/bin/rm'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cal='bc -l'
alias bin='cd ~/bin'
alias py3='conda activate py3'
alias sfile='du -sh ./'
alias nfile='find . -type f | wc -l'
alias mmff='sh ~/bin/orange/mmff.sh'
alias cluster='sh ~/bin/orange/cluster.sh'
alias center='python ~/bin/orange/center.py'
alias rotate='python ~/bin/orange/rotate.py'
alias flip='python ~/bin/orange/flip.py'
alias gather='sh ~/bin/orange/gather.sh'
alias spread='sh ~/bin/orange/spread.sh'
alias duplicate='sh ~/bin/orange/duplicate.sh'
alias xyz2vasp='python ~/bin/orange/xyz2vasp.py'
alias backup='sh ~/bin/orange/backup.sh'
alias clone='sh ~/bin/orange/clone.sh'

alias zip='tar -cvzf'
alias unzip='tar -xvf'

alias temp='sh ~/bin/orange/temp.sh'
alias vbash='vi ~/.bashrc'
alias sbash='source ~/.bashrc'

alias get='sh ~/bin/orange/get.sh'
alias send='sh ~/bin/orange/send.sh'
alias port='sh ~/bin/orange/port.sh'
alias repeat='sh ~/bin/orange/repeat.sh'
alias rename='sh ~/bin/orange/rename.sh'
alias convert='python3 ~/bin/orange/convert.py'

alias orange='dir_now=$PWD
cd ~/bin/orange
git pull
cd $dir_now'
alias shoulder='dir_now=$PWD
cd ~/bin/shoulder
git pull
cd $dir_now'

#SSH
alias burning='ssh -X -Y hyeonjung@burning.postech.ac.kr -p 1234'
alias x2431='ssh -X -Y x2431a10@nurion.ksc.re.kr'
alias x2421='ssh -X -Y x2421a04@nurion.ksc.re.kr'
alias x2347='ssh -X -Y x2347a10@nurion.ksc.re.kr'
alias cori='ssh -X -Y jiuy97@cori.nersc.gov'
alias nersc='ssh -X -Y jiuy97@perlmutter-p1.nersc.gov'

alias send='sh ~/bin/orange/send.sh'
alias get='sh ~/bin/orange/get.sh'

alias token='echo jhyeonjung97
echo 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'

#ASE
alias ag='ase gui'
alias aga='ag *.vasp'
alias pos='ag POSCAR'
alias posa='ag */POSCAR'
alias pos3='ag 00/POSCAR 01/POSCAR 02/POSCAR 03/POSCAR 04/POSCAR'
alias pos5='ag 00/POSCAR 01/POSCAR 02/POSCAR 03/POSCAR 04/POSCAR 05/POSCAR 06/POSCAR'
alias con='ag CONTCAR'
alias cona='ag */CONTCAR'
alias con3='ag 00/POSCAR 01/CONTCAR 02/CONTCAR 03/CONTCAR 04/POSCAR'
alias con5='ag 00/POSCAR 01/CONTCAR 02/CONTCAR 03/CONTCAR 04/CONTCAR 05/CONTCAR 06/POSCAR'

alias combine='python ~/bin/orange/combine.py'
alias pickle='python3 -m ase.io.trajectory *.traj'
