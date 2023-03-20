# usage: sh clone.sh a2.vasp b3 -> b1.vasp b2.vasp b3.vasp
#      : sh clone.sh a.vasp c.vasp

if [[ -n $(echo $2 | grep '\.') ]]; then
    filename=${1%.*}
    ext=${1##*.}
    mkdir clone_temp
    cp "$filename"*.$ext clone_temp
    cd clone_temp
    sh ~/bin/orange/rename.sh $1 $2
    mv * ..
    cd ..
    rm -r clone_temp
else
    filename=$(echo $2 | rev | cut -c 2- | rev)
    numb=$(echo $2 | rev | cut -c 1)
    # filename=$(echo ${2: (-1)})
    # numb=$(echo ${2: 0: (-1)})
    ext=${1##*.}
    for i in $(seq 1 $numb)
    do
        cp $1 $filename$i.$ext
    done
fi