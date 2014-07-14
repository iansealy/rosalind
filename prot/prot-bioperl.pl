#!/usr/bin/env perl

# PODNAME: prot-bioperl.pl
# ABSTRACT: Translating RNA into Protein

## Author     : ian.sealy@sanger.ac.uk
## Maintainer : ian.sealy@sanger.ac.uk
## Created    : 2014-07-13

use warnings;
use strict;
use autodie;
use Getopt::Long;
use Pod::Usage;
use Carp;
use version; our $VERSION = qv('v0.1.0');

use Bio::SeqIO;

# Default options
my $dataset_file;
my ( $debug, $help, $man );

# Get and check command line options
get_and_check_options();

# Get input
my $in = Bio::SeqIO->new(
    -file     => $dataset_file,
    -format   => 'raw',
    -alphabet => 'rna',
);
my $s = $in->next_seq;

# Translate
my $protein = $s->translate->seq;
$protein =~ s/[*] \z//xms;
printf "%s\n", $protein;

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

prot-bioperl.pl

Translating RNA into Protein

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This script is given "An RNA string s corresponding to a strand of mRNA (of
length at most 10 kbp)" and returns "The protein string encoded by s".

=head1 EXAMPLES

    perl prot-bioperl.pl --dataset_file sample.txt

=head1 USAGE

    prot-bioperl.pl
        [--dataset_file file]
        [--debug]
        [--help]
        [--man]

=head1 OPTIONS

=over 8

=item B<--dataset_file FILE>

File containing "An RNA string s corresponding to a strand of mRNA (of length at
most 10 kbp)".

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
