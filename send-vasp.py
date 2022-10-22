import subprocess
import sys

a = input("to where?: ")
subprocess.call('scp *.vasp hailey@134.79.69.172:~/Desktop/'+a+'', shell=True)
