#!/bin/bash

function conti {
    i=1
    save="conti_$i"
    while [[ -d "conti_$i" ]]
    do
        i=$(($i+1))
        save="conti_$i"
    done
    mkdir $save
    mv * $save
    cd $save/
    mv */ ..
    cp POSCAR ../initial.vasp
    cp POSCAR CONTCAR INCAR KPOINTS POTCAR run_slurm.sh initial.vasp ..
    cd ..

    if [[ -s CONTCAR ]]; then
        mv CONTCAR POSCAR
    fi

    if [[ ${here} == 'burning' ]]; then
        sbatch run_slurm.sh
    elif [[ ${here} == 'nurion' ]] || [[ ${here} == 'kisti' ]]; then
        qsub run_slurm.sh
    else
        echo 'where am i..? please modify [con2pos.sh] code'
        exit 1
    fi
}

function conti-qe {
    i=1
    save="conti_$i"
    while [[ -d "conti_$i" ]]
    do
        i=$(($i+1))
        save="conti_$i"
    done
    sh out2xyz.sh
    mkdir $save
    mv * $save
    cd $save/
    mv */ ..
    cp poscar.in ../initial.in
    cp poscar.in contcar.in incar.in kpoints.in potcar.in run_slurm.sh initial.in ..
    cd ..

    if [[ -s contcar.in ]]; then
        mv contcar.in poscar.in
    fi

    if [[ ${here} == 'burning' ]]; then
        sbatch run_slurm.sh
    elif [[ ${here} == 'nurion' ]] || [[ ${here} == 'kisti' ]]; then
        qsub run_slurm.sh
    else
        echo 'where am i..? please modify [conti-qe.sh] code'
        exit 1
    fi
}

if [[ -z $1 ]]; then # simple conti
    if [[ -z $(grep pw.x run_slurm.sh) ]]; then
        conti
    else
        conti-qe
    fi
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
        if [[ -z $(grep pw.x run_slurm.sh) ]]; then
            conti
        else
            conti-qe
        fi
        cd ..
    done
fi