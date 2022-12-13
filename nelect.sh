ntyp_tag=$(sed -n 6p POSCAR | sed 's/\t/ /g')
IFS=' '
read -ra ntyp_arr <<< $ntyp_tag
ntyp=${#ntyp_arr[@]}
# ntyp=${ntyp_arr[2]}

nat_tag=$(sed -n 7p POSCAR | sed 's/\t/ /g')
IFS=' '
read -ra nat_arr <<< $nat_tag

i=1
nelect=0
for nat in ${nat_arr[@]}
do
    zval_tag=$(grep ZVAL POTCAR | sed 's/\t/ /g' | sed -n "$i"p)
    IFS=' '
    read -ra zval_arr <<< $zval_tag
    zval=${zval_arr[5]}
    nelect=$(echo "$nelect $nat $zval" | awk '{print $1 + ($2 * $3)}')
    i=$(($i+1))
done

sh ~/bin/orange/modify.sh INCAR NELECT $nelect