filename=$1

for dir in */
do
    numb=$(echo $dir | cut -c 1)
    cp $dir/ACF.dat ACF$numb.dat
done

sed -i -e '1,2d' ACF*.dat
sed -i -e '1,2d' ACF*.dat
sed -i -e '$d' ACF*.dat
sed -i -e '$d' ACF*.dat
sed -i -e '$d' ACF*.dat
sed -i -e '$d' ACF*.dat

python ~/bin/orange/chg.py $filename