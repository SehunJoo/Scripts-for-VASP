#!perl

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);

my $xsdname = "CONTCAR";
my $xsddoc = $Documents{$xsdname.".xsd"};
my $range = 0.9;


my $tempdoc;
my $tempname;
my $atoms;
my ($latveca, $latvecb, $latvecc);
my ($latveca_dx, $latveca_dy, $latveca_dz);
my ($latvecb_dx, $latvecb_dy, $latvecb_dz);
my ($latvecc_dx, $latvecc_dy, $latvecc_dz);
my ($latlenga, $latlengb, $latlengc);

$latveca = $xsddoc->Lattice3D->VectorA;
$latvecb = $xsddoc->Lattice3D->VectorB;
$latvecc = $xsddoc->Lattice3D->VectorC;
$latlenga = $xsddoc->Lattice3D->LengthA;
$latlengb = $xsddoc->Lattice3D->LengthB;
$latlengc = $xsddoc->Lattice3D->LengthC;

$latveca_dx = ($latveca->X);
$latveca_dy = ($latveca->Y);
$latveca_dz = ($latveca->Z);

$latvecb_dx = ($latvecb->X);
$latvecb_dy = ($latvecb->Y);
$latvecb_dz = ($latvecb->Z);

$latvecc_dx = ($latvecc->X);
$latvecc_dy = ($latvecc->Y);
$latvecc_dz = ($latvecc->Z);

$tempname = $xsdname."_backup.xsd";
$tempdoc = $xsddoc->SaveAs($tempname);
$atoms = $xsddoc->UnitCell->Atoms;

foreach my $atom (@$atoms)
{
	if ($atom->FractionalXYZ->X > $range || $atom->FractionalXYZ->Y > $range)
	{
		$atom->X = $atom->X - $latveca_dx;
		$atom->Y = $atom->Y - $latveca_dy;
		$atom->Z = $atom->Z - $latveca_dz;
		
		if ($atom->FractionalXYZ->X > $range || $atom->FractionalXYZ->Y > $range)
		{
			$atom->X = $atom->X + $latveca_dx;
			$atom->Y = $atom->Y + $latveca_dy;
			$atom->Z = $atom->Z + $latveca_dz;
		}
	}

	if ($atom->FractionalXYZ->X > $range || $atom->FractionalXYZ->Y > $range)
	{
		$atom->X = $atom->X - $latvecb_dx;
		$atom->Y = $atom->Y - $latvecb_dy;
		$atom->Z = $atom->Z - $latvecb_dz;
		
		if ($atom->FractionalXYZ->X > $range || $atom->FractionalXYZ->Y > $range)
		{
			$atom->X = $atom->X + $latvecb_dx;
			$atom->Y = $atom->Y + $latvecb_dy;
			$atom->Z = $atom->Z + $latvecb_dz;
		}
	}
	
	if ($atom->FractionalXYZ->X > $range || $atom->FractionalXYZ->Y > $range)
	{
		$atom->X = $atom->X - $latveca_dx - $latvecb_dx;
		$atom->Y = $atom->Y - $latveca_dy - $latvecb_dy;
		$atom->Z = $atom->Z - $latveca_dz - $latvecb_dz;
		
		if ($atom->FractionalXYZ->X > $range || $atom->FractionalXYZ->Y > $range)
		{
			$atom->X = $atom->X + $latveca_dx + $latvecb_dx;
			$atom->Y = $atom->Y + $latveca_dy + $latvecb_dy;
			$atom->Z = $atom->Z + $latveca_dz + $latvecb_dz;
		}
	}
}

$xsddoc->Save;
$tempdoc->Save;
undef $xsddoc;
undef $tempdoc;
