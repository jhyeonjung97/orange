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
    grep "$2 " $1
}

# prepare input files
if [[ $1 == 'chg' ]] || ([[ $1 == INCAR ]] && [[ $3 == chg ]]); then
    cp INCAR .INCAR
    modify INCAR NSW
    modify INCAR IBRION
    modify INCAR ALGO
    modify INCAR LCHARG
    modify INCAR LAECHG .TRUE.
    modify INCAR LORBIT
    sed -i '/#PBS -N/s/$/-chg/' run_slurm.sh
elif [[ $1 == 'dos' ]] || ([[ $1 == INCAR ]] && [[ $3 == dos ]]); then
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
    sed -i '/#PBS -N/s/-dos//g' run_slurm.sh
    sed -i '/#PBS -N/s/$/-dos/' run_slurm.sh
else
    modify $1 $2 $3
fi