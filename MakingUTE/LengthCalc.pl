#!/usr/bin/perl
#! Code to count the length of a TE tag, and spit it out to a CSV

die "usage: LengthCalc.pl <Input> <Output>" unless @ARGV==2;


my $temp_name;
my $count=1;
open(tmp, "<$ARGV[0]");
open(OUT, ">$ARGV[1]");

while(<tmp>){
	chomp;
	if ($_ =~ m/>/){
		print OUT "$_,";
	} else {
		print OUT length($_) . "\n";
	}
}

