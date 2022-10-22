import subprocess
import sys

b = input("to where?: ")
subprocess.call('scp -r  ~/bin/port/* jiuy97@cori.nersc.gov:'+b+' \n rm -r ~/bin/port/* \n scp ~/bin/port/* jiuy97@cori.nersc.gov:'+b+' \n rm ~/bin/port/*', shell=True)
