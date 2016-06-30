#!/usr/bin/env perl

# PODNAME: hamm.pl
# ABSTRACT: Counting Point Mutations

## Author     : ian.sealy@sanger.ac.uk
## Maintainer : ian.sealy@sanger.ac.uk
## Created    : 2014-05-11

use warnings;
use strict;
use autodie;
use Getopt::Long;
use Pod::Usage;
use Carp;
use version; our $VERSION = qv('v0.1.0');

use Path::Tiny;

# Default options
my $dataset_file;
my ( $debug, $help, $man );

# Get and check command line options
get_and_check_options();

# Get input
my ( $s, $t ) = path($dataset_file)->lines;

# Calculate Hamming distance
my $distance = ( $s ^ $t ) =~ tr/\0//c;

# Output
printf "%d\n", $distance;

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

hamm.pl

Counting Point Mutations

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This script is given "Two DNA strings s and t of equal length (not exceeding 1
kbp)" and returns "The Hamming distance dH(s,t)".

=head1 EXAMPLES

    perl hamm.pl --dataset_file sample.txt

=head1 USAGE

    hamm.pl
        [--dataset_file file]
        [--debug]
        [--help]
        [--man]

=head1 OPTIONS

=over 8

=item B<--dataset_file FILE>

File containing "Two DNA strings s and t of equal length (not exceeding 1 kbp)".

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
