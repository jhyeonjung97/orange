#!/bin/bash

function out2xyz {
    atomic=$(grep ATOMIC_POSITIONS stdout.log | tail -n 1)
    if [[ ! -f stdout.log ]] || [[ -z $atomic ]]; then
        echo $PWD': no contcar data...'
        cp poscar.in contcar.in
        return 0
    fi

    nat_tag=$(grep nat qe-relax.in | sed 's/\t/ /')
    IFS=' '
    read -ra nat_arr <<< $nat_tag
    nat=${nat_arr[2]}
    # echo $nat

    ntyp_tag=$(grep ntyp qe-relax.in | sed 's/\t/ /')
    IFS=' '
    read -ra ntyp_arr <<< $ntyp_tag
    ntyp=${ntyp_arr[2]}
    # echo $ntyp

    unit=$(grep CELL_PARAMETERS qe-relax.in)
    if [[ $unit =~ crystal ]] || [[ $unit =~ alat ]]; then
        alat=$(grep 'A =' qe-relax.in)
        celldm=$(grep 'celldm(1)' qe-relax.in)
        if [[ -n $alat ]]; then
            alat_tag=$(grep 'A =' qe-relax.in | sed 's/\t/ /')
            IFS=' '
            read -ra alat_arr <<< $alat_tag
            cell=${alat_arr[2]}
        elif [[ -n $celldm ]]; then
            celldm_tag=$(grep 'A =' qe-relax.in | sed 's/\t/ /')
            IFS=' '
            read -ra celldm_arr <<< $celldm_tag
            cell=${celldm_arr[2]}
        else    
            cell_tag=$(grep CELL_PARAMETERS qe-relax.in -A 1 | tail -n 1)
            IFS=' '
            read -ra cell <<< $cell_tag
        fi
    else
        cell=1
    fi
    # echo $cell

    atoms=$(grep ATOMIC_POSITIONS stdout.log -A $nat | tail -n $nat )

    if [[ -e contcar.in ]]; then
        rm contcar.in
    fi
    sed '/ATOMIC_POSITIONS/,$d' poscar.in >> contcar.in
    echo "$atomic" >> contcar.in
    echo $atoms >> contcar.in

    if [[ -e '.contcar.xyz' ]]; then
        rm '.contcar.xyz'
    fi
    echo $nat >> '.contcar.xyz'
    echo $PWD >> '.contcar.xyz'
    echo $atoms >> '.contcar.xyz'

    python ~/bin/orange/cell2xyz.py '.contcar.xyz' 'contcar.xyz' $cell
    file=$(ls *.cif)
    filename="${file%.*}"
    sed -i -e "1a$filename" -e '2d' contcar.xyz
}

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
    cp POSCAR CONTCAR INCAR KPOINTS POTCAR run_slurm.sh initial.vasp mpiexe.sh ..
    cd ..

    if [[ -s CONTCAR ]]; then
        mv CONTCAR POSCAR
    fi
    sh ~/bin/orange/sub.sh
}

function qe {
    i=1
    while [[ -f "stdout$i.log" ]] || [[ -f "contcar$i.xyz" ]]
    do
        i=$(($i+1))
    done
    sh ~/bin/orange/out2xyz.sh
    cp contcar.xyz contcar$i.xyz
    cp stdout.log stdout$i.log
    if [[ -s contcar.in ]]; then
        mv contcar.in poscar.in
    fi
    if [[ -n $(grep DONE stdout.log) ]]; then
        if [[ -n $(grep Maximum stdout.log) ]] || [[ -n $(grep request stdout.log) ]]; then
            sed -i 's/from_scratch/restart/g' incar.in
            sed -i 's/from_scratch/restart/g' qe-relax.in
        fi
    fi
    cat incar.in potcar.in poscar.in kpoints.in > qe-relax.in
    sh ~/bin/orange/sub.sh
}

function cep {
    rm STD*
    if [[ ! -s WAVECAR ]] && [[ -s CONTCAR ]]; then
        cp POSCAR .POSCAR
        mv CONTCAR POSCAR
    elif [[ -s WAVECAR ]]; then
        sed -i -e '/mpiexe/d' run_slurm.sh
    fi
    sh ~/bin/orange/sub.sh
}

if [[ -z $1 ]]; then # simple conti
    if [[ -n $(grep pw.x run_slurm.sh) ]]; then
        qe
    elif [[ -n $(grep cep-sol.sh run_slurm.sh) ]]; then
        cep
    else
        conti
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
        if [[ -n $(grep pw.x run_slurm.sh) ]]; then
            if [[ -n $(grep Maximum stdout.log) ]] && [[ -n $(grep request stdout.log) ]]; then
                if [[ -n $(grep DONE stdout.log) ]]; then
                    echo 'DONE!'
                else
                    qe
                fi
            else
                qe
            fi
        elif [[ -n $(grep cep-sol.sh run_slurm.sh) ]]; then
            cep
        else
            conti
        fi
        cd ..
    done
fi