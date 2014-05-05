#!/usr/bin/env python

"""This script is given "Positive integers n≤40 and k≤5" and returns "The total
number of rabbit pairs that will be present after n months if we begin with 1
pair and in each generation, every pair of reproduction-age rabbits produces a
litter of k rabbit pairs (instead of only 1 pair)".
"""

import argparse
from functools import lru_cache

def main(args):
    """Rabbits and Recurrence Relations"""

    (n, k) = args.dataset.read().split()

    print(fib(int(n), int(k)))

@lru_cache()
def fib(n, k):
    """Fibonacci recursive function"""

    if n == 1 or n == 2:
        return 1

    return fib( n - 1, k ) + fib( n - 2, k ) * k;

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Rabbits and Recurrence Relations')
    parser.add_argument('dataset', metavar='FILE', type=argparse.FileType('r'),
        help='Positive integers n≤40 and k≤5')
    args = parser.parse_args()

    main(args)
