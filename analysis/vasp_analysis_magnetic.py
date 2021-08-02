"""
Python scripts for analyzing magnetic properties

Author: Se Hun Joo
The latest update: 2021-08-02
"""

import sys
import os
from collections import defaultdict 

from pymatgen.io.vasp.outputs import Vasprun, Outcar


def vasprun_from_cwd():
    """
    Read the vasprun.xml file from the current working directory.
    """
    vasprun = Vasprun(
        "./vasprun.xml",
        ionic_step_skip = None,
        ionic_step_offset = 0,
        parse_dos = False,
        parse_eigen = False,
        parse_projected_eigen = False,
        parse_potcar_file = False,
        occu_tol = 1e-08,
        exception_on_bad_xml = True
    )

    return vasprun


def outcar_from_cwd():
    """
    Read the OURCAR file from the current working directory.
    """
    outcar = Outcar("./OUTCAR")
    
    return outcar


def analysis_magnetic():
    """
    Analze magnetization at the final ionic step
    """ 
    natoms = len(vasprun.atomic_symbols)
    elements = list(dict.fromkeys(vasprun.atomic_symbols))
    
    
    def mag_atom():
        """
        Print magnetization of each atom.
        """
        print("Magnetization (atom):\n")
        print(
            "index",
            "element",
            "s",
            "p",
            "d",
            "tot"
        )
        for idx in range(len(outcar.magnetization)):
            print(
                idx+1,
                vasprun.atomic_symbols[idx],
                f"{outcar.magnetization[idx]['s']:6.3f}",
                f"{outcar.magnetization[idx]['p']:6.3f}",
                f"{outcar.magnetization[idx]['d']:6.3f}",
                f"{outcar.magnetization[idx]['tot']:6.3f}",
                sep = "\t"
            )
        print("\n")
   

    def mag_element():
        """
        Print average magnetization of each element. 
        """
        mag_elements = defaultdict(list)
        mag_elements_avg = {}
        
        for idx in range(len(outcar.magnetization)):
            mag_elements[vasprun.atomic_symbols[idx]].append(abs(outcar.magnetization[idx]["tot"]))
        for element in mag_elements.keys():
            mag_elements_avg[element] = f'{sum(mag_elements[element])/len(mag_elements[element]):.3f}'
        
        print("Magnetization (element):\n")
        print(mag_elements_avg)
        print("\n")
  

    def mag_total():
        """
        Print total magnetization
        """
        mag_tot = 0
        
        for idx in range(len(outcar.magnetization)):
            mag_tot += outcar.magnetization[idx]["tot"]
        
        print("Magnetization (total):\n")
        print(f"{mag_tot:.3f}", "\t", "# sum of atomic magnetization") # sum of magnetization of each ion
        print(f"{outcar.total_mag:.3f}") # printed in energy electronic step "number of electron\s+\S+\s+magnetization\s+(" r"\S+)"
        print("\n")
   

    def mag_write_file():
        """
        Write the 'vasp_assign_spin.pl' file in the current working directory.
        """
        
        lines = []
        
        print("Write the 'vasp_assign_spin.pl' file in the current working directory.")
        lines.append("#!perl\n")
        lines.append("use strict;")
        lines.append("use Getopt::Long;")
        lines.append("use MaterialsScript qw(:all);\n")
        lines.append('my $xsddoc = $Documents{"CONTCAR".".xsd"};')
        lines.append("my $atoms = $xsddoc->UnitCell->Atoms;\n")
        for idx in range(len(outcar.magnetization)):
            lines.append(f"$atoms->Item({idx})->Spin={outcar.magnetization[idx]['tot']:6.3f};")    
        with open("vasp_assign_spin.pl", "wt") as f:
            f.write("\n".join(lines))
        print("\n")
   

    """ Sub main"""
    
    mag_atom()
    mag_element()
    mag_total()
    mag_write_file()
    

"""Main"""

outcar = outcar_from_cwd()
vasprun = vasprun_from_cwd()
analysis_magnetic()
