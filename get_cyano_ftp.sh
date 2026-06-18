#!/usr/bin/env bash

INPUT="gcf_list.txt"
OUT="cyano_rep_ncbigenomes_ftp.txt"

# Open INPUT on fd 3 (see getassemblyaccessions.sh for reasoning to use fd3)
exec 3< "$INPUT"

# create output file
: > "$OUT"

while IFS= read -r GCF <&3; do
  [[ -z "$GCF" ]] && continue

  # look up each assembly accession and save its RefSeq FTP path
  esearch -db assembly -query "$GCF" \
    | esummary \
    | xtract -pattern DocumentSummary -element FtpPath_RefSeq \
    >> "$OUT"
done

# close fd 3
exec 3<&-

