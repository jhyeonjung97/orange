#!/bin/bash

hl=4.4
function update {
    IFS=' '
    nes=$(grep NELECT OUTCAR)
    read -ra nea <<< $nes
    ne=$(echo ${nea[2]} | cut -c -6)
    vls=$(vaspkit -task 426 | grep Vacuum | grep eV)
    read -ra vla <<< $vls
    vl=$(echo ${vla[2]} | cut -c -6)
    fls=$(grep E-fermi OUTCAR | tail -n 1)
    read -ra fla <<< $fls
    fl=$(echo ${fla[2]} | cut -c -6)
    wf=$(echo "$vl $fl" | awk '{print $1 - $2}' | cut -c -6)
    ep=$(echo "$wf $hl" | awk '{print $1 - $2}' | cut -c -6)
}

echo -e "Dir\tNELECT\tVacuum\tFermi\tWork.F\tE.Potential"

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
    if [[ -f OUTCAR ]]; then
        update
        echo -e "$i\t$ne\t$vl\t$fl\t$wf\t$ep"
    fi
    cd ..
done
# fi