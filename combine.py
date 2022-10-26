#!/usr/bin/env python
from ase.io import write, read
from sys import argv, exit

l = len(argv) # two for command and name.vasp

if l < 4 or '-h' in argv:
	print("usage: combine.py file1.vasp file2.vasp ... name.vasp\n")
	exit(0)	

atom = read(argv[1])

for i in range(2, l-1):
	atom = atom + read(argv[i])

atom.write(argv[l-1])
