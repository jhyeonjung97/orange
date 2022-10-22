import sys
import os

a = sys.argv[1]
b = sys.argv[2]

if a == 'p' or a == 'pos':
    a = 'POSCAR'
if a == 'c' or a == 'con':
    a = 'CONTCAR'

if not b:
    os.system("cp %s ~/port/" % a)
else:
    os.system("cp %s ~/port/%s" % (a,b))
