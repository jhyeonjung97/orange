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
sed '1,15d' run_slurm.sh > fragment.sh
cp run_slurm.sh .run_slurm.sh
sed -e '16,$d' run_slurm.sh

for i in $SET
do
    echo "cp $i* ." >> run_slurm.sh
    more fragment.sh >> run_slurm.sh
    echo "cp * $i" >> run_slurm.sh
done
