#!/usr/bin/env perl

# PODNAME: fib.pl
# ABSTRACT: Rabbits and Recurrence Relations

## Author     : ian.sealy@sanger.ac.uk
## Maintainer : ian.sealy@sanger.ac.uk
## Created    : 2014-05-05

use warnings;
use strict;
use autodie;
use Getopt::Long;
use Pod::Usage;
use Carp;
use version; our $VERSION = qv('v0.1.0');

use File::Slurp;
use Memoize qw( memoize );

# Default options
my $dataset_file;
my ( $debug, $help, $man );

# Get and check command line options
get_and_check_options();

# Get input
my ( $input_n, $input_k ) = split /\s+/xms, read_file($dataset_file);

# Print output
memoize('fib');
printf "%d\n", fib( $input_n, $input_k );

# Fibonacci recursive function
sub fib {
    my ( $n, $k ) = @_;

    if ( $n == 1 || $n == 2 ) {
        return 1;
    }

    return fib( $n - 1, $k ) + fib( $n - 2, $k ) * $k;
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

fib.pl

Rabbits and Recurrence Relations

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This script is given "Positive integers n≤40 and k≤5" and returns "The total
number of rabbit pairs that will be present after n months if we begin with 1
pair and in each generation, every pair of reproduction-age rabbits produces a
litter of k rabbit pairs (instead of only 1 pair)".

=head1 EXAMPLES

    perl fib.pl --dataset_file sample.txt

=head1 USAGE

    fib.pl
        [--dataset_file file]
        [--debug]
        [--help]
        [--man]

=head1 OPTIONS

=over 8

=item B<--dataset_file FILE>

File containing "Positive integers n≤40 and k≤5".

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
