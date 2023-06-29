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
            grep $1 POTCAR --color
            i+=1
        fi
        cd $dir_now
    done
    
    DIR=$DIR+'*/'
    echo "directories: $DIR"
done