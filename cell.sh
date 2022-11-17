for file in *.cif
do
    filename="${file%.*}"
    cif2cell $file -p quantum-espresso -o $filename.in
    grep nat $filename.in > $filename.data
    grep ntyp $filename.in >> $filename.data
    sed -i '1,/ATOMIC_SPECIES/d' $filename.in
    sed -i '1i\ATOMIC_SPECIES' $filename.in
    
    sed -i 's/H_PSEUDO/H.pbe-kjpaw_psl.1.0.0.UPF/' $filename.in
    sed -i 's/O_PSEUDO/O.pbe-nl-kjpaw_psl.1.0.0.UPF/' $filename.in
    sed -i 's/Li_PSEUDO/Li.pbe-sl-kjpaw_psl.1.0.0.UPF/' $filename.in
done