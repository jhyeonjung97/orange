#!/bin/bash

# default destination server
if [[ ${here} == 'mac' ]]; then
    port=' -P 1234'
    srvr='hyeonjung@burning.postech.ac.kr:'
else
    srvr='hailey@134.79.69.172:~/Desktop/'
fi

# Let's check the input values
for i in $@
do

    # File OR Directory
    if [[ $i == '-r' ]]; then
        r=' -r'
        
    # specific destination server
    elif [[ $i == 'mac' ]]; then
        srvr='hailey@134.79.69.172:~/Desktop'
    elif [[ $i == 'burning' ]]; then
        port='-P 1234 '
        srvr='hyeonjung@burning.postech.ac.kr:'
    elif [[ $i == 'kisti' ]]; then
        srvr='x2431a10@nurion.ksc.re.kr:'
    elif [[ $i == 'cori' ]]; then
        srvr='jiuy97@cori.nersc.gov:'
    elif [[ $i == 'nersc' ]]; then
        srvr='jiuy97@perlmutter-p1.nersc.gov:'
    fi
    
done

# File OR Directory
if [[ $r == '-r' ]]; then
    read -p "which directories?: " file
else
    read -p "which files?: " file
    if [[ $file == 'p' ]] || [[ $file == 'pos' ]]; then
        file='POSCAR'
    elif [[ $file == 'c' ]] || [[ $file == 'con' ]]; then
        file='CONTCAR'
    fi
fi

if [[ $file == 'port' ]]; then
    path='~/port'
    file='*'
else
    read -p "from where?: " path
fi

echo "scp $port$r$srvr$path/$file ."
scp $port$r$srvr$path/$file .