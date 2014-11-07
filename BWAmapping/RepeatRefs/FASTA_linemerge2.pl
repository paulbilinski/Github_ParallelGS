#!/usr/bin/perl
# Generic script to take in a FASTA with line breaks and get rid of the line breaks.
# Made by PB on 6-1-12

my $file = $ARGV[0];
my $out = $ARGV[1];

open(URG, "<$file");
open(EDIT, ">$out");
while (<URG>) {
        chomp;
#        print "This is working\n";
        if ($_ =~ m/^>/) {
       	        my @array = split(",", $_);
                print EDIT "\n$array[0],";
        } else {
                print EDIT $_;
        }
}
