#!/usr/bin/env bash

# note: this script opens the input file in 'fd3' file descriptor 3.
# I did this because there was an issue where the input file lines were deleted
# within the while loop. FD3 prevents this by keeping the input separate from loop

# input file is first argument on the command line
INPUT_FILE="$1"

# raise error if no input file specified
if [[ -z "$INPUT_FILE" ]]; then
  echo "Usage: $0 accessions.txt"
  exit 1
fi

# open fd 3 for reading the input file
exec 3< "$INPUT_FILE"

# trouble shooting - print column names of output table
echo -e "ContigAccession\tAssemblyAccession"

# loop, reading from fd 3 only
while IFS= read -r ACC <&3; do

  # skip blank lines
  [[ -z "$ACC" ]] && continue

  # first attempt is searching Assembly database directly 
  # catches accessions that are directly linked to the assemblies in the input file
  RESULT=$(esearch -db assembly -query "$ACC" 2>/dev/null \
           | esummary                  2>/dev/null \
           | xtract -pattern DocumentSummary \
                    -element AssemblyAccession 2>/dev/null)

  # if first attempt doesn't find anything, search nucleotide database and link
  # record to its assembly
  if [[ -z "$RESULT" ]]; then
    RESULT=$(esearch -db nuccore -query "$ACC"       2>/dev/null \
             | elink -target assembly                 2>/dev/null \
             | esummary                               2>/dev/null \
             | xtract -pattern DocumentSummary \
                      -element AssemblyAccession       2>/dev/null)
  fi

  # print the original contig accession and its matching assembly accession 
  # if no assembly found, NOT_FOUND is printed
  printf "%s\t%s\n" "$ACC" "${RESULT:-NOT_FOUND}"
done

# close fd 3
exec 3<&-

