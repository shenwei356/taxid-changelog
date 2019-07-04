# taxid-changelog

NCBI taxonomic identifier (taxid) changelog

## Data source

https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump_archive/

## Download

[Release](https://github.com/shenwei356/taxid-changelog/releases)

File format (CSV format with 8 fields):

    # fields        comments
    taxid           # taxid
    version         # version / time of archive, e.g, 2019-07-01
    change          # change, values: NEW, DELETE, LINEAGE_CHANGED, MERGE, ABSORB
    change-value    # variable values for changes: 
                    #    1) empty for NEW, DELETE, LINEAGE_CHANGED
                    #    2) new taxid for MERGE,
                    #    3) merged taxids for ABSORB
    name            # scientific name
    rank            # rank
    lineage         # full lineage of the taxid
    lineage-taxids  # taxids of the lineage

Example

    $ gzip -dc taxid-changelog.csv.gz | head -n 11
    taxid,version,change,change-value,name,rank,lineage,lineage-taxids
    1,2014-08-01,NEW,,root,no rank,root,1
    2,2014-08-01,NEW,,Bacteria,superkingdom,cellular organisms;Bacteria,131567;2
    3,2014-08-01,DELETE,,,,,
    4,2014-08-01,DELETE,,,,,
    5,2014-08-01,DELETE,,,,,
    6,2014-08-01,NEW,,Azorhizobium,genus,cellular organisms;Bacteria;Proteobacteria;Alphaproteobacteria;Rhizobiales;Xanthobacteraceae;Azorhizobium,131567;2;1224;28211;356;335928;6
    7,2014-08-01,NEW,,Azorhizobium caulinodans,species,cellular organisms;Bacteria;Proteobacteria;Alphaproteobacteria;Rhizobiales;Xanthobacteraceae;Azorhizobium;Azorhizobium caulinodans,131567;2;1224;28211;356;335928;6;7
    7,2014-08-01,ABSORB,395,Azorhizobium caulinodans,species,cellular organisms;Bacteria;Proteobacteria;Alphaproteobacteria;Rhizobiales;Xanthobacteraceae;Azorhizobium;Azorhizobium caulinodans,131567;2;1224;28211;356;335928;6;7
    8,2014-08-01,DELETE,,,,,
    9,2014-08-01,NEW,,Buchnera aphidicola,species,cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Buchnera;Buchnera aphidicola,131567;2;1224;1236;91347;543;32199;9

## Results

Some findings based on parts of archives (2014-2015)

- Scientific names can change, obviously.

        $ pigz -cd taxid-changelog.csv.gz | csvtk grep -f taxid -p 1329799 \
            | csvtk cut -f -lineage,-lineage-taxids | csvtk pretty 
        taxid     version      change            change-value   name                             rank
        1329799   2014-08-01   NEW                              Testudines + Archosauria group   no rank
        1329799   2015-01-01   LINEAGE_CHANGED                  Archelosauria                    no rank

- Lineage changed but lineage taxids remained the same, 
  due to scientific name changes in parts of taxids of higher ranks.

        $ pigz -cd taxid-changelog.csv.gz | csvtk grep -f taxid -p 135634
        taxid,version,change,change-value,name,rank,lineage,lineage-taxids
        135634,2014-08-01,NEW,,Streptopelia capicola,species,cellular organisms;Eukaryota;Opisthokonta;Metazoa;Eumetazoa;Bilateria;Deuterostomia;Chordata;Craniata;Vertebrata;Gnathostomata;Teleostomi;Euteleostomi;Sarcopterygii;Dipnotetrapodomorpha;Tetrapoda;Amniota;Sauropsida;Sauria;Testudines + Archosauria group;Archosauria;Dinosauria;Saurischia;Theropoda;Coelurosauria;Aves;Neognathae;Columbiformes;Columbidae;Streptopelia;Streptopelia capicola,131567;2759;33154;33208;6072;33213;33511;7711;89593;7742;7776;117570;117571;8287;1338369;32523;32524;8457;32561;1329799;8492;436486;436489;436491;436492;8782;8825;8929;8930;36242;135634
        135634,2015-01-01,LINEAGE_CHANGED,,Streptopelia capicola,species,cellular organisms;Eukaryota;Opisthokonta;Metazoa;Eumetazoa;Bilateria;Deuterostomia;Chordata;Craniata;Vertebrata;Gnathostomata;Teleostomi;Euteleostomi;Sarcopterygii;Dipnotetrapodomorpha;Tetrapoda;Amniota;Sauropsida;Sauria;Archelosauria;Archosauria;Dinosauria;Saurischia;Theropoda;Coelurosauria;Aves;Neognathae;Columbiformes;Columbidae;Streptopelia;Streptopelia capicola,131567;2759;33154;33208;6072;33213;33511;7711;89593;7742;7776;117570;117571;8287;1338369;32523;32524;8457;32561;1329799;8492;436486;436489;436491;436492;8782;8825;8929;8930;36242;135634

- Deleted taxid were re-used, e.g., `7343`

        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f taxid -p 7343 \
            | csvtk cut -f -lineage,-lineage-taxids \
            | csvtk pretty 
        taxid   version      change   change-value   name                rank
        7343    2014-08-01   DELETE                                      
        7343    2015-04-01   NEW                     Paraliodrosophila   genus

        # how many delted taxids were re-used
        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk collapse -f taxid -v change -s ";" \
            | csvtk grep -f change -r -p ".*DELETE.*NEW" \
            | wc -l 
        17418

        pigz -cd taxid-changelog.csv.gz \
            | csvtk collapse -f taxid -v change -s ";" \
            | csvtk grep -f change -r -p ".*DELETE.*NEW" \
            | csvtk freq -f change -nr \
            | csvtk pretty
        change                                                       frequency
        DELETE;NEW                                                   16342
        DELETE;NEW;LINEAGE_CHANGED                                   923
        DELETE;NEW;ABSORB                                            76
        DELETE;NEW;MERGE                                             39
        DELETE;NEW;LINEAGE_CHANGED;LINEAGE_CHANGED                   28
        DELETE;NEW;ABSORB;LINEAGE_CHANGED                            7
        DELETE;NEW;LINEAGE_CHANGED;LINEAGE_CHANGED;LINEAGE_CHANGED   1
        DELETE;NEW;MERGE;LINEAGE_CHANGED                             1

        # OMG, who changed so many times:
        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk collapse -f taxid -v change -s ";" \
            | csvtk grep -f change -r -p ".*DELETE.*NEW" \
            | csvtk grep -f change -p "DELETE;NEW;LINEAGE_CHANGED;LINEAGE_CHANGED;LINEAGE_CHANGED"
        taxid,change
        1565341,DELETE;NEW;LINEAGE_CHANGED;LINEAGE_CHANGED;LINEAGE_CHANGED

        pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f taxid -p 1565341 \
            | csvtk pretty
        taxid     version      change            change-value   name                      rank      lineage                                                                                                                                                                             lineage-taxids
        1565341   2014-11-01   DELETE                                                                                                                                                                                                                                                   
        1565341   2014-12-01   NEW                              Cryptococcus sp.1 AM07    species   cellular organisms;Eukaryota;Opisthokonta;Fungi;Dikarya;Basidiomycota;Agaricomycotina;Tremellomycetes;Tremellales;mitosporic Tremellales;Cryptococcus;Cryptococcus sp.1 AM07        131567;2759;33154;4751;451864;5204;5302;155616;5234;34476;106841;1565341
        1565341   2015-05-01   LINEAGE_CHANGED                  Cryptococcus sp.1 AM07    species   cellular organisms;Eukaryota;Opisthokonta;Fungi;Dikarya;Basidiomycota;Agaricomycotina;Tremellomycetes;Tremellales;Tremellales incertae sedis;Cryptococcus;Cryptococcus sp.1 AM07    131567;2759;33154;4751;451864;5204;5302;155616;5234;415703;106841;1565341
        1565341   2015-07-01   LINEAGE_CHANGED                  Cryptococcus sp. 1 AM07   species   cellular organisms;Eukaryota;Opisthokonta;Fungi;Dikarya;Basidiomycota;Agaricomycotina;Tremellomycetes;Tremellales;Tremellales incertae sedis;Cryptococcus;Cryptococcus sp. 1 AM07   131567;2759;33154;4751;451864;5204;5302;155616;5234;415703;106841;1565341
        1565341   2015-12-01   LINEAGE_CHANGED                  Cryptococcus sp. 1 AM07   species   cellular organisms;Eukaryota;Opisthokonta;Fungi;Dikarya;Basidiomycota;Agaricomycotina;Tremellomycetes;Tremellales;Trichosporonaceae;Cryptococcus;Cryptococcus sp. 1 AM07            131567;2759;33154;4751;451864;5204;5302;155616;5234;1759442;106841;1565341


to be investigated ...
        
## Method

Dependencies:
    
- rush, https://github.com/shenwei356/rush/
- taxonkit, https://github.com/shenwei356/taxonkit/, version 0.4.0 or later

Hardware:

- DISK: > 15 GiB
- RAM: > ??? (11 GiB for 17 archives)

Steps

    mkdir -p archive; cd archive;

    # --------- download ---------

    # option 1
    # for fast network connection
    wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump_archive/taxdmp*.zip

    # option 2
    # for bad network connection like mine
    url=https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump_archive/
    wget $url -O - -o /dev/null \
        | grep taxdmp | perl -ne '/(taxdmp_.+?.zip)/; print "$1\n";' \
        | rush -j 2 -v url=$url 'axel -n 5 {url}/{}' \
            --immediate-output  -c -C download.rush

    # --------- unzip ---------

    ls taxdmp*.zip | rush -j 1 'unzip {} names.dmp nodes.dmp merged.dmp delnodes.dmp -d {@_(.+)\.}'

    # --------- create log ---------

    cd ..
    taxonkit taxid-changelog -i archive -o taxid-changelog.csv.gz --verbose
    

