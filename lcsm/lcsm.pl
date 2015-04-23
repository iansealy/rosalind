#!/usr/bin/env perl

# PODNAME: lcsm.pl
# ABSTRACT: Finding a Shared Motif

## Author     : ian.sealy@sanger.ac.uk
## Maintainer : ian.sealy@sanger.ac.uk
## Created    : 2015-04-12

use warnings;
use strict;
use autodie;
use Getopt::Long;
use Pod::Usage;
use Carp;
use version; our $VERSION = qv('v0.1.0');

use English qw( -no_match_vars );
use List::Util qw(max);

# Default options
my $dataset_file;
my ( $debug, $help, $man );

# Get and check command line options
get_and_check_options();

# Split records by > rather than line by line
local $INPUT_RECORD_SEPARATOR = q{>};

# Get input and make suffix trie
my $num_seqs = 0;
my $trie     = { 0 => undef };    # Root
my $ancestor = {};
open my $fh, '<', $dataset_file;    ## no critic (RequireBriefOpen)
my $discard = <$fh>;                # Discard initial empty record
while ( my $fasta_record = <$fh> ) {
    my ( undef, @seq ) = split /\n/xms, $fasta_record;
    my $seq = join q{}, @seq;
    $seq =~ s/[>\n]//xmsg;
    ( $trie, $ancestor ) =
      add_to_suffix_trie( $trie, $ancestor, $num_seqs, $seq );
    $num_seqs++;
}
close $fh;

# Print output
printf "%s\n",
  get_longest_common_substring( $trie, $ancestor, $num_seqs, 0, q{} );

# Add to suffix trie
sub add_to_suffix_trie {
    ## no critic (ProhibitReusedNames)
    my ( $trie, $ancestor, $id, $seq ) = @_;
    ## use critic

    $seq .= q{$};    # Terminal symbol

    my $new_node = max( keys %{$trie} ) + 1;

    foreach my $i ( 0 .. ( length $seq ) - 1 ) {
        my $current_node = 0;    # Root
        foreach my $j ( $i .. ( length $seq ) - 1 ) {
            my $symbol = substr $seq, $j, 1;
            $ancestor->{$current_node}{$id} = 1;
            if ( exists $trie->{$current_node}{$symbol} ) {

                # Existing node
                $current_node = $trie->{$current_node}{$symbol};
            }
            elsif ( $symbol ne q{$} ) {

                # New node
                $trie->{$current_node}{$symbol} = $new_node;
                $trie->{$new_node}              = undef;
                $current_node                   = $new_node;
                $new_node++;
            }
            else {
                # Terminal symbol
                $trie->{$current_node}{$symbol} = undef;
            }
        }
    }

    return $trie, $ancestor;
}

# Get longest common substring by DFS
sub get_longest_common_substring {
    ## no critic (ProhibitReusedNames)
    my ( $trie, $ancestor, $num_seqs, $node, $seq ) = @_;
    ## use critic

    my @seqs = ($seq);
    foreach my $symbol ( keys %{ $trie->{$node} } ) {
        next if $symbol eq q{$};
        my $next_node = $trie->{$node}{$symbol};
        next if scalar keys %{ $ancestor->{$next_node} } < $num_seqs;
        push @seqs,
          get_longest_common_substring( $trie, $ancestor, $num_seqs, $next_node,
            $seq . $symbol );
    }

    return ( reverse sort { length $a <=> length $b } @seqs )[0];
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

lcsm.pl

Finding a Shared Motif

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This script is given "A collection of k (k≤100) DNA strings of length at most 1
kbp each in FASTA format" and returns "A longest common substring of the
collection".

=head1 EXAMPLES

    perl lcsm.pl --dataset_file sample.txt

=head1 USAGE

    lcsm.pl
        [--dataset_file file]
        [--debug]
        [--help]
        [--man]

=head1 OPTIONS

=over 8

=item B<--dataset_file FILE>

File containing "A collection of k (k≤100) DNA strings of length at most 1 kbp
each in FASTA format".

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
