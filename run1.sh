#!/bin/bash

i=0
for dir in */
do
    cd $dir
    
    # head
    if [[ $i == 0 ]]; then
        if [[ ${here} == 'burning' ]]; then
            sed -n '1,15p' run_slurm.sh > ../head.sh
        elif [[ ${here} == 'kisti' ]] || [[ ${here} == 'nurion' ]]; then
            sed -n '1,10p' run_slurm.sh > ../head.sh
        else
            echo 'where am i..? please modify [run1.sh] code'
            exit 1
        fi
    else
        echo "cd ..
        " >> ../bond.sh
    fi
    echo "## run_slurm.sh from directory: $dir" >> ../bond.sh
    echo "cd $dir" >> ../bond.sh
    
    # tail
    if [[ ${here} == 'burning' ]]; then
        sed -n '16,$p' run_slurm.sh > ../tail.sh
    elif [[ ${here} == 'kisti' ]] || [[ ${here} == 'nurion' ]]; then
        sed -n '11,$p' run_slurm.sh > ../tail.sh
    else
        echo 'where am i..? please modify [combine.sh] code'
        exit 1
    fi
    
    cd ..
    i=$(($i+1))
    
    cat head.sh bond.sh tail.sh > run_slurm.sh
    rm head.sh bond.sh tail.sh
    mv run_slurm.sh head.sh
done
rm bond*.sh
sed -i '$d' head.sh
mv head.sh run_slurm.sh