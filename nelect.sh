ntyp_tag=$(sed -n 6p POSCAR | sed 's/\t/ /g')
IFS=' '
read -ra ntyp_arr <<< $ntyp_tag
ntyp=${#ntyp_arr[@]}
# ntyp=${ntyp_arr[2]}

nat_tag=$(sed -n 7p POSCAR | sed 's/\t/ /g')
IFS=' '
read -ra nat_arr <<< $nat_tag
    
step=1
nelect=0
for i in $(seq 1 $ntyp)
do
    j=$(echo "$i $step" | awk '{print $1 - $2}')
    typ=${ntyp_arr[$j]}
    nat=${nat_arr[$j]}
    zval_tag=$(grep ZVAL POTCAR | sed 's/\t/ /g' | sed -n "$i"p)
    IFS=' '
    read -ra zval_arr <<< $zval_tag
    zval=${zval_arr[5]}
    nelect=$(echo "$nelect $nat $zval" | awk '{print $1 + ($2 * $3)}')
    echo $i $typ $nat $zval $nelect
done

sh ~/bin/orange/modify.sh NELECT $nelect