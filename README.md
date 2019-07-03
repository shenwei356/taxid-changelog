# taxid-changelog

NCBI taxonomic identifier (taxid) changelog

## Data source

https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/

## File formats

`taxid_changelog.csv`

    # fields        comments
    taxid           # taxid
    version         # version / time of archive, e.g, 2019-07-01
    lineage         # full lineage of the taxid
    lineage-taxid   # taxids of the lineage
    change          # change, values: NEW, DELETE, MERGE, ABSORB
    change-value    # variable values for changes: empty for NEW and DELETE, new taxid for MERGE, merged taxids for ABSORB

`versions.txt`
    
    # list of versions

## Tool

    taxid-changelog create      creating taxid changelog
    
    taxid-changelog log         show changelog of given taxids in detail (maybe greping in taxid_changelog.csv is enough)
