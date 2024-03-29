#!/bin/bash

# error cases
if [[ ! -e "incar.in" ]]; then
    echo "don't forget INCAR.."
    exit 2
elif [[ ! -e "kpoints.in" ]]; then
    echo "don't forget KPOINTS.."
    exit 2
elif [[ ! -e "run_slurm.sh" ]]; then
    echo "don't forget run_slurm.sh.."
    if [[ $here =~'burning' ]]; then
        sh ~/bin/orange/run-burning.sh
    elif [[ $here == 'kisti' ]]; then
        sh ~/bin/orange/run-kisti.sh
    exit 3
    fi
elif [[ -z $1 ]]; then
    echo 'usage: autosub (directory#1) [directory#2]'
fi

grep --colour tot_charge incar.in
read -p 'change tot_charge? (press enter to skip) ' tot_charge
if [[ -n $tot_charge ]]; then
    sed -i -e "/tot_charge/c\    tot_charge = $tot_charge" incar.in
    grep --colour tot_charge incar.in
fi

if [[ ${here} =~ 'burning' ]]; then
    sed -i -e "/pseudo_dir/c\    pseudo_dir = '/home/hyeonjung/q-e-qe-7.1/pslibrary/pbe/PSEUDOPOTENTIALS'" incar.in
elif [[ ${here} == 'kisti' ]]; then
    sed -i -e "/pseudo_dir/c\    pseudo_dir = '/home01/${account}/qe-7.1/pslibrary/pbe/PSEUDOPOTENTIALS'" incar.in
fi

read -p "lattice parameter (A): " a
if [[ -z $a ]]; then
    echo 'use default lattice parameter, 30 A ...'
    a=30.
elif [[ ! $a =~ '.' ]]; then
    a=$a.
fi
python ~/bin/orange/xyz2cif.py $a

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

read -p "poscars starts with (*.xyz): " p
read -p "jobname if you want to specify: " n
if [[ -z $n ]]; then
    echo 'use poscar name as jobname ...'
    n=$p
fi

for i in $SET
do
    if [[ ! -d $i ]]; then
        mkdir $i
    fi
    cp incar.in kpoints.in run_slurm.sh $p$i.xyz $p$i.cif $i
    cd $i
    
    cif2cell $p$i.cif -p quantum-espresso -o $p$i.in
    
    nat_tag=$(grep nat $p$i.in | sed 's/\t/ /')
    IFS=' '
    read -ra nat_arr <<< $nat_tag
    nat=${nat_arr[2]}
    sed -i "/nat/c\    nat = $nat" incar.in

    ntyp_tag=$(grep ntyp $p$i.in | sed 's/\t/ /')
    IFS=' '
    read -ra ntyp_arr <<< $ntyp_tag
    ntyp=${ntyp_arr[2]}
    sed -i "/ntyp/c\    ntyp = $ntyp" incar.in
    
    sh ~/bin/orange/pseudopotential.sh $p$i.in
    sed -i -e '1,19d' -e '/ATOMIC_POSITIONS/,$d' $p$i.in
    sed -i '1,2d' $p$i.xyz
    sed -i '1i\ATOMIC_POSITIONS {angstrom}' $p$i.xyz
    
    if [[ -n $(grep CELL_PARAMETERS incar.in) ]]; then
        sed -i '/CELL/,$d' incar.in
    fi
    echo "
CELL_PARAMETERS {angstrom}
    $a 0. 0.
    0. $a 0.
    0. 0. $a" >> incar.in
    
    cp $p$i.in potcar.in
    cp $p$i.xyz poscar.in
    sed -i "1i\\$nat" $p$i.xyz
    cat incar.in potcar.in poscar.in kpoints.in > qe-relax.in
    sh ~/bin/orange/jobname.sh $n$i
    
    sed -i -e "s/x2658a09/${account}/" *
    sed -i -e "s/x2431a10/${account}/" *
    sed -i -e "s/x2421a04/${account}/" *
    sed -i -e "s/x2347a10/${account}/" *
    sed -i -e "s/x2755a09/${account}/" *
    cd ..
done
grep --colour chemical_formula_sum */*.cif

read -p 'do you want to submit jobs? [y/n] (default: n) ' submit
if [[ $submit == y* ]]; then
    sh ~/bin/orange/sub.sh -s $SET
fi