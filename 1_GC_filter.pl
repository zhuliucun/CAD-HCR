#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;

my $man  = 0;
my $help = 0;

my $in_file		= 'total_seq';
my $out_file	= 'GC_filtered_seq';
my $gc_cnt		= 4;

GetOptions(
    'help|?'	=> \$help,
    'man'		=> \$man,
	'infile=s'	=> \$in_file,
	'outfile=s'	=> \$out_file,
	'gc=i'		=> \$gc_cnt,
) or pod2usage(2);

pod2usage(1) if $help;
pod2usage( -exitstatus => 0, -verbose => 2 ) if $man;

$|++;

open IN, "< $in_file";
open OUT, "> $out_file";
while ( my $seq = <IN> ) {
	chomp $seq;
	my $gc = gc_content($seq);
	if ($gc == $gc_cnt){
		print OUT "$seq\n";
	}
	
}
close OUT;
close IN;

sub gc_content{
	my $seq = shift;
	my $c_cnt = $seq =~ s/C/C/g;
	my $g_cnt = $seq =~ s/G/G/g;
	return ($c_cnt + $g_cnt);
}