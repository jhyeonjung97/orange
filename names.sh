echo -n 'initial names: '
read -a i
echo -n 'final names: '
read -a f

n=${#i[@]}
for j in $(seq 0 $n)
do
    echo "mv $i[$j] $f[$j]"
    mv $i[$j] $f[$j]
done