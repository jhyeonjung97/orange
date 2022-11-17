for file in *.cif
do
    filename="${file%.*}"
    cif2cell $file -p quantum-espresso -o $filename.in
    grep nat $filename.in > $filename.data
    grep ntyp $filename.in >> $filename.data
    grep PSEUDO $filename.in >> $filename.data
    sed -i '1,/ATOMIC_POSITIONS {crystal}/d' $filename.in
    sed -i '1i\ATOMIC_POSITIONS {crystal}' $filename.in
done