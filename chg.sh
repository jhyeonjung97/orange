function ichg { 
    sh ~/bin/orange/modify.sh INCAR LCHARG True
    sh ~/bin/orange/modify.sh INCAR LAECHG True
}


if [[ $1 == '-r' ]]; then
    for dir in */
    do
        cd $dir
        ichg
        cd ..
    done
else
    ichg
fi
    


