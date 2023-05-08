if [[ ! -d "0$1" ]]; then
    echo 'prepare 00 01 02 .. first'
    exit 1
fi

sh ~/bin/orange/modify.sh INCAR IMAGES $1
sh ~/bin/orange/modify.sh INCAR SPRING -5.0
sh ~/bin/orange/modify.sh INCAR LCLIMB .TRUE.

if [[ ${here} == 'burning' ]]; then
    if [[ ! -s run_slurm.sh ]]; then
        echo 'prepare run_slurm.sh first..'
        exit 2
    fi
    sed -i -e "s/nodes=1/nodes=$1" run_slurm.sh
elif [[ ${here} == 'kisti' ]]; then
    sh ~/bin/orange/run-kisti.sh -l vtst
    np=$(echo $1 | awk '{print $1 * 64}')
    sed -i -e "s/np 64/np $np" run_slurm.sh
    sed -i -e "s/select=1/select=$1" run_slurm.sh
fi