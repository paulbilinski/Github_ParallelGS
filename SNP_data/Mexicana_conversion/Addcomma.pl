#/usr/bin/perl

$i = 1;

while(<>){
	chomp;
	print "$i,$_\n";
	$i++;
}
