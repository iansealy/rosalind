#!/usr/bin/env python

"""This script is given "Positive integers n≤100 and m≤20" and returns "The
total number of pairs of rabbits that will remain after the n-th month if all
rabbits live for m months".
"""

import argparse
from functools import lru_cache


def main(args):
    """Mortal Fibonacci Rabbits"""

    (n, m) = [int(x) for x in args.dataset.read().split()]

    print(sum(fib(n, m)))


@lru_cache()
def fib(n, m):
    """Fibonacci recursive function"""

    if n < 1:
        return 0, 0
    elif n == 1:
        return 1, 0
    elif n == 2:
        return 0, 1

    young_prev, mature_prev = fib(n - 1, m)
    young_prev_m, mature_prev_m = fib(n - m, m)
    young = mature_prev
    mature = mature_prev + young_prev - young_prev_m

    return young, mature

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Mortal Fibonacci Rabbits')
    parser.add_argument(
        'dataset', metavar='FILE', type=argparse.FileType('r'),
        help='Positive integers n≤100 and m≤20')
    args = parser.parse_args()

    main(args)
