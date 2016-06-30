#!/usr/bin/env perl

# PODNAME: fibd.pl
# ABSTRACT: Mortal Fibonacci Rabbits

## Author     : ian.sealy@sanger.ac.uk
## Maintainer : ian.sealy@sanger.ac.uk
## Created    : 2015-04-11

use warnings;
use strict;
use autodie;
use Getopt::Long;
use Pod::Usage;
use Carp;
use version; our $VERSION = qv('v0.1.0');

use Path::Tiny;
use Memoize qw( memoize );
use bignum;

# Default options
my $dataset_file;
my ( $debug, $help, $man );

# Get and check command line options
get_and_check_options();

# Get input
my ( $input_n, $input_m ) = split /\s+/xms, path($dataset_file)->slurp;

# Print output
memoize('fib');
my ( $output_young, $output_mature ) = fib( $input_n, $input_m );
printf "%s\n", $output_young + $output_mature;

# Fibonacci recursive function
sub fib {
    my ( $n, $m ) = @_;

    if ( $n < 1 ) {
        return 0, 0;
    }
    elsif ( $n == 1 ) {
        return 1, 0;
    }
    elsif ( $n == 2 ) {
        return 0, 1;
    }

    my ( $young_prev,   $mature_prev )   = fib( $n - 1,  $m );
    my ( $young_prev_m, $mature_prev_m ) = fib( $n - $m, $m );
    my $young  = $mature_prev;
    my $mature = $mature_prev + $young_prev - $young_prev_m;

    return $young, $mature;
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

fibd.pl

Mortal Fibonacci Rabbits

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This script is given "Positive integers n≤100 and m≤20" and returns "The total
number of pairs of rabbits that will remain after the n-th month if all rabbits
live for m months".

=head1 EXAMPLES

    perl fibd.pl --dataset_file sample.txt

=head1 USAGE

    fibd.pl
        [--dataset_file file]
        [--debug]
        [--help]
        [--man]

=head1 OPTIONS

=over 8

=item B<--dataset_file FILE>

File containing "Positive integers n≤100 and m≤20".

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

This software is Copyright (c) 2015 by Genome Research Ltd.

This is free software, licensed under:

  The GNU General Public License, Version 3, June 2007

=cut
