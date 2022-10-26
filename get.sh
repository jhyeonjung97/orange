#!/bin/bash

# default starting server
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
        path='~/port'
        file='*'
    else 
        file="$i"
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
The default interactive shell is now zsh.
To update your account to use zsh, please run `chsh -s /bin/zsh`.
For more details, please visit https://support.apple.com/kb/HT208050.
(base) Haileys-MBP:~ hailey$ cori
***************************************************************************
                          NOTICE TO USERS

Lawrence Berkeley National Laboratory operates this computer system under
contract to the U.S. Department of Energy.  This computer system is the
property of the United States Government and is for authorized use only.
Users (authorized or unauthorized) have no explicit or implicit
expectation of privacy.

Any or all uses of this system and all files on this system may be
intercepted, monitored, recorded, copied, audited, inspected, and disclosed
to authorized site, Department of Energy, and law enforcement personnel,
as well as authorized officials of other agencies, both domestic and foreign.
By using this system, the user consents to such interception, monitoring,
recording, copying, auditing, inspection, and disclosure at the discretion
of authorized site or Department of Energy personnel.

Unauthorized or improper use of this system may result in administrative
disciplinary action and civil and criminal penalties. By continuing to use
this system you indicate your awareness of and consent to these terms and
conditions of use. LOG OFF IMMEDIATELY if you do not agree to the conditions
stated in this warning.

*****************************************************************************

Login connection to host cori07 :

(jiuy97@cori.nersc.gov) Password + OTP:
Last login: Fri Oct 21 14:54:48 2022 from pc91622.slac.stanford.edu
----------------------------- Contact Information ------------------------------

NERSC Contacts                https://www.nersc.gov/about/contact-us/
NERSC Status                  https://www.nersc.gov/live-status/motd/
NERSC: 800-66-NERSC (USA)     510-486-8600 (outside continental USA)

----------------- Current Status as of 2022-10-25 20:46 PDT --------------------

Compute Resources:
Cori:            Available.
Perlmutter:      Unavailable. 10/24/22 15:00-10/26/22 9:00 PDT, Scheduled