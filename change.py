import subprocess
import sys

a = sys.argv[1]
b = sys.argv[2]
subprocess.call('sed -i -e \'/'+a+'/c\\'+a+' = '+b+'\' INCAR', shell=True)
subprocess.call('grep '+a+' INCAR', shell=True)
