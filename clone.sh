# usage: sh clone.sh a2.vasp b3 -> b1.vasp b2.vasp b3.vasp

# filename=$(echo $2 | rev | cut -c 2- | rev)
# numb=$(echo $2 | rev | cut -c 1)

filename=$(echo ${2: (-1)})
numb=$(echo ${2: 0:(-1)})
ext=${1##*.}

for i in $(seq 1 $numb)
do
    cp $1 $filename$i.$ext
done