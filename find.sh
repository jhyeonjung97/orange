i=1
DIR='*/'
dir_now=$PWD

while [[ $i -gt 0 ]]
do
    i=0
    for j in $DIR
    do
        cd $j
        if [[ -f POTCAR ]] && [[ -n $(grep $1 POTCAR) ]]; then
            echo $j
            grep "PAW_PBE $1" POTCAR --color
        fi
        cd $dir_now
        i=$(($i+1))
    done
    
    DIR=$DIR'*/'
    echo "i: $i, j: $j"
    echo "directories: $DIR"
done