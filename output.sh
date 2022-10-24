read -p "which files?: " a

if [ "$a" == "p" ]; then
    $a = "POSCAR"
elif [ "$a" == "c" ]; then
    $a = "CONTCAR"
fi

read -p "files starts with: " b

for i in {0..9}
do
    cp $i*/$a $b$i.vasp
done