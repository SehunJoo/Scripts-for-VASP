#!/usr/bin/env python
# coding: utf-8

# In[1]:


from glob import glob
import subprocess
import shutil
import time
import csv
import os

from pymatgen.io.vasp.inputs import Incar, Kpoints, Potcar, Poscar
from pymatgen.symmetry.analyzer import SpacegroupAnalyzer
from pymatgen.io.vasp.outputs import Vasprun
from matplotlib import pyplot as plt
from dotenv import load_dotenv
from pymatgen import Structure
from pymatgen import MPRester
import pandas as pd
import numpy as np

from pymatgen.electronic_structure.plotter import DosPlotter
from pymatgen.electronic_structure.plotter import BSPlotter
from pymatgen.io.vasp import BSVasprun


"""
================================================================================
Check the convergence of the calculation

.. pymatgen.io.vasp.outputs module
    .. Vasprun class
================================================================================
"""

try:
    vasprun_result = Vasprun('vasprun.xml')
except:
    print('Error to read vasprun.xml. There will be a problem with the previous calculation.')
    print("\n")

if not vasprun_result.converged:
    print('run not converged')
    if not vasprun_result.converged_electronic:
        print("Failed to electronic step convergence")
    else:
        print("electronic step convergence has been reached")

    if not vasprun_result.converged_ionic:
        print("Failed to ionic step convergence")
    else:
        print("ionic step convergence has been reached")

    print("\n")



# Make plot directory
if not os.path.exists("plots"):
    os.mkdir("plots")

"""
================================================================================
Plot electronic density of states using the python matplotlib

.. pymatgen.io.vasp package
    .. pymatgen.io.vasp.outputs module
        .. Vasprun class
        
.. pymatgen.electronic_structure package
    .. pymatgen.electronic_structure.dos module
        .. CompleteDos class
    .. pymatgen.electronic_structure.plotter module
        .. DosPlotter class
================================================================================
"""

# Plot electronic density of states
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

from pymatgen.io.vasp import Vasprun
from pymatgen.electronic_structure.plotter import DosPlotter


v = Vasprun('./vasprun.xml', parse_dos = True)  # Parse the dos.
cdos = v.complete_dos                           # Create a complete dos object which incorporates the total dos and all projected dos from a vasprun.xml file.
element_dos = cdos.get_element_dos()            # Get element projected Dos.


plotter = DosPlotter()
plotter.add_dos_dict(element_dos)
plotter.save_plot('plots/dos.pdf', img_format='pdf', xlim= None, ylim = None)
# plotter.save_plot('spin-up_dos.pdf', img_format='pdf', xlim= None, ylim = [0,None])   # up-spin dos


"""
================================================================================
Plot electronic band structure using the python matplotlib

.. pymatgen.io.vasp package
    .. pymatgen.io.vasp.outputs module
        .. BSVasprun class
        
.. pymatgen.electronic_structure package
    .. pymatgen.electronic_structure.plotter module
        .. BSPlotter class
================================================================================
"""

from pymatgen.io.vasp import BSVasprun
from pymatgen.electronic_structure.plotter import BSPlotter


v = BSVasprun('./vasprun.xml', parse_projected_eigen = True)
bs = v.get_band_structure(kpoints_filename = './KPOINTS', line_mode = True)
bsplot = BSPlotter(bs)

bsplot.get_plot(zero_to_efermi = True, ylim = [-2,2]).savefig('plots/band.pdf')


"""
================================================================================
Plot electronic band structure and density of states using the python matplotlib

.. pymatgen.io.vasp package
    .. pymatgen.io.vasp.outputs module
        .. BSVasprun class
        
.. pymatgen.electronic_structure package
    .. pymatgen.electronic_structure.plotter module
        .. BSPlotter class
================================================================================
"""

"""
.. matplotlib.pyplot.gca / Get the current Axes instance on the current figure matching the given keyword args, or create one.
.. matplotlib.axes.Axes.set_title / Set a title for the axes.
.. matplotlib.axes.Axes.get_xlim / Return the x-axis view limits.
.. matplotlib.axes.Axes.hlines / Plot horizontal lines at each y from xmin to xmax.
.. matplotlib.axes.Axes.plot / Plot y versus x as lines and/or markers.
.. matplotlib.axes.Axes.legend / Place a legend on the axes.
"""

# add some features
ax = plt.gca()                                  
ax.set_title("Bandstructure", fontsize = 40)                        # Set a title for the axes
xlim = ax.get_xlim()
ax.hlines(0, xlim[0], xlim[1], linestyles="dashed", color="black")  # Plot y = 0 from x = xmin to xmax

# add legend
ax.plot((), (), "b-", label = "spin up")        # Plot () and () using blue solid line
ax.plot((), (), "r--", label = "spin-down")     # Plot () and () using red dashed line
ax.legend(fontsize = 16, loc = "upper left")    #

bs.as_dict()['vbm']
bs.as_dict()['cbm']

vbm = bs.as_dict()['vbm']['energy']
efermi = bs.as_dict()['efermi']
cbm = bs.as_dict()['cbm']['energy']


if bs.get_band_gap()['direct'] == False:
    bgtype = 'Indirect'
else:
    bgtype = 'Direct'

bg = bs.get_band_gap()['energy']
bgpath = bs.get_band_gap()['transition']

"""
Plot Brillouin Zone
"""
bsplot.plot_brillouin()
plt.savefig('plots/brillouin_fig.pdf')



"""
Another plot type
bsplot_proj = BSPlotterProjected(bs)
bsplot_proj.get_elt_projected_plots(vbm_cbm_marker = True)
# bsplot_proj.get_projected_plots_dots({"Ti":["s","p","d"], "O":["s", "p"]}, ylim = [-5,5], vbm_cbm_marker = True)
"""


"""
# getting raw data for specific bands & kpts
from pymatgen import Spin
data = bsplot.bs_plot_data()
ibands = 9
spin = str(Spin.up)
for xpath, epath in zip(data['distances'], data['energy']):
    print(20 * "-")
    for x, bands in zip(xpath, epath[spin][ibands]):
        print("%8.4f %8.4f" % (x,bands))
"""

"""
Plot DOS & Band
"""

from pymatgen.electronic_structure.plotter import BSDOSPlotter

bsdosplot = BSDOSPlotter(
        bs_projection = "elements",
        dos_projection = "elements",
        vb_energy_range = 10,
        cb_energy_range = 10,
        egrid_interval = 2,
        font = 'DejaVu Sans'
        )

bsdosplot.get_plot(bs, cdos).savefig('plots/band_dos.pdf')


"""
Summary
"""

with open('plots/summary', 'w') as f:
    if (type(vbm) and type(cbm)) == float:
        f.writelines("VBM = %4.3f eV,  E_fermi = %4.3f eV, CBM = %4.3f eV\n" % (vbm, efermi, cbm))
        print("VBM = %4.3f eV,  E_fermi = %4.3f eV, CBM = %4.3f eV\n" % (vbm, efermi, cbm))
        f.writelines("%s gap = %4.3f eV (transition = %s)" % (bgtype, bg, bgpath))
        print("%s gap = %4.3f eV (transition = %s)" % (bgtype, bg, bgpath))
    elif (vbm and cbm) == None:
        f.writelines("VBM = None,  E_fermi = %4.3f eV, CBM = None\n" % (efermi))
        print("VBM = None,  E_fermi = %4.3f eV, CBM = None\n" % (efermi))
        f.writelines("%s gap = %4.3f eV (transition = %s)" % (bgtype, bg, bgpath))
        print("%s gap = %4.3f eV (transition = %s)" % (bgtype, bg, bgpath))


# close all open figures
#     ax.clf()
#     ax.close()
plt.clf()
plt.close('all')
