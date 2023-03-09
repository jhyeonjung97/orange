import numpy as np
from sys import argv

data = [] 
number = argv[1]
filename = argv[2]

for i in range(1,number+1):
    chg = np.loadtxt("ACF%s.dat" % i, dtype=str)[:,4]
    data.append(chg)

np.savetxt("%s.csv" % filename, np.transpose(data), delimiter =", ", fmt ='% s')