#!/usr/bin/perl

open(listgbs, "listgbs.txt");

while(<listgbs>){
	@list = split(",");
}

while (<>){
	chomp;
	($id, $tmp1) = split("\t");
	if( $id ~~ @list){
		print "$_\n";
	}
}
