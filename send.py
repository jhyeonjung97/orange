import sys
import os

a = input("which files?: ")
if a == 'p':
    a = 'POSCAR'
elif a == 'c':
    a = 'CONTCAR'
elif a == 'dir':
    a = '-r ' + input("which directories?: ")
b = input("to where?: ")
os.system("scp %s hailey@134.79.69.172:~/Desktop/%s" % (a, b))
