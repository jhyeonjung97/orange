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
    if [[ $here == 'burning' ]]; then
        sh ~/bin/orange/run-burning.sh
    elif [[ $here == 'kisti' ]] || [[ $here == 'nurion' ]]; then
        sh ~/bin/orange/run-nurion.sh
    fi
    exit 3
elif [[ -z $1 ]]; then
    echo 'usage: autosub (directory#1) [directory#2]'
fi

grep --colour tot_charge incar.in

read -p "lattice parameter (A): " a
python ~/bin/orange/xyz2cif.py $a
if [[ ! $a =~ '.' ]]; then
    a=$a.0
fi

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
    
read -p "poscars starts with: " p
read -p "job name: " n

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
    
    sed -i '1,2d' $p$i.xyz
    sed -i -e '1,19d' '/ATOMIC_POSITIONS/,$d' $p$i.in
    sed -i 's/H_PSEUDO/H.pbe-kjpaw_psl.1.0.0.UPF/' $p$i.in
    sed -i 's/O_PSEUDO/O.pbe-nl-kjpaw_psl.1.0.0.UPF/' $p$i.in
    sed -i 's/Li_PSEUDO/Li.pbe-sl-kjpaw_psl.1.0.0.UPF/' $p$i.in
    
    echo "
CELL_PARAMETERS
    $a 0. 0.
    0. $a 0.
    0. 0. $a" >> incar.in

    cat incar.in $p$i.in $p$i.xyz kpoints.in > qe-relax.in
    sed -i -e "1i\\$nat" "1i\\$nat" $p$i.xyz
    sh ~/bin/orange/jobname.sh $n$i
    cd ..
done

cd *
grep nat $p*.data
grep nat incar.in
grep ntyp $p*.data
grep ntyp incar.in
cd ..