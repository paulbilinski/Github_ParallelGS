#!/usr/bin/perl
#used to convert topstrand style data, which is what we should have
use strict; use warnings;

die "usage: ConvertSNP.pl <SNP file> <Output>" unless @ARGV==2;

my $snpfile = $ARGV[0];
my $out = $ARGV[1];

open(SNP, "<$snpfile");
open(OUT, ">$out");

my $linecount = 1;
my $zero;
my $one;

while(<SNP>){
	chomp;
	my @line = split(/,/, $_);
	my ($zerogeno, $trash) = split(//, $line[0]);
	#print "$zerogeno\n";
	foreach my $geno (@line) {
		if ($geno eq "NN") {
			print OUT "NA,";
		} else {
			my ($temp1, $temp2) = split(//,$geno);
			if ($temp1 =~ m/$temp2/ && $temp1 eq "$zerogeno"){
			print OUT "00,";
			}
			if ($temp1 !~ m/$temp2/){
			print OUT "01,"; #note, you have to make sure your data only has 2 alleles or NA, otherwise this line will convert extra alleles into hets
			}
			if ($temp1 =~ m/$temp2/ && $temp1 ne "$zerogeno"){
				print OUT "02,";			
			}
		}
	}
	print OUT "\n";
}
