import sys
import os

len=len(sys.argv)

if len==2:
    file=input("which files?: ")
    if file=='p' or file=='pos':
        file='POSCAR'
    elif file=='c' or file=='con':
        file='CONTCAR'
    elif file=='port':
        file='~/bin/port/*'
    surv=sys.argv[1]
elif len==3 and sys.argv[1]=='-r':
    file='-r '+input("which directories?: ")
    surv=sys.argv[2]
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
    
    
path=input("to where?: ")

os.system("scp %s %s%s" % (file, surv, path))
# -


