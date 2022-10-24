import sys
import os

len=len(sys.argv)

if len==2:
    file=input("which files?: ")
    if file=='p' or file=='pos':
        file='POSCAR'
    elif file=='c' or file=='con':
        file='CONTCAR'
    surv=sys.argv[1]
    scp='scp'
elif len==3 and sys.argv[1]=='-r':
    file=input("which directories?: ")
    surv=sys.argv[2]
    scp='scp -r'
else:
    print("would you like something to drink?")

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


