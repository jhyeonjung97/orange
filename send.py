import sys
import os

if sys.argv[1]=='-r':
    surv=sys.argv[2]
    scp='scp -r'
    file='-r '+input("which directories?: ")
else:
    surv=sys.argv[1]
    scp='scp'
    file=input("which files?: ")
    if file=='p' or file=='pos':
        file='POSCAR'
    elif file=='c' or file=='con':
        file='CONTCAR'
    elif file=='port':
        file='~/bin/port/*'

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
    
path=input("to where?: ")

os.system("scp %s %s%s" % (file, surv, path))


