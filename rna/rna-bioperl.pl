#!/usr/bin/env perl

# PODNAME: rna-bioperl.pl
# ABSTRACT: Transcribing DNA into RNA

## Author     : ian.sealy@sanger.ac.uk
## Maintainer : ian.sealy@sanger.ac.uk
## Created    : 2014-03-24

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
    -alphabet => 'dna',
);
my $t = $in->next_seq;

# Transcribe
print $t->transcribe->seq, "\n";

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

rna-bioperl.pl

Transcribing DNA into RNA

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This script is given "A DNA string t having length at most 1000 nt" and returns
"The transcribed RNA string of t".

=head1 EXAMPLES

    perl rna-bioperl.pl --dataset_file sample.txt

=head1 USAGE

    rna-bioperl.pl
        [--dataset_file file]
        [--debug]
        [--help]
        [--man]

=head1 OPTIONS

=over 8

=item B<--dataset_file FILE>

File containing "A DNA string t having length at most 1000 nt".

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
