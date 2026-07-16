#!/bin/bash
#SBATCH --job-name=prokka_noMAG
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=08:00:00
#SBATCH --array=0-1570
#SBATCH --output=prokka_noMAG_%A_%a.out
#SBATCH --error=prokka_noMAG_%A_%a.err

# runs one Prokka annotation job for each genome in "no_MAG_fna_list.txt"
cd /project/def-vtai4/kyoshid2

module load apptainer/1.3.5

# SLURM array task IDs begin at 1, but sed line numbers begin at 1. (bug fix)
FASTA=$(sed -n "$((SLURM_ARRAY_TASK_ID+1))p" no_MAG_fna_list.txt)

# stop task if corresponding line is empty
if [[ -z "$FASTA" ]]; then
  echo "Error: No FASTA found for task ID ${SLURM_ARRAY_TASK_ID}"
  exit 1
fi

# extract genome accession from the FASTA filename
BASE=$(basename "$FASTA" _genomic.fna)
OUTDIR="prokka_noMAG/${BASE}"
mkdir -p "$OUTDIR"

echo "[$(date)] Annotating $BASE from $FASTA"

# run Prokka inside the specified apptainer image
apptainer exec docker://quay.io/biocontainers/prokka:1.14.6--pl5321hdfd78af_5 \
  prokka \
    --outdir "$OUTDIR" \
    --prefix "$BASE" \
    --cpus 8 \
    --force \
    "$FASTA"
