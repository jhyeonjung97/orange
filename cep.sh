#!/bin/bash

goal=$1
hl=4.4
step=0.5
error=0.005
unset map
declare -A map
grep mpiexe run_slurm.sh > cep.sh
echo 'NELECT WF EP' > out.log

function cep_out {
    IFS=' '
    nes=$(grep NELECT OUTCAR)
    read -ra nea <<< $nes
    ne=${nea[2]}
    vls=$(vaspkit -task 426 | grep Vacuum | grep eV)
    read -ra vla <<< $vls
    vl=${vla[2]}
    fls=$(grep E-fermi OUTCAR | tail -n 1)
    read -ra fla <<< $fls
    fl=${fla[2]}
    wf=$(echo "$vl $fl" | awk '{print $1 - $2}')
    ep=$(echo "$wf $hl" | awk '{print $1 - $2}')
    echo $ne $wf $ep >> out.log
    map+=([$ne]=$ep)
}

function linear {
    n=${#map[@]}
    echo $n
    y1=$(printf "%s\n" ${map[@]} | sort -n | head -n 1)
    y2=$(printf "%s\n" ${map[@]} | sort -n | tail -n 1)
    x1=${!map[$y1]}
    x2=${!map[$y2]}
    echo $y1 $y2 $x1 $x2
    if [[ $x1 == $x2 ]] || [[ $n == 1 ]]; then
        echo 'something goes wrong...'
        exit 1
    elif [[ `echo "$goal < $y1" | bc` -eq 1 ]]; then
        y2=$(printf "%s\n" ${map[@]} | sort -n | head -n 2 | tail -n 1)
        x2=${!map[$y2]}
    elif [[ `echo "$y2 < $goal" | bc` -eq 1 ]]; then
        y1=$(printf "%s\n" ${map[@]} | sort -n | tail -n 2 | head -n 1)
        x1=${!map[$y1]}
    else
        for i in $(seq 1 $n)
        do
            y2=$(printf "%s\n" ${map[@]} | sort -n | sed -n "$i"p)
            x2=${!map[$y2]}
            if [[ `echo "$y2 > $goal" | bc` -eq 1 ]]; then
                j=$(($i-1))
                y1=$(printf "%s\n" ${map[@]} | sort -n | sed -n "$j"p)
                x1=${!map[$y1]}
                break
            fi
        done
    fi
}

cep_out
if [[ `echo "$ep < $goal" | bc` -eq 1 ]]; then
    x1=$ne
    y1=$ep
elif [[ `echo "$ep > $goal" | bc` -eq 1 ]]; then
    x2=$ne
    y2=$ep
else
    exit 0
fi

range0=$(echo "$goal $error" | awk '{print $1 - $2}')
range1=$(echo "$goal $error" | awk '{print $1 + $2}')
until [[ `echo "$range0 < $ep" | bc` -eq 1 ]] && [[ `echo "$ep < $range1" | bc` -eq 1 ]] 
do
    mkdir nelect_$ne
    cp * nelect_$ne
    mv CONTCAR POSCAR
    if [[ -z $x2 ]] || [[ -z $y2 ]]; then
        new=$(echo "$ne $step" | awk '{print $1 - $2}')
    elif [[ -z $x1 ]] || [[ -z $y1 ]]; then
        new=$(echo "$ne $step" | awk '{print $1 + $2}')
    else
        eq1=$(echo "$x2 $x1" | awk '{print $1 - $2}')
        eq2=$(echo "$y2 $y1" | awk '{print $1 - $2}')
        eq3=$(echo "$goal $y1" | awk '{print $1 - $2}')
        eq4=$(echo "$eq1 $eq2 $eq3" | awk '{print $1 / $2 * $3}')
        new=$(echo "$eq4 $x1" | awk '{print $1 + $2}')        
    fi
    sh ~/bin/orange/modify.sh INCAR NELECT $new
    sh cep.sh
    cep_out
    echo ${map[@]}
    echo ${!map[@]}
    linear
done