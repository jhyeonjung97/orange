import subprocess
import sys

a = sys.argv[1]
subprocess.call('sed -i \'/'+a+'/d\' INCAR', shell=True)
