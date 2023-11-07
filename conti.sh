#!/bin/bash
OIFS=$IFS

neb=''
if [[ $1 =~ '-n' ]]; then
    neb='yes'
    shift
fi

if [[ -z $1 ]]; then # simple submit
    DIR='./'
elif [[ $1 == '-r' ]] || [[ $1 == 'all' ]]; then
    DIR='*/'
elif [[ $1 == '-s' ]] || [[ $1 == '-select' ]]; then
    DIR=${@:2}
elif [[ -z $2 ]]; then
    DIR=$(seq 1 $1)
else
    DIR=$(seq $1 $2)
fi

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
    if [[ -s CHGCAR ]]; then
        cp CHGCAR ..
        sh ~/bin/orange/modify.sh INCAR ICHARG 1
    fi
    if [[ -s WAVECAR ]]; then
        cp WAVECAR ..
        sh ~/bin/orange/modify.sh INCAR ISTART 1
    fi
    cp POSCAR CONTCAR INCAR KPOINTS POTCAR run_slurm.sh initial.vasp mpiexe.sh ..
    cd ..

    if [[ -s CONTCAR ]]; then
        mv CONTCAR POSCAR
    fi
}

function neb {
    i=1
    save="conti_$i"
    while [[ -d "conti_$i" ]]
    do
        i=$(($i+1))
        save="conti_$i"
    done
    mkdir $save
    mv * $save
    cd $save
    # IFS=' '
    # image_string=$(grep IMAGES INCAR)
    # read -ra image_array <<< $image_string
    # image=$(echo ${image_array[2]} | awk '{printf "%.3f", $1}')
    cp -r 0*/ ..
    cp INCAR KPOINTS POTCAR run_slurm.sh mpiexe.sh ..
    cd ..
    for j in 0*/
    do
        mv $j/CONTCAR $j/POSCAR
    done
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
}

function cep {
    rm STD*
    if [[ ! -s WAVECAR ]] && [[ -s CONTCAR ]]; then
        if [[ -z initial.vasp ]]; then
            cp POSCAR initial.vasp
        fi
        mv CONTCAR POSCAR
    elif [[ -s WAVECAR ]]; then
        sed -i -e '/mpiexe/d' run_slurm.sh
    fi
}


for i in $DIR
do
    i=${i%/}
    cd $i*
    if [[ $neb == 'yes' ]]; then
        neb
        sh ~/bin/orange/sub.sh
    elif [[ -n $(grep pw.x run_slurm.sh) ]]; then
        if [[ -n $(grep Maximum stdout.log) ]] && [[ -n $(grep request stdout.log) ]]; then
            if [[ -n $(grep DONE stdout.log) ]]; then
                echo 'DONE!'
            else
                qe
                sh ~/bin/orange/sub.sh
            fi
        else
            qe
            sh ~/bin/orange/sub.sh
        fi
    elif [[ -n $(grep cep-sol.sh run_slurm.sh) ]]; then
        cep
        sh ~/bin/orange/sub.sh
    else
        conti
        sh ~/bin/orange/sub.sh
    fi
    cd ..
done
IFS=$OIFS