#!/bin/bash
OIFS=$IFS

if [[ ! -d wave ]]; then
    mkdir wave
    cp * wave
fi
sh ~/bin/orange/modify.sh INCAR ISTART 1
sh ~/bin/orange/modify.sh INCAR LSOL .TRUE.
sh ~/bin/orange/modify.sh INCAR LWAVE .FALSE.
sh ~/bin/orange/modify.sh INCAR NSW
sh ~/bin/orange/modify.sh INCAR IBRION

goal=$1
# goal=-0.6
x1=''
x2=''
y1=''
y2=''
hl=-4.43
step=0.1
error=0.02
# nediff=-15.0
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
    IFS=$'\t' read -r -a line <<< $line
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
    ne=$(echo ${nea[2]} | awk '{printf "%.2f", $1}')
    shs=$(grep FERMI_SHIFT stdout.log | tail -n 1)
    read -ra sha <<< $shs
    sh=$(echo ${sha[2]} | awk '{printf "%.4f", $1}')
    fls=$(grep E-fermi OUTCAR | tail -n 1)
    read -ra fla <<< $fls
    fl=${fla[2]}
    wf=$(echo "$fl $sh" | awk '{printf "%.4f", $1 + $2}')
    ep=$(echo "$hl $wf" | awk '{printf "%.4f", $1 - $2}')
    diff=$(echo $diff | awk '{printf "%.2f", $1}')
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

if [[ ${#map[@]} -eq 0 ]]; then
    update
    echo -e "$ne\t$type\t$diff\t$sh\t$fl\t$wf\t$ep" >> optout.log
    x2=$ne
    y2=$ep
else
    mkdir cep_$ne
    cp INCAR POSCAR CONTCAR XDATCAR OUTCAR OSZICAR vasprun.xml stdout.log cep_$ne
    sh ~/bin/orange/modify.sh INCAR NEDIFF
    # if [[ -s CONTCAR ]]; then
    #     mv CONTCAR POSCAR
    # fi
fi

echo -e "$ne\t$type\t$diff\t$sh\t$fl\t$wf\t$ep" >> cepout.log
range0=$(echo "$goal $error" | awk '{print $1 - $2}')
range1=$(echo "$goal $error" | awk '{print $1 + $2}')
until [[ `echo "$range0 < $ep" | bc` -eq 1 ]] && [[ `echo "$ep < $range1" | bc` -eq 1 ]] 
do
    if [[ ${#map[@]} -eq 0 ]]; then
        type=type0
        diff=0.0
        # if [[ -n $(grep '#NEDIFF' INCAR) ]]; then
        #     diff=0.0
        # elif [[ -n $(grep NEDIFF INCAR) ]]; then
        #     read -ra nediff_tag <<< $(grep NEDIFF INCAR)
        #     diff=${nediff_tag[2]}
        #     sh ~/bin/orange/modify.sh INCAR NEDIFF
        # elif [[ -n $nediff ]]; then
        #     diff=$nediff
        # else
        #     diff=0.0
        # fi
    elif [[ ${#map[@]} -eq 1 ]] && [[ `echo "$ep < $goal" | bc` == 1 ]]; then
        type=type1
        diff=-1.0
    elif [[ ${#map[@]} -eq 1 ]] && [[ `echo "$ep > $goal" | bc` == 1 ]]; then
        type=type2
        diff=+1.0
    else
        grad=$(echo "$x1 $x2 $y1 $y2" | awk '{print ($1 - $2) / ($3 - $4)}')
        diff=$(echo "$grad $goal $y2" | awk '{print $1 * ($2 - $3)}')
        if [[ `echo "$diff > 10.0" | bc` == 1 ]]; then
            type=type3
            diff=+10.0
        elif [[ `echo "$diff < -10.0" | bc` == 1 ]]; then
            type=type4
            diff=-10.0
        else
            type=type5
        fi
    fi
    # echo -e "$x1\t$x2\t$y1\t$y2\t$grad\t$goal\t$type\t$diff" >> check.log
    new=$(echo "$ne $diff" | awk '{print $1 + $2}')
    while in_map $new
    do
        if [[ `echo "$diff < 0" | bc` == 1 ]]; then
            new=$(echo "$new $step" | awk '{print $1 - $2}')
        else
            new=$(echo "$new $step" | awk '{print $1 + $2}')
        fi
    done
    sh ~/bin/orange/modify.sh INCAR NELECT $new
    if [[ -s POSCAR ]] && [[ -s WAVECAR ]]; then
        sh mpiexe.sh
    else
        exit 1
    fi
    update
    echo -e "$ne\t$type\t$diff\t$sh\t$fl\t$wf\t$ep" >> cepout.log
    map+=([$ne]=$ep)
    x1=$x2
    y1=$y2
    x2=$ne
    y2=$ep
    # linear
done

x1=''
x2=''
y1=''
y2=''
unset map
declare -A map
sh ~/bin/orange/modify.sh INCAR NSW 600
sh ~/bin/orange/modify.sh INCAR IBRION 2
date >> optout.log
# date >> check.log
echo -e "Nelect\tType\tShift\tFermi\tWork.F\tPotential" >> optout.log

while read line
do
    IFS=$'\t' read -r -a line <<< $line
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
done < optout.log

update
echo -e "$ne\t$type\t$diff\t$sh\t$fl\t$wf\t$ep" >> optout.log
x2=$ne
y2=$ep

if [[ -s POSCAR ]] && [[ -s WAVECAR ]]; then
    sh mpiexe.sh
else
    exit 2
fi

until [[ `echo "$range0 < $ep" | bc` -eq 1 ]] && [[ `echo "$ep < $range1" | bc` -eq 1 ]] 
do
    if [[ ${#map[@]} -ne 0 ]]; then
        mkdir opt_$ne
        cp INCAR POSCAR CONTCAR XDATCAR OUTCAR OSZICAR vasprun.xml stdout.log opt_$ne
        # if [[ -s CONTCAR ]]; then
        #     mv CONTCAR POSCAR
        # fi
    fi
    
    if [[ ${#map[@]} -eq 0 ]]; then
        type=type0
        diff=0.0
    elif [[ ${#map[@]} -eq 1 ]] && [[ `echo "$ep < $goal" | bc` == 1 ]]; then
        type=type1
        diff=-$step
    elif [[ ${#map[@]} -eq 1 ]] && [[ `echo "$ep > $goal" | bc` == 1 ]]; then
        type=type2
        diff=+$step
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
    # echo -e "$x1\t$x2\t$y1\t$y2\t$grad\t$goal\t$type\t$diff" >> check.log
    new=$(echo "$ne $diff" | awk '{print $1 + $2}')
    while in_map $new
    do
        if [[ `echo "$diff < 0" | bc` == 1 ]]; then
            new=$(echo "$new $step" | awk '{print $1 - $2}')
        else
            new=$(echo "$new $step" | awk '{print $1 + $2}')
        fi
    done
    sh ~/bin/orange/modify.sh INCAR NELECT $new
    if [[ -s POSCAR ]] && [[ -s WAVECAR ]]; then
        sh mpiexe.sh
    else
        exit 3
    fi
    update
    echo -e "$ne\t$type\t$diff\t$sh\t$fl\t$wf\t$ep" >> optout.log
    map+=([$ne]=$ep)
    x1=$x2
    y1=$y2
    x2=$ne
    y2=$ep
    # linear
done
IFS=$OIFS