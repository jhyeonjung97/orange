#!/bin/bash

if [[ ! -d ~/KISTI_VASP/ ]]; then
    echo 'Here is not nurion.ksc.re.kr...'
    exit 1
fi
if [[ $1 =~ '-h' ]]; then
    echo "usage: run-burning.sh [-q] <1,2,3,4,5> [types]"
    exit 4
elif [[ $1 == -* ]]; then
    q=${1##-}
    shift
else
    read -p 'which queue? (normal, skl, long, flat): ' q
fi

if [[ -s mpiexe.sh ]]; then
    rm mpiexe.sh
fi
cp ~/input_files/run_slurm.sh .
if [[ $q == l* ]]; then
    node=64
    q='long'
    sed -i -e 's/walltime=48/walltime=120/g' run_slurm.sh
elif [[ $q == s* ]]; then
    node=40
    q='norm_skl'
    sed -i -e 's/KNL_XeonPhi/SKL_Skylake/g' run_slurm.sh
elif [[ $q == f* ]]; then
    node=64
    q='flat'
else
    node=64
    q='normal'
fi

if [[ -n $1 ]]; then
    type=${@}
else
    echo -n 'which type? (beef, vtst, sol, gam, qe, cep, mmff, lobster, sea): '
    read -a type
fi

sed -i "/ncpus/c\#PBS -l select=1:ncpus=$node:mpiprocs=$node:ompthreads=1" run_slurm.sh
sed -i "/#PBS -q/c\#PBS -q $q" run_slurm.sh

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
    sed -i 's/custom/8 pw.x -in qe-relax.in/' run_slurm.sh
    echo 'if [[ -n $(grep Maximum stdout.log) ]]; then' >> run_slurm.sh
    echo '    sh ~/bin/orange/conti.sh' >> run_slurm.sh
    echo 'fi' >> run_slurm.sh
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
    # if in_array 'vtst' "${type[*]}"; then
    #     total+='.vtst179.beef'
    # elif in_array 'sea' "${type[*]}"; then
    #     total+='.beef.vaspsol'
    # elif in_array 'sol' "${type[*]}"; then
    #     total+='.beef.vaspsol'
    # elif in_array 'beef' "${type[*]}"; then
    #     total+='.vtst179.beef'
    # elif in_array 'cep' "${type[*]}"; then
    #     total+='.beef.vaspsol'
    # fi
    # if [[ -n $(echo $total | grep beef) ]]; then
    #     sed -i -e '/mpiexe/i\cp ~/KISTI_VASP/vdw_kernel.bindat .' run_slurm.sh
    #     echo 'rm vdw_kernel.bindat' >> run_slurm.sh
    # fi
    # if in_array 'gam' "${type[*]}"; then
    #     sed -i -e "3c\Gamma-only" KPOINTS
    #     sed -i -e "4c\1\t1\t1" KPOINTS
    #     total+='.gam'
    # elif in_array 'ncl' "${type[*]}"; then
    #     total+='.ncl'
    # else
    #     total+='.std'
    # fi
    # echo "/home01/${account}/KISTI_VASP/KNL_XeonPhi/vasp.5.4.4.pl2.KISTI.KNL_XeonPhi$total.x"
    # if [[ -e "/home01/${account}/KISTI_VASP/KNL_XeonPhi/vasp.5.4.4.pl2.KISTI.KNL_XeonPhi$total.x" ]]; then
    #     custom='KISTI_VASP\/KNL_XeonPhi\/vasp.5.4.4.pl2.KISTI.KNL_XeonPhi'
    #     sed -i -e "s/custom/$node \/home01\/${account}\/$custom$total.x/" run_slurm.sh
    # else
    #     echo 'there is no corroesponding version...'
    #     exit 1
    # fi
    sed -i -e "s/custom/$node/" run_slurm.sh
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

jobname=0
for i in $@
do
    if [[ jobname==1 ]]; then
        jobname=$i
    fi
    if [[ $i == -j* ]]; then
        jobname=1
    fi
done

if [[ -z $jobname ]]; then
    echo $PWD
    read -p 'enter jobname if you want to change it: ' jobname
fi

if [[ -n $jobname ]]; then
    sh ~/bin/orange/jobname.sh $jobname
fi
if in_array 'repeat' "${type[*]}"; then
    sed -i -e 's/ediff.sh/repeat.sh/g' run_slurm.sh
fi
if in_array 'freq' "${type[*]}"; then
    sed -i -e 's/; sh ~\/bin\/orange\/ediff.sh//' run_slurm.sh
fi