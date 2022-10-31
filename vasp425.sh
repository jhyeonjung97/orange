#!/bin/bash

nums=$(sed -n '6s/ //p' POSCAR)
nums=$(echo $nums | cut -c 1)

if [ $nums -eq $nums ] 2>/dev/null ; then
    echo "Oops, it's VASP4"
    sed -n 6p POSCAR >> temp1
    sed 1d POSCAR >> temp2
    cat temp1 temp2 > POSCAR
    rm temp1 temp2
else
    echo "Don't worry, it's VASP5"
fi

# r=${nums//[0-9]/}
# if [ -z "$r" ]; then
#     echo "vasp4"
# else
#     echo "vasp5"
# fi