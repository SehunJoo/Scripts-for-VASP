"""
Generate input files for neb calculations
from result files of structural optimization for intial and final states.

Prerequisite:
- Install VTST(Transition State Tools for VASP, https://theory.cm.utexas.edu/vtsttools/)
- Set environmental variable VTST

Author: Se Hun Joo
"""


import os
import shutil

print('\n')
print('='*90)
print('Generate input files for neb calculations')
print('from result files of structural optimization for initial and final states.')
print('='*90)
print('\n')


# get the input parameters
dirname_is = input('Absolute path of the directory for initial state\n>>')
if os.path.exists(dirname_is):
    if os.path.isdir(dirname_is):
        print(*os.listdir(dirname_is), sep='\n');
    else:
        print(f'Error, Invalid directory path');
else:
    print(f'Error, Invalid directory path');
print()

dirname_fs = input('Absolute path of the directory for final state\n>>')
if os.path.exists(dirname_fs):
    if os.path.isdir(dirname_fs):
        print(*os.listdir(dirname_fs), sep='\n');
    else:
        print(f'Error, Invalid directory path');
else:
    print(f'Error, Invalid directory path');
print()

nimgs = input('The number of NEB images (It is recommended to use 1 image for the first step and increase later.)\n>>')
print()

dirname_wd = os.path.dirname(os.path.abspath(__file__))


# copy INCAR, KPOINTS, CONTCAR, OUTCAR, jobscript
print('-'*50, 'copy INCAR, KPOINTS, CONTCAR, and OUTCAR\n')
shutil.copy(f'{dirname_is}/INCAR', f'{dirname_wd}/INCAR_org')
shutil.copy(f'{dirname_is}/KPOINTS', f'{dirname_wd}/KPOINTS')
shutil.copy(f'{dirname_is}/jobscript_vasp.sh', f'{dirname_wd}/jobscript_vasp.sh')
shutil.copy(f'{dirname_is}/CONTCAR', f'{dirname_wd}/POSCAR_IS')
shutil.copy(f'{dirname_is}/OUTCAR', f'{dirname_wd}/OUTCAR_IS')
shutil.copy(f'{dirname_fs}/CONTCAR',f'{dirname_wd}/POSCAR_FS')
shutil.copy(f'{dirname_fs}/OUTCAR', f'{dirname_wd}/OUTCAR_FS')
print()
print(f'current working directory:\n{dirname_wd}\n\n')
print(*os.listdir(dirname_wd), sep='\n')
print()


# interpolate structures
print('-'*50, 'create {nimgs} interpolated NEB images\n')
os.system(f'$VTST/nebmake.pl {dirname_wd}/POSCAR_IS {dirname_wd}/POSCAR_FS {nimgs}')
shutil.copy(f'{dirname_wd}/OUTCAR_IS', f'{dirname_wd}/00/OUTCAR')
shutil.copy(f'{dirname_wd}/OUTCAR_FS', f'{dirname_wd}/{int(nimgs)+1:0>2}/OUTCAR')
print()
print(f'current working directory:\n{dirname_wd}\n\n')
print(*os.listdir(dirname_wd), sep='\n')
print()
for img in range(0, int(nimgs)+2):
    print(f'{img:0>2} directory')
    print(*os.listdir(f'{dirname_wd}/{img:0>2}'),sep='\n')
    print()
