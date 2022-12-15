#!/bin/bash

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
    echo -e "$ne\t$vl\t$fl\t$wf\t$ep"
}

echo -e "NELECT\tVacuum\tFermi\tWork.F\tE.Potential"

# if [[ -f OUTCAR ]]; then # simple submit
#     update
# else
#     if [[ $1 == '-r' ]] || [[ $1 == 'all' ]]; then
#         DIR='*/'
#     elif [[ $1 == '-s' ]] || [[ $1 == '-select' ]]; then
#         DIR=${@:2}
#     elif [[ -z $2 ]]; then
#         DIR=$(seq 1 $1)
#     else
#         DIR=$(seq $1 $2)
#     fi
for i in */
do
    i=${i%/}
    cd $i*
    update
    cd ..
done
# fi