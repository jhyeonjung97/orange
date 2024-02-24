#!/usr/bin/env python
from subprocess import *
import os
import subprocess
import sys
import re, glob
import shutil
import time

ldau_tag=0

# In[2]:

# [1;color : bold
reset='\033[0m'

Bl = '\033[30m' # black
R  = '\033[31m' # red
Ge = '\033[32m' # green
Y  = '\033[33m' # yellow
Bu = '\033[34m' # blue
Ma = '\033[35m' # magenta
Cy = '\033[36m' # cyan
W  = '\033[37m' # white
Gr = '\033[90m' # bright black
BR = '\033[91m' # bright Red
BG = '\033[92m' # bright Green
BY = '\033[93m' # bright yellow
BBu= '\033[94m' # bright blue
BMa= '\033[95m' # bright magenta
BCy= '\033[96m' # bright cyan
BW = '\033[97m' # bright white


# 배경색
Black = '\033[40m' # black
White = '\033[47m' # white

f=open('POSCAR', mode='rt', encoding='utf-8')
stline=str(f.readline())
list_line=stline.split()
line2=str(f.readline())
line3=str(f.readline())
line4=str(f.readline())
line5=str(f.readline())
line6=str(f.readline())
line62=line6.split()
line7=str(f.readline())
line72=line7.split()


print(Gr)
print("POSCAR : ", line62)
atomnumber=[]
if line62[0].isdigit():
    atomnumber=line62
    print(atomnumber)
elif line72[0].isdigit():
    atomnumber=line72
    print(atomnumber)
else :
    print("NOT")

if 'tetra' in os.getcwd() :
    iLDAUU={'Ti':'3.00','V':'3.25','Cr':'3.50','Mn':'3.75','Fe':'4.30','Co':'3.32','Ni':'6.45','Cu':'3.00'}
else:
    iLDAUU={}

LDAUUlist=[]
for a, i in enumerate(line62) :
    try:
        atom=iLDAUU['{}'.format(i)]
        LDAUUlist.append(atom)
        ldau_tag=1
    except:
        LDAUUlist.append('0.00')
print(LDAUUlist)

atomlist=[]
for i in line62:
    atomlist.append(i)

firstline= ' '.join(LDAUUlist)
atomline=' '.join(atomlist)

if ldau_tag == 0 :
    subprocess.call('sed -i \'/LDAU /c\LDAU = .FALSE.\' INCAR', shell=True)
else :
    subprocess.call('sed -i \'/LDAUU/d\' INCAR', shell=True)
    subprocess.call('sed -i \'/LDAUL/aLDAUU = '+firstline+' \# '+atomline+'\' INCAR', shell=True)
    print(Bu)
    subprocess.call('grep \'LDAU =\' INCAR', shell=True)
    subprocess.call('grep LDAUU INCAR', shell=True)
    print(reset)
