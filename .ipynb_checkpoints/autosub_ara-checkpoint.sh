#!/bin/bash

echo -e "\033[1;31;03m——————————————————————"
echo -e "\033[93;03m         start "
echo " check the MAGMOM, U-value, NPAR ..."
echo -e "\033[1;31;03m—————————————————————— "
echo ""

SET=$(seq -f "%02g" $1 $2)
while :
do
        echo -e "\033[1;31;03m—————————————————————— \033[93;03m"
        read -p " $1 부터 $2 까지 폴더 생성 ? " fy
		read -p " "
        echo -e "\033[1;31;03m—————————————————————— \033[93;03m"
        echo " "
        if [ "$fy" == "y" ]; then
			for i in $SET
            do
                mkdir $i
                cp INCAR KPOINTS POTCAR run_slurm.sh $i
                cd $i
				python ~/bin/xcell.py 
                mv ../$d $i.vasp POSCAR
                echo -e "\033[1;31m mv POSCAR_$i into $i/POSCAR \033[0m"
                cd ..
            done
            break
		fi
done
