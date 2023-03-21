import sys
import argparse
from scgid.sequence import DNASequenceCollection, complement_dna

parser = argparse.ArgumentParser()
parser.add_argument("--fasta", action = "store", required = True, help = "FASTA file with sequences.")
parser.add_argument("--coordinates", action = "store", required = True, help = "3-column tsv file with contig header, start pos, stop pos.")
args = parser.parse_args()

### Need this until scgid.sequence is reimplemented better - like nit keying the index of DNASequenceCollections by full header
seqs_by_full_header = DNASequenceCollection().from_fasta(args.fasta)
seqs_by_accession = seqs_by_full_header
seqs_by_accession = DNASequenceCollection().from_dict({k.split(" ")[0]: v for k,v in seqs_by_accession.index.items()})

with open(args.coordinates, 'r') as coords:
    for line in coords:
        spl = [x.strip() for x in line.split("\t")]
        if len(spl) != 3:
            print("[ERROR] Malformed coordinates file.")
            sys.exit(1)

        else:
            header, start, stop = tuple(spl)

### Need this until scgid.sequence is reimplemented better - like nit keying the index of DNASequenceCollections by full header
            if header in seqs_by_full_header.index:
                seqs = seqs_by_full_header
            else:
                seqs = seqs_by_accession
            start = int(start)
            stop = int(stop)
            try:
                target = seqs.get(header)

            except KeyError:
                print (f"[ERROR] Sequence header does not exist in fasta: {header}")

            if start >= stop:
                print(f">{header}:{start}-{stop}\n{complement_dna(target.string[start:stop:-1])}")
            else:
                print(f">{header}:{start}-{stop}\n{target.string[start:stop:1]}")
