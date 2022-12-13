nchg_tag=$(grep NETCHG INCAR | sed 's/\t/ /g')
IFS=' '
read -ra nchg_arr <<< $nchg_tag
nchg=${nchg_arr[2]}
sed -i -e '/NETCHG/d' INCAR

ntyp_tag=$(sed -n 6p POSCAR | sed 's/\t/ /g')
IFS=' '
read -ra ntyp_arr <<< $ntyp_tag
ntyp=${#ntyp_arr[@]}

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

nelect0=$(echo "$nelect $nchg" | awk '{print $1 + $2}')
sh ~/bin/orange/modify.sh INCAR NELECT $nelect0
echo "NELECT_neutral: $nelect, NELECT: $nelect0 (net_charge: $nchg)"