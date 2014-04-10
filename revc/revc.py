#!/usr/bin/env python

"""This script is given "A DNA string s of length at most 1000 bp" and
returns "The reverse complement sc of s".
"""

import argparse

def main(args):
    """Complementing a Strand of DNA"""

    s = args.dataset.read()

    print(s.rstrip().translate(str.maketrans('ACGT', 'TGCA'))[::-1])

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Complementing a Strand of DNA')
    parser.add_argument('dataset', metavar='FILE', type=argparse.FileType('r'),
        help='A DNA string s of length at most 1000 bp')
    args = parser.parse_args()

    main(args)
