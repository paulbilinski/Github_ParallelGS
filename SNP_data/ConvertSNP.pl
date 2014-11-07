#!/usr/bin/perl
use strict; use warnings;

die "usage: ConvertSNP.pl <SNP file> <Output>" unless @ARGV==2;

my $snpfile = $ARGV[0];
my $out = $ARGV[1];

open(SNP, "<$snpfile");
open(OUT, ">$out");

while(<SNP>){
	chomp;
	my @line = split(/,/, $_);
	#print "$line[1]\n";
	if ($line[1] =~ m/A\/G/) {
		foreach (@line){
			$_ =~ s/AG/00/;
			$_ =~ s/AA/01/;
			$_ =~ s/GG/-1/;
#			print OUT "$_,"
			}
		}
	if ($line[1] =~ m/G\/A/) {
		foreach (@line){
			$_ =~ s/AG/00/;
			$_ =~ s/GG/01/;
			$_ =~ s/AA/-1/;
#			print OUT "$_,"
			}
		}
	if ($line[1] =~ m/A\/T/) {
		foreach (@line){
			$_ =~ s/AT/00/;
			$_ =~ s/AA/01/;
			$_ =~ s/TT/-1/;
#			print OUT "$_,"
			}
		}
	if ($line[1] =~ m/T\/A/) {
		foreach (@line){
			$_ =~ s/AT/00/;
			$_ =~ s/TT/01/;
			$_ =~ s/AA/-1/;
#			print OUT "$_,"
			}
		}
	if ($line[1] =~ m/A\/C/) {
		foreach (@line){
			$_ =~ s/AC/00/;
			$_ =~ s/AA/01/;
			$_ =~ s/CC/-1/;
#			print OUT "$_,"
			}
		}
	if ($line[1] =~ m/C\/A/) {
		foreach (@line){
			$_ =~ s/AC/00/;
			$_ =~ s/CC/01/;
			$_ =~ s/AA/-1/;
#			print OUT "$_,"
			}
		}
	if ($line[1] =~ m/C\/G/) {
		foreach (@line){
			$_ =~ s/GC/00/;
			$_ =~ s/CC/01/;
			$_ =~ s/GG/-1/;
#			print OUT "$_,"
			}
		}
	if ($line[1] =~ m/G\/C/) {
		foreach (@line){
			$_ =~ s/GC/00/;
			$_ =~ s/GG/01/;
			$_ =~ s/CC/-1/;
#			print OUT "$_,"
			}
		}
	if ($line[1] =~ m/C\/T/) {
		foreach (@line){
			$_ =~ s/TC/00/;
			$_ =~ s/CC/01/;
			$_ =~ s/TT/-1/;
#			print OUT "$_,"
			}
		}
	if ($line[1] =~ m/T\/C/) {
		foreach (@line){
			$_ =~ s/TC/00/;
			$_ =~ s/TT/01/;
			$_ =~ s/CC/-1/;
#			print OUT "$_,"
			}
		}
	if ($line[1] =~ m/G\/T/) {
		foreach (@line){
			$_ =~ s/GT/00/;
			$_ =~ s/GG/01/;
			$_ =~ s/TT/-1/;
#			print OUT "$_,"
			}
		}
	if ($line[1] =~ m/T\/G/) {
		foreach (@line){
			$_ =~ s/GT/00/;
			$_ =~ s/TT/01/;
			$_ =~ s/GG/-1/;
#			print OUT "$_,"
			}
		}
	foreach (@line){
		print OUT "$_,";
	}			
	print OUT "\n";
}		