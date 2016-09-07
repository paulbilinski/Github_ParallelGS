#!/usr/bin/perl


my @line;
my $calls;
my $first;
my $second;

while(<>){
	chomp;
	@line = split(/,/, $_);
	$calls = shift @line;
	($first, $second) = split(/\//, $calls);
	$geno = join(',', @line);
	#print "$geno\n";
	if  ($geno =~ /$first/) {
		my $stuff = join(',',@line);
		print "$stuff\n";  
	} else {
		foreach my $i (@line) {
			$i =~ tr/ATGC/TACG/;
			print "$i,";
		}
	print "\n";
	}
}	

