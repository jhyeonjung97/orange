#!/bin/bash

goal=$1
# goal=-0.6
x1=''
x2=''
y1=''
y2=''
hl=4.4
step=0.1
error=0.02
unset map
declare -A map
grep mpiexe run_slurm.sh > cep.sh
echo 'NELECT WF EP' > out.log

function update {
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
    x1=$x2
    y1=$y2
    x2=$ne
    y2=$ep
}

function linear {
    n=${#map[@]}
    echo $n
    y1=$(printf "%s\n" ${map[@]} | sort -n | head -n 1)
    y2=$(printf "%s\n" ${map[@]} | sort -n | tail -n 1)
    for key in "${!map[@]}"
    do
        if [[ ${map[$key]} == $y1 ]]; then
            x1=$key
        elif [[ ${map[$key]} == $y2 ]]; then
            x2=$key
        fi
    done
    echo $y1 $y2 $x1 $x2
    if [[ $x1 == $x2 ]] || [[ $n == 1 ]]; then
        echo 'something goes wrong...'
        exit 1
    elif [[ `echo "$goal < $y1" | bc` -eq 1 ]]; then
        y2=$(printf "%s\n" ${map[@]} | sort -n | head -n 2 | tail -n 1)
        for key in "${!map[@]}"
        do
            if [[ ${map[$key]} == $y2 ]]; then
                x2=$key
            fi
        done
    elif [[ `echo "$y2 < $goal" | bc` -eq 1 ]]; then
        y1=$(printf "%s\n" ${map[@]} | sort -n | tail -n 2 | head -n 1)
        for key in "${!map[@]}"
        do
            if [[ ${map[$key]} == $y1 ]]; then
                x1=$key
            fi
        done
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

function in_map {
    for e in ${map[*]}
    do
        if [[ $e == $1 ]]; then
            return 0
        fi
    done
    return 1
}

update
x2=$ne
y2=$ep
# if [[ `echo "$ep < $goal" | bc` -eq 1 ]]; then
#     x1=$ne
#     y1=$ep
# elif [[ `echo "$ep > $goal" | bc` -eq 1 ]]; then
#     x2=$ne
#     y2=$ep
# else
#     exit 0
# fi

range0=$(echo "$goal $error" | awk '{print $1 - $2}')
range1=$(echo "$goal $error" | awk '{print $1 + $2}')
until [[ `echo "$range0 < $ep" | bc` -eq 1 ]] && [[ `echo "$ep < $range1" | bc` -eq 1 ]] 
do
    mkdir nelect_$ne
    cp * nelect_$ne
    mv CONTCAR POSCAR
    if [[ ${#map[@]} == 1 ]] && [[ `echo "$ep < $goal" | bc` == 1 ]]; then
        echo diff1 $diff
        diff=-$step
    elif [[ ${#map[@]} == 1 ]] && [[ `echo "$ep > $goal" | bc` == 1 ]]; then
        echo diff2 $diff
        diff=+$step
    else
        grad=$(echo "$x1 $x2 $y1 $y2" | awk '{print ($1 - $2) / ($3 - $4)}')
        diff=$(echo "$grad $goal $x1 $y1" | awk '{print $1 * ($2 - $3) + $4}')
        if [[ `echo "$diff > 2.5" | bc` == 1 ]]; then
            echo diff3 $diff
            diff=+$step
        elif [[ `echo "$diff < -2.5" | bc` == 1 ]]; then
            echo diff4 $diff
            diff=-$step
        else
            echo diff5 $diff
        fi
    fi
    new=$(echo "$ne $diff" | awk '{print $1 + $2}')
    echo new $new
    while in_map $new
    do
        if [[ `echo "$diff < 0" | bc` == 1 ]]; then
            new=$(echo "$new $step" | awk '{print $1 - $2}')
        else
            new=$(echo "$new $step" | awk '{print $1 + $2}')
        fi
        echo updated $diff $new
    done
    sh ~/bin/orange/modify.sh INCAR NELECT $new
    sh cep.sh
    update
    # linear
done