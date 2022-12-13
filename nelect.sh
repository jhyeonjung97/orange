ntyp_tag=$(sed -n 6p POSCAR | sed 's/\t/ /g')
IFS=' '
read -ra ntyp_arr <<< $ntyp_tag
ntyp=${#ntyp_arr[@]}
# ntyp=${ntyp_arr[2]}

nat_tag=$(sed -n 7p POSCAR | sed 's/\t/ /g')
IFS=' '
read -ra nat_arr <<< $nat_tag
    
for i in $(seq 1 $ntyp)
do
    typ=${ntyp_arr[$i]}
    nat=${nat_arr[$i]}
    zval_tag=$(grep ZVAL POTCAR | sed 's/\t/ /g' | sed -n "$i"p)
    IFS=' '
    read -ra zval_arr <<< $zval_tag
    zval=${zval_arr[5]}
    nelect+=$(echo "$nat $zval" | awk '{print $1 * $2}')
    echo $i $typ $nat $zval $nelect
done

sh ~/bin/orange/incar.sh NELECT $nelect