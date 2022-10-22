from subprocess import *
import os
import subprocess

a = input("from where?: ")
b = input("which files?: ")
subprocess.call('scp hailey@134.79.69.172:~/Desktop/'+a+'/'+b+' .', shell=True)
