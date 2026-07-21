import pandas as pd
import re

# load your presence/absence table from panaroo output
df = pd.read_csv("gene_presence_absence.csv")
genomes = df.columns[3:]

# For this, you will need to create a .tsv file that has two columns, one for GCF # and one with scientific name for each genome (row)
# see twocolumn.tsv file

# load the GCF→species lookup (tab-delimited, no header)
names = (
    pd.read_csv("gcf_with_organism_name.tsv", sep="\t",
                header=None, names=["GCF","Species"], dtype=str)
      .set_index("GCF")["Species"]
      .to_dict()
)
# convert panaroo gene matrix to binary presence/absence matrix
bin_mat = df[genomes].notna().astype(int).T
bin_mat.index.name = None

gcf_pat = re.compile(r'^(GCF_\d+\.\d+)')

# extract each GCF accession from each genome name
def get_base_gcf(g):
    m = gcf_pat.match(g)
    return m.group(1) if m else g

# replace each row name in the binary matrix with its standardized GCF accession.
bin_mat.index = [ get_base_gcf(g) for g in bin_mat.index ]

# debug -> check if every GCF accession in binary matrix appears in GCF-to-species dictionary
missing = set(bin_mat.index) - set(names.keys())
if missing:
    print("Still missing these IDs:")
    for g in sorted(missing):
        print(repr(g))
else:
    print("All genome IDs have a mapping now.")

# write PHYLIP, using the species name as the label
n_taxa, n_chars = bin_mat.shape
with open("pa_with_species_labels.phy", "w") as out:
    
    # the phylip header contains the number of genomes then number of binary characters
    out.write(f"{n_taxa} {n_chars}\n")
    
    # process one genome and its binary seuqence at a time
    for gcf_id, row in bin_mat.iterrows():
        seq = "".join(map(str, row.values))

        # e.g. get “Prochlorococcus marinus” 
        full_name = names.get(gcf_id, gcf_id)  
        # convert spaces to underscores
        sp_label  = full_name.replace(" ", "_")
        # add on the GCF accession (no dots)
        gcf_base  = gcf_id.replace(".", "_")
        
        # combine the species name and GCF accession to create unique label, robust to multiple genomes having the same scientific name
        unique_label = f"{sp_label}_{gcf_base}"

        # write the taxon label and its binary gene presence/absence sequence
        out.write(f"{unique_label} {seq}\n")