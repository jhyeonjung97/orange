#!/bin/bash

if ! [[ -d ~/KISTI_VASP/ ]]; then
    echo "Here is not nurion.ksc.re.kr..."
    exit 1
fi

cp ~/input_files/run_slurm.sh .

read -p "which queue? (normal, skl): " q
echo -n "which type? (beef, vaspsol, gam): "
read -a type

if [[ $q =~ 's' ]]; then
    node=40
    q='norm_skl'
    sed -i "s/KNL_XeonPhi/SKL_Skylake" run_slurm.sh
else
    node=64
    q='normal'
fi

sed -i "/ncpus/c\#PBS -l select=1:ncpus=$node:mpiprocs=$node:ompthreads=1" run_slurm.sh
sed -i "/partition/c\#PBS -q $q" run_slurm.sh

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

if in_array "beef" "${type[*]}"; then
    sed -i '/mpiexec/i\cp ~/KISTI_VASP/vdw_kernel.bindat .' run_slurm.sh
    sed -i 's/std/beef.std/' run_slurm.sh
    echo 'rm vdw_kernel.bindat' >> run_slurm.sh

    if in_array "vaspsol" "${type[*]}"; then
        sed -i 's/std/vaspsol.std/' run_slurm.sh
    elif in_array "vtst" "${type[*]}"; then
        sed -i 's/beef/vtst179.beef/' run_slurm.sh
    fi
fi

if in_array "gam" "${type[*]}"; then
    sed -i 's/std/gam/' run_slurm.sh
elif in_array "ncl" "${type[*]}"; then
    sed -i 's/std/ncl/' run_slurm.sh
fi

if [[ -n $(grep beef run_slurm.sh) ]]; then
    sed -n '11,13p' run_slurm.sh > temp1
else
    sed -n '11p' run_slurm.sh > temp1
fi

echo '
i=1
while [[ $i < 3 ]] && [[ -n $(grep "please rerun with smaller EDIFF, or copy CONTCAR" std*) ]]
do
mkdir $i
cp * $i
i=$i+1
rm std*' >> run_slurm.sh
cat run_slurm.sh temp1 >> temp2
mv temp2 run_slurm.sh
echo 'done

if [[ $i = 3 ]] && [[ -n $(grep "please rerun with smaller EDIFF, or copy CONTCAR" std*) ]]; then
echo "please check if your calculation is okay to be continued.."
exit 1' >> run_slurm.sh