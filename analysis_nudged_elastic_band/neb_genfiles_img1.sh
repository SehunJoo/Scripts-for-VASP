#!/usr/bin/env perl
use Cwd;

# =====================================================================
# Author : Se Hun Joo
# Date: 2020-03-03
# =====================================================================

# ---------------------------------------------------------------------
# user input 
# absolute path of the current working directory
$dir = cwd;

# absolute path of the directory for initial state
$diris = "/scratch/x1786a08/1_LCO/2_LCO_2x1x1/2_2Liv_3/cellopt3_k2x2x4_C2_D3_mag2_done";

# absolute path of the directory for final state
$dirfs = "/scratch/x1786a08/1_LCO/2_LCO_2x1x1/2_2Liv_3_mag2_tet/geomopt2_k2x2x4_C1_D3_done"; 
# ---------------------------------------------------------------------


# begin
print "\n\n";
print "==================================================\n";
print "Set up input files for NEB calculations (1 image) \n";
print "==================================================\n\n";
print "Current working directory\n","$dir","\n\n";
print "Absolute path for for initial state\n","$diris","\n\n";
print "Absolute path for for final state\n","$dirfs","\n\n";



# copy CONTCARs and OUTCARs
print "\n\n--------------------------------------------------------------------------------copy input files\n\n\n";

`cp $diris/CONTCAR $dir/POSCAR_IS`;
`cp $dirfs/CONTCAR $dir/POSCAR_FS`;
`cp $diris/OUTCAR $dir/OUTCAR_IS`;
`cp $dirfs/OUTCAR $dir/OUTCAR_FS`;

`cp $diris/INCAR $dir/INCAR_org`;
`cp $diris/KPOINTS $dir/KPOINTS`;
`cp $diris/jobscript_vasp.sh $dir/jobscript_vasp.sh`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";



# interpolate structures
print "\n\n---------------------------------------------------------------------create 1 interpolated image\n\n\n";
`$ENV{"VTST"}/nebmake.pl $dir/POSCAR_IS $dir/POSCAR_FS 1`;
`cp $dir/OUTCAR_IS $dir/00/OUTCAR`;
`cp $dir/OUTCAR_FS $dir/02/OUTCAR`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";


# for spin-restricted calculation
print "\n\n----------------------------------------------set up input files for spin-restricted calculation\n\n\n";
mkdir "$dir/00/spin-res";
mkdir "$dir/01/spin-res";
mkdir "$dir/02/spin-res";
`cp $dir/01/POSCAR         $dir/01/spin-res/POSCAR`;
`cp $dir/INCAR_org         $dir/01/spin-res/INCAR`;
`cp $dir/KPOINTS           $dir/01/spin-res/KPOINTS`;
`cp $dir/jobscript_vasp.sh $dir/01/spin-res`;

$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]/spin-res`; print $outlist,"\n";
