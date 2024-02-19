#!/bin/bash

# default destination server
if [[ ${here} == 'mac' ]]; then
    port=' -P 54329'
    srvr='hyeonjung@burning.postech.ac.kr:'
elif [[ ${here} == 'burning' ]]; then
    port=''
    srvr='hailey@192.168.0.241:~/Desktop/'
fi

# Let's check the input values
for i in $@
do

    # File OR Directory
    if [[ $i == '-r' ]]; then
        r=' -r'
        
    # specific destination server
    elif [[ $i == 'mac' ]]; then
        port=''
        srvr='hailey@172.30.1.14:~/Desktop/'
    elif [[ $i == 'mini' ]]; then
        port=''
        srvr='hailey@192.168.0.241:~/Desktop/'
    elif [[ $i == 'burning' ]]; then
        port=' -P 54329'
        srvr='hyeonjung@burning.postech.ac.kr:'
    elif [[ $i == 'snu' ]]; then
        port=''
        srvr='hyeonjung@210.117.209.87:'
    elif [[ $i == 'x2658' ]]; then
        port=''
        srvr='x2658a09@nurion-dm.ksc.re.kr:'
    elif [[ $i == 'x2421' ]]; then
        port=''
        srvr='x2421a04@nurion-dm.ksc.re.kr:'
    elif [[ $i == 'x2431' ]]; then
        port=''
        srvr='x2431a10@nurion-dm.ksc.re.kr:'
    elif [[ $i == 'x2347' ]]; then
        port=''
        srvr='x2347a10@nurion-dm.ksc.re.kr:'
    elif [[ $i == 'x2755' ]]; then
        port=''
        srvr='x2755a09@nurion-dm.ksc.re.kr:'
    elif [[ $i == 'cori' ]]; then
        port=''
        srvr='jiuy97@cori.nersc.gov:'
    elif [[ $i == 'nersc' ]]; then
        port=''
        srvr='jiuy97@perlmutter.nersc.gov:'
    
    # POSCAR/CONTCAR/port
    elif [[ $i == 'p' ]] || [[ $i == 'pos' ]]; then
        file="$file POSCAR"
    elif [[ $i == 'c' ]] || [[ $i == 'con' ]]; then
        file="$file CONTCAR"
    elif [[ $i == 'port' ]]; then
        file="$file ~/port/*"
    else 
        file="$file $i"
    fi
    
done

# destination path
read -p "to where?: " path

# I don't want meaningless command
if [[ -z $file ]]; then
    echo 'Please let me know which file to send..'
    exit 1
elif [[ -z $path ]] && [[ $srvr != 'hailey@172.30.1.14:~/Desktop/' ]]; then
    echo 'Files/Directories will be sent to home directory..'
fi

echo "scp$port$r$file $srvr$path"
scp$port$r$file $srvr$path


