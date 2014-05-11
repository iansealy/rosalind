#!/usr/bin/env python

"""This script is given "Two DNA strings s and t of equal length (not exceeding
1 kbp)" and returns "The Hamming distance dH(s,t)".
"""

import argparse

def main(args):
    """Counting Point Mutations"""

    (s, t) = [line.rstrip() for line in args.dataset]

    print( len( [True for x, y in zip(s, t) if x != y] ) )

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Counting Point Mutations')
    parser.add_argument('dataset', metavar='FILE', type=argparse.FileType('r'),
        help='Two DNA strings s and t of equal length (not exceeding 1 kbp)')
    args = parser.parse_args()

    main(args)
