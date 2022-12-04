#!/bin/bash

if [[ ! -d ~/KISTI_VASP/ ]]; then
    echo 'Here is not nurion.ksc.re.kr...'
    exit 1
fi

cp ~/input_files/run_slurm.sh .

read -p 'which queue? (normal, skl, long): ' q
echo -n 'which type? (beef, vtst, vaspsol, gam, qe): '
read -a type

if [[ $q == l* ]]; then
    node=64
    q='long'
    sed -i 's/walltime=48/walltime=120/' run_slurm.sh
elif [[ $q == s* ]]; then
    node=40
    q='norm_skl'
    sed -i 's/KNL_XeonPhi/SKL_Skylake/' run_slurm.sh
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

if in_array "qe" "${type[*]}"; then
    sed -i '/mpirun/c\mpirun -np 8 pw.x -in qe-relax.in > stdout.log' run_slurm.sh
    sed -i '/mpirun/i\cat incar.in potcar.in poscar.in kpoints.in > qe-relax.in' run_slurm.sh
fi

if in_array "beef" "${type[*]}"; then
    sed -i '/mpirun/i\cp ~/KISTI_VASP/vdw_kernel.bindat .' run_slurm.sh
    sed -i 's/std/beef.std/' run_slurm.sh
    echo 'rm vdw_kernel.bindat' >> run_slurm.sh

    if (in_array "vaspsol" "${type[*]}") || (in_array "sol" "${type[*]}") ; then
        sed -i 's/std/vaspsol.std/' run_slurm.sh
    else
        sed -i 's/beef/vtst179.beef/' run_slurm.sh
    fi
elif in_array "vtst" "${type[*]}"; then
    sed -i 's/std/vtst179.beef.std/' run_slurm.sh
fi

if in_array "gam" "${type[*]}"; then
    sed -i 's/std/gam/' run_slurm.sh
elif in_array "ncl" "${type[*]}"; then
    sed -i 's/std/ncl/' run_slurm.sh
fi

# if [[ -n $(grep beef run_slurm.sh) ]]
#     sed -n '11,13p' run_slurm.sh > .run_conti.sh
# else
#     sed -n '11p' run_slurm.sh > .run_conti.sh
# fi
    
# echo '
# sh ~/bin/orange/relax_error.sh' >> run_slurm.sh

read -p 'enter jobname if you want to change it: ' jobname
if [[ -n $jobname ]]; then
    sh ~/bin/orange/jobname.sh $jobname
fi
