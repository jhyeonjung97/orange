alias clone='echo "git clone https://github.com/jhyeonjung97/shlouder"'

#INPUT
alias incar='cp ~/input_files/INCAR .'
alias k='cp ~/input_files/KPOINTS .'
alias potcar='python3 ~/bin/shoulder/potcar_ara.py'
alias PBE='grep TITEL POTCAR'
alias vasp='sed -i -e '1h' -e '5G' POSCAR'

alias pos2cif='~/bin/vtstscripts/pos2cif.pl POSCAR'
alias con2cif='~/bin/vtstscripts/pos2cif.pl CONTCAR'

alias input='python3 ~/bin/orange/input.py'
alias out='python3 ~/bin/orange/output.py'
alias outneb='python3 ~/bin/orange/outneb.py'
alias outsend='out
python3 ~/bin/orange/send-vasp.py'
alias nebsend='outneb
python3 ~/bin/orange/send-vasp.py'
alias nebef.pl='
date +"%Y-%m-%d %H:%M:%S" >> nebef.txt
~/bin/vtstscripts-981/nebef.pl
~/bin/vtstscripts-981/nebef.pl >> nebef.txt'
alias xc='xcell.py
mv out*.vasp POSCAR'

#RUN_SLURM.SH
alias sub='python3 ~/bin/orange/sub.py'
alias resub='rm STD* std*
sub'
alias autosub='python3 ~/bin/orange/autosub.py'
alias puresub='sbatch run_slurm.sh'
alias name='python3 ~/bin/orange/jobname.py'

alias conti='rm c
mkdir c
mv * c
cp c/POSCAR initial.vasp
cp c/INCAR c/KPOINTS c/POTCAR c/run_slurm.sh c/initial.vasp .
cp c/CONTCAR POSCAR
cp c/conti.vasp POSCAR
sub'

#OUTPUT
alias e='grep E0 stdout*'
alias ta='tail -n 6 */stdout*'
alias fermi='grep E-fermi OUTCAR'
alias kpoint='grep subdivisionlength vasprun.xml -A 1'

#INCAR
alias chg='python3 ~/bin/orange/change.py'
alias del='python3 ~/bin/orange/delete.py'
alias close='python3 ~/bin/orange/close.py'
alias magmom='python3 ~/bin/orange/magmom.py'
alias ldau='python3 ~/bin/orange/ldau.py'
alias ma='grep MAGMOM */INCAR'

#LOBSTERIN
alias lobin='python3 ~/bin/orange/lobin.py
cp ~/input_files/submit_lobster.sh .'
alias lobsub='sbatch submit_lobster.sh'
alias cohp='mkdir cohp
cd elf
cp INCAR KPOINTS POTCAR POSCAR ../cohp
cd ../cohp
python3 ~/bin/lobsterin.py
mv INCAR.lobster INCAR
sed -i -e "/LCHARG/c\LCHARG = False" INCAR
sed -i "/LELF/d" INCAR
sed -i "/LAECHG/d" INCAR'

#PACKMOL
alias pack='~/bin/packmol/packmol < mixture.inp'
alias data='~/bin/packmol/packmol < mixture.inp
python3 ~/bin/pdb2lmp.py'

#Vibrational frequency
alias vivi='mkdir freq
cp INCAR KPOINTS POTCAR CONTCAR run_slurm.sh freq/
cd freq/
mv CONTCAR POSCAR
sed -i "s/IBRION.*/IBRION = 5/g" INCAR
sed -i "s/#POTIM.*/POTIM = 0.015/g" INCAR
sed -i "s/NPAR.*/#NPAR/g" INCAR'
alias freq='grep THz OUTCAR'
alias vector='vasp2xsf.py'

#SOLVATION
alias sol='mkdir fresh
cp INCAR KPOINTS POTCAR WAVECAR CONTCAR fresh
cd fresh
mv CONTCAR POSCAR
sed -i -e "/LSOL/c\LSOL = .TRUE." INCAR
sed -i -e "/ISTART/c\ISTART = 1" INCAR
sed -i -e "/LWAVE/c\LWAVE = .FALSE." INCAR
sol3'
alias sea='mkdir seawater
cp INCAR KPOINTS POTCAR WAVECAR CONTCAR seawater
cd seawater
mv CONTCAR POSCAR
sed -i -e "/LSOL/c\LSOL = .TRUE." INCAR
sed -i -e "/ISTART/c\ISTART = 1" INCAR
sed -i -e "/LWAVE/c\LWAVE = .FALSE." INCAR
echo "EB_k = 80" >> INCAR
sol3'

#NEB
alias reneb3='mkdir save
mv * save
mkdir 01 02 03
cd save
cp 01/CONTCAR ../01/POSCAR
cp 02/CONTCAR ../02/POSCAR
cp 03/CONTCAR ../03/POSCAR
cp INCAR KPOINTS POTCAR run_slurm.sh ../
cp -r 00 04 ../
cd ../
sub'
alias reneb5='mkdir save
mv * save
mkdir 01 02 03 04 05
cd save
cp 01/CONTCAR ../01/POSCAR
cp 02/CONTCAR ../02/POSCAR
cp 03/CONTCAR ../03/POSCAR
cp 04/CONTCAR ../04/POSCAR
cp 05/CONTCAR ../05/POSCAR
cp INCAR KPOINTS POTCAR run_slurm.sh ../
cp -r 00 06 ../
cd ../
sub'

#Electronic structure
alias aloha='python3 ~/bin/orange/cohp.py'
alias bader='chgsum.pl AECCAR0 AECCAR2
bader CHGCAR -ref CHGCAR_sum'