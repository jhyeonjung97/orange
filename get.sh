#!/bin/bash

# default starting server
if [[ ${here} == 'mac' ]]; then
    srvr='hailey@134.79.69.172:'
else
    port=' -P 1234'
    srvr='hyeonjung@burning.postech.ac.kr:'
fi

# Let's check the input values
for i in $@
do

    # File OR Directory
    if [[ $i == '-r' ]]; then
        r=' -r'
        
    # specific destination server
    elif [[ $i == 'mac' ]]; then
        srvr='hailey@134.79.69.172:'
    elif [[ $i == 'burning' ]]; then
        port='-P 1234 '
        srvr='hyeonjung@burning.postech.ac.kr:'
    elif [[ $i == 'kisti' ]]; then
        srvr='x2431a10@nurion.ksc.re.kr:'
    elif [[ $i == 'cori' ]]; then
        srvr='jiuy97@cori.nersc.gov:'
    elif [[ $i == 'nersc' ]]; then
        srvr='jiuy97@perlmutter-p1.nersc.gov:'
    
    # specific destination
    elif [[ $i == 'p' ]] || [[ $i == 'pos' ]]; then
        file='POSCAR'
    elif [[ $i == 'c' ]] || [[ $i == 'con' ]]; then
        file='CONTCAR'
    elif [[ $i == 'port' ]]; then
        path='~/bin/port'
        file='*'
    else 
        file=$i
    fi
    
done

# starting path
if [[ -z $path ]]; then
    read -p "from where?: " path
fi

# I don't want meaningless command
if [[ -z $file ]]; then
    echo 'Please let me know which file to send..'
    break
elif [[ -z $path ]] && [[ $srvr != 'hailey@134.79.69.172:~/Desktop/' ]]; then
    echo 'Files/Directories will be sent to home directory..'
fi

echo "scp$port$r $srvr$path/$file ."
scp$port$r $srvr$path/$file .