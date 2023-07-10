#!/bin/bash


if [[ ! -d /TGM/Apps/VASP/VASP_BIN/6.3.2 ]]; then
    echo "Here is not burning.postech.ac.kr..."
    exit 1
fi
if [[ $1 =~ '-h' ]]; then
    echo "usage: run-burning.sh [-q] <1,2,3,4,5> [types]"
    exit 4
elif [[ $1 == '-q' ]]; then
    shift
    if [[ $1 == -* ]];
        echo "usage: run-burning.sh [-q] <1,2,3,4,5> [types]"
        exit 3
    else
        q=${1##-}
        shift
    fi
elif [[ ${here} == 'burning2' ]]; then
    q='g1'
else
    echo -e "\033[1mg1:\033[0m"
    qstat | grep -i "Q g1"
    echo -e "\033[1mg2:\033[0m"
    qstat | grep -i "Q g2"
    echo -e "\033[1mg3:\033[0m"
    qstat | grep -i "Q g3"
    echo -e "\033[1mg4:\033[0m"
    qstat | grep -i "Q g4"
    echo -e "\033[1mg5:\033[0m"
    qstat | grep -i "Q g5"
    pestat -s idle
    read -p "which queue? (g1~g5, gpu): " q
fi

if [[ -s mpiexe.sh ]]; then
    rm mpiexe.sh
fi
cp ~/input_files/run_slurm.sh .
if [[ $q == 'g1' ]] || [ $q == '1' ]]; then
    if [[ ${here} == 'burning2' ]]; then
        node=32
    else
        node=12
    fi
elif [[ $q == 'g2' ]] || [ $q == '2' ]] || [[ $q == 'g3' ]] || [ $q == '3' ]]; then
    node=20
elif [[ $q == 'g4' ]] || [ $q == '4' ]]; then
    node=24
elif [[ $q == 'g5' ]] || [ $q == '5' ]] || [[ $q == 'gpu' ]]; then
    node=32
else
    echo "think about queue..."
    exit 2
fi

if [[ -n $1 ]]; then
    type=${@}
else
    echo -n "which type? (beef, vtst, sol, gam, qe, cep, mmff, lobster, sea): "
    read -a type
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

total=''
if in_array 'qe' "${type[*]}"; then
    sed -i '/mpiexe/i\cat incar.in potcar.in poscar.in kpoints.in > qe-relax.in' run_slurm.sh
    sed -i 's/custom/4 pw.x -in qe-relax.in/' run_slurm.sh
else
    if in_array 'mmff' "${type[*]}"; then
        file=''
        la=''
        lb=''
        lc=''
        read -p '[filename.extention] and lattice a, b, c? ' file la lb lc
        sed -i -e "/mpiexe/i\sh ~\/bin\/orange\/mmff.sh $file $la $lb $lc" run_slurm.sh
        if [[ ${#type[*]} == 1 ]]; then
            sed -i '/mpiexe/d' run_slurm.sh
            exit 5
        fi
    fi
    if in_array 'beef' "${type[*]}"; then
        sed -i '/mpiexe/i\cp /TGM/Apps/VASP/vdw_kernel.bindat .' run_slurm.sh
        echo 'rm vdw_kernel.bindat' >> run_slurm.sh
        total+='.beef' 
    elif in_array 'dftd4' "${type[*]}"; then
        total+='.dftd4'
    fi
    if in_array 'sea' "${type[*]}"; then
        total+='.vaspsol'
    elif in_array 'sol' "${type[*]}"; then
        total+='.vaspsol'
    elif in_array 'vtst' "${type[*]}"; then
        total+='.vtst'
    elif in_array 'wan90v3' "${type[*]}"; then
        total+='.wan90v3'
    fi
    if in_array 'gam' "${type[*]}"; then
        total+='.gam'
    elif in_array 'ncl' "${type[*]}"; then
        total+='.ncl'
    else
        total+='.std'
    fi
    if [[ -e '/TGM/Apps/VASP/VASP_BIN/6.3.2/vasp.6.3.2'$total'.x' ]]; then
        custom='\$SLURM_NTASKS \/TGM\/Apps\/VASP\/VASP_BIN\/6.3.2\/vasp.6.3.2'
        sed -i "s/custom/$custom$total.x/" run_slurm.sh
    else
        echo 'there is no corroesponding version...'
        exit 1
    fi
    if in_array 'cep' "${type[*]}"; then
        # read -p 'goal electrode potential? ' goal
        if [[ -d wave ]]; then
            cp wave/INCAR wave/KPOINTS wave/POTCAR wave/WAVECAR wave/OUTCAR .
            cp wave/CONTCAR POSCAR
        fi
        cp INCAR .INCAR_old
        sh ~/bin/orange/modify.sh INCAR ISTART 0
        if in_array 'sol' "${type[*]}"; then
            sh ~/bin/orange/modify.sh INCAR IDIPOL
            sh ~/bin/orange/modify.sh INCAR LDIPOL
            sh ~/bin/orange/modify.sh INCAR LVHAR
            sh ~/bin/orange/modify.sh INCAR LSOL
            sh ~/bin/orange/modify.sh INCAR LWAVE
            sed -i -e "/mpiexe/a\sh ~\/bin\/orange\/cep-sol.sh" run_slurm.sh
            # sed -i -e "/mpiexe/a\sh ~\/bin\/orange\/cep-sol.sh $goal" run_slurm.sh
        else
            sh ~/bin/orange/modify.sh INCAR IDIPOL 3
            # sh ~/bin/orange/modify.sh INCAR LDIPOL 
            sh ~/bin/orange/modify.sh INCAR LVHAR .TRUE.
            sh ~/bin/orange/modify.sh INCAR LSOL .FALSE.
            sh ~/bin/orange/modify.sh INCAR LWAVE 
            sed -i -e "/mpiexe/a\sh ~\/bin\/orange\/cep.sh" run_slurm.sh
            # sed -i -e "/mpiexe/a\sh ~\/bin\/orange\/cep.sh $goal" run_slurm.sh
        fi
    fi
fi

if in_array 'lobster' "${type[*]}"; then
    echo '~/bin/lobster/lobster' >> run_slurm.sh
fi

grep mpiexe run_slurm.sh > mpiexe.sh
sed -i -e '/mpiexe/c\sh mpiexe.sh; sh ~/bin/orange/ediff.sh' run_slurm.sh

if in_array 'sea' "${type[*]}"; then
    if [[ -d wave ]]; then
        cp wave/INCAR wave/KPOINTS wave/POTCAR wave/WAVECAR wave/OUTCAR .
        cp wave/CONTCAR POSCAR
    else
        rm STD* *.e* *.o*
        mv CONTCAR POSCAR
    fi
    sed -i '/mpiexe/i\sh ~/bin/orange/modify.sh INCAR ISTART 0' run_slurm.sh
    sed -i '/mpiexe/i\sh ~/bin/orange/modify.sh INCAR LSOL .FALSE.' run_slurm.sh
    sed -i '/mpiexe/i\sh ~/bin/orange/modify.sh INCAR LWAVE .TRUE.' run_slurm.sh
    echo 'mv CONTCAR POSCAR
sh ~/bin/orange/seawater.sh
sh mpiexe.sh; sh ~/bin/orange/ediff.sh' >> run_slurm.sh
fi
        
if in_array 'cep' "${type[*]}"; then
    if [[ -e mpiexe.sh ]] && [[ -s WAVECAR ]]; then
        sed -i -e '/mpiexe/d' run_slurm.sh
    fi
fi
            
if [[ -z $(grep stdout run_slurm.sh) ]]; then
    sed -i 's/STDOUT/stdout/' run_slurm.sh
fi

echo $PWD
read -p 'enter jobname if you want to change it: ' jobname
if [[ -n $jobname ]]; then
    sh ~/bin/orange/jobname.sh $jobname
fi
if in_array 'repeat' "${type[*]}"; then
    sed -i -e 's/ediff.sh/repeat.sh/g' run_slurm.sh
fi