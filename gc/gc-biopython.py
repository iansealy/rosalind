#!/usr/bin/env python

"""This script is given "At most 10 DNA strings in FASTA format (of length at
most 1 kbp each)" and returns "The ID of the string having the highest
GC-content, followed by the GC-content of that string".
"""

import argparse
from Bio import SeqIO
from Bio.Alphabet import generic_dna
from Bio.SeqUtils import GC

def main(args):
    """Computing GC Content"""

    high_id = None
    high_gc = 0

    for record in SeqIO.parse(args.dataset, 'fasta', generic_dna):
        gc = GC(record.seq)
        if gc > high_gc:
            high_id = record.id
            high_gc = gc

    print(high_id)
    print('{:.3f}'.format(high_gc))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Computing GC Content')
    parser.add_argument('dataset', metavar='FILE', type=argparse.FileType('r'),
        help='At most 10 DNA strings in FASTA format (of length at most 1 kbp each)')
    args = parser.parse_args()

    main(args)
