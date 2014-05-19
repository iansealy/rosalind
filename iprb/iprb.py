#!/usr/bin/env python

"""This script is given "Three positive integers k, m, and n, representing a
population containing k+m+n organisms: k individuals are homozygous dominant for
a factor, m are heterozygous, and n are homozygous recessive" and returns "The
probability that two randomly selected mating organisms will produce an
individual possessing a dominant allele (and thus displaying the dominant
phenotype)".
"""

import argparse

def main(args):
    """Mendel's First Law"""

    (k, m, n) = [int(x) for x in args.dataset.read().split()]

    # Genotype constants
    HOM_DOM   = 0
    HET       = 1
    HOM_REC   = 2
    GENOTYPES = ( HOM_DOM, HET, HOM_REC )

    prob_dom_phenotype = 0
    population = [ k, m, n ]
    for parent1 in GENOTYPES:
        parent1_prob = population[parent1] / sum(population)
        population[parent1] -= 1
        for parent2 in GENOTYPES:
            parent2_prob = population[parent2] / sum(population)
            parent_prob  = parent1_prob * parent2_prob
            if parent1 == HOM_DOM or parent2 == HOM_DOM:
                # If either parent is homozygous dominant then all offspring are
                # phenotypically dominant
                prob_dom_phenotype += parent_prob
            elif parent1 == HET and parent2 == HET:
                # If both parents are heterozygous then 3/4 of offspring are
                # phenotypically dominant
                prob_dom_phenotype += parent_prob * 3 / 4
            elif parent1 == HET or parent2 == HET:
                # If one parent is heterozygous then 1/2 of offspring are
                # phenotypically dominant
                prob_dom_phenotype += parent_prob * 1 / 2
        population[parent1] += 1 # Restore population

    print('{:.3f}'.format(prob_dom_phenotype))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Mendel's First Law")
    parser.add_argument('dataset', metavar='FILE', type=argparse.FileType('r'),
        help='Three positive integers k, m, and n, representing a population containing k+m+n organisms: k individuals are homozygous dominant for a factor, m are heterozygous, and n are homozygous recessive')
    args = parser.parse_args()

    main(args)
