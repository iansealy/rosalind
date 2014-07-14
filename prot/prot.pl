#!/usr/bin/env perl

# PODNAME: prot.pl
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

use Readonly;
use File::Slurp;

# Genetic code constants
Readonly our %AMINO_ACID_FOR = (
    AAA => q{K},
    AAC => q{N},
    AAG => q{K},
    AAU => q{N},
    ACA => q{T},
    ACC => q{T},
    ACG => q{T},
    ACU => q{T},
    AGA => q{R},
    AGC => q{S},
    AGG => q{R},
    AGU => q{S},
    AUA => q{I},
    AUC => q{I},
    AUG => q{M},
    AUU => q{I},
    CAA => q{Q},
    CAC => q{H},
    CAG => q{Q},
    CAU => q{H},
    CCA => q{P},
    CCC => q{P},
    CCG => q{P},
    CCU => q{P},
    CGA => q{R},
    CGC => q{R},
    CGG => q{R},
    CGU => q{R},
    CUA => q{L},
    CUC => q{L},
    CUG => q{L},
    CUU => q{L},
    GAA => q{E},
    GAC => q{D},
    GAG => q{E},
    GAU => q{D},
    GCA => q{A},
    GCC => q{A},
    GCG => q{A},
    GCU => q{A},
    GGA => q{G},
    GGC => q{G},
    GGG => q{G},
    GGU => q{G},
    GUA => q{V},
    GUC => q{V},
    GUG => q{V},
    GUU => q{V},
    UAA => q{},
    UAC => q{Y},
    UAG => q{},
    UAU => q{Y},
    UCA => q{S},
    UCC => q{S},
    UCG => q{S},
    UCU => q{S},
    UGA => q{},
    UGC => q{C},
    UGG => q{W},
    UGU => q{C},
    UUA => q{L},
    UUC => q{F},
    UUG => q{L},
    UUU => q{F},
);

# Default options
my $dataset_file;
my ( $debug, $help, $man );

# Get and check command line options
get_and_check_options();

# Get input
my $s = read_file($dataset_file);
chomp $s;

# Translate
printf "%s\n", translate($s);

# Translate
sub translate {
    my ($rna) = @_;

    my $peptide = q{};

    while ($rna) {
        my $codon = substr $rna, 0, 3, q{};  ## no critic (ProhibitMagicNumbers)
        $peptide .= $AMINO_ACID_FOR{$codon};
    }

    return $peptide;
}

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

dna.pl

Translating RNA into Protein

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This script is given "An RNA string s corresponding to a strand of mRNA (of
length at most 10 kbp)" and returns "The protein string encoded by s".

=head1 EXAMPLES

    perl prot.pl --dataset_file sample.txt

=head1 USAGE

    prot.pl
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
