i=0
filename=$1

for dir in */
do
    numb=$(echo $dir | cut -c 1)
    cp $dir/ACF.dat ACF$numb.dat
    i+=1
done

sed -i -e '1,2d' ACF*.dat
sed -i -e '1,2d' ACF*.dat
sed -i -e '$d' ACF*.dat
sed -i -e '$d' ACF*.dat
sed -i -e '$d' ACF*.dat
sed -i -e '$d' ACF*.dat

python ~/bin/orange/chg.py $i $filename