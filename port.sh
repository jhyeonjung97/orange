if [[ $1 == 'p' ]] || [[ $1 == 'pos' ]]; then
    file='POSCAR'
elif [[ $1 == 'c' ]] || [[ $1 == 'con' ]]; then
    file='CONTCAR'
else
    file=$1
fi

echo $1
cp $1 ~/port/
