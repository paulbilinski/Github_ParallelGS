#!/usr/bin/perl


my $ok = 0;
my $dist = 0;
my $prevloc = -6000;
my $pastchr = 1;

while (<>){
	chomp;
	($tmp1, $tmp2, $chr, $pos) = split("\t");
	$dist = $pos - $prevloc;	
	#print "$chr is chromosome\n\n";
	if ($chr == $pastchr){
		if ($dist > 5000) {
		print "$tmp1,$tmp2,$chr,$pos\n";
		$prevloc=$pos;
		} if ($dist < 5000) {
		next;
		}
	} else {
	#$pastchr = $chr;
	print "$tmp1,$tmp2,$chr,$pos\n";
	}
}
