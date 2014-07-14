#!/usr/bin/env python

"""This script is given "An RNA string s corresponding to a strand of mRNA (of
length at most 10 kbp)" and returns "The protein string encoded by s".
"""

import argparse
from Bio.Seq import Seq
from Bio.Alphabet import generic_rna

def main(args):
    """Translating RNA into Protein"""

    s = Seq(args.dataset.read().rstrip(), generic_rna)
    print(s.translate(stop_symbol=''))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Translating RNA into Protein')
    parser.add_argument('dataset', metavar='FILE', type=argparse.FileType('r'),
        help='An RNA string s corresponding to a strand of mRNA (of length at most 10 kbp)')
    args = parser.parse_args()

    main(args)
