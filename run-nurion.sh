#!/bin/bash

if [[ ! -d ~/KISTI_VASP/ ]]; then
    echo 'Here is not nurion.ksc.re.kr...'
    exit 1
fi

cp ~/input_files/run_slurm.sh .

read -p 'which queue? (normal, skl, long, flat): ' q
echo -n 'which type? (beef, vtst, sol, gam, qe, cep): '
read -a type

if [[ $q == l* ]]; then
    node=64
    q='long'
    sed -i -e 's/walltime=48/walltime=120/g' run_slurm.sh
elif [[ $q == s* ]]; then
    node=40
    q='norm_skl'
    sed -i -e 's/KNL_XeonPhi/SKL_Skylake/g' run_slurm.sh
elif [[ $q == f* ]]; then
    node=64
    q='flat'
else
    node=64
    q='normal'
fi

sed -i "/ncpus/c\#PBS -l select=1:ncpus=$node:mpiprocs=$node:ompthreads=1" run_slurm.sh
sed -i "/#PBS -q/c\#PBS -q $q" run_slurm.sh

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
if in_array 'qe' "${type[*]}"; then
    sed -i '/mpiexe/i\cat incar.in potcar.in poscar.in kpoints.in > qe-relax.in' run_slurm.sh
    sed -i 's/custom/8 pw.x -in qe-relax.in/' run_slurm.sh
    echo 'if [[ -n $(grep Maximum stdout.log) ]]; then' >> run_slurm.sh
    echo '    sh ~/bin/orange/conti.sh' >> run_slurm.sh
    echo 'fi' >> run_slurm.sh
else
    if in_array 'vtst' "${type[*]}"; then
        total+='.vtst179'
    fi
    if in_array 'beef' "${type[*]}"; then
        sed -i -e '/mpiexe/i\cp ~/KISTI_VASP/vdw_kernel.bindat .' run_slurm.sh
        echo 'rm vdw_kernel.bindat' >> run_slurm.sh
        total+='.beef'
    fi
    if in_array 'sol' "${type[*]}"; then
        total+='.vaspsol'
    elif in_array 'cep' "${type[*]}"; then
        total+='.vaspsol'
    fi
    if in_array 'gam' "${type[*]}"; then
        total+='.gam'
    elif in_array 'ncl' "${type[*]}"; then
        total+='.ncl'
    else
        total+='.std'
    fi
    if [[ -e "/home01/${account}/KISTI_VASP/KNL_XeonPhi/vasp.5.4.4.pl2.KISTI.KNL_XeonPhi$total.x" ]]; then
        custom='KISTI_VASP\/KNL_XeonPhi\/vasp.5.4.4.pl2.KISTI.KNL_XeonPhi'
        sed -i -e "s/custom/$node \/home01\/${account}\/$custom$total.x/" run_slurm.sh
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
            grep mpiexe run_slurm.sh >> mpiexe.sh
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
