
==================================================================================================
# Collection of commands for analyzing NEB results
==================================================================================================


# analysis of initial structures
$VTST/nebmovie.pl; mkdir nebmovie_POSCAR; mv movie* nebmovie_POSCAR;

# analysis of final structures
$VTST/nebmovie.pl; mkdir nebmovie_CONTCAR; mv movie* nebmovie_CONTCAR;

# analysis force, energy, barrier, magnetization
$VTST/nebef.pl
$VTST/nebef.pl > nebef.dat
$VTST/nebefs.pl
$VTST/nebefs.pl > nebefs.dat
grep 'max atom' 01/OUTCAR > nebconverged.dat



==================================================================================================
IMAGE = 1
==================================================================================================
**********************(PBC 꺼져 있는지 check)****************************

 $VTST/nebmake.pl POSCAR_IS POSCAR_FS 1 

#======================================================================
# Initialization (After POSCARs, INCAR, KPOINTS, hostfile, run, ready)
#======================================================================

mkdir 01/init; cp 01/POSCAR 01/init/;

cp INCAR.init KPOINTS run hostfile 01/init/; mv 01/init/INCAR.init 01/init/INCAR;

#==================
# After completion
#==================

# backup
mkdir run1;
cp -R 00 01 02 run1;
mv stdout  vasprun.xml  run1

# prepare for the continued calculation / case 1 (normal termination)
cd 01; pwd; ll;
~/cleanvasp;
mv -f CONTCAR POSCAR; ll; cd ../; pwd;

# prepare for the continued calculation / case 2 (bad termination, need spin-restricted calculation)
cd 01/spin-res;pwd;ll;
~/cleanvasp;
rm -rf CHGCAR CONTCAR POSCAR WAVECAR;cp ../POSCAR ../CHGCAR ./;ll; cd ../..;pwd;





==================================================================================================
IMAGE = 3
==================================================================================================

export IMG1DIR=/scratch2/x1552jsh/2_LCO/6_LCO_NEB/3_TSH_v1_to_v2_D3-11/2-1_IS-FS_1_geomopt

mkdir 00 01 02 03 04;ll;

# copy
cp POSCAR_IS 00/POSCAR;
cp POSCAR_FS 04/POSCAR;
cp $IMG1DIR/01/POSCAR $IMG1DIR/01/CHGCAR $IMG1DIR/01/WAVECAR ./02

# make POSCARs (PBC 켜져있는지 check)
mkdir 01/nebmake; cd 01/nebmake; pwd; $VTST/nebmake.pl ../../00/POSCAR ../../02/POSCAR 1; ll; cp 01/POSCAR ../;cd ../;pwd;ll;cd ../;pwd;
mkdir 03/nebmake; cd 03/nebmake; pwd; $VTST/nebmake.pl ../../02/POSCAR ../../04/POSCAR 1; ll; cp 01/POSCAR ../;cd ../;pwd;ll;cd ../;pwd;

#======================================================================
# Initialization (After POSCARs, INCAR, KPOINTS, hostfile, run, ready)
#======================================================================

rm -rf 01/init; mkdir 01/init; cp 01/POSCAR 01/init/;
rm -rf 02/init; mkdir 02/init; cp 02/POSCAR 02/init/;
rm -rf 03/init; mkdir 03/init; cp 03/POSCAR 03/init/;

cp INCAR.init KPOINTS run hostfile 01/init/; mv 01/init/INCAR.init 01/init/INCAR;
cp INCAR.init KPOINTS run hostfile 02/init/; mv 02/init/INCAR.init 02/init/INCAR;
cp INCAR.init KPOINTS run hostfile 03/init/; mv 03/init/INCAR.init 03/init/INCAR;

#==================
# After completion
#==================

# backup
mkdir run2_chg;
cp -R 00 01 02 03 04 run2_chg;
mv stdout  vasprun.xml  run2_chg

# clean subdir
cd 01;pwd;ll;~/cleanvasp;mv -f CONTCAR POSCAR;ll; cd ..;pwd;
cd 02;pwd;ll;~/cleanvasp;mv -f CONTCAR POSCAR;ll; cd ..;pwd;
cd 03;pwd;ll;~/cleanvasp;mv -f CONTCAR POSCAR;ll; cd ..;pwd;

# clean subdir/init and copy updated POSCAR and CHGCAR
cd 01/init;pwd;ll;~/cleanvasp;rm -rf CHGCAR CONTCAR POSCAR WAVECAR;cp ../POSCAR ../CHGCAR ./;ll; cd ../..;pwd;
cd 01/init;pwd;ll;~/cleanvasp;rm -rf CHGCAR CONTCAR POSCAR WAVECAR;cp ../POSCAR ../CHGCAR ./;ll; cd ../..;pwd;
cd 02/init;pwd;ll;~/cleanvasp;rm -rf CHGCAR CONTCAR POSCAR WAVECAR;cp ../POSCAR ../CHGCAR ./;ll; cd ../..;pwd;
cd 03/init;pwd;ll;~/cleanvasp;rm -rf CHGCAR CONTCAR POSCAR WAVECAR;cp ../POSCAR ../CHGCAR ./;ll; cd ../..;pwd;





==================================================================================================
IMAGE = 7
==================================================================================================

export IMG3DIR=/home01/x1552jsh/x1552jsh/2_LCO/6_LCO_NEB/1_ODH_v1_to_v2/2_IS-FS_3;

mkdir 00 01 02 03 04 05 06 07 08;
# copy
cp POSCAR_IS 00/POSCAR;
cp POSCAR_FS 08/POSCAR;
cp $IMG3DIR/01/POSCAR $IMG3DIR/01/CHGCAR $IMG3DIR/01/WAVECAR ./02
cp $IMG3DIR/02/POSCAR $IMG3DIR/02/CHGCAR $IMG3DIR/02/WAVECAR ./04
cp $IMG3DIR/03/POSCAR $IMG3DIR/03/CHGCAR $IMG3DIR/03/WAVECAR ./06

# make POSCARs (PBC 켜져있는지 check)
mkdir 01/nebmake; cd 01/nebmake; pwd; $VTST/nebmake.pl ../../00/POSCAR ../../02/POSCAR 1; ll; cp 01/POSCAR ../;cd ../;pwd;ll;cd ../;pwd;
mkdir 03/nebmake; cd 03/nebmake; pwd; $VTST/nebmake.pl ../../02/POSCAR ../../04/POSCAR 1; ll; cp 01/POSCAR ../;cd ../;pwd;ll;cd ../;pwd;
mkdir 05/nebmake; cd 05/nebmake; pwd; $VTST/nebmake.pl ../../04/POSCAR ../../06/POSCAR 1; ll; cp 01/POSCAR ../;cd ../;pwd;ll;cd ../;pwd;
mkdir 07/nebmake; cd 07/nebmake; pwd; $VTST/nebmake.pl ../../06/POSCAR ../../08/POSCAR 1; ll; cp 01/POSCAR ../;cd ../;pwd;ll;cd ../;pwd;

#======================================================================
# Initialization (After POSCARs, INCAR, KPOINTS, hostfile, run, ready)
#======================================================================

rm -rf 01/init; mkdir 01/init; cp 01/POSCAR 01/init/;
rm -rf 02/init; mkdir 02/init; cp 02/POSCAR 02/init/;
rm -rf 03/init; mkdir 03/init; cp 03/POSCAR 03/init/;
rm -rf 04/init; mkdir 04/init; cp 04/POSCAR 04/init/;
rm -rf 05/init; mkdir 05/init; cp 05/POSCAR 05/init/;
rm -rf 06/init; mkdir 06/init; cp 06/POSCAR 06/init/;
rm -rf 07/init; mkdir 07/init; cp 07/POSCAR 07/init/;

cp INCAR.init KPOINTS run hostfile 01/init/; mv 01/init/INCAR.init 01/init/INCAR;
cp INCAR.init KPOINTS run hostfile 02/init/; mv 02/init/INCAR.init 02/init/INCAR;
cp INCAR.init KPOINTS run hostfile 03/init/; mv 03/init/INCAR.init 03/init/INCAR;
cp INCAR.init KPOINTS run hostfile 04/init/; mv 04/init/INCAR.init 04/init/INCAR;
cp INCAR.init KPOINTS run hostfile 05/init/; mv 05/init/INCAR.init 05/init/INCAR;
cp INCAR.init KPOINTS run hostfile 06/init/; mv 06/init/INCAR.init 06/init/INCAR;
cp INCAR.init KPOINTS run hostfile 07/init/; mv 07/init/INCAR.init 07/init/INCAR;

#==================
# After completion
#==================

# backup
mkdir run1;
cp -R 00 01 02 03 04 05 06 07 08 run1;
mv stdout  vasprun.xml  run1

# clean subdir
cd 01;pwd;ll;~/cleanvasp;mv -f CONTCAR POSCAR;ll; cd ..;pwd;
cd 02;pwd;ll;~/cleanvasp;mv -f CONTCAR POSCAR;ll; cd ..;pwd;
cd 03;pwd;ll;~/cleanvasp;mv -f CONTCAR POSCAR;ll; cd ..;pwd;
cd 04;pwd;ll;~/cleanvasp;mv -f CONTCAR POSCAR;ll; cd ..;pwd;
cd 05;pwd;ll;~/cleanvasp;mv -f CONTCAR POSCAR;ll; cd ..;pwd;
cd 06;pwd;ll;~/cleanvasp;mv -f CONTCAR POSCAR;ll; cd ..;pwd;
cd 07;pwd;ll;~/cleanvasp;mv -f CONTCAR POSCAR;ll; cd ..;pwd;

# clean subdir/init and copy updated POSCAR and CHGCAR
cd 01/init;pwd;ll;~/cleanvasp;rm -rf CHGCAR CONTCAR POSCAR WAVECAR;cp ../POSCAR ../CHGCAR ./;ll; cd ../..;pwd;
cd 02/init;pwd;ll;~/cleanvasp;rm -rf CHGCAR CONTCAR POSCAR WAVECAR;cp ../POSCAR ../CHGCAR ./;ll; cd ../..;pwd;
cd 03/init;pwd;ll;~/cleanvasp;rm -rf CHGCAR CONTCAR POSCAR WAVECAR;cp ../POSCAR ../CHGCAR ./;ll; cd ../..;pwd;
cd 04/init;pwd;ll;~/cleanvasp;rm -rf CHGCAR CONTCAR POSCAR WAVECAR;cp ../POSCAR ../CHGCAR ./;ll; cd ../..;pwd;
cd 05/init;pwd;ll;~/cleanvasp;rm -rf CHGCAR CONTCAR POSCAR WAVECAR;cp ../POSCAR ../CHGCAR ./;ll; cd ../..;pwd;
cd 06/init;pwd;ll;~/cleanvasp;rm -rf CHGCAR CONTCAR POSCAR WAVECAR;cp ../POSCAR ../CHGCAR ./;ll; cd ../..;pwd;
cd 07/init;pwd;ll;~/cleanvasp;rm -rf CHGCAR CONTCAR POSCAR WAVECAR;cp ../POSCAR ../CHGCAR ./;ll; cd ../..;pwd;

==================================================================================================
==================================================================================================
