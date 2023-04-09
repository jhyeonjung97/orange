#!/home/bjpark/anaconda3/bin/python

from ase import Atoms 
from ase.io import read,write
from glob import glob
import sys,os,subprocess,math,time
sys.path.insert(0,'/home/bjpark/anaconda3/lib/python3.8/site-packages')
import numpy as np
#from param_set import param_set
#from density_at_z import density_at_z

#--------------------------------------------------------------#
# this script optimizes geometry at a given desired potential  #
# the desired potential is entered below                       #
#                                                              #
# INCAR should contain parameters using implicit solvent       #
# namely, LSOL = .TRUE. and others as desired.                 #
#--------------------------------------------------------------#

# ------------------------------------- #
# enter desired potential here          #
pot_des = 0.80 # Volts vs SHE           #   
# ------------------------------------- #
def get_ntasks(out):
    if ',' in out:
        if '(' in out:
            nodes = [int(i.split('(')[0]) for i in out.split(',')]
        else:
            nodes = [int(i) for i in out.split(',')]
    else:
        if '(' in out:
            nodes = [int(out.split('(')[0])]
        else:
            nodes = [int(out)]
    nodes.sort()
    return nodes[0]

def vasp():
    os.system('module load compiler/2022.1.0 mkl/2022.1.0 mpi/2021.6.0')
    os.system('export OMP_NUM_THREADS=1')

    #ntasks=get_ntasks(subprocess.check_output('echo $SLURM_TASKS_PER_NODE',shell=True))
    #nnodes=int(subprocess.check_output("scontrol show hostnames $SLURM_JOB_NODELIST|wc -l",shell=True))
    #ncpu = ntasks*nnodes

    lines = ['import os\n','exitcode = os.system(\'mpiexec.hydra -genv I_MPI_DEBUG 5 -np $SLURM_NTASKS /TGM/Apps/VASP/VASP_BIN/6.3.2/vasp.6.3.2.vaspsol.vtst.std.x\')\n']
    f = open('run_vasp.py','w')
    f.writelines(lines)
    f.close()

    os.system('export VASP_SCRIPT=./run_vasp.py')
    os.system('export VASP_PP_PATH=$HOME/vasp/potpaw_PBE')
    os.system('mpiexec.hydra -genv I_MPI_DEBUG 5 -np $SLURM_NTASKS /TGM/Apps/VASP/VASP_BIN/6.3.2/vasp.6.3.2.vaspsol.vtst.std.x')

def get_pot():
    #determines the potential of the slab given the number of electrons
    ## FERMI
    out_byte = subprocess.check_output("grep fermi OUTCAR",shell=True)            #_byte
    out2_byte = subprocess.check_output("grep FERMI_SHIFT ./opt.log",shell=True)  #_byte
    
    out = out_byte.decode('utf-8')
    out2 = out2_byte.decode('utf-8')

    sys.stdout.flush()
    fermi = float(out.split(' : ')[1].split('XC')[0])
    shift = float(out2.split(' = ')[-1])
    sys.stdout.flush()
    print('Fermi energy not zero: %.3f eV'%fermi)
    sys.stdout.flush()

    # pot_she = -1*(fermi+4.43)
    pot_she = -1*(fermi+shift+4.43)
    sys.stdout.flush()
    print('Potential vs SHE: %.2f'%pot_she)
    sys.stdout.flush()
    return pot_she

def set_pot(pot_des):
    # determine NELECT required to have potential=pot_des

    os.system('param_set LCHARG .FALSE.')
    os.system('param_set LWAVE .FALSE.')
    os.system('param_set LVTOT .FALSE.')
    os.system('param_set NSW 0')

    # run the single point to generate LOCPOT file
    # if this is running after the initial optimization is complete, no need to
    # re-run from scratch
    if glob('LOCPOT') == [] or glob('OUTCAR') == []:
        # no NELECT optimization has been done yet
        sys.stdout.flush()
        print('Running the first single point to generate LOCPOT')
        print(os.getcwd())
        sys.stdout.flush()
        vasp()
        old_pots = []
        old_pots.append(get_pot())
    else:
        # see if the existing OUTCAR contains a completed ionic step
        try:
            read('OUTCAR').get_potential_energy()
            sys.stdout.flush()
            print('Starting NELECT optimization from previous LOCPOT')
            print(os.getcwd())
            sys.stdout.flush()
            old_pots = []
            old_pots.append(get_pot())
        except:
            # incomplete calculation in outcar, run an ionic step
            sys.stdout.flush()
            print('Running the first single point to generate LOCPOT')
            print(os.getcwd())
            sys.stdout.flush()
            vasp()
            old_pots = []
            old_pots.append(get_pot())

    # no need to run further optimization if you're already at the desired potential
    if abs(old_pots[-1]-pot_des) < 0.02:
        return

    #initial number of electrons:
    line = os.popen('grep -n "NELECT" OUTCAR | tail -n 1','r')
    nelect_start = float(line.readline().split()[3])
    line.close()
    old_n = [nelect_start]

    # then do another single point with slightly more electrons to get 
    # an initial gradient for newton's method
    
    nelect_start_1 = nelect_start+0.1
    nelect_start_1_str = str(nelect_start_1)

    os.system(command='param_set NELECT '+ nelect_start_1_str)
    vasp()
    old_pots.append(get_pot())

    #start the optimization, initialize vars
    current_pot = old_pots[-1]
    nelect = nelect_start+0.1
    old_n.append(nelect)
    sys.stdout.flush()
    print(old_pots)
    sys.stdout.flush()
    file = open("nelect_output.txt","w")
    iter = 0
    while abs(old_pots[-1]-pot_des) > 0.02:
        iter += 1
        # Newton's method to optimize NELECT
        grad = (old_pots[-2]-old_pots[-1])/(old_n[-2]-old_n[-1])
        y = old_pots[-1]-pot_des
        diff = abs(y)**2/(y*grad)
        
        # don't take too big of a step ..
        # can happen if two subsequent steps are too close together
        if diff > 2.5:
            diff = 0.1
        elif diff < -2.5:
            diff = -0.1

        # update nelect
        nelect = nelect - diff
        
        #check if nelect is nan
        if math.isnan(nelect):
            print('Error: Check NELECT (nan)')
            sys.exit()

        # check guess from newton's method
        old_n.append(nelect)

        nelect_str = str(nelect)
        os.system(command='param_set NELECT '+ nelect_str)
        vasp()
        old_pots.append(get_pot())
        file = open("nelect_output.txt","a")
        lines = ["\nNELECT = %f\n"%nelect,'Pot vs SHE: %.5f V\n'%old_pots[-1], 'Error: %.2f V\n'%abs(old_pots[-1]-pot_des), "iter = %i\n"%iter]
        file.writelines(lines)
        file.close()
    os.system('param_set LWAVE .TRUE.')

#in case job is being restarted ...
if os.path.isfile('CONTCAR') and os.stat('CONTCAR').st_size != 0:
    os.system('cp CONTCAR POSCAR')
else:
    sys.stdout.flush()
    print('New job! No CONTCAR found')
    sys.stdout.flush()

converged = 0
i = 0
while converged == 0:
    i += 1
    # first, assuming the given geometry is already optimized, set the desired potential
    set_pot(pot_des)
    os.system('param_set NSW 300')
    os.system('param_set LWAVE .TRUE.')
    os.system('param_set POTIM 0.1')

    # rho = density_at_z(z_des)
    # if rho > 0:
        # param_set('NC_K_IONS',rho)
    # else:
        # print 'negative charge density at desired z!'
        # param_set('NC_K_IONS',1e-8)

    # geometry optimize
    sys.stdout.flush()
    print('Running geometry optimization, iter = ' + str(i))
    print(os.getcwd())
    sys.stdout.flush()
    vasp()
    os.system('cp CONTCAR POSCAR')

    # write the current energy and max forces
    atoms = read('POSCAR')
    unconst = [atom.index for atom in atoms if atom.index not in atoms.constraints[0].index]
    atoms = read('OUTCAR')
    sys.stdout.flush()
    print('Current energy: %.5f'%atoms.get_potential_energy())
    sys.stdout.flush()
    flist = []
    for ind in unconst:
        f=atoms.get_forces()[ind]
        flist.append((f[0]**2+f[1]**2+f[2]**2)**0.5)
    flist.sort()
    sys.stdout.flush()
    print('Max force: %.2f ev/A'%flist[-1])
    sys.stdout.flush()
    atoms.write('iter'+str(i)+'.traj')

    # check if the optimization is done
    # job is finished when the line below is printed to opt.log
    # reached required accuracy - stopping structural energy minimisation
    # also check to make sure the potential is still within tolerance 
    # of the desired potential
    log = open('opt.log','r')
    lines = log.readlines()
    log.close()
    for line in lines:
        if 'reached required accuracy' in line:
            if abs(get_pot() - pot_des) < 0.02:
                converged = 1
            else:
                sys.stdout.flush()
                print('Potential not yet converged: %.2f'%get_pot())
                sys.stdout.flush()
            break

# now do a single point calculation to get RHOB and RHOION
# param_set('LRHOB','.TRUE.')
os.system('param_set LRHOION .TRUE.')
os.system('param_set OUTIT .FALSE.')
os.system('param_set NSW 0')
os.system('cp CONTCAR POSCAR')
vasp()

