#!/bin/bash

if ! [[ -d /TGM/Apps/VASP/VASP_BIN/6.3.2 ]]; then
    echo "Here is not burning.postech.ac.kr..."
fi

cp ~/input_files/run_slurm.sh .

read -p "which queue? (g1~g5, gpu): " q
echo -n "which type? (beef, vtst, vaspsol, gam): "
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
    echo "I've never heard of that kind of node.."
    break
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

if in_array "vtst" "${type[*]}"; then
    sed -i 's/std/vtst.std/' run_slurm.sh
fi

if in_array "beef" "${type[*]}"; then
    sed -i '/mpiexec/i\cp /TGM/Apps/VASP/vdw_kernel.bindat .' run_slurm.sh
    sed -i 's/vasp.6.3.2./vasp.6.3.2.beef./' run_slurm.sh
    echo 'rm vdw_kernel.bindat' >> run_slurm.sh
elif in_array "vaspsol" "${type[*]}"; then
    sed -i 's/vasp.6.3.2./vasp.6.3.2.vaspsol./' run_slurm.sh
elif in_array "dftd4" "${type[*]}"; then
    sed -i 's/vasp.6.3.2./vasp.6.3.2.dftd4./' run_slurm.sh
fi

if in_array "gam" "${type[*]}"; then
    sed -i 's/std/gam/' run_slurm.sh
    sed -i 's/gamout/stdout/' run_slurm.sh
elif in_array "ncl" "${type[*]}"; then
    sed -i 's/std/ncl/' run_slurm.sh
    sed -i 's/nclout/stdout/' run_slurm.sh
fi

if [[ -n $(grep beef run_slurm.sh) ]]
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