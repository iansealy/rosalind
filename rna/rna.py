#!/usr/bin/env python

"""This script is given "A DNA string t having length at most 1000 nt" and
returns "The transcribed RNA string of t".
"""

from __future__ import print_function
import argparse

def main(args):
    """Transcribing DNA into RNA"""

    t = args.dataset.read()

    print(t.replace('T', 'U'), end='')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Transcribing DNA into RNA')
    parser.add_argument('dataset', metavar='FILE', type=argparse.FileType('r'),
        help='File containing "A DNA string t having length at most 1000 nt')
    args = parser.parse_args()

    main(args)
