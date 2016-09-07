#!/usr/bin/perl

while (<>){
	chomp;
	($marker, $chr, $pos) = split("\t");
	print "$marker,$chr\_$pos\n";
}
