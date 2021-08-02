"""
Python scripts for summarizing results

Author: Se Hun Joo
The latest update: 2021-08-02
"""

import os
import sys
import pandas as pd
import warnings
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
        parse_eigen = True,
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


def vasp_convergence():
    """
    Convergence
    """
    print("Convergence"); print("-"*60)
    
    if not vasprun.converged:
        msg = "This is an unconverged VASP run.\n"
        msg += "Electronic convergence reached: %s.\n" % vasprun.converged_electronic
        msg += "Ionic convergence reached: %s." % vasprun.converged_ionic
        warnings.warn(msg)
        print();
    else:
        print("Electronic convergence reached:", vasprun.converged_electronic)
        print("Ionic convergence reached:", vasprun.converged_ionic, "\n")
        print("Number of electronic steps:", len(vasprun.ionic_steps[-1]["electronic_steps"]))
        print("Mumber of ionic steps:",len(vasprun.ionic_steps))
    
    #yn = input("Ionic minimization is note completed within 1 step. Wn Will you run it again? [y/n]")
    print("\n\n")

    
def vasp_inputs_structure():
    """
    VASP inputs - structure (POSCAR)
    
    :param
    """
    vasprun_dict = vasprun.as_dict()
    print("VASP inputs - structure (POSCAR)"); print("-"*60)
    print(
        "Cell Fromula",
        "Natoms",
        sep = "\t"
    )
    print(
        vasprun_dict.get("pretty_formula"),
        len(vasprun.atomic_symbols),
        sep = "\t"
    )
    print("\n\n")

    
def vasp_inputs_parameters():
    """
    VASP inputs - parameters (INCAR, KPOINTS)
    
    :param
    """
    print("VASP inputs - parameters (INCAR, KPOINTS)"); print("-"*60)
    
    incar = vasprun.incar
    parameters = vasprun.parameters
    kpoints = vasprun.kpoints
    actual_kpoints = vasprun.actual_kpoints
    actual_kpoints_weights = vasprun.actual_kpoints_weights
    
    #print(incar.get_string(pretty=True))
    #print(parameters.get_string(pretty=True))
    #print(kpoints)
    #print("actual_kpoints:\n",pd.DataFrame(actual_kpoints),"\n")
    #print("actual_kpoints_weights:\n",pd.DataFrame(actual_kpoints_weights),"\n")
    
    print(
        "Run Type",
        "Functional",
        "ENMAX",
        "ISPIN",
        "IVDW",
        "LDAU",
        "LDAUU",
        "NUPDOWN",
        "EDIFF",
        "EDIFFG",
        "ISIF",
        "ISYM",
        "IDIPOL",
        "KPOINTS",
        sep = "\t"
    )
    print(
        "DFT(GGA+U)" if vasprun.is_hubbard else "DFT(GGA)",
        parameters.get("GGA"),
        parameters.get("ENMAX"),
        parameters.get("ISPIN"),
        parameters.get("IVDW"),
        parameters.get("LDAU"),
        vasprun.hubbards,
        parameters.get("NUPDOWN"),
        parameters.get("EDIFF"),
        parameters.get("EDIFFG"),
        parameters.get("ISIF"),
        parameters.get("ISYM"),
        parameters.get("IDIPOL"),
        f'{kpoints.as_dict().get("generation_style")} {kpoints.as_dict().get("kpoints")}',
        sep = "\t"
    )
    print("\n\n")

    
def vasp_outputs_thermodynamic():
    """
    Thermodynamic properties
    
    :param
    """
    print("VASP outputs - thermodynamic properties:"); print("-"*60)
    for ionicstep_cnt in range(vasprun.nionic_steps):
        vasprun.ionic_steps[ionicstep_cnt]
        if ionicstep_cnt == 0:
            print("ionic_steps","\t",
                  "e_fr_energy","\t",
                  "e_wo_entrp","\t",
                  "e_0_energy")
        print(ionicstep_cnt+1,"\t",
              vasprun.ionic_steps[ionicstep_cnt]['e_fr_energy'],"\t",
             vasprun.ionic_steps[ionicstep_cnt]['e_wo_entrp'], "\t",
             vasprun.ionic_steps[ionicstep_cnt]['e_0_energy'])
    
    print("\n\n")

    
def vasp_outputs_structure():
    """
    Structural properties
    
    :param
    """
    print("VASP outputs - structural properties:"); print("-"*60)
    
    final_istep = vasprun.ionic_steps[-1]
    final_structure = final_istep['structure']
    
    print(
        "a(Å)",
        "b(Å)",
        "c(Å)",
        "α(°)",
        "β(°)",
        "γ(°)",
        "Volume(Å^3)",
        "Density(g/cc)",
        sep = "\t"
    )
    print(
        final_structure.lattice.a,
        final_structure.lattice.b,
        final_structure.lattice.c,
        final_structure.lattice.alpha,
        final_structure.lattice.beta,
        final_structure.lattice.gamma,
        final_structure.lattice.volume,
        float(final_structure.density),
        sep = "\t"
    )
    print("\n","outputs the final structure to a cif file", sep = '')
    final_structure.to(fmt = "cif", filename = "CONTCAR.cif")
    print("\n\n")

    
def vasp_outputs_electronic():
    """
    Electronic properties
    
    :param
    """ 
    print("VASP outputs - electronic properties:"); print("-"*60)
    print(
        "Band Gap (eV)",
        "CBM (eV)",
        "VBM (eV)",
        "Direct/Indirect",
        "Fermi Energy (eV)",
        sep = "\t"
    )
    print(
        vasprun.eigenvalue_band_properties[0],
        vasprun.eigenvalue_band_properties[1],
        vasprun.eigenvalue_band_properties[2],
        "Direct" if vasprun.eigenvalue_band_properties[3] else "Indirect",
        vasprun.efermi,
        sep = "\t"
    )
    print("\n\n")

    
def vasp_outputs_magnetic():
    """
    Magnetic properties
    
    :param
    """
    print("VASP outputs - magentic properties:"); print("-"*60)
    

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
            "tot",
            sep = "\t"
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
        
        return mag_elements_avg


    def mag_total():
        """
        Print total magnetization
        """       
        mag_tot = f"{outcar.total_mag:.3f}"
        
        return mag_tot
    
    
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
    
    
    """Sub main"""
    
    print(
        "Total Magnetization",
        "Average Magnetization",
        sep = "\t"
    )
    print(
        mag_total(),
        mag_element(),
        sep = "\t"
    )
    print("\n")
    
    mag_atom()
    mag_write_file()
    

"""Main"""

vasprun = vasprun_from_cwd()
outcar = outcar_from_cwd()
vasp_convergence()
vasp_inputs_structure()
vasp_inputs_parameters()
vasp_outputs_thermodynamic()
vasp_outputs_structure()
vasp_outputs_electronic()
vasp_outputs_magnetic()