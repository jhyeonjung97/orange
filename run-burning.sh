#!/bin/bash

read -p "which queue? (g1~g5, gpu): $q"
read -a -p "which type? (beef, vtst, vaspsol, gam): $type"

if test -d /TGM/Apps/VASP/VASP_BIN/6.3.2
then
    cp /TGM/Apps/VASP/VASP_BIN/6.3.2/vasp.6.3.2.vtst.std.x run_slurm.sh
elif
    echo "Here is not burning.postech.ac.kr..."
    break
fi

function in_array {
    ARRAY=$2
    for e in ${ARRAY[*]}
    do
        if [[ "$e" == "$1" ]]
        then
            return 0
        fi
    done

    return 1
}

if in_array "vtst" "${type[*]}"
then
    sed -i 's/std/vtst.std/' run_slurm.sh
fi

if in_array "beef" "${type[*]}"
then
    sed -i 's/6.3.2./6.3.2.beef/' run_slurm.sh
elif in_array "vaspsol" "${type[*]}"
    sed -i 's/6.3.2./6.3.2.vaspsol/' run_slurm.sh
elif in_array "dftd4" "${type[*]}"
    sed -i 's/6.3.2./6.3.2.dftd4/' run_slurm.sh
fi

if in_array "gam" "${type[*]}"
then
    sed -i 's/std/gam/' run_slurm.sh
elif in_array "ncl" "${type[*]}"
    sed -i 's/std/ncl/' run_slurm.sh
fi