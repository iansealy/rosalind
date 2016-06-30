#!/usr/bin/env perl

# PODNAME: iprb.pl
# ABSTRACT: Mendel's First Law

## Author     : ian.sealy@sanger.ac.uk
## Maintainer : ian.sealy@sanger.ac.uk
## Created    : 2014-05-15

use warnings;
use strict;
use autodie;
use Getopt::Long;
use Pod::Usage;
use Carp;
use version; our $VERSION = qv('v0.1.0');

use Readonly;
use Path::Tiny;
use List::Util qw( sum );

# Genotype constants
Readonly our $HOM_DOM   => 0;
Readonly our $HET       => 1;
Readonly our $HOM_REC   => 2;
Readonly our @GENOTYPES => ( $HOM_DOM, $HET, $HOM_REC );

# Default options
my $dataset_file;
my ( $debug, $help, $man );

# Get and check command line options
get_and_check_options();

# Get input
my ( $k, $m, $n ) = split /\s+/xms, path($dataset_file)->slurp;

my $prob_dom_phenotype = 0;
my @population = ( $k, $m, $n );
foreach my $parent1 (@GENOTYPES) {
    my $parent1_prob = $population[$parent1] / sum(@population);
    $population[$parent1]--;
    foreach my $parent2 (@GENOTYPES) {
        my $parent2_prob = $population[$parent2] / sum(@population);
        my $parent_prob  = $parent1_prob * $parent2_prob;
        if ( $parent1 == $HOM_DOM || $parent2 == $HOM_DOM ) {

            # If either parent is homozygous dominant then all offspring are
            # phenotypically dominant
            $prob_dom_phenotype += $parent_prob;
        }
        elsif ( $parent1 == $HET && $parent2 == $HET ) {

            # If both parents are heterozygous then 3/4 of offspring are
            # phenotypically dominant
            ## no critic (ProhibitMagicNumbers)
            $prob_dom_phenotype += $parent_prob * 3 / 4;
            ## use critic
        }
        elsif ( $parent1 == $HET || $parent2 == $HET ) {

            # If one parent is heterozygous then 1/2 of offspring are
            # phenotypically dominant
            $prob_dom_phenotype += $parent_prob * 1 / 2;
        }
    }
    $population[$parent1]++;    # Restore population
}

# Output
printf "%.3f\n", $prob_dom_phenotype;

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

iprb.pl

Mendel's First Law

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This script is given "Three positive integers k, m, and n, representing a
population containing k+m+n organisms: k individuals are homozygous dominant for
a factor, m are heterozygous, and n are homozygous recessive" and returns "The
probability that two randomly selected mating organisms will produce an
individual possessing a dominant allele (and thus displaying the dominant
phenotype)".

=head1 EXAMPLES

    perl iprb.pl --dataset_file sample.txt

=head1 USAGE

    iprb.pl
        [--dataset_file file]
        [--debug]
        [--help]
        [--man]

=head1 OPTIONS

=over 8

=item B<--dataset_file FILE>

File containing "Three positive integers k, m, and n, representing a population
containing k+m+n organisms: k individuals are homozygous dominant for a factor,
m are heterozygous, and n are homozygous recessive".

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
