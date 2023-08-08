from subprocess import *
import os
import subprocess
import sys
import re, glob
import shutil
import time

if 'cation' in os.getcwd() :
    subprocess.call('sed -i \'/mpiexe/i\cp /TGM/Apps/VASP/vdw_kernel.bindat .\' run_slurm.sh', shell=True)
    subprocess.call('echo \'rm vdw_kernel.bindat\' >> run_slurm.sh', shell=True)
if 'Cation' in os.getcwd() :

        
        
        total+='.beef'