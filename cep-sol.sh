#!/bin/bash

mkdir 0
cp * 0
sh ~/bin/orange/modify.sh INCAR ISTART 1
sh ~/bin/orange/modify.sh INCAR LWAVE
sh ~/bin/orange/modify.sh INCAR LSOL .TRUE.

            
goal=$1
# goal=-0.6
x1=''
x2=''
y1=''
y2=''
hl=-4.43
step=0.1
error=0.02
unset map
declare -A map
if [[ -z run_cep.sh ]]; then
    grep mpiexe run_slurm.sh > run_cep.sh
fi
echo -e "Type\tDiff\tNelect\tShift\tFermi\tWork.F\tPotential" >> cepout.log
echo -e "x1\tx2\ty1\ty2\tgrad\tgoal\tdiff" >> check.log

function update {
    IFS=' '
    nes=$(grep NELECT OUTCAR)
    read -ra nea <<< $nes
    ne=$(echo ${nea[2]} | awk '{printf "%.2f", $1}')
    shs=$(grep FERMI_SHIFT stdout.log | tail -n 1)
    read -ra sha <<< $shs
    sh=$(echo ${sha[2]} | awk '{printf "%.4f", $1}')
    fls=$(grep E-fermi OUTCAR | tail -n 1)
    read -ra fla <<< $fls
    fl=${fla[2]}
    wf=$(echo "$fl $sh" | awk '{printf "%.4f", $1 + $2}')
    ep=$(echo "$hl $wf" | awk '{printf "%.4f", $1 - $2}')
    echo -e "$type\t$diff\t$ne\t$sh\t$fl\t$wf\t$ep" >> cepout.log
    map+=([$ne]=$ep)
    x1=$x2
    y1=$y2
    x2=$ne
    y2=$ep
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

range0=$(echo "$goal $error" | awk '{print $1 - $2}')
range1=$(echo "$goal $error" | awk '{print $1 + $2}')
until [[ `echo "$range0 < $ep" | bc` -eq 1 ]] && [[ `echo "$ep < $range1" | bc` -eq 1 ]] 
do
    mkdir $ne
    cp INCAR POSCAR CONTCAR XDATCAR OUTCAR OSZICAR vasprun.xml stdout.log $ne
    mv CONTCAR POSCAR
    
    if [[ ${#map[@]} -eq 1 ]] && [[ `echo "$ep < $goal" | bc` == 1 ]]; then
        type=type1
        diff=-$step
    elif [[ ${#map[@]} -eq 1 ]] && [[ `echo "$ep > $goal" | bc` == 1 ]]; then
        type=type2
        diff=+$step
    else
        grad=$(echo "$x1 $x2 $y1 $y2" | awk '{print ($1 - $2) / ($3 - $4)}')
        diff=$(echo "$grad $goal $x1 $y1" | awk '{print $1 * ($2 - $4) + $3}')
        echo -e "$x1\t$x2\t$y1\t$y2\t$grad\t$goal\t$diff" >> check.log
        if [[ `echo "$diff > 2.5" | bc` == 1 ]]; then
            type=type3
            diff=+1.0
        elif [[ `echo "$diff < -2.5" | bc` == 1 ]]; then
            type=type4
            diff=-1.0
        else
            type=type5
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
    sh run_cep.sh
    update
    # linear
done