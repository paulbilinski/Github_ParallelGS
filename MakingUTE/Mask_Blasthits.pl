#!/usr/bin/perl
#! Read TE db and BLAST outputs (concatenated) to isolate hits to other TE's.  Use the location of these hits in other TE's to mask those base pairs in the original TE.
use strict; use warnings;

die "usage: Mask_Blasthits.pl <BLAST RESULT> <TE_DB> <Dashes> <Masked Out>" unless @ARGV==4;

my $blast_out = $ARGV[0];
my $TE_DB = $ARGV[1];
my $dashes = $ARGV[2];
my $Masked = $ARGV[3];

open(BLAST, "<$blast_out");
open(TE_DB, "<$TE_DB");
open(DASH, "<$dashes");
open(MASK, ">$Masked");
#BLAST hit variables
my $TE_name;
my $TE_start_mask;
my $TE_end_mask;
my $TE_length_mask;
my $query_fam; #for family ID in BLAST hit
my $subj_fam;  #for family ID in BLAST hit
#TE database variables
my %TEs;
my $tempTE = "";
my $tempSEQ = "";
my $dash;

while(<DASH>){
	chomp;
	$dash = $_;
#	print "$dash\n";
}
close DASH;

while(<TE_DB>){
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
close TE_DB;

#Dump Hash Contents for Error
#print %TEs;

#foreach my $key (sort keys %TEs) {
#    print "$key\n$TEs{$key}\n";
#}

while(<BLAST>) {
	chomp;
	if($_ =~ m/#/) {
		#In case I want to do something with the name...
	} else {
#		print "$_\n";
		my($query, $subject, $ID, $length, $mismatch, $gap, $q_start, $q_end, $s_start, $s_end, $evalue, $bitscore) = split("\t");  
		#to be used only if you want to look at the subfamily of the TEs, which is indicated in the first 3 chars of the TE name
		$query_fam = substr($query, 0, 3);
		#print "Query:$query_fam\n";
		$subj_fam = substr($subject, 0,3);
		#print "Subject:$subj_fam\n";
		if ($query !~ m/$subject/) { #to be used for unique TEs individually
		#if ($query_fam !~ m/$subj_fam/){ #to be used for being able to map better to families
			$TE_name = ">$query";
			$TE_start_mask = $q_start;
			$TE_end_mask = $q_end;
			$TE_length_mask = $q_end - $q_start;
#			print "$TE_length_mask\n";
#			print "$TE_name\t$TE_start_mask\t$TE_end_mask\n";
			my $replacement = substr($dash, 1, $TE_length_mask);
#			print "$replacement\n";
			my $hashlookup = $TEs{$TE_name};
#			print "$hashlookup";
#			print "$TE_end_mask\n";
			my $masked_TE_seq = substr ($hashlookup, $TE_start_mask, $TE_length_mask, "$replacement");
#			print "$masked_TE_seq\n$hashlookup\n";
#			print MASK "$TE_name\n$hashlookup\n";
			$TEs{$TE_name} = $hashlookup;
		}
		#print %newTEs; #and its still there
	}
#	print keys(%TEs); #is even bigger, still there									
}
close BLAST;
#my @bob=keys(%TEs); #and its gone
#print "HOLY SHIT, @bob\n";

foreach my $key (sort keys %TEs) {
   print MASK "$key\n$TEs{$key}\n";
}


