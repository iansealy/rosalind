#!/usr/bin/env perl

# PODNAME: cons.pl
# ABSTRACT: Consensus and Profile

## Author     : ian.sealy@sanger.ac.uk
## Maintainer : ian.sealy@sanger.ac.uk
## Created    : 2014-07-20

use warnings;
use strict;
use autodie;
use Getopt::Long;
use Pod::Usage;
use Carp;
use version; our $VERSION = qv('v0.1.0');

use English qw( -no_match_vars );

# Default options
my $dataset_file;
my ( $debug, $help, $man );

# Get and check command line options
get_and_check_options();

# Split records by > rather than line by line
local $INPUT_RECORD_SEPARATOR = q{>};

# Get input and make profile
my @profile;
open my $fh, '<', $dataset_file;    ## no critic (RequireBriefOpen)
my $discard = <$fh>;                # Discard initial empty record
while ( my $fasta_record = <$fh> ) {
    my ( undef, @seq ) = split /\n/xms, $fasta_record;
    my $seq = join q{}, @seq;
    $seq =~ s/[>\n]//xmsg;
    foreach my $i ( 0 .. ( length $seq ) - 1 ) {
        my $base = substr $seq, $i, 1;
        $profile[$i]->{$base}++;
    }
}
close $fh;

# Construct consensus string
my $consensus = q{};
foreach my $i ( 0 .. $#profile ) {
    $consensus .= (
        reverse sort { $profile[$i]->{$a} <=> $profile[$i]->{$b} }
          keys %{ $profile[$i] }
    )[0];
}

# Output
printf "%s\n", $consensus;
foreach my $base (qw( A C G T )) {
    my @counts = map { $_->{$base} || 0 } @profile;
    printf "%s: %s\n", $base, join q{ }, @counts;
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

cons.pl

Consensus and Profile

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This script is given "A collection of at most 10 DNA strings of equal length (at
most 1 kbp) in FASTA format" and returns "A consensus string and profile matrix
for the collection".

=head1 EXAMPLES

    perl cons.pl --dataset_file sample.txt

=head1 USAGE

    cons.pl
        [--dataset_file file]
        [--debug]
        [--help]
        [--man]

=head1 OPTIONS

=over 8

=item B<--dataset_file FILE>

File containing "A collection of at most 10 DNA strings of equal length (at most
1 kbp) in FASTA format".

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
