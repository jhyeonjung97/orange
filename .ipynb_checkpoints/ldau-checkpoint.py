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
print(Gr)
print("POSCAR : ", line62)



iLDAUL={'Sc':'-1','Zn':'-1','Ti':'2','V':'2','Cr':'2','Mn':'2','Fe':'2','Co':'2','Ni':'2','Cu':'2'}
iLDAUU={'Sc':'0','Zn':'0','Ti':'7.0','V':'4.0','Cr':'4.2','Mn':'5.0','Fe':'5.3','Co':'4.52','Ni':'4.8','Cu':'4.6'}
iLDAUJ={'Sc':'0','Zn':'0','Ti':'1.0','V':'1.0','Cr':'1.0','Mn':'1.0','Fe':'1.0','Co':'1.0','Ni':'1.0','Cu':'1.0'}



#iLDAUL={'Ce':'3','Co':'2','Fe':'2','Zr':'2','Zn':'2'}
#iLDAUU={'Ce':'6.0','Co':'5.0','Fe':'5.0','Zr':'5.0','Zn':'6.4'}
#iLDAUJ={'Ce':'1.0','Co':'1.0','Fe':'1.0','Zr':'1.0','Zn':'1.0'}

# Ce is f-orbital, Co, Fe, Zr is d-orbital

LADULlist=[]
for i in line62 :
    try :
        value='{}'.format(i)
        LADULlist.append(iLDAUL[value])
    except:
        LADULlist.append('-1')


LADUUlist=[]
for i in line62 :
    try :
        value='{}'.format(i)
        LADUUlist.append(iLDAUU[value])
    except:
        LADUUlist.append('0')

LDAUJlist=[]
for i in line62 :
    try :
        value='{}'.format(i)
        LDAUJlist.append(iLDAUJ[value])
    except:
        LDAUJlist.append('0')

atomlist=[]
for i in line62:
    atomlist.append(i)

firstline= ' '.join(LADULlist)
secondline = ' '.join(LADUUlist)
thirdline=' '.join(LDAUJlist)
atomline=' '.join(atomlist)


subprocess.call('sed -i \'/LDAUL/d\' INCAR', shell=True)
subprocess.call('sed -i \'/LDAUU/d\' INCAR', shell=True)
subprocess.call('sed -i \'/LDAUJ/d\' INCAR', shell=True)
subprocess.call('sed -i \'/#####LDA+U/d\' INCAR', shell=True)
subprocess.call('sed -i \'/LDAU/d\' INCAR', shell=True)
subprocess.call('sed -i \'/LDAUTYPE/d\' INCAR', shell=True)
subprocess.call('sed -i \'/LDA+U/aLDAU     = .TRUE.\\nLDAUTYPE = 2\' INCAR', shell=True)
subprocess.call('sed -i \'/LDAUTYPE/aLDAUL    = '+firstline+' \# '+atomline+'\\nLDAUU    = '+secondline+'\\nLDAUJ    = '+thirdline+'\' INCAR', shell=True)
subprocess.call('sed -i \'s/\#LDAU/LDAU/g\' INCAR', shell=True)
subprocess.call('sed -i \'s/\#LDAUTYPE/LDAUTYPE/g\' INCAR', shell=True)


print(Ge)
subprocess.call('grep -n LDA INCAR', shell=True)
print(reset)
