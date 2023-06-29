#!/bin/bash

#INPUT
alias i='cp ~/input_files/INCAR .'
alias ii='sed -i -e "s/  / /g" INCAR'
alias k='cp ~/input_files/KPOINTS .'
alias potcar='sh ~/bin/orange/potcar.sh'
alias PBE='grep TITEL POTCAR'
alias acf='sh ~/bin/orange/acf.sh'

alias pos2cif='~/bin/vtstscripts/pos2cif.pl POSCAR'
alias con2cif='~/bin/vtstscripts/pos2cif.pl CONTCAR'
alias out2xyz='sh ~/bin/orange/out2xyz.sh'
alias rmport='~/bin/rm_mv ~/port/; mkdir ~/port'
alias lsport='ls ~/port/'
alias rmtemp='~/bin/rm_mv ~/bin/temp.sh'
alias vitemp='vi ~/bin/temp.sh'
alias multiple='sh ~/bin/orange/multiple.sh'

alias nebsend='sh ~/bin/orange/nebsend.sh'
alias vaspsend='sh ~/bin/orange/vaspsend.sh'
alias sendvasp='sh ~/bin/orange/vaspsend.sh'
alias vaspport='cp *.vasp ~/port/'
alias portvasp='cp *.vasp ~/port/'
alias portsend='sh ~/bin/orange/send.sh -r ~/port'
alias xc='python ~/bin/pyband/xcell.py
mv out*.vasp POSCAR'
alias vasp='sh ~/bin/orange/vasp5.sh'
alias vasp524='sed -i -e '1h' -e '5G' POSCAR'
alias chdo='sh ~/bin/orange/chgdos.sh'
alias run1='sh ~/bin/orange/run1.sh'
alias cell='sh ~/bin/orange/cell.sh'
alias relax='sh ~/bin/orange/relax.sh'
alias n='grep nat incar.in
grep nat *.data | head -n 1
grep ntyp incar.in
grep ntyp *.data | head -n 1'
alias wf='sh ~/bin/orange/wf.sh'

#OUTPUT
alias e='grep E0 stdout*'
alias ee='grep E0 stdout* | tail -n 3'
alias te='sh ~/bin/orange/te.sh'
alias fermi='grep E-fermi OUTCAR | tail -n 1'
alias kpoint='grep subdivisionlength vasprun.xml -A 1'
alias time='tail OUTCAR -n 50 | grep sec'
alias nebef='
date +"%Y-%m-%d %H:%M:%S" >> nebef.txt
~/bin/vtstscripts/nebef.pl
~/bin/vtstscripts/nebef.pl >> nebef.txt'
alias z='python3 ~/bin/orange/z-position.py'
alias energy='ag -t -g "i,e" OUTCAR > '

#RUN_SLURM.SH
alias sub='sh ~/bin/orange/sub.sh'
alias resub='sh ~/bin/orange/resub.sh'
alias autosub='sh ~/bin/orange/autosub.sh'
alias puresub='sbatch run_slurm.sh'
alias name='sh ~/bin/orange/jobname.sh'

alias conti='sh ~/bin/orange/conti.sh'

#INCAR
alias chg='python3 ~/bin/orange/change.py'
alias del='python3 ~/bin/orange/delete.py'
alias close='python3 ~/bin/orange/close.py'
alias magmom='python3 ~/bin/orange/magmom.py'
alias ldau='python3 ~/bin/orange/ldau.py'
alias ma='grep MAGMOM */INCAR'
alias neb='sh ~/bin/orange/neb.sh'
alias modify='sh ~/bin/orange/modify.sh'

#LOBSTERIN
alias lobin='python3 ~/bin/shoulder/lobin.py'
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
alias pack='sh ~/bin/orange/pack.sh'
alias seed='sh ~/bin/orange/seed.sh'
alias xyz2hex='python3 ~/bin/orange/xyz2hex.py'
alias xyz2vasp='python2 ~/bin/vtstscripts/xyz2vasp.py'

#Vibrational frequency
alias vivi='sh ~/bin/orange/vivi.sh'
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
alias aloha='python3 ~/bin/orange/cohp.py > icohp.txt
python3 ~/bin/orange/cohp.py'
alias mahalo='python3 ~/bin/orange/cobi.py > icobi.txt
python3 ~/bin/orange/cobi.py'
alias charge='python3 ~/bin/orange/charge.py'
alias bader='chgsum.pl AECCAR0 AECCAR2
bader CHGCAR -ref CHGCAR_sum'
alias ichg='sh ~/bin/orange/modify0.sh chg
cp INCAR INCAR.original
mv INCAR_chg INCAR'
alias idos='sh ~/bin/orange/modify0.sh dos
cp INCAR INCAR.original
mv INCAR_dos INCAR'
alias incar='sh ~/bin/orange/modify.sh INCAR'
alias incarc='sh ~/bin/orange/modify.sh INCAR_chg'
alias incard='sh ~/bin/orange/modify.sh INCAR_dos'

