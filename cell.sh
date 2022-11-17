for file in *.cif
do
    filename="${file%.*}"
    cif2cell $file -p quantum-espresso -o $filename.in
    sed -n 10,23p $filename.in > $filename.data
    sed -i 1,23d $filename.in
done