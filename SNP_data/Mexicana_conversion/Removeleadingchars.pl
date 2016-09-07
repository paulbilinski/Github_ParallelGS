#/usr/bin/perl
use strict; use warnings;

while(<>){
	chomp;
	s/^[^,]*,//;
	print "$_\n";
}
