#!/usr/bin/env python

"""This script is given "A collection of at most 10 DNA strings of equal length
(at most 1 kbp) in FASTA format" and returns "A consensus string and profile
matrix for the collection".
"""

import argparse
from Bio import SeqIO
from Bio import motifs
from Bio.Alphabet import generic_dna


def main(args):
    """Consensus and Profile"""

    seqs = [record.seq for record in SeqIO.parse(args.dataset, 'fasta',
                                                 generic_dna)]
    profile = motifs.create(seqs)
    print(profile.consensus)
    for base in 'ACGT':
        print(base + ':',
              ' '.join(str(count) for count in profile.counts[base]))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Consensus and Profile')
    parser.add_argument(
        'dataset', metavar='FILE', type=argparse.FileType('r'),
        help='A collection of at most 10 DNA strings of equal length '
        '(at most 1 kbp) in FASTA format')
    args = parser.parse_args()

    main(args)
