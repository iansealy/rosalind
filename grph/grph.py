#!/usr/bin/env python

"""This script is given "A collection of DNA strings in FASTA format having
total length at most 10 kbp" and returns "The adjacency list corresponding to
O3. You may return edges in any order".
"""

import argparse


def main(args):
    """Overlap Graphs"""

    # Overlap constant
    OVERLAP = 3

    seq_by_prefix = {}
    for id, seq in read_fasta(args.dataset):
        try:
            seq_by_prefix[seq[:OVERLAP]].append(id)
        except KeyError:
            seq_by_prefix[seq[:OVERLAP]] = [id]

    graph = {}
    args.dataset.seek(0)
    for id, seq in read_fasta(args.dataset):
        suffix = seq[-OVERLAP:]
        try:
            for overlap_id in seq_by_prefix[suffix]:
                if id == overlap_id:
                    continue
                try:
                    graph[id][overlap_id] = True
                except KeyError:
                    graph[id] = {}
                    graph[id][overlap_id] = True
        except:
            pass

    for id1 in graph:
        for id2 in graph[id1]:
            print('{:s} {:s}'.format(id1, id2))


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
    parser = argparse.ArgumentParser(description='Overlap Graphs')
    parser.add_argument(
        'dataset', metavar='FILE', type=argparse.FileType('r'),
        help='A collection of DNA strings in FASTA format '
        'having total length at most 10 kbp')
    args = parser.parse_args()

    main(args)
