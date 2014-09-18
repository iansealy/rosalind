#!/usr/bin/env python

"""This script is given "Two DNA strings s and t (each of length at most 1
kbp)" and returns "All locations of t as a substring of s".
"""

import argparse


def main(args):
    """Finding a Motif in DNA"""

    (s, t) = [line.rstrip() for line in args.dataset]

    print(' '.join(str(location) for location in get_location(s, t)))


def get_location(string, substring):
    """Get locations of substring in string location by location"""

    location = 0
    try:
        while True:
            location = string.index(substring, location) + 1
            yield location
    except ValueError:
        pass

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Finding a Motif in DNA')
    parser.add_argument(
        'dataset', metavar='FILE', type=argparse.FileType('r'),
        help='Two DNA strings s and t (each of length at most 1 kbp)')
    args = parser.parse_args()

    main(args)
