echo -n 'initial names: '
read -a i
echo -n 'final names: '
read -a f

n=${#i[@]}
n=$(($n-1))
for j in $(seq 0 $n)
do
    echo "mv ${i[$j]} ${f[$j]}"
    mv ${i[$j]} ${f[$j]}
done