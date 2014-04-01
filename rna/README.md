# Notes on Transcribing DNA into RNA

http://rosalind.info/problems/rna/

## Command line version:

```
sed -e 's/T/U/g' sample.txt
```

## Other solutions:

### Perl

* https://gist.github.com/EBuschNentwich/9895756

### Python

* https://gist.github.com/richysix/55511481271f37f82285

* ```print (''.join([line.strip().replace("T","U") for line in open('sample.txt')]))```

### C

* https://gist.github.com/jazberna/9765921

### Command line

* https://gist.github.com/richysix/a652bc5862afaadf419c
