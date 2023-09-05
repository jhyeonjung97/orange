#!/bin/bash

if [[ $1 == '-s' ]] || [[ $1 == '-select' ]]; then
    SET=${@:2}
elif [[ $1 == '-n' ]] || [[ $1 == '-non' ]]; then
    if [[ -z $3 ]]; then
        SET=$(seq 1 $2)
    else
        SET=$(seq $2 $3)
    fi
elif [[ -z $2 ]]; then
    SET=$(seq 1 $1)
else
    SET=$(seq $1 $2)
fi

if [[ -s fragment.sh ]]; then
    rm fragment.sh
fi

cp run_slurm.sh .run_slurm.sh
sed -i '/vdw_kernel.bindat/d' run_slurm.sh
if [[ ${here} == 'burning' ]]; then
    sed '1,15d' run_slurm.sh > fragment.sh
    sed -i '16,$d' run_slurm.sh
elif [[ ${here} == 'burning2' ]]; then
    sed '1,10d' run_slurm.sh > fragment.sh
    sed -i '11,$d' run_slurm.sh
elif [[ ${here} == 'kisti' ]]; then
    sed '1,10d' run_slurm.sh > fragment.sh
    sed -i '11,$d' run_slurm.sh
else
    echo 'where am i?'
    exit 1
fi

if [[ -n $(grep vdw_kernel.bindat .run_slurm.sh) ]]; then
    if [[ ${here} =~ 'burning' ]]; then
        echo 'cp /TGM/Apps/VASP/vdw_kernel.bindat .' >> run_slurm.sh
    elif [[ ${here} == 'kisti' ]]; then
        echo 'cp ~/KISTI_VASP/vdw_kernel.bindat .' >> run_slurm.sh
    fi
    echo " " >> run_slurm.sh
fi
for i in $SET
do
    rm $i/mpiexe.sh
    rm $i/run_slurm.sh
    echo "cp $i/* ." >> run_slurm.sh
    more fragment.sh >> run_slurm.sh
    echo "cp * $i/" >> run_slurm.sh
    if [[ -n $(grep ediff run_slurm.sh) ]]; then
        echo "mv conti*/ $i/" >> run_slurm.sh
    fi
    echo " " >> run_slurm.sh
done
rm fragment.sh
if [[ -n $(grep vdw_kernel.bindat run_slurm.sh) ]]; then
    echo 'rm vdw_kernel.bindat' >> run_slurm.sh
fi