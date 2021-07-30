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

# absolute path of the directory for 3 images NEB calculation
$dirimg3 = $dir;
# ---------------------------------------------------------------------

# begin
print "\n\n";
print "==================================================\n";
print "Set up input files for NEB calculations (3 images)\n";
print "==================================================\n\n";
print "Current working directory\n","$dir","\n\n";
print "Absolute path for 1 image NEB result\n","$dirimg1","\n\n";
print "Absolute path for 3 images NEB calculation\n","$dirimg3","\n\n";

# copy CONTCARs and OUTCARs from $dirimg1 to $dirimg3
print "\n\n--------------------------------------------------------------------------------copy input files\n\n\n";
mkdir "$dirimg3/00";
mkdir "$dirimg3/01";
mkdir "$dirimg3/02";
mkdir "$dirimg3/03";
mkdir "$dirimg3/04";

`cp $dirimg1/00/POSCAR  $dirimg3/00/POSCAR`;
`cp $dirimg1/01/CONTCAR $dirimg3/02/POSCAR`;
`cp $dirimg1/02/POSCAR  $dirimg3/04/POSCAR`;

`cp $dirimg1/00/OUTCAR $dirimg3/00/OUTCAR`;
`cp $dirimg1/02/OUTCAR $dirimg3/04/OUTCAR`;

`cp $dirimg1/INCAR             $dirimg3`;
`cp $dirimg1/INCAR_org         $dirimg3`;
`cp $dirimg1/KPOINTS           $dirimg3`;
`cp $dirimg1/jobscript_vasp.sh $dirimg3`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";
#$outlist = `ls -l "$dirimg3"/[0-9][0-9]`; print $outlist,"\n";


# interpolate structures
print "\n\n---------------------------------------------------------------------create 2 interpolated image\n\n\n";

# image 1
print "\n\nCreate image 1\n\n\n";
chdir "$dirimg3/01";
`$ENV{"VTST"}/nebmake.pl $dirimg3/00/POSCAR $dirimg3/02/POSCAR 1`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";

`cp $dirimg3/01/01/POSCAR $dirimg3/01/POSCAR`;
`rm -rf $dirimg3/01/00`;
`rm -rf $dirimg3/01/01`;
`rm -rf $dirimg3/01/02`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";

# image 3
print "\n\nCreate image 3\n\n\n";
chdir "$dirimg3/03";
`$ENV{"VTST"}/nebmake.pl $dirimg3/02/POSCAR $dirimg3/04/POSCAR 1`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";

`cp $dirimg3/03/01/POSCAR $dirimg3/03/POSCAR`;
`rm -rf $dirimg3/03/00`;
`rm -rf $dirimg3/03/01`;
`rm -rf $dirimg3/03/02`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";


# for spin-restricted calculation
print "\n\n----------------------------------------------set up input files for spin-restricted calculation\n\n\n";
chdir "$dirimg3";
mkdir "$dirimg3/00/spin-res";
mkdir "$dirimg3/01/spin-res";
mkdir "$dirimg3/02/spin-res";
mkdir "$dirimg3/03/spin-res";
mkdir "$dirimg3/04/spin-res";
`cp $dirimg3/01/POSCAR $dirimg3/01/spin-res/POSCAR`;
`cp $dirimg3/02/POSCAR $dirimg3/02/spin-res/POSCAR`;
`cp $dirimg3/03/POSCAR $dirimg3/03/spin-res/POSCAR`;

`cp $dirimg3/INCAR_org $dirimg3/01/spin-res/INCAR`;
`cp $dirimg3/INCAR_org $dirimg3/02/spin-res/INCAR`;
`cp $dirimg3/INCAR_org $dirimg3/03/spin-res/INCAR`;

`cp $dirimg3/KPOINTS $dirimg3/01/spin-res/KPOINTS`;
`cp $dirimg3/KPOINTS $dirimg3/02/spin-res/KPOINTS`;
`cp $dirimg3/KPOINTS $dirimg3/03/spin-res/KPOINTS`;

`cp $dirimg3/jobscript_vasp.sh $dirimg3/01/spin-res`;
`cp $dirimg3/jobscript_vasp.sh $dirimg3/02/spin-res`;
`cp $dirimg3/jobscript_vasp.sh $dirimg3/03/spin-res`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";

$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]/spin-res`; print $outlist,"\n";







