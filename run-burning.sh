#!/bin/bash

if [[ ! -d /TGM/Apps/VASP/VASP_BIN/6.3.2 ]]; then
    echo "Here is not burning.postech.ac.kr..."
    exit 1
fi

cp ~/input_files/run_slurm.sh .

pestat -s idle
read -p "which queue? (g1~g5, gpu): " q
echo -n "which type? (beef, vtst, sol, gam, qe, cep): "
read -a type

if [[ $q == 'g1' ]]; then
    node=12
elif [[ $q == 'g2' ]] || [[ $q == 'g3' ]] ; then
    node=20
elif [[ $q == 'g4' ]]; then
    node=24
elif [[ $q == 'g5' ]] || [[ $q == 'gpu' ]]; then
    node=32
else
    q='g3'
    node=20
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

total=''
if in_array "qe" "${type[*]}"; then
    sed -i '/mpiexec/i\cat incar.in potcar.in poscar.in kpoints.in > qe-relax.in' run_slurm.sh
    sed -i 's/custom/4 pw.x -in qe-relax.in/' run_slurm.sh
else
    if in_array "beef" "${type[*]}"; then
        sed -i '/mpiexec/i\cp /TGM/Apps/VASP/vdw_kernel.bindat .' run_slurm.sh
        echo 'rm vdw_kernel.bindat' >> run_slurm.sh
        total+='.beef' 
    elif in_array "dftd4" "${type[*]}"; then
        total+='.dftd4'
    fi
    if in_array "sol" "${type[*]}"; then
        total+='.vaspsol'
    elif in_array 'cep' "${type[*]}"; then
        total+='.vaspsol'
    elif in_array "vtst" "${type[*]}"; then
        total+='.vtst'
    elif in_array "wan90v3" "${type[*]}"; then
        total+='.wan90v3'
    fi
    if in_array "gam" "${type[*]}"; then
        total+='.gam'
    elif in_array "ncl" "${type[*]}"; then
        total+='.ncl'
    else
        total+='.std'
    fi
    if [[ -e '/TGM/Apps/VASP/VASP_BIN/6.3.2/vasp.6.3.2'$total'.x' ]]; then
        custom='\$SLURM_NTASKS \/TGM\/Apps\/VASP\/VASP_BIN\/6.3.2\/vasp.6.3.2'
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
        cp INCAR .INCAR_old
        sh ~/bin/orange/modify.sh INCAR IDIPOL 3
        sh ~/bin/orange/modify.sh INCAR LDIPOL
        # if in_array "sol" "${type[*]}"; then
            sh ~/bin/orange/modify.sh INCAR LVHAR
            sh ~/bin/orange/modify.sh INCAR LWAVE
            sh ~/bin/orange/modify.sh INCAR LSOL
            sed -i -e "/mpiexe/a\sh ~\/bin\/orange\/cep-sol.sh $goal" run_slurm.sh
        # else
        #     sh ~/bin/orange/modify.sh INCAR LVHAR .TRUE.
        #     sh ~/bin/orange/modify.sh INCAR LWAVE .FALSE.
        #     sed -i -e "/mpiexe/a\sh ~\/bin\/orange\/cep.sh $goal" run_slurm.sh
        # fi
        if [[ -s WAVECAR ]]; then
            grep mpiexe run_slurm.sh > mpiexe.sh
            sed -i -e '/mpiexe/d' run_slurm.sh
        elif [[ -s CONTCAR ]]; then
            mkdir geo
            cp * geo
            mv CONTCAR POSCAR
        fi
    fi
fi

read -p 'enter jobname if you want to change it: ' jobname
if [[ -n $jobname ]]; then
    sh ~/bin/orange/jobname.sh $jobname
fi