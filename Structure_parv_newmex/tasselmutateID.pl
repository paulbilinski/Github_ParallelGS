#!/usr/bin/perl

while (<>){
	chomp;
	@line = split("\t");
	#$mutateID = @line[3]\_@line[4];
	print @line[2] . "_";
	print @line[3] . "\t";
	print join("\t", @line),"\n";
}
