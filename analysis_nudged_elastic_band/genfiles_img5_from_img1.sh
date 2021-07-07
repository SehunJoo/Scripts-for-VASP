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

# absolute path of the directory for 1 image NEB result
$dirimg1 = "/scratch/x1786a08/1_LCO/5_LCO_2x1x1_LNCFO/4_v4/2_2Liv-3_mag7_tet_neb/neb_img1";

# absolute path of the directory for 5 images NEB calculation
$dirimg5 = $dir;
# ---------------------------------------------------------------------

# begin
print "\n\n";
print "==================================================\n";
print "Set up input files for NEB calculations (5 images)\n";
print "==================================================\n\n";
print "Current working directory\n","$dir","\n\n";
print "Absolute path for 1 image NEB result\n","$dirimg1","\n\n";
print "Absolute path for 5 images NEB calculation\n","$dirimg5","\n\n";

# copy CONTCARs and OUTCARs from $dirimg1 to $dirimg5
print "\n\n--------------------------------------------------------------------------------copy input files\n\n\n";
mkdir "$dirimg5/00";
mkdir "$dirimg5/01";
mkdir "$dirimg5/02";
mkdir "$dirimg5/03";
mkdir "$dirimg5/04";
mkdir "$dirimg5/05";
mkdir "$dirimg5/06";

`cp $dirimg1/00/POSCAR  $dirimg5/00/POSCAR`;
`cp $dirimg1/01/CONTCAR $dirimg5/03/POSCAR`;
`cp $dirimg1/02/POSCAR  $dirimg5/06/POSCAR`;

`cp $dirimg1/00/OUTCAR $dirimg5/00/OUTCAR`;
`cp $dirimg1/02/OUTCAR $dirimg5/06/OUTCAR`;

`cp $dirimg1/INCAR             $dirimg5`;
`cp $dirimg1/INCAR_org         $dirimg5`;
`cp $dirimg1/KPOINTS           $dirimg5`;
`cp $dirimg1/jobscript_vasp.sh $dirimg5`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";
#$outlist = `ls -l "$dirimg5"/[0-9][0-9]`; print $outlist,"\n";


# interpolate structures
print "\n\n---------------------------------------------------------------------create 2 interpolated image\n\n\n";

# images 1 2
print "\n\nCreate images 1 2\n\n\n";
chdir "$dirimg5/01";
`$ENV{"VTST"}/nebmake.pl $dirimg5/00/POSCAR $dirimg5/03/POSCAR 2`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";

`cp $dirimg5/01/01/POSCAR $dirimg5/01/POSCAR`;
`cp $dirimg5/01/02/POSCAR $dirimg5/02/POSCAR`;
`rm -rf $dirimg5/01/00`;
`rm -rf $dirimg5/01/01`;
`rm -rf $dirimg5/01/02`;
`rm -rf $dirimg5/01/03`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";

# images 4 5
print "\n\nCreate images 4 5\n\n\n";
chdir "$dirimg5/04";
`$ENV{"VTST"}/nebmake.pl $dirimg5/03/POSCAR $dirimg5/06/POSCAR 2`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";

`cp $dirimg5/04/01/POSCAR $dirimg5/04/POSCAR`;
`cp $dirimg5/04/02/POSCAR $dirimg5/05/POSCAR`;
`rm -rf $dirimg5/04/00`;
`rm -rf $dirimg5/04/01`;
`rm -rf $dirimg5/04/02`;
`rm -rf $dirimg5/04/03`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";

