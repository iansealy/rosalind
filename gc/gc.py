#!/usr/bin/env python

"""This script is given "At most 10 DNA strings in FASTA format (of length at
most 1 kbp each)" and returns "The ID of the string having the highest
GC-content, followed by the GC-content of that string".
"""

import argparse

def main(args):
    """Computing GC Content"""

    high_id = None
    high_gc = 0

    for id, seq in read_fasta(args.dataset):
        count = [seq.count(base) for base in ['C', 'G']]
        gc = ( count[0] + count[1] ) / len(seq)
        if gc > high_gc:
            high_id = id
            high_gc = gc

    print(high_id)
    print('{:.3f}'.format(high_gc * 100))

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
    parser = argparse.ArgumentParser(description='Computing GC Content')
    parser.add_argument('dataset', metavar='FILE', type=argparse.FileType('r'),
        help='At most 10 DNA strings in FASTA format (of length at most 1 kbp each)')
    args = parser.parse_args()

    main(args)
