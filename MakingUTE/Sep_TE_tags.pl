#!/usr/bin/perl
# Separates the TE tags into different lines to check the length of each tag.  (greater than 70bp in this case)
use strict; use warnings;

die "usage: Sep_TEtags.pl <Maskedhits_noN> <Sep_Out>" unless @ARGV==2;

my $masked_hits = $ARGV[0];
my $Sep_tag = $ARGV[1];

open(MASKED, "<$masked_hits");
open(SEP, ">$Sep_tag");
#Variables for separating tags
my $temp_name;
my $count=1;

while(<MASKED>){
	chomp;
	if ($_ =~ m/>/){
		$temp_name = $_;
		$count=1;
	} else {
		my @tags = split("-", $_);
		my $numtags = @tags;
#		print "$temp_name\n$numtags\n";
		foreach (@tags){
			if (length($_)>70){	#LINE WITH LENGTH OF FRAG FILTER
				print SEP "$temp_name.$count\n$_\n";
				$count++;
			}
		}
	}
}
