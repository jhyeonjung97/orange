mv 1_3d/ 1_3dA
mv 2_4d/ 3_4dA
mv 3_5d/ 5_5dA 
mv 4_/ 2_3dB
mkdir 4_4dB
mkdir 6_5dB

mv 5_5dA/c7.vasp 6_5dB/c1.vasp
mv 5_5dA/c8.vasp 6_5dB/c2.vasp
mv 5_5dA/c9.vasp 6_5dB/c3.vasp
mv 2_3dB/d7.vasp 6_5dB/c4.vasp
mv 2_3dB/d8.vasp 6_5dB/c5.vasp
mv 2_3dB/d9.vasp 6_5dB/c6.vasp

mv 3_4dA/b7.vasp 4_4dB/b1.vasp
mv 3_4dA/b8.vasp 4_4dB/b2.vasp
mv 3_4dA/b9.vasp 4_4dB/b3.vasp
mv 2_3dB/d4.vasp 4_4dB/b4.vasp
mv 2_3dB/d5.vasp 4_4dB/b5.vasp
mv 2_3dB/d6.vasp 4_4dB/b6.vasp

mv 1_3dA/a7.vasp 2_3dB/a1.vasp
mv 1_3dA/a8.vasp 2_3dB/a2.vasp
mv 1_3dA/a9.vasp 2_3dB/a3.vasp
mv 2_3dB/d1.vasp 2_3dB/a4.vasp
mv 2_3dB/d2.vasp 2_3dB/a5.vasp
mv 2_3dB/d3.vasp 2_3dB/a6.vasp

remove 1_3dA/INCAR 1_3dA/KPOINTS 1_3dA/lobsterin 1_3dA/run_slurm.sh
