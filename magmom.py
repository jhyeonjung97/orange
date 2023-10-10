#!/usr/bin/env python
# coding: utf-8

# In[1]:


from subprocess import *
import os
import subprocess
import sys
import re, glob
import shutil
import time


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

if 'NiFe' in os.getcwd() :
    iMAGMOM={'Sc':'2','Ti':'2','V':'2','Cr':'2','Mn':'2','Fe':'-4','Co':'2','Ni':'2','Cu':'2','Zn':'2', 
             'Y':'2','Zr':'2','Nb':'2','Mo':'2','Tc':'2','Ru':'2','Rh':'2','Pd':'2','Ag':'2','Cd':'2', 
             'La':'2','Hf':'2','Ta':'2','W':'2','Re':'2','Os':'2','Ir':'2','Pt':'2','Au':'2'}
elif 'thesis' in os.getcwd() :
    iMAGMOM={'Sc':'2','Ti':'2','V':'2','Cr':'2','Mn':'2','Fe':'-4','Co':'2','Ni':'2','Cu':'2','Zn':'2', 
             'Y':'2','Zr':'2','Nb':'2','Mo':'2','Tc':'2','Ru':'2','Rh':'2','Pd':'2','Ag':'2','Cd':'2', 
             'La':'2','Hf':'2','Ta':'2','W':'2','Re':'2','Os':'2','Ir':'2','Pt':'2','Au':'2'}
elif 'CoFeMo' in os.getcwd() :
    iMAGMOM={'Co':'2','Fe':'5','Mo':'0.6','O':'0.6','H':'0.6'}
elif 'Pt3Co' in os.getcwd() :
    iMAGMOM={'Li':'2','S':'3','Pt':'0','Fe':'4','Co':'3','Cu':'0','Ti':'0'}
elif 'LiS' in os.getcwd() :
    iMAGMOM={'Li':'1','S':'1','C':'1','N':'1','Fe':'2','Co':'2','Ni':'2'}
else :
    iMAGMOM={'Sc':'1','Ti':'2','V':'3','Cr':'6','Mn':'5','Fe':'4','Co':'3','Ni':'2','Cu':'1','Zn':'0',
             'Y':'1','Zr':'2','Nb':'5','Mo':'6','Tc':'5','Ru':'4','Rh':'3','Pd':'0','Ag':'1','Cd':'0',
             'La':'1','Hf':'2','Ta':'3','W':'4','Re':'5','Os':'4','Ir':'3','Pt':'2','Au':'1'}

MAGMOMlist=[]
for a , i in enumerate(line62) :
    try :
        atom=iMAGMOM['{}'.format(i)]
        MAGMOMlist.append(atomnumber[a]+"*"+atom)
    except:
        MAGMOMlist.append(atomnumber[a]+"*"+'0')
print(MAGMOMlist)

atomlist=[]
for i in line62:
    atomlist.append(i)

firstline= ' '.join(MAGMOMlist)
atomline=' '.join(atomlist)

subprocess.call('sed -i \'/MAGMOM/d\' INCAR', shell=True)
subprocess.call('sed -i \'/IDIPOL/aMAGMOM = '+firstline+' \# '+atomline+'\' INCAR', shell=True)



print(Ge)
subprocess.call('grep MAGMOM INCAR', shell=True)
print(reset)
