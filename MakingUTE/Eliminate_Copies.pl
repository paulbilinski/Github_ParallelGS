#!/usr/bin/perl
#! Read the masked TE DB and get rid of any TE that occurs multiple times, as a result of the many BLAST hits
use strict; use warnings;

die "usage: Eliminate_Copies.pl <Masked file> <SingleCopyOutput>" unless @ARGV==2;

my $maskedfile = $ARGV[0];
my $Singleout = $ARGV[1];

open(MASK, "<$maskedfile");
open(Single, ">$Singleout");

my %TEs;
my $tempTE = "";
my $tempSEQ = "";

while(<MASK>){
	chomp;
	if ($_ =~ m/^>/){
		$tempTE = $_;
#		print "$_";
#		print $tempTE;
#		$TEs{$tempTE}; #Ha, useless line, don't do this.
	} else {
		$tempSEQ = $_;
#		print "$tempTE\n$tempSEQ\n";
		$TEs{$tempTE} = $tempSEQ;
	}
}

foreach my $key (sort keys %TEs) {
    print Single "$key\n$TEs{$key}\n";
  }
