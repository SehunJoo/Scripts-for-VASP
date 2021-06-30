~/vasp_bader
~/vasp_analysis.pl
~/vasp_analysis.pl > analysis


echo ""
=======================================================
bash shell script - check status / restart
=======================================================

# restart
find . -maxdepth 1 -type f -exec mv {} sp4 \;


http://blog.naver.com/PostView.nhn?blogId=nativekim&logNo=220873659494
http://blog.naver.com/PostView.nhn?blogId=dudwo567890&logNo=130155977709
========================================================
grep EDIFFG INCAR
echo ""
grep reach OUTCAR
echo ""
grep "energy  w" OUTCAR
echo ""
grep mag stdout

==========================================================================================
==========================================================================================
#!/usr/bin/env perl
#;-*- Perl -*-

# Script prints the force, energy etc of OUTCAR's in immediate subdir
# of present working directory.
# Script prints the force, energy etc of OUTCAR's in immediate subdir
# of present working directory. Older versions of this script had specific
# paths hardcoded.  
use Cwd;

$dir = cwd;
$outfile='OUTCAR';

$steps  = `grep 'energy  without' "$outfile" | wc |cut -c 0-8` ;
$energy = `grep 'energy  without' "$outfile" | tail -n 1 |cut -c 29-44`; # every each ionic step
$force =  `grep 'max\ at' "$outfile" | tail -n 1 |cut -c 27-38`; # every each ionic step
$stress =  `grep 'Stress total and'  "$outfile" | tail -n 1 | cut -c 48-55` ; # every each ionic step
$volume =  `grep 'volume'  "$outfile" | tail -n 1 | cut -c 24-30` ; # every each ionic step
$mag =  `grep 'number of electron' "$outfile" | tail -n 1 | cut -c 51-65` ;

chop($steps) ;
chop($energy) ;
chop($force) ;
chop($stress) ;
chop($volume) ;
chop($mag) ;


print "\nSteps    Force       Energy            Stress     Volume    Magnet\n";
@f4 = ($steps,$force,$energy,$stress,$volume,$mag);
printf "%4i %12.6f %16.8f %12.6f %8.2f %12.7f\n\n",@f4;

	
==========================================================================================
==========================================================================================
#!/usr/bin/env perl
#;-*- Perl -*-

# Script prints the force, energy etc of OUTCAR's in immediate subdir
# of present working directory.

use Cwd;

$dir = cwd;
$outlist =`ls -1 "$dir"/[0-9][0-9]/OUTCAR`;   #specifies location of OUTCARs
@outlist = split("\n",$outlist);

$i = 0;
foreach $outfile (@outlist) {
    $energy = `grep 'energy  without' "$outfile" | tail -n 1 |cut -c 67-78`;
    $force =  `grep 'max\ at' "$outfile" | tail -n 1 |cut -c 27-38`;
    if(!$i) { $e0 = $energy; }
    $rel = $energy - $e0;
    @f4 = ($i,$force,$energy,$rel);
    printf "%4i %16.6f %16.6f %16.6f \n",@f4;
    $i++;
}

==========================================================================================
==========================================================================================
#!/usr/bin/env perl
#;-*- Perl -*-

# Script prints the force, energy etc of OUTCAR's in immediate subdir
# of present working directory. Older versions of this script had specific
# paths hardcoded.  

  use Cwd ;
  $dir = cwd ;
  @l1=`ls -la $dir/[0-9][0-9]/OUTCAR`;   #specifies location of outcars
  $i = 0 ;
  print " Image   Force        Stress   Volume    Magnet     Rel Energy  \n";
  foreach $_ (@l1) {
    chop() ;
    @t1=split() ;
    $t2=$t1[@t1-1] ;
#    $steps  = `grep 'energy  without' $t2 | wc |cut -c 0-8` ; 
    $energy = `grep 'energy  without' $t2 | tail -n 1 |cut -c 67-78` ;
    $force =  `grep 'max\ at' $t2 | tail -n 1 |cut -c 27-38` ;
    $stress =  `grep 'Stress total and'  $t2 | tail -n 1 | cut -c 48-55` ;
    $volume =  `grep 'volume'  $t2 | tail -n 1 | cut -c 24-30` ;
    $mag =  `grep 'number of electron' $t2 | tail -n 1 | cut -c 51-59` ;
#    chop($steps) ;
    chop($energy) ;
    chop($force) ;
    chop($stree) ;
    if(!$i) {$e0 = $energy ;}
    $rel = $energy - $e0 ;
    #@f4 = ($i,$force,$energy,$rel) ;
    #printf "%4i %16.8f %16.8f %16.8f \n",@f4 ; 
    @f4 = ($i,$force,$stress,$volume,$mag,$rel) ;
    printf "%4i %12.8f %12.8f %6.2f %11.8f %12.8f \n",@f4 ;

    $i++ ;

  };

~                                                                                                                                  
~                                                                                                                                  
~                                                                                      
