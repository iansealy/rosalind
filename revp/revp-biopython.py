#!/usr/bin/env python

"""This script is given "A DNA string of length at most 1 kbp in FASTA format"
and returns "The position and length of every reverse palindrome in the string
having length between 4 and 12. You may return these pairs in any order".
"""

import argparse
from Bio import SeqIO
from Bio.Alphabet import generic_dna


def main(args):
    """Locating Restriction Sites"""

    record = next(SeqIO.parse(args.dataset, 'fasta', generic_dna))
    seq = str(record.seq)
    revc = str(record.reverse_complement().seq)

    for pos in range(len(seq)):
        for length in range(2, 6 + 1):
            if pos + length * 2 > len(seq):
                continue
            seq1 = seq[pos:pos + length]
            seq2 = revc[-(pos + 2 * length):-(pos + length)]
            if seq1 == seq2:
                print('{:d} {:d}'.format(pos + 1, length * 2))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Locating Restriction Sites')
    parser.add_argument(
        'dataset', metavar='FILE', type=argparse.FileType('r'),
        help='A DNA string of length at most 1 kbp in FASTA format')
    args = parser.parse_args()

    main(args)
