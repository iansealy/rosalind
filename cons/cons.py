#!/usr/bin/env python

"""This script is given "A collection of at most 10 DNA strings of equal length
(at most 1 kbp) in FASTA format" and returns "A consensus string and profile
matrix for the collection".
"""

import argparse
from collections import defaultdict

def main(args):
    """Consensus and Profile"""

    # Construct profile
    profile = []
    for _, seq in read_fasta(args.dataset):
        for i, base in enumerate(seq):
            if i >= len(profile):
                profile.append(defaultdict(int))
            profile[i][base] += 1

    print(''.join(max(counts, key=counts.get) for counts in profile))
    for base in 'ACGT':
        print(base + ':', ' '.join(str(counts[base]) for counts in profile))

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
    parser = argparse.ArgumentParser(description='Consensus and Profile')
    parser.add_argument('dataset', metavar='FILE', type=argparse.FileType('r'),
        help='A collection of at most 10 DNA strings of equal length (at most 1 kbp) in FASTA format')
    args = parser.parse_args()

    main(args)
