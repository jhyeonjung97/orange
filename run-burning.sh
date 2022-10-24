#!/bin/bash

if test -d /TGM/Apps/VASP/VASP_BIN/6.3.2; then
    cp ~/input_files/run_slurm.sh .
else
    echo "Here is not burning.postech.ac.kr..."
    break
fi

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
    sed -i 's/vasp.6.3.2./vasp.6.3.2.beef./' run_slurm.sh
elif in_array "vaspsol" "${type[*]}"; then
    sed -i 's/vasp.6.3.2./vasp.6.3.2.vaspsol./' run_slurm.sh
elif in_array "dftd4" "${type[*]}"; then
    sed -i 's/vasp.6.3.2./vasp.6.3.2.dftd4./' run_slurm.sh
fi

if in_array "gam" "${type[*]}"; then
    sed -i 's/std/gam/' run_slurm.sh
elif in_array "ncl" "${type[*]}"; then
    sed -i 's/std/ncl/' run_slurm.sh
fi