# functions
function modify {
    if [[ -z $(grep $2 $1) ]]; then
        echo $2 >> $1
    fi
    
    if [[ -z $3 ]]; then
        sed -i "s/#$2/$2/" $1
        sed -i "s/$2/#$2/" $1
    else
        sed -i "/$2/c\\$2 = $3" $1
    fi
}

#prepare input files
if [[ $1 == 'chg' ]]; then
    cp INCAR INCAR_chg
    echo '<INCAR_chg>'
    modify INCAR_chg NSW
    modify INCAR_chg IBRION
    modify INCAR_chg LCHARG
    modify INCAR_chg LAECHG .TRUE.
    modify INCAR_chg LORBIT
fi

if [[ $1 == 'dos' ]]; then
    cp INCAR INCAR_dos
    echo '<INCAR_dos>'
    modify INCAR_dos ICHARG 11
    modify INCAR_dos NSW
    modify INCAR_dos IBRION
    modify INCAR_dos ISMEAR -5
    modify INCAR_dos ALGO
    modify INCAR_dos LCHARG .FALSE.
    modify INCAR_dos LAECHG
    modify INCAR_dos LORBIT 11
    modify INCAR_dos NEDOS 1000
    modify INCAR_dos EMIN -50
    modify INCAR_dos EMAX 50
fi