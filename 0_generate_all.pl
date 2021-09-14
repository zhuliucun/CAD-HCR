#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;

my $man  = 0;
my $help = 0;

my $out_file	= 'total_seq';
my $len			= 8;

GetOptions(
    'help|?'	=> \$help,
    'man'		=> \$man,
	'outfile=s'	=> \$out_file,
	'length=i'	=> \$len
) or pod2usage(2);

pod2usage(1) if $help;
pod2usage( -exitstatus => 0, -verbose => 2 ) if $man;

$|++;

my @nuc = ('A', 'T', 'C', 'G');
my @seq = ('');

foreach my $i ( (1..$len) ){
	my @new_seq;
	foreach my $exist_seq ( @seq ) {
		foreach my $nuc ( @nuc ){
			push @new_seq, "$exist_seq$nuc";
		}
	}
	@seq = @new_seq;
}

open OUT, "> $out_file";
foreach my $seq ( @seq ) {
	print OUT "$seq\n";
}
close OUT;

sub gc_content{
	my $seq = shift;
	my $c_cnt = $seq =~ s/C/C/g;
	my $g_cnt = $seq =~ s/G/G/g;
	return ($c_cnt + $g_cnt)/(length $seq);
}

sub css{
	my $seq1 = shift;
	my $seq2 = shift;
	my $css = 0;
	my $l = length $seq1;
	
	foreach my $i ( (1..$l) ){
		my $s1 = substr $seq1, 0, $i;
		my $s2 = substr $seq2, -$i, $i;
		my $css_temp = csame($s1, $s2);
		if ( $css < $css_temp ) { $css = $css_temp; }
		
		$s1 = substr $seq1, -$i, $i;
		$s2 = substr $seq2, 0, $i;
		$css_temp = csame($s1, $s2);
		if ( $css < $css_temp ) { $css = $css_temp; }
	}
	
}

sub csame {
	my $seqA = shift;
	my $seqB = shift;
	my $l = length $seqA;
	my $csl = 0;
	
	my $i = 0;
	my $same = 0;
	while ( $i < $l ){
		my $nucA = substr $seqA, $i, 1;
		my $nucB = substr $seqB, $i, 1;
		if ( $nucA eq $nucB ) {
			$same ++;
		}else{
			if ( $csl < $same ) {
				$csl = $same;
				$same = 0;
			}
		}
		$i++;
	}
	
	return $csl;
}

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
	}
	
	return $same;
}