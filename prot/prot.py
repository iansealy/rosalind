#!/usr/bin/env python

"""This script is given "An RNA string s corresponding to a strand of mRNA (of
length at most 10 kbp)" and returns "The protein string encoded by s".
"""

import argparse

def main(args):
    """Translating RNA into Protein"""

    AMINO_ACID_FOR = {
        'AAA': 'K',
        'AAC': 'N',
        'AAG': 'K',
        'AAU': 'N',
        'ACA': 'T',
        'ACC': 'T',
        'ACG': 'T',
        'ACU': 'T',
        'AGA': 'R',
        'AGC': 'S',
        'AGG': 'R',
        'AGU': 'S',
        'AUA': 'I',
        'AUC': 'I',
        'AUG': 'M',
        'AUU': 'I',
        'CAA': 'Q',
        'CAC': 'H',
        'CAG': 'Q',
        'CAU': 'H',
        'CCA': 'P',
        'CCC': 'P',
        'CCG': 'P',
        'CCU': 'P',
        'CGA': 'R',
        'CGC': 'R',
        'CGG': 'R',
        'CGU': 'R',
        'CUA': 'L',
        'CUC': 'L',
        'CUG': 'L',
        'CUU': 'L',
        'GAA': 'E',
        'GAC': 'D',
        'GAG': 'E',
        'GAU': 'D',
        'GCA': 'A',
        'GCC': 'A',
        'GCG': 'A',
        'GCU': 'A',
        'GGA': 'G',
        'GGC': 'G',
        'GGG': 'G',
        'GGU': 'G',
        'GUA': 'V',
        'GUC': 'V',
        'GUG': 'V',
        'GUU': 'V',
        'UAA': '',
        'UAC': 'Y',
        'UAG': '',
        'UAU': 'Y',
        'UCA': 'S',
        'UCC': 'S',
        'UCG': 'S',
        'UCU': 'S',
        'UGA': '',
        'UGC': 'C',
        'UGG': 'W',
        'UGU': 'C',
        'UUA': 'L',
        'UUC': 'F',
        'UUG': 'L',
        'UUU': 'F',
    }

    s = args.dataset.read().rstrip()

    # Translate
    peptide = []
    for codon in get_codon(s):
        peptide.append(AMINO_ACID_FOR[codon])
    print(''.join(peptide))

def get_codon(rna):
    """Get RNA codon by codon"""

    for i in range(0, len(rna), 3):
        yield rna[i:i+3]

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Translating RNA into Protein')
    parser.add_argument('dataset', metavar='FILE', type=argparse.FileType('r'),
        help='An RNA string s corresponding to a strand of mRNA (of length at most 10 kbp)')
    args = parser.parse_args()

    main(args)
