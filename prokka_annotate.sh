#!/usr/bin/env bash

INDIR=~/cyano_full/mag_representative_genomes/mag_genomes/ncbi_dataset/data
OUTDIR=~/cyano_full/representative_genomes/prokka_annotations
CPUS=15

# make output directory
mkdir -p "$OUTDIR"

# loop through every downloaded NCBI genome folder
for dir in "$INDIR"/GCF_*; do
  base=$(basename "$dir")
  out="$OUTDIR/$base"

  # use main genomic fasta file (not the cds_from file)
  fna=$(find "$dir" -maxdepth 1 -type f \
        -name "*_genomic.fna" \
        ! -name "*cds_from_genomic.fna" \
        | head -n1)

  # if no genomic fasta, skip folder and give output showing issue
  if [[ -z "$fna" ]]; then
    echo "[SKIP] no *_genomic.fna (genome) found in $base"
    continue
  fi

  echo "[RUN] Annotating (force) $base → $out"
  
  # run prokka (plus delete any previous prokka annotation for genome if previous fail)
  mkdir -p "$out"
  prokka \
    --force \
    --outdir "$out" \
    --prefix "$base" \
    --cpus "$CPUS" \
    --locustag "$base" \
    "$fna"
done

