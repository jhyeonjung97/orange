import subprocess
import sys

a = int(sys.argv[1])
b = int(sys.argv[2])
c = input()
for i in range(a,b+1):
    d = str(i)
    subprocess.call('cd '+d+' \n '+c+' \n cd ..', shell=True)
