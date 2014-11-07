#!/usr/bin/perl
#! Read SAM from BWA MEM alignment, create a hash that stores the number of reads hitting each TE and splits multiple hits
use strict; use warnings;
#perl ParseSam.pl toysam.sam FTEdb.fasta crap
die "usage: ParseSam.pl <SAMFILE> <TELIST> <ABUND OUT>" unless @ARGV==3;

my $SAM = $ARGV[0];
my $TE = $ARGV[1];
my $OUT = $ARGV[2];

open(SAM, "<$SAM");
open(TELIST, "<$TE");
open(ABUND, ">$OUT");

#Empty Hash of TEs, populate with TE ID's but Zero's for values
my %TEs;
my $tempTE = "";

#while(<TELIST>){
#	chomp;
#	if ($_ =~ m/^>/){
#		$tempTE = $_;
#		$TEs{$tempTE} = 0;
#	}
#}

close TELIST;

#print %TEs; yes, all TE names and 0s in this hash.

#Process SAM file
#Variables needed to process
my $tempreadid = "";
my @tempmultmap= ();
my $n = 0;
my ($readid, $flag, $tehit, $pos, $mapq, $cigar, $rnext, $pnext, $isize, $seq, $qual, $tag1, $tag2, $tag3);
my $totalreads = 0;

while (<SAM>){
	if ($_ =~ m/^HWI/){
		chomp;
		($readid, $flag, $tehit, $pos, $mapq, $cigar, $rnext, $pnext, $isize, $seq, $qual, $tag1, $tag2, $tag3) = split("\t");
		#check if the read is the same, in which case it is mapping multiply
		#print "$readid\t$tempreadid\n";
		if ($tempreadid =~ m/$readid/) {
			#print "i get here\n";
			push (@tempmultmap, $tehit);
			$n += 1;
			#print join(", ", @tempmultmap) . "\n$n\n"; #diagnostic line
		} else {
		$totalreads++;
		foreach my $name (@tempmultmap) {
			$TEs{$name} += 1/$n;

		}
		@tempmultmap = ();
		$n = 1;
		push (@tempmultmap, $tehit);
		$tempreadid = $readid;
		}
	} 
}

foreach my $name (@tempmultmap) {
			$TEs{$name} += 1/$n;
}

close SAM;
		
print ABUND "$_,$TEs{$_}\n" for (keys %TEs);
#print ABUND "Total,$totalreads\n";
		













