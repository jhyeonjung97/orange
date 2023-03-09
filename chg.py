import numpy as np
from sys import argv

data = []
filename = argv[1]

for i in range(1,10):
    chg = np.loadtxt("ACF%s.dat" % i, dtype=str)[:,4]
    data.append(chg)

np.savetxt("%s.csv" % filename, np.transpose(data), delimiter =", ", fmt ='% s')