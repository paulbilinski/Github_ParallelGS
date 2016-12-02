#!/usr/bin/perl


my @line;
my $calls;
my $first;
my $second;

while(<>){
	chomp;
	@line = split(/,/, $_);
	$calls = shift @line;
	$leng = length $calls;
	#print "$leng\n";
	if  ($leng == 3) {
		print "$_\n";  
	}
}	

