# mkdir freq
# cp INCAR KPOINTS POTCAR CONTCAR run_slurm.sh mpiexe.sh freq/

# # if [[ -f OUTCAR ]]; then
# #     npar_tag=$(grep NPAR OUTCAR)
# #     read -ra npar_arr <<< $npar_tag
# #     npar=${npar_arr[3]}
# #     echo "got NPAR = $npar from OUTCAR"
# # elif [[ -f INCAR ]]; then
# #     npar_tag=$(grep NPAR OUTCAR)
# #     read -ra npar_arr <<< $npar_tag
# #     npar=${npar_arr[3]}
# #     echo "got NPAR = $npar from INCAR"
# # else
# #     read - 'NPAR?' $npar 
# # fi

# cd freq
# mv CONTCAR POSCAR

sh ~/bin/orange/modify.sh INCAR IBRION 5
sh ~/bin/orange/modify.sh INCAR POTIM 0.015
sh ~/bin/orange/modify.sh INCAR NPAR

sh ~/bin/orange/modify.sh INCAR LWAVE .FALSE.
sh ~/bin/orange/modify.sh INCAR LCHARG .FALSE.
sh ~/bin/orange/modify.sh INCAR LAECHG
sh ~/bin/orange/modify.sh INCAR LORBIT

# sed -i -e 's/; sh ~\/bin\/orange\/ediff.sh//' run_slurm.sh
# sed -i -e '/conti/d' run_slurm.sh

# if [[ ${here} =~ 'burning' ]]; then
#     npar=$(grep ntasks-per-node run_slurm.sh | rev | cut -c -2 | rev)
# elif [[ ${here} == 'kisti' ]]; then
#     npar=64
# else
#     echo 'where am i ..? you might need to modify vivi.sh file'
# fi

# sh ~/bin/orange/modify.sh INCAR NPAR $npar
# sh ~/bin/orange/sub.sh