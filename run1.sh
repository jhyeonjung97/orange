#!/bin/bash

i=0
for dir in */
do
    cd $dir
    
    # tail
    if [[ ${here} == 'burning' ]]; then
        sed -n '16,$p' run_slurm.sh > ../tail.sh
    elif [[ ${here} == 'kisti' ]] || [[ ${here} == 'nurion' ]]; then
        sed -n '11,$p' run_slurm.sh > ../tail.sh
    else
        echo 'where am i..? please modify [combine.sh] code'
        exit 1
    fi

    # head
    if [[ $i == 0 ]]; then
        if [[ ${here} == 'burning' ]]; then
            sed -i '16,$d' run_slurm.sh
        elif [[ ${here} == 'kisti' ]] || [[ ${here} == 'nurion' ]]; then
            sed -i '11,$d' run_slurm.sh
        else
            echo 'where am i..? please modify [combine.sh] code'
            exit 1
        fi
        # bond2
        echo "cd $dir" > bond2.sh
        cat run_slurm.sh bond2.sh > ../head.sh
    else
        # bond1
        echo "cd .." > ../bond1.sh
        # bond2
        echo "cd $dir" > bond2.sh
    fi
    
    cd ..
    i=$(($i+1))
    
    cat head.sh bond1.sh bond2.sh tail.sh > run_slurm.sh
    mv run_slurm.sh head.sh
done
rm bond1.sh bond2.sh
sed -i '$d' run_slurm.sh
mv head.sh run_slurm.sh