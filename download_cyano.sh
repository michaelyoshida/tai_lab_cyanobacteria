#!/bin/bash

#input file that contains one genome accession per line
ACCESSION_LIST="MAG_assembly_accessions.txt"

# directory where downloaded genome zip files will be stored
ZIP_DIR="mag_representative_genomes/zips"

# output text files listing the downloaded zip files for later steps
GFF_LIST="cyano_gff_zips.txt"
FASTA_LIST="cyano_fasta_zips.txt"

# make zip directory as specified above
mkdir -p "$ZIP_DIR"

#bug fix - clear old file lists before starting a new download attempt
> "$GFF_LIST"
> "$FASTA_LIST"

# loop through each accession in the input list
while IFS= read -r acc; do
  [[ -z "$acc" ]] && continue

  # optional status to bug fix case where files weren't downloading 
  echo "Downloading $acc..."

  # download genome data zip
  datasets download genome accession "$acc" \
    --include genome,gff3,cds,protein \
    --filename "${ZIP_DIR}/${acc}.zip"

  # check if download succeeded (bug fix)
  if [ -f "${ZIP_DIR}/${acc}.zip" ]; then
    echo "${ZIP_DIR}/${acc}.zip" >> "$GFF_LIST"
    echo "${ZIP_DIR}/${acc}.zip" >> "$FASTA_LIST"
    echo "Saved: ${ZIP_DIR}/${acc}.zip"
  
  # show if download failed (also bug fix)
  else
    echo "Failed: $acc (no zip file created)"
  fi

done < "$ACCESSION_LIST"

