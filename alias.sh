#BASIC
alias c='clear'
alias ls='ls --color=auto'
alias rm='~/bin/rm_mv'
alias rmv='sh ~/bin/orange/rmv.sh'
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
alias spread='sh ~/bin/orange/spread.sh'
alias duplicate='sh ~/bin/orange/duplicate.sh'
alias xyz2vasp='python ~/bin/orange/xyz2vasp.py'
alias backup='sh ~/bin/orange/backup.sh'
alias clone='sh ~/bin/orange/clone.sh'
alias pomass='sh ~/bin/orange/pomass.sh'
alias walltime='sh ~/bin/orange/walltime.sh'
alias queue='sh ~/bin/orange/queue.sh'
alias nofile='mkdir _trash
find . -maxdepth 1 -type f -exec mv {} _trash \;
~/bin/rm_mv _trash'
alias rmfile='find . -maxdepth 1 -type f -delete'
alias direct='sh ~/bin/orange/direct.sh'
alias slab='python3 ~/bin/orange/slab.py'
alias split_dos='python ~/bin/vtstscripts/split_dos.py'
alias merge='python ~/bin/orange/merge-csvs.py'
alias jn='jupyter notebook --allow-root'
alias bader='sh ~/bin/orange/bader.sh'
alias va='sh ~/bin/orange/va.sh'
alias magnet='awk "/magnetization \(x\)/,/tot /" OUTCAR'
alias zip='tar -cvzf'
alias unzip='tar -xvf'
alias ta='tail */std*'

alias temp='sh ~/bin/orange/temp.sh'
alias vbash='vi ~/.bashrc'
alias sbash='source ~/.bashrc'

alias get='sh ~/bin/orange/get.sh'
alias send='sh ~/bin/orange/send.sh'
alias port='sh ~/bin/orange/port.sh'
alias repeat='sh ~/bin/orange/repeat.sh'
alias convert='python3 ~/bin/orange/convert.py'
alias wrap='python ~/bin/orange/wrap.py'
alias cpport='cp *.vasp ~/port'
alias names='sh ~/bin/orange/names.sh'
alias chg='sh ~/bin/orange/chg.sh'
alias dos3='sh ~/bin/shoulder/dos3.sh'

alias orange='dir_now=$PWD
cd ~/bin/orange
git stash
git pull
cd $dir_now'
alias shoulder='dir_now=$PWD
cd ~/bin/shoulder
git stash
git pull
cd $dir_now'
alias verve='dir_now=$PWD
cd ~/bin/verve
git stash
git pull
cd $dir_now'

#SSH
alias burning='ssh -X -Y hyeonjung@burning.postech.ac.kr -p 54329'
alias snu='ssh -X -Y hyeonjung@210.117.209.87'
alias x2658='ssh -X -Y x2658a09@nurion.ksc.re.kr'
alias x2431='ssh -X -Y x2431a10@nurion.ksc.re.kr'
alias x2421='ssh -X -Y x2421a04@nurion.ksc.re.kr'
alias x2347='ssh -X -Y x2347a10@nurion.ksc.re.kr'
alias x2755='ssh -X -Y x2755a09@nurion.ksc.re.kr'
alias cori='ssh -X -Y jiuy97@cori.nersc.gov'
alias nersc='ssh -X -Y jiuy97@perlmutter.nersc.gov'

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
