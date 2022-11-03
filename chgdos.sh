#!/bin/bash

#usage: chdo [geo?] [chg?] [dos?]

geo=$1; chg=$2; dos=$3

if [[ -z $1 ]]; then
    read -p '1) Geometry optimization? [y/n] (default: y) ' geo
fi
if [[ -z $2 ]]; then
    read -p '2) CHG? [y/n] (default: y) ' chg
fi
if [[ -z $3 ]]; then
    read -p '3) DOS? [y/n] (default: y) ' dos
fi

# default answer/ check input files
if [[ -z $geo ]] || [[ $geo =~ 'y' ]]; then
    if [ ! -e INCAR ] || [ ! -e KPOINTS ] || [ ! -e POTCAR ] || [ ! -e POSCAR ] || [ ! -e run_slurm.sh ]; then
        echo 'you are missing something..'
        exit 1
    fi
    geo='y'
fi

# default answer/ check input files
if [[ -z $chg ]] || [[ $chg =~ 'y' ]]; then
    chg='y'
fi

if [[ -z $dos ]] || [[ $dos =~ 'y' ]]; then
    if [[ $chg != 'y' ]] && [[ ! -s CHGCAR ]]; then
        echo 'you need CHGCAR..'
        exit 2
    fi
    dos='y'
fi

if ( [[ $geo == 'y' ]] && [[ $chg == 'y' ]] && [[ $dos == 'y' ]] ) || ( [[ $geo == 'y' ]] && [[ $chg == 'y' ]] && [[ $dos != 'y' ]] ) || ( [[ $geo != 'y' ]] && [[ $chg == 'y' ]] && [[ $dos == 'y' ]] ) || ( [[ $geo != 'y' ]] && [[ $chg == 'y' ]] && [[ $dos != 'y' ]] ) || ( [[ $geo != 'y' ]] && [[ $chg != 'y' ]] && [[ $dos == 'y' ]] ); then
    mkdir geo
else
    echo 'calculation sequence is wrong..'
    exit 3
fi

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
if [[ $chg == 'y' ]]; then
    mkdir chg
    cp INCAR INCAR_chg
    echo '<INCAR_chg>'
    modify INCAR_chg NSW
    modify INCAR_chg IBRION
    modify INCAR_chg LCHARG
    modify INCAR_chg LAECHG .TRUE.
    modify INCAR_chg LORBIT
fi

if [[ $dos == 'y' ]]; then
    mkdir dos
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

#geo, chg, dos
if [[ $chg != 'y' ]] && [[ ! -d chg ]]; then
    echo 'please prepare chg directory..'
    exit 4
fi

#prepare run files
if [[ ${here} == 'burning' ]]; then
    if [[ -n $(grep beef run_slurm.sh) ]]; then
        sed -n '16,18p' run_slurm.sh > temp1
    else
        sed -n '16p' run_slurm.sh > temp1
    fi
elif [[ ${here} == 'kisti' ]] || [[ ${here} == 'nurion' ]]; then
    if [[ -n $(grep beef run_slurm.sh) ]]; then
        sed -n '11,13p' run_slurm.sh > temp1
    else
        sed -n '11p' run_slurm.sh > temp1
    fi
else
    echo 'where am i..? please modify [chgdos.sh] code'
    exit 5
fi

echo $geo
echo $chg
echo $dos

if [[ $geo != 'y' ]]; then
    cp * geo
    if [[ ${here} == 'burning' ]]; then
        sed -i '16,$d' run_slurm.sh
    elif [[ ${here} == 'kisti' ]] || [[ ${here} == 'nurion' ]]; then
        sed -i '11,$d' run_slurm.sh
fi

if [[ $chg == 'y' ]]; then
    echo '
cp * geo
cp CONTCAR POSCAR
mv INCAR_chg INCAR' >> run_slurm.sh
    cat run_slurm.sh temp1 >> temp2
    mv temp2 run_slurm.sh
    echo 'cp * chg' >> run_slurm.sh
fi

if [[ $dos == 'y' ]]; then
    if ! [[ -e double_k ]]; then
        cp KPOINTS double_k
        echo '#please double k-points' >> double_k
    fi
    
    if [[ -n $(grep ISMEAR INCAR_dos | grep 5) ]]; then
        sed -i '3c\Gamma-only' double_k
    fi
    
    echo '
cp * chg
cp CONTCAR POSCAR
mv double_k KPOINTS
mv INCAR_dos INCAR' >> run_slurm.sh
    cat run_slurm.sh temp1 >> temp2
    mv temp2 run_slurm.sh
    echo 'cp * dos' >> run_slurm.sh
fi

echo 'mkdir x
mv * x
mv x/*/ .
rm x' >> run_slurm.sh
#rm temp1

if [[ $dos == 'y' ]]; then
    more double_k
    read -p 'do you want to double this? [y/n] (default: n) ' double
    if [[ $double =~ 'y' ]]; then
        vi double_k
    fi
fi

read -p 'do you want to submit the job now? [y/n] (default:y) ' submit
if ! [[ $submit =~ 'n' ]]; then
    sh ~/bin/orange/sub.sh
fi