for file in *.cif
do
    filename="${file%.*}"
    cif2cell $file -p quantum-espresso -o $filename.in
done