#!/bin/bash
OIFS=$IFS

x1=''
x2=''
y1=''
y2=''
hl=-4.43
step=0.1
error=0.02
    
if [[ ! -d wave ]]; then
    mkdir wave
    cp * wave
fi
sh ~/bin/orange/modify.sh INCAR ISTART 1
sh ~/bin/orange/modify.sh INCAR LSOL .TRUE.
sh ~/bin/orange/modify.sh INCAR LWAVE .FALSE.
sh ~/bin/orange/modify.sh INCAR LCHARG .TRUE.
sh ~/bin/orange/modify.sh INCAR LAECHG .TRUE.

if [[ -n $1 ]]; then
    goal=$1
elif [[ -n $(echo $PWD | grep 1_Au) ]]; then
    goal=-0.6
elif [[ -n $(echo $PWD | grep 2_Pt) ]]; then
    goal=-0.1
else
    goal=-0.6
fi

unset map
declare -A map
if [[ ! -s mpiexe.sh ]]; then
    grep mpiexe run_slurm.sh > mpiexe.sh
fi
date >> cepout.log
# date >> check.log
echo -e "Nelect\tType\tDiff\tShift\tFermi\tWork.F\tPotential" >> cepout.log
# echo -e "x1\tx2\ty1\ty2\tgrad\tgoal\ttype\tdiff" >> check.log

while read line
do
    IFS=' ' read -r -a line <<< $line
    head=${line[0]}
    head=${head#-}
    head=${head//[0-9]/}
    head=${head#.}
    # echo $head
    # echo ${#line[@]}
    if [[ -z $head ]] && [[ ${#line[@]} == 7 ]]; then
        ne=${line[0]}
        ep=${line[6]}
        x1=$x2
        y1=$y2
        x2=$ne
        y2=$ep
        if [[ "$x1" == "$x2" ]]; then
            x1=''
            y1=''
        else
            map+=([$ne]=$ep)
        fi
    fi
done < cepout.log
# echo $x1 $x2 $y1 $y2 ${#map[@]}

function update {
    IFS=' '
    nes=$(grep NELECT OUTCAR)
    read -ra nea <<< $nes
    ne=$(echo ${nea[2]} | awk '{printf "%.8f", $1}')
    shs=$(grep FERMI_SHIFT stdout.log | tail -n 1)
    read -ra sha <<< $shs
    sh=$(echo ${sha[2]} | awk '{printf "%.8f", $1}')
    fls=$(grep E-fermi OUTCAR | tail -n 1)
    read -ra fla <<< $fls
    fl=${fla[2]}
    wf=$(echo "$fl $sh" | awk '{printf "%.8f", $1 + $2}')
    ep=$(echo "$hl $wf" | awk '{printf "%.8f", $1 - $2}')
    diff=$(echo $diff | awk '{printf "%.8f", $1}')
}

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

echo -e "$ne\t$type\t$diff\t$sh\t$fl\t$wf\t$ep" >> cepout.log
range0=$(echo "$goal $error" | awk '{print $1 - $2}')
range1=$(echo "$goal $error" | awk '{print $1 + $2}')
until [[ `echo "$range0 < $ep" | bc` -eq 1 ]] && [[ `echo "$ep < $range1" | bc` -eq 1 ]] 
do
    if [[ ${#map[@]} -eq 0 ]]; then
        update
        echo -e "$ne\t$type\t$diff\t$sh\t$fl\t$wf\t$ep" >> cepout.log
        x2=$ne
        y2=$ep
        echo $ne
    fi
    if [[ ${#map[@]} -eq 0 ]]; then
        type=type0
        diff=0.0
    elif [[ ${#map[@]} -eq 1 ]] && [[ `echo "$ep < $goal" | bc` == 1 ]]; then
        type=type1
        diff=-0.1
    elif [[ ${#map[@]} -eq 1 ]] && [[ `echo "$ep > $goal" | bc` == 1 ]]; then
        type=type2
        diff=+0.1
    else
        grad=$(echo "$x1 $x2 $y1 $y2" | awk '{print ($1 - $2) / ($3 - $4)}')
        diff=$(echo "$grad $goal $y2" | awk '{print $1 * ($2 - $3)}')
        if [[ `echo "$diff > 1.0" | bc` == 1 ]]; then
            type=type3
            diff=+1.0
        elif [[ `echo "$diff < -1.0" | bc` == 1 ]]; then
            type=type4
            diff=-1.0
        else
            type=type5
        fi
    fi
    new=$(echo "$ne $diff" | awk '{print $1 + $2}')
    while in_array "$new" "${!map[*]}"
    do
        if [[ `echo "$diff < 0" | bc` == 1 ]]; then
            type=type6
            new=$(echo "$new $step" | awk '{print $1 - $2}')
        else
            type=type7
            new=$(echo "$new $step" | awk '{print $1 + $2}')
        fi
    done
    sh ~/bin/orange/modify.sh INCAR NELECT $new
    if [[ -s POSCAR ]] && [[ -s WAVECAR ]]; then
        sh mpiexe.sh; sh ~/bin/orange/ediff.sh
    else
        exit 1
    fi
    update
    echo -e "$ne\t$type\t$diff\t$sh\t$fl\t$wf\t$ep" >> cepout.log
    map+=([$ne]=$ep)
    mkdir cep_$ne
    cp INCAR POSCAR CONTCAR XDATCAR CHGCAR OUTCAR OSZICAR vasprun.xml stdout.log cep_$ne
    x1=$x2
    y1=$y2
    x2=$ne
    y2=$ep
done
IFS=$OIFS