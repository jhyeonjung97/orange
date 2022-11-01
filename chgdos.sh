#!/bin/bash

read -p 'Geometry optimization? [y/n] (default: y)' geo

# default answer/ check input files
if [[ -z $geo ]] || [[ $geo =~ 'y' ]]; then
    if [ ! -e INCAR ] || [ ! -e KPOINTS ] || [ ! -e POTCAR ] || [ ! -e POSCAR ] || [ ! -e run_slurm.sh ]; then
        echo 'you are missing something..'
        exit 8
    fi
    geo='y'
fi


read -p 'CHG? [y/n] (default: y)' chg
read -p 'DOS? [y/n] (default: y)' dos

# default answer/ check input files
if [[ -z $chg ]] || [[ $chg =~ 'y' ]]; then
    chg='y'
fi
 
if [[ -z $dos ]] || [[ $dos =~ 'y' ]]; then
    if [[ $chg == 0 ]] && [[ ! -e double_k ]]; then
        echo 'you need double_k..'
        exit 5
    elif [[ ! -s CHGCAR ]]; then
        echo 'you need CHGCAR..'
        exit 6
    else
        more KPOINTS
        read -p 'double k-points? (enter: yes)' double
    fi
    dos='y'
fi

if ( [[ $geo == 'y' ]] && [[ $chg == 'y' ]] && [[ $dos == 'y' ]] ) || ( [[ $geo == 'y' ]] && [[ $chg == 'y' ]] && [[ $dos != 'y' ]] ) || ( [[ $geo != 'y' ]] && [[ $chg == 'y' ]] && [[ $dos == 'y' ]] ) || ( [[ $geo != 'y' ]] && [[ $chg == 'y' ]] && [[ $dos != 'y' ]] ) || ( [[ $geo != 'y' ]] && [[ $chg != 'y' ]] && [[ $dos == 'y' ]] ); then
    mkdir geo
else
    echo 'calculation sequence is wrong..'
    exit 1
fi

# functions
function modify {
    grep $2 $1

    if [[ -z $(grep $2 $1) ]]; then
        echo "#$2"
        echo $2 >> $1
    fi
    
    if [[ -z $3 ]]; then
        sed -i "s/#$2/$2/" $1
        sed -i "s/$2/#$2/" $1
    else
        sed -i "/$2/c\\$2 = $3" $1
    fi
        
    grep $2 $1
}

if [[ $chg == 'y' ]]; then
    mkdir chg
    cp INCAR INCAR_chg
    modify INCAR_chg NSW
    modify INCAR_chg IBRION
    modify INCAR_chg LCHARG
    modify INCAR_chg LAECHG .TRUE.
    modify INCAR_chg LORBIT
fi

if [[ $dos == 'y' ]]; then
    mkdir dos
    cp INCAR INCAR_dos
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

#geo, chg, dos
if [[ $chg != 'y' ]]; then
    if [[ ! -e $chg ]]; then
        echo 'please prepare chg directory..'
        exit 2
    fi
elif [[ geo != 'y' ]]; then
    cp * geo
    sed -i '11,$d' run_slurm.sh
fi

#prepare input files
sed -n '11,$p' run_slurm.sh > temp1
if [[ $chg == 'y' ]]; then
    echo 'cp * geo
    cp CONTCAR POSCAR
    mv INCAR_chg INCAR' >> run_slurm.sh
    cat run_slurm.sh temp1 >> temp2
    mv temp2 run_slurm.sh
fi
if [[ $dos == 'y' ]]; then
    cp KPOINTS double_k
    if [[ -z $(grep ISMEAR INCAR | grep -5) ]]; then
        sed -i '3c\Gamma-only' KPOINTS
    fi
    echo '#please double k-points' >> double_k
    
    echo 'cp * dos
    cp CONTCAR POSCAR
    mv double_k KPOINTS
    mv INCAR_dos INCAR' >> run_slurm.sh
    cat run_slurm.sh temp1 >> temp2
    mv temp2 run_slurm.sh
fi

rm temp1 temp2

if [[ dos == 'y' ]]; then
    vi double_k
fi