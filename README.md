This is the repository made by Michael Yoshida for his work in the Tai Lab from 2024-2026 on analyzing the accessory genome of various cyanobacteria. 

Scripts:
1. getassemblyaccessions.sh - this script takes contig accession.version codes and finds the corresponding GCF identifier
2. get_cyano_ftp.sh - this script takes the GCF identifier and finds the NCBI FTP for genome download onto a server
3. download_cyano.sh - this script downloads genomes from a file called an input text file containing one genome accession per line.
4. prokka_annotate.sh - this script takes downloaded genome fasta files and annotates them using the program "prokka" (a pre-req for panaroo)
5. prokka_noMAG.slurm - sample call for Prokka with notes on arguments
6. panaroo_noMAG_80.slurm - sample call for Panaroo with notes on arguments
7. panaroobinary2.py - takes panaroo output and converts it to .phy format for RaxML

Plain texts:
1. Nibi_cyanobacteria.txt - gives instructions on starting off on Nibi. Explains how to download genomes, download prokka / panaroo, etc.
2. RaxML.txt - gives command to run RaxML and general information on the program
3. twocolumntsv.txt - instructions on how to create required metadata file prior to RaxML call


Some use cases:
If starting with a contig accession.version (e.g. BX548174.1), use pipeline of:
getassemblyaccession.sh --> get_cyano_ftp.sh --> download_cyano.sh --> fully downloaded genome on server for prokka/panaroo

if starting with GCF number (e.g. GCF_022984195.1), use pipeline of:
get_cyano_ftp.sh --> download_cyano.sh --> fully downloaded genome on server for prokka/panaroo
