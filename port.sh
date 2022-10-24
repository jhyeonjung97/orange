if [[ $1 == 'p' ]] || [[ $1 == 'pos' ]]; then
    1='POSCAR'
elif [[ $1 == 'c' ]] || [[ $1 == 'con' ]]; then
    1='CONTCAR'
fi

cp $1 ~/port/$2
