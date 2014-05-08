#!/usr/bin/env perl

# PODNAME: gc-bioperl.pl
# ABSTRACT: Computing GC Content

## Author     : ian.sealy@sanger.ac.uk
## Maintainer : ian.sealy@sanger.ac.uk
## Created    : 2014-05-07

use warnings;
use strict;
use autodie;
use Getopt::Long;
use Pod::Usage;
use Carp;
use version; our $VERSION = qv('v0.1.0');

use Bio::SeqIO;
use Bio::Tools::SeqStats;

# Default options
my $dataset_file;
my ( $debug, $help, $man );

# Get and check command line options
get_and_check_options();

# Get input
my $in = Bio::SeqIO->new(
    -file     => $dataset_file,
    -format   => 'fasta',
    -alphabet => 'dna',
);

# Calculate highest GC
my $high_id;
my $high_gc = 0;
while ( my $seq = $in->next_seq ) {
    my $stats  = Bio::Tools::SeqStats->new( -seq => $seq );
    my $counts = $stats->count_monomers();
    my $gc     = ( $counts->{G} + $counts->{C} ) / $seq->length;
    if ( $gc > $high_gc ) {
        $high_id = $seq->id;
        $high_gc = $gc;
    }
}

# Print output
## no critic (ProhibitMagicNumbers)
printf "%s\n%.3f\n", $high_id, $high_gc * 100;
## use critic

# Get and check command line options
sub get_and_check_options {

    # Get options
    GetOptions(
        'dataset_file=s' => \$dataset_file,
        'debug'          => \$debug,
        'help'           => \$help,
        'man'            => \$man,
    ) or pod2usage(2);

    # Documentation
    if ($help) {
        pod2usage(1);
    }
    elsif ($man) {
        pod2usage( -verbose => 2 );
    }

    # Check options
    if ( !$dataset_file ) {
        pod2usage("--dataset_file must be specified\n");
    }

    return;
}

__END__
=pod

=encoding UTF-8

=head1 NAME

gc-bioperl.pl

Computing GC Content

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This script is given "At most 10 DNA strings in FASTA format (of length at most
1 kbp each)" and returns "The ID of the string having the highest GC-content,
followed by the GC-content of that string".

=head1 EXAMPLES

    perl gc-bioperl.pl --dataset_file sample.txt

=head1 USAGE

    gc-bioperl.pl
        [--dataset_file file]
        [--debug]
        [--help]
        [--man]

=head1 OPTIONS

=over 8

=item B<--dataset_file FILE>

File containing "At most 10 DNA strings in FASTA format (of length at most 1 kbp
each)".

=item B<--debug>

Print debugging information.

=item B<--help>

Print a brief help message and exit.

=item B<--man>

Print this script's manual page and exit.

=back

=head1 DEPENDENCIES

None

=head1 AUTHOR

=over 4

=item *

Ian Sealy <ian.sealy@sanger.ac.uk>

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Genome Research Ltd.

This is free software, licensed under:

  The GNU General Public License, Version 3, June 2007

=cut
