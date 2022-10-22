from subprocess import *
import os
import subprocess

a = input()
subprocess.call('scp -r hailey@134.79.69.172:~/Desktop/'+a+' .', shell=True)
