#!/usr/bin/env perl

# PODNAME: grph.pl
# ABSTRACT: Overlap Graphs

## Author     : ian.sealy@sanger.ac.uk
## Maintainer : ian.sealy@sanger.ac.uk
## Created    : 2015-04-25

use warnings;
use strict;
use autodie;
use Getopt::Long;
use Pod::Usage;
use Carp;
use version; our $VERSION = qv('v0.1.0');

use English qw( -no_match_vars );
use Readonly;

# Overlap constant
Readonly our $OVERLAP => 3;

# Default options
my $dataset_file;
my ( $debug, $help, $man );

# Get and check command line options
get_and_check_options();

my $seq_by_prefix = get_prefixes( $dataset_file, $OVERLAP );

my $graph = get_overlap_graph( $dataset_file, $OVERLAP, $seq_by_prefix );

# Print output
foreach my $node1 ( sort keys %{$graph} ) {
    foreach my $node2 ( sort keys %{ $graph->{$node1} } ) {
        printf "%s %s\n", $node1, $node2;
    }
}

# Get prefixes of each sequence in FASTA file
sub get_prefixes {
    my ( $fasta_file, $overlap ) = @_;

    # Split records by > rather than line by line
    local $INPUT_RECORD_SEPARATOR = q{>};

    # Get input and get prefix
    my $seq_by_prefix = {};    ## no critic (ProhibitReusedNames)
    open my $fh, '<', $dataset_file;
    my $discard = <$fh>;       # Discard initial empty record
    while ( my $fasta_record = <$fh> ) {
        my ( $id, @seq ) = split /\n/xms, $fasta_record;
        my $seq = join q{}, @seq;
        $seq =~ s/[>\n]//xmsg;
        my $prefix = substr $seq, 0, $overlap;
        push @{ $seq_by_prefix->{$prefix} }, $id;
    }
    close $fh;

    return $seq_by_prefix;
}

# Get overlap graph of FASTA file
sub get_overlap_graph {
    ## no critic (ProhibitReusedNames)
    my ( $fasta_file, $overlap, $seq_by_prefix ) = @_;
    ## use critic

    # Split records by > rather than line by line
    local $INPUT_RECORD_SEPARATOR = q{>};

    # Get input and get prefix
    my $graph = {};    ## no critic (ProhibitReusedNames)
    open my $fh, '<', $dataset_file;    ## no critic (RequireBriefOpen)
    my $discard = <$fh>;                # Discard initial empty record
    while ( my $fasta_record = <$fh> ) {
        my ( $id, @seq ) = split /\n/xms, $fasta_record;
        my $seq = join q{}, @seq;
        $seq =~ s/[>\n]//xmsg;
        my $suffix = substr $seq, -$overlap, $overlap;
        if ( exists $seq_by_prefix->{$suffix} ) {
            foreach my $overlap_id ( @{ $seq_by_prefix->{$suffix} } ) {
                next if $id eq $overlap_id;
                $graph->{$id}{$overlap_id} = 1;
            }
        }
    }
    close $fh;

    return $graph;
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

grph.pl

Overlap Graphs

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This script is given "A collection of DNA strings in FASTA format having total
length at most 10 kbp" and returns "The adjacency list corresponding to O3. You
may return edges in any order".

=head1 EXAMPLES

    perl grph.pl --dataset_file sample.txt

=head1 USAGE

    grph.pl
        [--dataset_file file]
        [--debug]
        [--help]
        [--man]

=head1 OPTIONS

=over 8

=item B<--dataset_file FILE>

File containing "A collection of DNA strings in FASTA format having total length
at most 10 kbp".

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
