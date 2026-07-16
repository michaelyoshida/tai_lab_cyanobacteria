#!/bin/bash
#SBATCH --job-name=panaroo_noMAG_80
#SBATCH --cpus-per-task=32
#SBATCH --mem=128G
#SBATCH --time=2-00:00:00
#SBATCH --output=logs_panaroo/panaroo_noMAG_80_%j.out
#SBATCH --error=logs_panaroo/panaroo_noMAG_80_%j.err

cd /project/def-vtai4/kyoshid2

module load apptainer/1.3.5

# added this date prompt to benchmark how long this script took to complete
echo "[$(date)] Starting Panaroo (80% identity, strict clean) on Prokka noMAG set"

# actual Panaroo call in apptainer. 
apptainer exec docker://quay.io/biocontainers/panaroo:1.5.2--pyhdfd78af_0 \
  panaroo \
    -i panaroo_gff_list.txt \
    -o panaroo_noMAG_80 \
    --clean-mode strict \
    --remove-invalid-genes \
    -c 0.80 \
    -a core \
    --aligner mafft \
    -t 32

echo "[$(date)] Panaroo finished"
