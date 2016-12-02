#!/usr/bin/perl

open(list55k, "list55k.txt");

while(<list55k>){
	@list = split(",");
}

while (<>){
	chomp;
	($id, $tmp1) = split("\t");
	if( $id ~~ @list){
		print "$_\n";
	}
}
