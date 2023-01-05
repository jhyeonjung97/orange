# functions
function modify {
    if [[ -z $(grep $2 $1) ]]; then
        echo "#$2 =" >> $1
    fi
    if [[ -z $3 ]]; then
        sed -i "s/#$2 /$2 /" $1
        sed -i "s/$2 /#$2 /" $1
    else
        sed -i "/$2 /c\\$2 = $3" $1
    fi
}

# prepare input files
if [[ -s $1 ]]; then
    modify $1 $2 $3
    grep "$2 " $1
elif [[ $1 == 'chg' ]]; then
    cp INCAR .INCAR
    modify INCAR NSW
    modify INCAR IBRION
    modify INCAR ALGO
    modify INCAR LCHARG
    modify INCAR LAECHG .TRUE.
    modify INCAR LORBIT
elif [[ $1 == 'dos' ]]; then
    cp INCAR .INCAR
    modify INCAR ICHARG 11
    modify INCAR NSW
    modify INCAR IBRION
    modify INCAR ISMEAR -5
    modify INCAR SIGMA
    modify INCAR ALGO
    modify INCAR LCHARG .FALSE.
    modify INCAR LAECHG
    modify INCAR LORBIT 11
    sed -i "s/Monk-horst/Gamma-only/" KPOINTS
else