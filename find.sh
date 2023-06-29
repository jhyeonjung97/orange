i=1
DIR='*/'
dir_now=$PWD

while [[ $i -gt 0 ]]
do
    i=0
    for i in $DIR
    do
        cd $i
        if [[ -n $(grep $1 POTCAR) ]]; then
            pwd
            grep $1 POTCAR --color
        fi
        cd $dir_now
    done
    
    
    DIR=$DIR+'*/'
    echo "directories: $DIR"
done