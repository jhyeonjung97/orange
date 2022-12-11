#!/bin/bash

if [[ ! -d /TGM/Apps/VASP/VASP_BIN/6.3.2 ]]; then
    echo "Here is not burning.postech.ac.kr..."
fi

cp ~/input_files/run_slurm.sh .

q=$1
jobname=$2
type=${@:3}

if [[ -z $q ]]; then
    pestat -s idle
    read -p "which queue? (g1~g5, gpu): " q
fi
if [[ $type == 'n' ]] || [[ $type == '0' ]]; then
    type=''
elif [[ -z $type ]]; then
    echo -n "which type? (beef, vtst, vaspsol, gam, qe, cep): "
    read -a type
fi

if [[ $q == 'g1' ]]; then
    node=12
elif [[ $q == 'g2' ]] || [[ $q == 'g3' ]] ; then
    node=20
elif [[ $q == 'g4' ]]; then
    node=24
elif [[ $q == 'g5' ]] || [[ $q == 'gpu' ]]; then
    node=32
else
    echo "I've never heard of that kind of node.."
    exit 1
fi

sed -i "/ntasks-per-node/c\#SBATCH --ntasks-per-node=$node" run_slurm.sh
sed -i "/partition/c\#SBATCH --partition=$q" run_slurm.sh

function in_array {
    ARRAY=$2
    for e in ${ARRAY[*]}
    do
        if [[ $e == $1 ]]; then
            return 0
        fi
    done

    return 1
}

if in_array "qe" "${type[*]}"; then
    sed -i '/mpiexec/i\cat incar.in potcar.in poscar.in kpoints.in > qe-relax.in' run_slurm.sh
    sed -i 's/custom/4 qe-relax.in/' run_slurm.sh
else
    if in_array "beef" "${type[*]}"; then
        sed -i '/mpiexec/i\cp /TGM/Apps/VASP/vdw_kernel.bindat .' run_slurm.sh
        # sed -i 's/std/beef.std/' run_slurm.sh
        total+='beef' 
        echo 'rm vdw_kernel.bindat' >> run_slurm.sh
    elif in_array "dftd4" "${type[*]}"; then
        # sed -i 's/std/dftd4.std/' run_slurm.sh
        total+='dftd4'
    fi
    if in_array "vaspsol" "${type[*]}"; then
        # sed -i 's/std/vaspsol.std/' run_slurm.sh
        total+='.vaspsol'
    elif in_array "vtst" "${type[*]}"; then
        # sed -i 's/std/vtst.std/' run_slurm.sh
        total+='.vtst'
    elif in_array "wan90v3" "${type[*]}"; then
        # sed -i 's/std/wan90v3.std/' run_slurm.sh
        total+='.wan90v3'
    fi
    if in_array "gam" "${type[*]}"; then
        # sed -i 's/std.x/gam.x/' run_slurm.sh
        total+='.gam'
    elif in_array "ncl" "${type[*]}"; then
        # sed -i 's/std.x/ncl.x/' run_slurm.sh
        total+='.ncl'
    else
        total+='.std'
    fi
    if [[ -e '/TGM/Apps/VASP/VASP_BIN/6.3.2/vasp.6.3.2.'$total'.x' ]]; then
        custom='\$SLURM_NTASKS \/TGM\/Apps\/VASP\/VASP_BIN\/6.3.2\/vasp.6.3.2.'
        sed -i "s/custom/$custom$total.x/" run_slurm.sh
    else
        echo 'there is no corroesponding version...'
        exit 1
    fi
    if in_array 'cep' "${type[*]}"; then
        read -p 'goal electrode potential? (default: -0.6 V) ' goal
        if [[ -z $goal ]]; then
            echo 'use default value -0.6 V...'
            goal='-0.6'
        fi
        sed -i -e "/mpiexe/a\sh ~\/bin\/orange\/cep.sh $goal" run_slurm.sh
        sh ~/bin/orange/modify.sh INCAR IDIPOL 3
        sh ~/bin/orange/modify.sh INCAR LDIPOL
        sh ~/bin/orange/modify.sh INCAR LVHAR .TRUE.
        sh ~/bin/orange/modify.sh INCAR LWAVE
    fi
    # if [[ -n $(grep beef run_slurm.sh) ]]
    #     sed -n '16,18p' run_slurm.sh > .run_conti.sh
    # else
    #     sed -n '16p' run_slurm.sh > .run_conti.sh
    # fi

    # echo '
    # sh ~/bin/orange/relax_error.sh' >> run_slurm.sh
fi

if [[ $jobname == 'n' ]] || [[ $jobname == '0' ]]; then
    jobname=''
elif [[ -z $jobname ]]; then
    read -p 'enter jobname if you want to change it: ' jobname
fi

if [[ -n $jobname ]]; then
    sh ~/bin/orange/jobname.sh $jobname
fi