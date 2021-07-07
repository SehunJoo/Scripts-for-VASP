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

# absolute path of the directory for 3 images NEB result
$dirimg3 = "/scratch/x1786a08/1_LCO/5_LCO_2x1x1_LNCFO/4_v4/2_2Liv-3_mag7_tet_neb/neb_img1";

# absolute path of the directory for 5 images NEB calculation
$dirimg5 = $dir;
# ---------------------------------------------------------------------

# begin
print "\n\n";
print "==================================================\n";
print "Set up input files for NEB calculations (5 images)\n";
print "==================================================\n\n";
print "Current working directory\n","$dir","\n\n";
print "Absolute path for 3 images NEB result\n","$dirimg3","\n\n";
print "Absolute path for 5 images NEB calculation\n","$dirimg5","\n\n";

# copy CONTCARs and OUTCARs from $dirimg3 to $dirimg5
print "\n\n--------------------------------------------------------------------------------copy input files\n\n\n";
mkdir "$dirimg5/00";
mkdir "$dirimg5/01";
mkdir "$dirimg5/02";
mkdir "$dirimg5/03";
mkdir "$dirimg5/04";
mkdir "$dirimg5/05";
mkdir "$dirimg5/06";

`cp $dirimg3/00/POSCAR  $dirimg5/00/POSCAR`;
`cp $dirimg3/01/CONTCAR $dirimg5/01/POSCAR`;
`cp $dirimg3/02/CONTCAR $dirimg5/03/POSCAR`;
`cp $dirimg3/03/CONTCAR $dirimg5/05/POSCAR`;
`cp $dirimg3/04/POSCAR  $dirimg5/06/POSCAR`;

`cp $dirimg3/00/OUTCAR $dirimg5/00/OUTCAR`;
`cp $dirimg3/04/OUTCAR $dirimg5/06/OUTCAR`;

`cp $dirimg3/INCAR             $dirimg5`;
`cp $dirimg3/INCAR_org         $dirimg5`;
`cp $dirimg3/KPOINTS           $dirimg5`;
`cp $dirimg3/jobscript_vasp.sh $dirimg5`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";
#$outlist = `ls -l "$dirimg3"/[0-9][0-9]`; print $outlist,"\n";


# interpolate structures
print "\n\n---------------------------------------------------------------------create 2 interpolated image\n\n\n";

# image 2
print "\n\nCreate image 2\n\n\n";
chdir "$dirimg5/02";
`$ENV{"VTST"}/nebmake.pl $dirimg5/01/POSCAR $dirimg5/03/POSCAR 1`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";

`cp $dirimg5/02/01/POSCAR $dirimg5/02/POSCAR`;
`rm -rf $dirimg5/02/00`;
`rm -rf $dirimg5/02/01`;
`rm -rf $dirimg5/02/02`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";

# image 4
print "\n\nCreate image 4\n\n\n";
chdir "$dirimg5/04";
`$ENV{"VTST"}/nebmake.pl $dirimg5/03/POSCAR $dirimg5/05/POSCAR 1`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";

`cp $dirimg5/04/01/POSCAR $dirimg5/04/POSCAR`;
`rm -rf $dirimg5/04/00`;
`rm -rf $dirimg5/04/01`;
`rm -rf $dirimg5/04/02`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";
$outlist = `ls -l`; print $outlist,"\n";


# for spin-restricted calculation
print "\n\n----------------------------------------------set up input files for spin-restricted calculation\n\n\n";
chdir "$dirimg5";
mkdir "$dirimg5/00/spin-res";
mkdir "$dirimg5/01/spin-res";
mkdir "$dirimg5/02/spin-res";
mkdir "$dirimg5/03/spin-res";
mkdir "$dirimg5/04/spin-res";
mkdir "$dirimg5/05/spin-res";
mkdir "$dirimg5/06/spin-res";
`cp $dirimg5/01/POSCAR $dirimg5/01/spin-res/POSCAR`;
`cp $dirimg5/02/POSCAR $dirimg5/02/spin-res/POSCAR`;
`cp $dirimg5/03/POSCAR $dirimg5/03/spin-res/POSCAR`;
`cp $dirimg5/04/POSCAR $dirimg5/04/spin-res/POSCAR`;
`cp $dirimg5/05/POSCAR $dirimg5/05/spin-res/POSCAR`;

`cp $dirimg5/INCAR_org $dirimg5/01/spin-res/INCAR`;
`cp $dirimg5/INCAR_org $dirimg5/02/spin-res/INCAR`;
`cp $dirimg5/INCAR_org $dirimg5/03/spin-res/INCAR`;
`cp $dirimg5/INCAR_org $dirimg5/04/spin-res/INCAR`;
`cp $dirimg5/INCAR_org $dirimg5/05/spin-res/INCAR`;

`cp $dirimg5/KPOINTS $dirimg5/01/spin-res/KPOINTS`;
`cp $dirimg5/KPOINTS $dirimg5/02/spin-res/KPOINTS`;
`cp $dirimg5/KPOINTS $dirimg5/03/spin-res/KPOINTS`;
`cp $dirimg5/KPOINTS $dirimg5/04/spin-res/KPOINTS`;
`cp $dirimg5/KPOINTS $dirimg5/05/spin-res/KPOINTS`;

`cp $dirimg5/jobscript_vasp.sh $dirimg5/01/spin-res`;
`cp $dirimg5/jobscript_vasp.sh $dirimg5/02/spin-res`;
`cp $dirimg5/jobscript_vasp.sh $dirimg5/03/spin-res`;
`cp $dirimg5/jobscript_vasp.sh $dirimg5/04/spin-res`;
`cp $dirimg5/jobscript_vasp.sh $dirimg5/05/spin-res`;

$pwd = `pwd`; print "current working directory\n",$pwd,"\n";

$outlist = `ls -l`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]`; print $outlist,"\n";
$outlist = `ls -l [0-9][0-9]/spin-res`; print $outlist,"\n";







