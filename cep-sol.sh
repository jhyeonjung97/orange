#!/bin/bash
OIFS=$IFS

x1=''
x2=''
y1=''
y2=''
pH=14
hl=4.43
step=0.1
error=0.02
unset map
declare -A map

if [[ -n $1 ]]; then
    rhe=$1
elif [[ -n $(echo $PWD | grep _Au) ]]; then
    rhe=-0.6
elif [[ -n $(echo $PWD | grep _Pt) ]]; then
    rhe=-0.1
else
    rhe=-0.6
fi
goal=$(echo "$rhe $pH" | awk '{print $1 - 0.0592 * $2}')
echo "goal RHE: $rhe, SHE: $goal (pH = $pH)"

if [[ ! -d wave ]] && [[ -s WAVECAR ]] && [[ -s CONTCAR ]]; then
    mkdir wave
    cp * wave
    mv conti*/ wave
fi
sh ~/bin/orange/modify.sh INCAR ISTART 1
sh ~/bin/orange/modify.sh INCAR IDIPOL
sh ~/bin/orange/modify.sh INCAR TAU 0
sh ~/bin/orange/modify.sh INCAR LAMBDA_D_K 3.0
sh ~/bin/orange/modify.sh INCAR LSOL .TRUE.
sh ~/bin/orange/modify.sh INCAR LWAVE .TRUE.
sh ~/bin/orange/modify.sh INCAR LCHARG .TRUE.
sh ~/bin/orange/modify.sh INCAR LAECHG .TRUE.

if [[ ! -s mpiexe.sh ]]; then
    grep mpiexe run_slurm.sh > mpiexe.sh
fi
date >> cepout.log
echo -e "Nelect\tType\tDiff\tShift\tFermi_level\tWork_Function\tV_SHE\tV_RHE" >> cepout.log

while IFS=$'\t' read -r -a line
do
    head=${line[0]}
    head=${head#-}
    head=${head//[0-9]/}
    head=${head#.}
    echo $head
    echo ${#line[@]}
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

function update {
    IFS=' '
    nes=$(grep NELECT OUTCAR)
    read -ra nea <<< $nes
    ne=$(echo ${nea[2]} | awk '{printf "%.3f", $1}')
    shs=$(grep FERMI_SHIFT stdout.log | tail -n 1)
    read -ra sha <<< $shs
    sh=$(echo ${sha[2]} | awk '{printf "%.8f", $1}')
    fls=$(grep E-fermi OUTCAR | tail -n 1)
    read -ra fla <<< $fls
    fl=${fla[2]}
    wf=$(echo "$fl $sh" | awk '{printf "%.8f", - $1 - $2}')
    ep=$(echo "$wf $hl" | awk '{printf "%.8f", $1 - $2}')
    diff=$(echo $diff | awk '{printf "%.8f", $1}')
    rp=$(echo "$ep $pH" | awk '{print $1 + 0.0592 * $2}')
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
    echo -e "$ne\t$type\t$diff\t$sh\t$fl\t$wf\t$ep\t$rp" >> cepout.log
    map+=([$ne]=$ep)
    mkdir cep_$ne
    cp INCAR POSCAR CONTCAR XDATCAR AECCAR0 AECCAR1 AECCAR2 WAVECAR CHGCAR OUTCAR OSZICAR vasprun.xml stdout.log cep_$ne
    mv CONTCAR POSCAR
    x1=$x2
    y1=$y2
    x2=$ne
    y2=$ep
    if [[ -n $(grep LDIPOL stdout.log) ]]; then
        exit 5
    fi
done
IFS=$OIFS