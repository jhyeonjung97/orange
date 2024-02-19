import sys
import os

len = len(sys.argv)

r=''
p=''

if '-r' in sys.argv:
    if len==2:
        surv='burning'
    else:
        surv=sys.argv[2]
    file=input("which directories?: ")
else:
    if len==1:
        surv='burning'
    else:
        surv=sys.argv[1]
    file=input("which files?: ")
    if file=='p' or file=='pos':
        file='POSCAR'
    elif file=='c' or file=='con':
        file='CONTCAR'
    elif file=='port':
        file='~/bin/port/*'

scp='scp'

if surv=='burning':
    scp=scp+' -P 54329'
    surv='hyeonjung@burning.postech.ac.kr:'
elif surv=='mac':
    surv='hailey@172.30.1.14:~/Desktop/'
elif surv=='x2431':
    surv='x2431a10@nurion.ksc.re.kr:'
elif surv=='x2347':
    surv='x2347a10@nurion.ksc.re.kr:'
elif surv=='cori':
    surv='jiuy97@cori.nersc.gov:'
elif surv=='nersc':
    surv='jiuy97@perlmutter.nersc.gov:'
    
path=input("to where?: ")

os.system(f"scp {p} {r} {file} {surv}{path}")


