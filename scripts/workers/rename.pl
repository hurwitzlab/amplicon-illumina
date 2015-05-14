#!/usr/bin/perl

my @files = glob("*.fasta");

foreach my $fn (@files) {
	$fn =~ s/.fasta//; 
	print "renaming: ", $fn, "\n";
	system("sed 's/>/>$fn;/g' $fn.fasta > renamed_$fn.fasta");
}

