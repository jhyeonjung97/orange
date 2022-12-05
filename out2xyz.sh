#!/bin/bash

function out2xyz {
    if [[ ! -f stdout.log ]] || [[ -z $(grep ATOMIC_POSITIONS stdout.log) ]]; then
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
    echo 'ATOMIC_POSITIONS (crystal)' >> contcar.in
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

if [[ -z $1 ]]; then # simple out2xyz
    out2xyz
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
        out2xyz
        cd ..
    done
fi

read -p 'gather contcar.xyz? [y/n] (default: y) ' gather
if [[ $gather != n* ]]; then
    for dir in */
    do
        cd $dir
        if [[ -f contcar.xyz ]]; then
            numb=$(echo $dir | cut -c 1)
            cp contcar.xyz ../contcar$numb.xyz
        fi
        cd ..
    done
fi
# atoms=$(grep ATOMIC_POSITIONS qe-relax.in -A $nat | tail -n $nat )

# if [[ -e '.poscar.xyz' ]]; then
#     rm '.poscar.xyz'
# fi
# echo $nat >> '.poscar.xyz'
# echo $PWD >> '.poscar.xyz'
# echo $atoms >> '.poscar.xyz'

# python ~/bin/orange/cell2xyz.py '.poscar.xyz' 'poscar.xyz' $a
# sed -i -e "1a$nat" -e '2d' poscar.xyz