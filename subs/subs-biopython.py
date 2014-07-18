#!/usr/bin/env python

"""This script is given "Two DNA strings s and t (each of length at most 1 kbp)"
and returns "All locations of t as a substring of s".
"""

import argparse
from Bio import pairwise2

def main(args):
    """Finding a Motif in DNA"""

    (s, t) = [line.rstrip() for line in args.dataset]

    # Do local alignment with identical bases scoring 1 (otherwise 0) and gap
    # opening and extending penalties of -1
    # e.g. ('GATATATGCATATACTT', '---------ATAT----', 4.0, 9, 13)
    locations = [align[3] + 1 for align in pairwise2.align.localxs(s, t, -1, -1)]
    print(' '.join(str(location) for location in sorted(locations)))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Finding a Motif in DNA')
    parser.add_argument('dataset', metavar='FILE', type=argparse.FileType('r'),
        help='Two DNA strings s and t (each of length at most 1 kbp)')
    args = parser.parse_args()

    main(args)
