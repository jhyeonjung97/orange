from pymatgen.io.lobster import Lobsterin
import os

os.system("sed -i -e '/#ISMEAR/c\ISMEAR = 1' INCAR")
lobsterin = Lobsterin.standard_calculations_from_vasp_files("POSCAR","INCAR","POTCAR",option='standard')

lobsterin.write_INCAR(incar_input="INCAR",incar_output="INCAR.lobster",poscar_input="POSCAR",isym=-1,further_settings={"IBRION":-1})
file=open('./INCAR.lobster','r')
print(file.read())

os.system("mv INCAR INCAR.original")
os.system("mv INCAR.lobster INCAR")

lob_str = """COHPstartEnergy -50.0
COHPendEnergy 50.0

userecommendedbasisfunctions
saveProjectionToFile

cohpBetween atom # atom # orbitalWise

writeBasisFunctions
"""

with open('lobsterin', 'w') as f:
    f.write(lob_str)

#lobsterin.write_lobsterin(path="lobsterin")
file=open('./lobsterin','r')
print(file.read())
