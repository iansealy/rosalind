# Notes on Counting DNA Nucleotides

http://rosalind.info/problems/dna/

## Command line version:

```
for base in A C G T; do echo -n $base && grep -o $base sample.txt | wc -l; done
```

## Timings:

### Ian

```
time for x in `seq 100`; do perl dna.pl --dataset_file sample.txt > /dev/null; done
```

```
real    0m10.678s
user    0m9.103s
sys     0m0.976s
```

```
time for x in `seq 100`; do perl dna-bioperl.pl --dataset_file sample.txt > /dev/null; done
```

```
real    0m17.084s
user    0m13.997s
sys     0m1.597s
```

```
time for x in `seq 100`; do python dna.py sample.txt > /dev/null; done
```

```
real    0m4.428s
user    0m2.828s
sys     0m1.258s
```

```
time for x in `seq 100`; do for base in A C G T; do echo -n $base && grep -o $base sample.txt | wc -l; done > /dev/null; done
```

```
real    0m1.070s
user    0m0.553s
sys     0m1.207s
```

### Jorge

```
time for x in `seq 100`; do 9685358/count_dna < sample.txt > /dev/null; done
```

```
real    0m0.223s
user    0m0.053s
sys     0m0.120s
```

### Peter

```
time for x in `seq 100`; do python 92fe9d3967192d093560/rosalind1.py > /dev/null; done
```

```
real    0m3.139s
user    0m2.003s
sys     0m0.897s
```

### Rich

```
time for x in `seq 100`; do perl e3aee011a5a150b3856b/nucleotide_count.pl < sample.txt > /dev/null; done
```

```
real    0m0.865s
user    0m0.364s
sys     0m0.239s
```

```
time for x in `seq 100`; do python dbfa59336f196180988e/nuc_count.py sample.txt > /dev/null; done
```

```
real    0m3.193s
user    0m2.051s
sys     0m0.897s
```
