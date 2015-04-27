#!/usr/bin/env python

"""This script is given "A collection of DNA strings in FASTA format having
total length at most 10 kbp" and returns "The adjacency list corresponding to
O3. You may return edges in any order".
"""

import argparse
from Bio import SeqIO
from Bio.Alphabet import generic_dna


def main(args):
    """Overlap Graphs"""

    # Overlap constant
    OVERLAP = 3

    seq_by_prefix = {}
    for record in SeqIO.parse(args.dataset, 'fasta', generic_dna):
        try:
            seq_by_prefix[str(record.seq[:OVERLAP])].append(record.id)
        except KeyError:
            seq_by_prefix[str(record.seq[:OVERLAP])] = [record.id]

    graph = {}
    args.dataset.seek(0)
    for record in SeqIO.parse(args.dataset, 'fasta', generic_dna):
        suffix = str(record.seq[-OVERLAP:])
        try:
            for overlap_id in seq_by_prefix[suffix]:
                if record.id == overlap_id:
                    continue
                try:
                    graph[record.id][overlap_id] = True
                except KeyError:
                    graph[record.id] = {}
                    graph[record.id][overlap_id] = True
        except:
            pass

    for id1 in graph:
        for id2 in graph[id1]:
            print('{:s} {:s}'.format(id1, id2))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Overlap Graphs')
    parser.add_argument(
        'dataset', metavar='FILE', type=argparse.FileType('r'),
        help='A collection of DNA strings in FASTA format '
        'having total length at most 10 kbp')
    args = parser.parse_args()

    main(args)
