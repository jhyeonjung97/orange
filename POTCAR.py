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

W  = '\033[1;30m'  # black_foreground_bold
R  = '\033[31m' # red
G  = '\033[32m' # green
O  = '\033[33m' # orange
B  = '\033[34m' # blue
P  = '\033[35m' # purple
A  = '\033[38;5;7m' # gray
S  = '\033[1;5;243m' #gray
V  = '\033[0;37m' # white
T  = '\033[38;5;250m' # black_foreground
Q  = '\033[38;5;243m' # gray


try :
		f=open('.POSCAR_for_POTCAR', mode='rt', encoding='utf-8')
except :
		f=open('POSCAR', mode='rt', encoding='utf-8')
finally:
		stline=str(f.readline())
		#print(type(stline))
		list_line=stline.split()
		#print(type(list_line))
		print(S)
		print("POSCAR : ", list_line)
		#print(stline.strip().replace(" ",","))


# In[11]:



def path_pot(fol_name):
		return '/home/aracho/new_POTCARs/potpaw_PBE/'+ fol_name +'/POTCAR'

a=[]

pot_elements={'Zr':'Zr_sv', 'Ce':'Ce_h', 'Nb':'Nb_sv', 'Y':'Y_sv', 'Re':'Re_pv', 'Ru':'Ru_pv', 'Li':'Li_sv'}

# 'Ru' : 'Ru_pv'

for i in list_line:
		try :
			value = '{}'.format(i)
			pot=path_pot(pot_elements[value]).split()
			a.extend(pot)
		except :
			pot=path_pot(i).split()
			a.extend(pot)

#chpot = 'mv POTCAR p'
#os.system(chpot)

mkpot = 'cat' + ' '+ ' '.join(a) + ' > POTCAR'
#print(mkpot)

os.system(mkpot)


pbe2_list=[]
pbe3_list=[]
pbe4_list=[]

pbe=subprocess.check_output("grep PBE POTCAR", shell=True, encoding='utf8')
pbe_list=pbe.split("\n")


atom_num=int((len(pbe_list)-1)/2)

for i in range(atom_num):
		pbe2_list.append(pbe_list[2*i])


for i in range(int(len(pbe2_list))):
		pbe3_list.append(pbe2_list[i].split(" "))
		pbe4_list.append(pbe3_list[i][3])


print("POTCAR : ", pbe4_list)





print(Q)
#os.system(PBE)

print()
print(B+"VASP53_ver POTCAR generated—"+W)

print()
print()


# In[ ]:



