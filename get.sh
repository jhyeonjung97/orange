#!/bin/bash

if [[ $1 == '-r' ]]; then
    surv=$2
    r='-r '
    read -p "which directories?: " file
else
    surv=$1
    read -p "which files?: " file
    if [ $file == 'p' ] || [ $file == 'pos' ]; then
        file='POSCAR'
    elif [ $file == 'c' ] || [ $file == 'con' ]; then
        file='CONTCAR'
    fi
fi
        
if [[ -z $surv ]]; then
    p='-P 1234 '
    surv='hyeonjung@burning.postech.ac.kr:'
elif [[ $surv == 'mac' ]]; then
    surv='hailey@134.79.69.172:~/Desktop/'
elif [[ $surv == 'kisti' ]]; then
    surv='x2431a10@nurion.ksc.re.kr:'
elif [[ $surv == 'cori' ]]; then
    surv='jiuy97@cori.nersc.gov:'
elif [[ $surv == 'nersc' ]]; then
    surv='jiuy97@perlmutter-p1.nersc.gov:'
fi

read -p "from where?: " path

echo "scp $p$r$surv$path/$file ."
scp $p$r$surv$path/$file .