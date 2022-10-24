import sys
import os

if sys.argv[1]=='-r':
    surv=sys.argv[2]
    scp='scp -r'
    file=input("which directories?: ")
else:
    surv=sys.argv[1]
    scp='scp'
    file=input("which files?: ")
    if file=='p' or file=='pos':
        file='POSCAR'
    elif file=='c' or file=='con':
        file='CONTCAR'

if not surv:
    surv='hyeonjung@burning.postech.ac.kr:'
elif surv=='mac':
    surv='hailey@134.79.69.172:~/Desktop/'
elif surv=='kisti':
    surv='x2431a10@nurion.ksc.re.kr:'
elif surv=='cori':
    surv='jiuy97@cori.nersc.gov:'
elif surv=='nersc':
    surv='jiuy97@perlmutter-p1.nersc.gov:'

path=input("from where?: ")

os.system("%s %s%s%s ." % (scp, surv, path, file))


