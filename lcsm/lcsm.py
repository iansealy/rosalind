#!/usr/bin/env python

"""This script is given "A collection of k (k≤100) DNA strings of length at
most 1 kbp each in FASTA format" and returns "A longest common substring of the
collection".
"""

import argparse


def main(args):
    """Finding a Shared Motif"""

    seqs = sorted([seq for _, seq in read_fasta(args.dataset)], key=len)

    print(lcs(seqs))


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


def lcs(seqs):
    """Find longest common substring"""

    shortest_seq = seqs.pop(0)
    shortest_len = len(shortest_seq)
    motif = ''
    for motif_length in range(shortest_len + 1, 1, -1):
        for start in range(1, shortest_len - motif_length + 2):
            motif = shortest_seq[start:start+motif_length]
            got_lcs = True
            for seq in seqs:
                if seq.find(motif) == -1:
                    got_lcs = False
                    break
            if got_lcs:
                return motif

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Finding a Shared Motif')
    parser.add_argument(
        'dataset', metavar='FILE', type=argparse.FileType('r'),
        help='A collection of k (k≤100) DNA strings '
        'of length at most 1 kbp each in FASTA format')
    args = parser.parse_args()

    main(args)
