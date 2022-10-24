read -p "how many images: " a
read -p "files starts with: " f

$b = $a+1
for i in {0..$a+1}
do
    cp 0$i/POSCAR $b-p$i.vasp
    cp 0$i/CONTCAR $f-c$i.vasp
done

cp 00/POSCAR $f-c0.vasp
cp 0$b/POSCAR '+c+'-c$b.vasp', shell=True)
