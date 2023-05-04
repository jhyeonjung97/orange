#!/bin/bash

function resub {
    if [[ ${here} == 'kisti' ]]; then
        rm *.e* *.o* *out.log
    else
        rm STD* *out.log
    fi
    # rm WAVECAR CHGCAR
    # find . -size +10000000c -type f -delete
    if [[ -d pwscf.save ]]; then
        rm -r pwscf.save
    fi
    if [[ -e "pwscf.*" ]]; then
        rm "pwscf.*"
    fi
    if [[ -f CRASH ]]; then
        rm CRASH
    fi
    if [[ -n $(grep cep run_sluerm.sh) ]]; then
        if [[ -e mpiexe.sh ]] && [[ -s WAVECAR ]]; then
            sed -i -e '/mpiexe/d' run_slurm.sh
        fi
    fi
    sh ~/bin/orange/sub.sh
}

if [[ -z $1 ]]; then # simple re-submit
    resub
else
    if [[ $1 == '-r' ]] || [[ $1 == 'all' ]]; then
        DIR='*/'
    elif [[ $1 == '-s' ]] || [[ $1 == '-select' ]]; then
        DIR=${@:2}
    elif [[ -z $2 ]]; then
        DIR=$(seq 1 $1)
    else
        DIR=$(seq $1 $2)
    fi
    
    for i in $DIR
    do
        i=${i%/}
        cd $i*
        resub
        cd ..
    done
fi