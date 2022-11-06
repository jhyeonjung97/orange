#!/bin/bash

#usage: chdo [geo?] [chg?] [dos?] [submit?]

geo=$1; chg=$2; dos=$3; submit=$4

if [[ -z $1 ]]; then
    read -p '1) Geometry optimization? [y/n] (default: y) ' geo
fi
if [[ -z $2 ]]; then
    read -p '2) CHG? [y/n] (default: y) ' chg
fi
if [[ -z $3 ]]; then
    read -p '3) DOS? [y/n] (default: y) ' dos
fi
if [[ -z $4 ]]; then
    read -p '4) SUBMIT? [y/n] (default: y) ' submit
fi

# default answer/ check input files
if [[ -z $geo ]] || [[ $geo =~ 'y' ]] || [[ $geo =~ '1' ]]; then
    if [ ! -e INCAR ] || [ ! -e KPOINTS ] || [ ! -e POTCAR ] || [ ! -e POSCAR ] || [ ! -e run_slurm.sh ]; then
        echo 'you are missing something..'
        exit 1
    fi
    geo='y'
fi

# default answer/ check input files
if [[ -z $chg ]] || [[ $chg =~ 'y' ]] || [[ $chg =~ '1' ]]; then
    chg='y'
fi

if [[ -z $dos ]] || [[ $dos =~ 'y' ]] || [[ $dos =~ '1' ]]; then
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

#prepare input files
if [[ $chg == 'y' ]]; then
    mkdir chg
    sh ~/bin/orange/modify0.sh chg
fi

if [[ $dos == 'y' ]]; then
    mkdir dos
    sh ~/bin/orange/modify0.sh dos
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

if [[ $geo != 'y' ]]; then
    cp * geo
    if [[ ${here} == 'burning' ]]; then
        sed -i '16,$d' run_slurm.sh
    elif [[ ${here} == 'kisti' ]] || [[ ${here} == 'nurion' ]]; then
        sed -i '11,$d' run_slurm.sh
    fi
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
    if [[ ! -e double_k ]]; then
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

rm temp1

if [[ $dos == 'y' ]]; then
    more double_k
    read -p 'do you want to double this? [y/n] (default: n) ' double
    if [[ $double =~ 'y' ]]; then
        vi double_k
    fi
fi

if [[ ! $submit =~ 'n' ]] && [[ $submit != '0' ]]; then
    sh ~/bin/orange/sub.sh
fi