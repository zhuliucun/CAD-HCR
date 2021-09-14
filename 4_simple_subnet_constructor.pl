#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;

my $man  = 0;
my $help = 0;

my $in_file		= 'same_filtered_seq';
my $out_file	= 'network';
my $same_thred 	= 5;

GetOptions(
    'help|?'	=> \$help,
    'man'		=> \$man,
	'infile=s'	=> \$in_file,
	'outfile=s'	=> \$out_file,
	'sthred=i'	=> \$same_thred,
) or pod2usage(2);

pod2usage(1) if $help;
pod2usage( -exitstatus => 0, -verbose => 2 ) if $man;

$|++;

my @seqs;
open IN, "< $in_file";

$seqs[0] = <IN>;
chomp $seqs[0];

while ( my $candidate_seq = <IN> ) {
	
	chomp $candidate_seq;
	my $keep = 1;
	
	foreach my $exist_seq ( @seqs ) {
		my $s1a = same($candidate_seq, $exist_seq);
		unless($s1a <= $same_thred ){
			$keep = 0;
			last;
		}
	}
	
	if ($keep) {
		push @seqs, $candidate_seq;
	}
}

close IN;

open OUT, "> $out_file";
foreach my $seq ( @seqs ){
	print OUT "$seq\n";
}
close OUT;

sub same{
	my $seqA = shift;
	my $seqB = shift;
	my $l = length $seqA;
	my $same = 0;
	
	my $i = 0;
	while ( $i < $l ){
		my $nucA = substr $seqA, $i, 1;
		my $nucB = substr $seqB, $i, 1;
		if ( $nucA eq $nucB ) {
			$same ++;
		}
		$i++;
	}
	
	return $same;
}