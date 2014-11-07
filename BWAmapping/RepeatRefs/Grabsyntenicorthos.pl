#!/usr/bin/perl
#Script to go through schnable's set of ortho's and print out corresponding lines from T01 or T001 cDNA

my $cdna = $ARGV[0];
my $ortho = $ARGV[1];
my $out = $ARGV[2];

open(cdna, "<$cdna");
open(ortho, "<$ortho");
open(out, ">$out");

my @ortho;

while(<ortho>) {
	chomp;
	push (@ortho, $_);
}

close 

my @cdna;

while(<cdna>) {
	chomp;
	push(@cdna, $_);
}

foreach my $tmp1 (@ortho) {
	foreach my $tmp2 (@cdna) {
		if ($tmp1 =~ m/$tmp2/) {
			print "$tmp2\n";
		}
	}
}

