#!/bin/bash

select=0
xc_tag=0
mag_tag=0
ldau_tag=0
anti_tag=0
submit=''
filename=''
jobname=''
sed -i -e '/RECOMMEND/s/.FALSE.  /.TRUE.  /' ~/.vaspkit

while getopts ":xmauptyni:o:s" opt; do
  case $opt in
    x)
      xc_tag=1
      ;;
    m)
      mag_tag=1
      ;;
    a)
      anti_tag=1
      ;;
    u)
      ldau_tag=1
      ;;
    p)
      sed -i -e '/RECOMMEND/s/.TRUE.  /.FALSE.  /' ~/.vaspkit
      ;;
    t)
      submit='multi'
      ;;
    y)
      submit='yes'
      ;;
    n)
      submit='no'
      ;;
    i)
      filename="$OPTARG"
      ;;
    o)
      jobname="$OPTARG"
      ;;
    s)
      select=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Shift the options out, so $1, $2, etc. are the non-option arguments
shift "$((OPTIND-1))"    
        
# error cases
if [[ $1 == '-qe' ]] || [[ $1 == 'qe' ]]; then
    sh ~/bin/orange/autosub-qe.sh ${@:2}
    exit 1
elif [[ ! -e "INCAR" ]]; then
    echo "don't forget INCAR.."
    exit 2
elif [[ ! -e "KPOINTS" ]]; then
    echo "don't forget KPOINTS.."
    exit 2
elif [[ ! -e "run_slurm.sh" ]]; then
    echo "don't forget run_slurm.sh.."
    if [[ $here =~ 'burning' ]]; then
        sh ~/bin/orange/run-burning.sh
    elif [[ $here == 'kisti' ]]; then
        sh ~/bin/orange/run-kisti.sh
    fi
    exit 3
elif [[ -z $1 ]]; then
    echo 'usage: autosub (number)'
fi

multiple_input="${@}"
if [[ $select == 1 ]]; then
    SET=${@}
elif [[ -z $2 ]]; then
    SET=$(seq 1 $1)
else
    SET=$(seq $1 $2)
fi

if [[ -n $(echo $PWD | grep 'PCL') ]]; then
    sed -i -e '/RECOMMEND/s/.TRUE.  /.FALSE.  /' ~/.vaspkit
    if [[ -n $(echo $PWD | grep 'implicit') ]]; then
        sed -i -e '/RECOMMEND/s/.FALSE.  /.TRUE.  /' ~/.vaspkit
    fi
fi

# if [[ -n $(grep lobster run_slurm.sh) ]]; then
#     cp run_slurm.sh lobster.sh
#     if [[ ${here} =~ 'burning' ]]; then
#         sed -i -e '15,$d' lobster.sh
#     elif [[ ${here} == 'kisti' ]]; then
#         sed -i -e '10,$d' lobster.sh
#     fi
# fi

if [[ -z $filename ]]; then
    read -p 'name of the file? ' filename
fi
if [[ -z $jobname ]]; then
    $jobname='test'
    echo 'please make job names'
fi

for i in $SET
do
    if [[ ! -d $i ]]; then
        mkdir $i
    fi
    cp INCAR KPOINTS run_slurm.sh $i
    if [[ -s mpiexe.sh ]]; then
        cp mpiexe.sh $i
    fi
    if [[ -s lobsterin ]]; then
        cp lobsterin $i
    fi
    if [[ -n $(grep mmff run_slurm.sh) ]]; then
        sed -i -e "s/mmff.sh a.vasp/mmff.sh $filename.vasp/" run_slurm.sh
        cp $filename$i.vasp $i
    else
        cp $filename$i.vasp $i/POSCAR
    fi
    cd $i
    if [[ $xc_tag == 0 ]]; then
        python ~/bin/pyband/xcell.py #XCELL
        mv out*.vasp POSCAR #XCELL
        echo 'xcell.py is applied'
    fi
    if [[ $anti_tag == 1 ]]; then
        python3 ~/bin/orange/magmom-anti.py
    elif [[ $mag_tag == 1 ]] || [[ -n $(grep '#ISPIN' INCAR) ]] || [[ -n $(grep ISPIN INCAR | grep 1) ]]; then
        sed -i '/MAGMOM/d' INCAR
    else
        python3 ~/bin/orange/magmom.py
    fi
    if [[ $ldau_tag == 0 ]]; then
        python3 ~/bin/orange/ldauu.py
    fi
    sh ~/bin/orange/vasp5.sh
    if [[ -s POTCAR ]]; then
        rm POTCAR
    fi
    vaspkit -task 103 | grep --colour POTCAR  
    if [[ ! -s POTCAR ]]; then
        python3 ~/bin/shoulder/potcar_ara.py
    fi
    # if [[ -n $(grep cep-sol.sh run_slurm.sh) ]]; then
    #     sh ~/bin/orange/nelect.sh
    # fi
    if grep -q '^[^#]*IBRION\s*=\s*0' INCAR && \
       grep -q '^[^#]*POTIM\s*=\s*1' INCAR && \
       grep -q '^[^#]*TEBEG\s*=\s*300' INCAR && \
       grep -q '^[^#]*SMASS\s*=\s*0' INCAR && \
       grep -q '^[^#]*MDALGO\s*=\s*2' INCAR
    then
        echo "Note: This is MD calculation"
        sh ~/bin/orange/pomass.sh
    fi
    if [[ -n $(grep POTIM INCAR | grep 0.015) ]]; then
        sed -i "/NPAR/d" INCAR
    else
        sed -i "/NPAR/c\NPAR   = ${npar}" INCAR
    fi
    sed -i -e "/#SBATCH --job-name/c\#SBATCH --job-name=\"$jobname$i\"" *.sh
    sed -i -e "/#SBATCH -J/c\#SBATCH -J \"$jobname$i\"" *.sh
    sed -i -e "/#PBS -N/c\#PBS -N $jobname$i" *.sh
    cd ..
done

grep --colour NETCHG INCAR
if [[ -z $submit ]]; then
    read -p 'do you want to submit jobs? [y/n] (default: n) ' submit
fi
if [[ $submit =~ 'y' ]]; then
    for i in $SET
    do
        cd $i
        sh ~/bin/orange/sub.sh
        cd ..
    done
elif [[ $submit =~ 'm' ]] && [[ -n $multiple_input ]]; then
    sh ~/bin/orange/multiple.sh $multiple_input
    echo "multiple $multiple_input"
    sh ~/bin/orange/jobname.sh $jobname
    echo "multiple $multiple_input; name $jobname"
fi

sed -i -e '/RECOMMEND/s/.FALSE.  /.TRUE.  /' ~/.vaspkit