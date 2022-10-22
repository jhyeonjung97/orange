import subprocess
import sys

a = sys.argv[1]
subprocess.call('sed -i -e \'/'+a+'/c\#'+a+'\' INCAR', shell=True)
