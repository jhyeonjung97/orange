for i in $1*.vasp
do
    cp $i POSCAR
    python ~/bin/shoulder/xcell.py
    mv out*.vasp $i
done