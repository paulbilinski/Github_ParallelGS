#!/usr/bin/perl
use strict; use warnings;
die "usage: PrependHeader.pl <abund> <ABUND OUT>" unless @ARGV==2;

my $abund = $ARGV[0];
my $out = $ARGV[1];

open(abund, "<$abund");
open(OUT, ">$out");
my $count=0;

while (<abund>){
	if ($count == 0){
		 print OUT "FTE,$abund\n";
	}
	print OUT "$_";
	$count=1;
}
