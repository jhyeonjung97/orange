echo "POSCAR? INCAR? run_slurm.sh?"

read -p "directory from: $a"
read -p "directory to: $b"
read -p "POSCARs starts with: $p"
read -p "job name: $n"

for i in {$a+1..$b}
do
    cp -r $a $i
done

for i in {$a..$b}
do
    cp $p$i.vasp $i/POSCAR
    cd $i
    xc
    magmom
    potcar
    sed -i -e '/job-name/c\#SBATCH --job-name="$n$i"' run_slurm.sh
    sbatch run_slurm.sh
    cd ..
done