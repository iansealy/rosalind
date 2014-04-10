#!/usr/bin/env python

"""This script is given "A DNA string s of length at most 1000 nt" and returns
"Four integers (separated by spaces) counting the respective number of times
that the symbols 'A', 'C', 'G', and 'T' occur in s".
"""

import argparse

def main(args):
    """Counting DNA Nucleotides"""

    s = args.dataset.read()

    output = [s.count(base) for base in ['A', 'C', 'G', 'T']]

    print('{0[0]} {0[1]} {0[2]} {0[3]}'.format(output))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Counting DNA Nucleotides')
    parser.add_argument('dataset', metavar='FILE', type=argparse.FileType('r'),
        help='File containing "A DNA string s of length at most 1000 nt')
    args = parser.parse_args()

    main(args)
