#!/usr/bin/env python

"""This script is given "A DNA string of length at most 1 kbp in FASTA format"
and returns "The position and length of every reverse palindrome in the string
having length between 4 and 12. You may return these pairs in any order".
"""

import sys
import argparse

# Ensure maketrans works in Python 2 and 3
if sys.version_info[0] >= 3:
    maketrans = str.maketrans
else:
    import string
    maketrans = string.maketrans


def main(args):
    """Locating Restriction Sites"""

    _, seq = next(read_fasta(args.dataset))

    for pos in range(len(seq)):
        for length in range(2, 6 + 1):
            if pos + length * 2 > len(seq):
                continue
            seq1 = seq[pos:pos + length]
            seq2 = revcomp(seq[pos + length:pos + 2 * length])
            if seq1 == seq2:
                print('{:d} {:d}'.format(pos + 1, length * 2))


def revcomp(seq):
    """Reverse complement a DNA sequence"""

    return(seq.translate(maketrans('ACGT', 'TGCA'))[::-1])


def read_fasta(file):
    """Read FASTA file record by record"""

    id = None
    seq = []
    for line in file:
        line = line.rstrip()
        if line.startswith('>'):
            if id:
                yield(id, ''.join(seq))
            id = line.lstrip('>')
            seq = []
        else:
            seq.append(line)
    if id:
        yield(id, ''.join(seq))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Locating Restriction Sites')
    parser.add_argument(
        'dataset', metavar='FILE', type=argparse.FileType('r'),
        help='A DNA string of length at most 1 kbp in FASTA format')
    args = parser.parse_args()

    main(args)
