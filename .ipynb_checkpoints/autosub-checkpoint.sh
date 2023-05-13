#!/bin/bash

xc_tag=0
# error cases
if [[ $1 == '-qe' ]] || [[ $1 == 'qe' ]]; then
    sh ~/bin/orange/autosub-qe.sh ${@:2}
    exit 1
elif [[ ! -e "INCAR" ]]; then
    echo "don't forget INCAR.."
    exit 2
elif [[ ! -e "KPOINTS" ]]; then
    echo "don't forget KPOINTS.."
    exit 2
elif [[ ! -e "run_slurm.sh" ]]; then
    echo "don't forget run_slurm.sh.."
    if [[ $here == 'burning' ]]; then
        sh ~/bin/orange/run-burning.sh
    elif [[ $here == 'kisti' ]]; then
        sh ~/bin/orange/run-kisti.sh
    fi
    exit 3
elif [[ -z $1 ]]; then
    echo 'usage: autosub (directory#1) [directory#2]'
fi

if [[ $1 == '-x' ]] || [[ $1 == '-xc' ]]; then
    shift
    xc_tag=1
fi

multiple_input="${@}"
if [[ $1 == '-s' ]] || [[ $1 == '-select' ]]; then
    SET=${@:2}
elif [[ -z $2 ]]; then
    SET=$(seq 1 $1)
else
    SET=$(seq $1 $2)
fi

ls
read -p "POSCARs starts with: " p
read -p "job name: " n

if [[ -z $n ]]; then
    n=$p
fi

# if [[ -n $(grep lobster run_slurm.sh) ]]; then
#     cp run_slurm.sh lobster.sh
#     if [[ ${here} == 'burning' ]]; then
#         sed -i -e '15,$d' lobster.sh
#     elif [[ ${here} == 'kisti' ]]; then
#         sed -i -e '10,$d' lobster.sh
#     fi
# fi
    
for i in $SET
do
    if [[ ! -d $i ]]; then
        mkdir $i
    fi
    cp INCAR KPOINTS run_slurm.sh $i
    if [[ -s mpiexe.sh ]]; then
        cp mpiexe.sh $i
    fi
    if [[ -s lobsterin ]]; then
        cp lobsterin $i
    fi
    if [[ -n $(grep mmff run_slurm.sh) ]]; then
        sed -i -e "s/mmff.sh a.vasp/mmff.sh $p.vasp/" run_slurm.sh
        cp $p$i.vasp $i
    else
        cp $p$i.vasp $i/POSCAR
    fi
    cd $i
    if [[ -n $(grep '#ISPIN' INCAR) ]] || [[ -n $(grep ISPIN INCAR | grep 1) ]]; then
        sed -i '/MAGMOM/d' INCAR
    else
        if [[ $xc_tag == 0 ]]; then
            python ~/bin/pyband/xcell.py #XCELL
            mv out*.vasp POSCAR #XCELL
            echo 'xcell.py is applied'
        fi
        python3 ~/bin/orange/magmom.py
    fi
    sh ~/bin/orange/vasp5.sh
    if [[ -s POTCAR ]]; then
        rm POTCAR
    fi
    vaspkit -task 103 | grep --colour POTCAR
    if [[ ! -s POTCAR ]]; then
        python3 ~/bin/shoulder/potcar_ara.py
    fi
    # if [[ -n $(grep cep-sol.sh run_slurm.sh) ]]; then
    #     sh ~/bin/orange/nelect.sh
    # fi
    if grep -q '^[^#]*IBRION\s*=\s*0' INCAR && \
       grep -q '^[^#]*POTIM\s*=\s*1' INCAR && \
       grep -q '^[^#]*TEBEG\s*=\s*300' INCAR && \
       grep -q '^[^#]*SMASS\s*=\s*0' INCAR && \
       grep -q '^[^#]*MDALGO\s*=\s*2' INCAR
    then
        echo "Note: This is MD calculation"
        sh ~/bin/orange/pomass.sh
    fi
    sed -i "/NPAR/c\NPAR   = ${npar}" INCAR
    sed -i -e "/#SBATCH --job-name/c\#SBATCH --job-name=\"$n$i\"" *.sh
    sed -i -e "/#PBS -N/c\#PBS -N $n$i" *.sh
    cd ..
done

grep --colour NETCHG INCAR
read -p 'do you want to submit jobs? [y/n] (default: n) ' submit
if [[ $submit =~ 'y' ]]; then
    for i in $SET
    do
        cd $i
        sh ~/bin/orange/sub.sh
        cd ..
    done
elif [[ $submit =~ 'm' ]] && [[ -n $multiple_input ]]; then
    sh ~/bin/orange/multiple.sh $multiple_input
    echo "multiple $multiple_input"
fi