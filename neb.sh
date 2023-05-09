pos=''
dir=$(($1+1))
if [[ ! -d "0$1" ]]; then
    echo 'prepare 00 01 02 .. first'
    exit 1
fi

if [[ -s $2/CONTCAR ]] && [[ -s $3/CONTCAR ]] && [[ -s $2/OUTCAR ]] && [[ -s $3/OUTCAR ]]; then
    nebmake.pl $2/CONTCAR $3/CONTCAR $1
    cp $2/OUTCAR 00
    cp $3/OUTCAR 0$dir
else
    echo "check $2 and $3 directories"
    exit 3
fi

cp $2/INCAR $2/KPOINTS $2/POTCAR .
cp $3/INCAR $3/KPOINTS $3/POTCAR .

sh ~/bin/orange/modify.sh INCAR NSW 2000
sh ~/bin/orange/modify.sh INCAR IBRION 3
sh ~/bin/orange/modify.sh INCAR POTIM 0.05
sh ~/bin/orange/modify.sh INCAR IMAGES $1
sh ~/bin/orange/modify.sh INCAR SPRING -5.0
sh ~/bin/orange/modify.sh INCAR LCLIMB .TRUE.

if [[ ${here} == 'burning' ]]; then
    if [[ ! -s run_slurm.sh ]]; then
        if [[ -n $(grep vtst $2/mpiexe.sh) ]]; then
            cp $2/mpiexe.sh $2/run_slurm.sh .
        elif [[ -n $(grep vtst $3/mpiexe.sh) ]]; then
            cp $3/mpiexe.sh $3/run_slurm.sh .
        else
            echo 'prepare run_slurm.sh first..'
            exit 2
        fi
    fi
    sed -i -e "s/nodes=1/nodes=$1/" run_slurm.sh
elif [[ ${here} == 'kisti' ]]; then
    if [[ -n $(grep vtst $2/mpiexe.sh) ]]; then
        cp $2/mpiexe.sh $2/run_slurm.sh .
    elif [[ -n $(grep vtst $3/mpiexe.sh) ]]; then
        cp $3/mpiexe.sh $3/run_slurm.sh .
    else
        sh ~/bin/orange/run-kisti.sh -l vtst
        echo '(warning) check mpiexe.sh ..'
    fi
    np=$(echo $1 | awk '{print $1 * 64}')
    sed -i -e "s/np 64/np $np/" mpiexe.sh
    sed -i -e "s/select=1/select=$1/" run_slurm.sh
fi

for i in $(seq 0 $dir)
do
    pos+="0$i/POSCAR "
done
ase gui $pos