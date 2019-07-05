# taxid-changelog

NCBI taxonomic identifier (taxid) changelog


- [Download](#download)
- [Results](#results)
- [Method](#Method)
- [Contributing](#contributing)
- [License](#license)

## Download

[Release](https://github.com/shenwei356/taxid-changelog/releases)

File format (CSV format with 8 fields):

    # fields        comments
    taxid           # taxid
    version         # version / time of archive, e.g, 2019-07-01
    change          # change, values:
                    #   NEW             newly added
                    #   DELETE          deleted
                    #   MERGE           merged into another taxid
                    #   ABSORB          other taxids merged into this one
                    #   L_CHANGE_LIN    lineage taxids remain but lineage remain
                    #   L_CHANGE_TAX    lineage taxids changed
                    #   L_CHANGE_LEN    lineage length changed
    change-value    # variable values for changes: 
                    #   1) empty for NEW, DELETE, L_CHANGE_LIN, L_CHANGE_TAX, L_CHANGE_LEN
                    #   2) new taxid for MERGE,
                    #   3) merged taxids for ABSORB
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

Tools:
- [csvtk](https://github.com/shenwei356/csvtk).
- [`pigz`](https://zlib.net/pigz/) can be replaced by `gzip`.

Some findings based on parts of archives (2014-2015).

- Scientific names can change, obviously.

        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f taxid -p 11 -p 152 \
            | csvtk cut -f -lineage,-lineage-taxids \
            | csvtk pretty 
        taxid   version      change         change-value        name                      rank
        11      2014-08-01   NEW                                [Cellvibrio] gilvus       species
        11      2015-05-01   L_CHANGE_LEN                       [Cellvibrio] gilvus       species
        11      2015-11-01   L_CHANGE_LIN                       Cellulomonas gilvus       species
        152     2014-08-01   NEW                                Treponema stenostrepta    species
        152     2015-06-01   L_CHANGE_LIN                       Treponema stenostreptum   species
                

- Lineage changed but lineage taxids can remained the same, 
  due to scientific name changes in parts of taxids of itself (`730`) or higher ranks (`8492`).

        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f taxid -p 730,8492 \
            | csvtk pretty
        taxid   version      change         change-value   name                    rank      lineage                                                                                                                                                                                                                                                                    lineage-taxids
        730     2014-08-01   NEW                           Haemophilus ducreyi     species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Pasteurellales;Pasteurellaceae;Haemophilus;Haemophilus ducreyi                                                                                                                                              131567;2;1224;1236;135625;712;724;730
        730     2015-06-01   L_CHANGE_LIN                  [Haemophilus] ducreyi   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Pasteurellales;Pasteurellaceae;Haemophilus;[Haemophilus] ducreyi                                                                                                                                            131567;2;1224;1236;135625;712;724;730
        8492    2014-08-01   NEW                           Archosauria             no rank   cellular organisms;Eukaryota;Opisthokonta;Metazoa;Eumetazoa;Bilateria;Deuterostomia;Chordata;Craniata;Vertebrata;Gnathostomata;Teleostomi;Euteleostomi;Sarcopterygii;Dipnotetrapodomorpha;Tetrapoda;Amniota;Sauropsida;Sauria;Testudines + Archosauria group;Archosauria   131567;2759;33154;33208;6072;33213;33511;7711;89593;7742;7776;117570;117571;8287;1338369;32523;32524;8457;32561;1329799;8492
        8492    2015-01-01   L_CHANGE_LIN                  Archosauria             no rank   cellular organisms;Eukaryota;Opisthokonta;Metazoa;Eumetazoa;Bilateria;Deuterostomia;Chordata;Craniata;Vertebrata;Gnathostomata;Teleostomi;Euteleostomi;Sarcopterygii;Dipnotetrapodomorpha;Tetrapoda;Amniota;Sauropsida;Sauria;Archelosauria;Archosauria                    131567;2759;33154;33208;6072;33213;33511;7711;89593;7742;7776;117570;117571;8287;1338369;32523;32524;8457;32561;1329799;8492

- Lots of taxids were deleted

        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f change -p DELETE \
            | csvtk freq -f version \
            | csvtk pretty
        version      frequency
        2014-08-01   310603
        2014-09-01   7957
        2014-10-01   6535
        2014-11-01   9568
        2014-12-01   7146
        2015-01-01   7650
        2015-02-01   14906
        2015-03-01   8595
        2015-04-01   13745
        2015-05-01   8379
        2015-06-01   8622
        2015-07-01   12744
        2015-08-01   14678
        2015-09-01   6638
        2015-10-01   16931
        2015-11-01   12168
        2015-12-01   9781

- **Deleted taxid can be re-used**, e.g., `7343`

        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f taxid -p 7343 \
            | csvtk cut -f -lineage,-lineage-taxids \
            | csvtk pretty 
        taxid   version      change   change-value   name                rank
        7343    2014-08-01   DELETE                                      
        7343    2015-04-01   NEW                     Paraliodrosophila   genus

        
        # how many deleted taxids were re-used
        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk collapse -f taxid -v change -s ";" \
            | csvtk grep -f change -r -p ".*DELETE.*NEW" \
            | sed 1d | wc -l 
        138973
        
        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk collapse -f taxid -v change -s ";" \
            | csvtk grep -f change -r -p ".*DELETE.*NEW" \
            | csvtk freq -f change -nr \
            | csvtk pretty
        change                                              frequency
        DELETE;NEW                                          129998
        DELETE;NEW;L_CHANGE_LEN                             5370
        DELETE;NEW;L_CHANGE_TAX                             1409
        DELETE;NEW;L_CHANGE_LIN                             844
        DELETE;NEW;ABSORB                                   730
        DELETE;NEW;MERGE                                    320
        DELETE;NEW;L_CHANGE_LEN;L_CHANGE_LEN                50
        DELETE;NEW;ABSORB;L_CHANGE_LIN                      47
        DELETE;NEW;L_CHANGE_LIN;L_CHANGE_LEN                39
        DELETE;NEW;L_CHANGE_TAX;L_CHANGE_TAX                32
        DELETE;NEW;ABSORB;L_CHANGE_LEN                      22
        DELETE;NEW;ABSORB;L_CHANGE_TAX                      21
        DELETE;NEW;L_CHANGE_LEN;L_CHANGE_LIN                14
        DELETE;NEW;L_CHANGE_LEN;L_CHANGE_LIN;L_CHANGE_LEN   12
        DELETE;NEW;L_CHANGE_LIN;ABSORB                      12
        DELETE;NEW;L_CHANGE_TAX;L_CHANGE_LIN                11
        DELETE;NEW;L_CHANGE_LEN;L_CHANGE_TAX                7
        DELETE;NEW;L_CHANGE_LEN;MERGE                       6
        DELETE;NEW;ABSORB;L_CHANGE_LIN;MERGE                3
        DELETE;NEW;L_CHANGE_LEN;ABSORB                      3
        DELETE;NEW;L_CHANGE_TAX;ABSORB;L_CHANGE_TAX         3
        DELETE;NEW;L_CHANGE_TAX;MERGE                       3
        DELETE;NEW;ABSORB;MERGE                             2
        DELETE;NEW;L_CHANGE_LIN;L_CHANGE_LIN                2
        DELETE;NEW;L_CHANGE_LIN;L_CHANGE_TAX                2
        DELETE;NEW;L_CHANGE_LIN;MERGE                       2
        DELETE;NEW;L_CHANGE_TAX;L_CHANGE_LEN                2
        DELETE;NEW;L_CHANGE_TAX;L_CHANGE_LIN;L_CHANGE_TAX   2
        DELETE;NEW;ABSORB;L_CHANGE_LIN;L_CHANGE_LEN         1
        DELETE;NEW;ABSORB;L_CHANGE_LIN;L_CHANGE_TAX         1
        DELETE;NEW;L_CHANGE_LEN;ABSORB;L_CHANGE_LIN         1
        DELETE;NEW;L_CHANGE_LEN;L_CHANGE_LEN;L_CHANGE_LEN   1
        DELETE;NEW;L_CHANGE_TAX;ABSORB                      1


to be investigated ...
        
## Method

Data source: https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump_archive/

Dependencies:
    
- rush, https://github.com/shenwei356/rush/
- taxonkit, https://github.com/shenwei356/taxonkit/, version 0.4.1 or later

Hardware:

- DISK: > 15 GiB
- RAM: > ??? (11 GiB for 17 archives)

Steps:

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
    
## Contributing

We welcome pull requests, bug fixes and issue reports.

## License

[MIT License](https://github.com/shenwei356/taxid-changelog/blob/master/LICENSE)
