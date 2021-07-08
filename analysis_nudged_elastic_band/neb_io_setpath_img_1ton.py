"""
Increase the number of NEB images
from result files of previous NEB calculation.

Author: Se Hun Joo
"""


import os
import shutil

print('\n')
print('='*90)
print('Increase the number of NEB images')
print('='*90)
print('\n')

print('Select the case:')
print('1. from 1 image to n images, n is odd')

# get the input parameters
dirname_img1 = input('Absolute path of the directory for neb calculation with 1 image\n>>')
if os.path.exists(dirname_img1):
    if os.path.isdir(dirname_img1):
        print(*os.listdir(dirname_img1), sep='\n');
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
