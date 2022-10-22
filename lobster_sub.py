import os

cur_dir = os.getcwd()
if os.path.isfile('WAVECAR'):
    filesize = os.path.getsize('WAVECAR')
    if filesize == 0:
        print("WAVECAR is empty")
    else:
        os.system('lobster')
else:
    print("There is no WAVECAR")
