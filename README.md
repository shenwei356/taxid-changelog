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

Example 1:

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

Example 2 (*E.coli* with taxid `562`)

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -p 562 \
        | csvtk pretty
    taxid   version      change         change-value    name               rank      lineage                                                                                                                            lineage-taxids
    562     2014-08-01   NEW                            Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia coli   131567;2;1224;1236;91347;543;561;562
    562     2014-08-01   ABSORB         662101;662104   Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia coli   131567;2;1224;1236;91347;543;561;562
    562     2015-11-01   ABSORB         1637691         Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia coli   131567;2;1224;1236;91347;543;561;562
    562     2016-10-01   L_CHANGE_LIN                   Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia coli    131567;2;1224;1236;91347;543;561;562
    562     2018-06-01   ABSORB         469598          Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia coli    131567;2;1224;1236;91347;543;561;562
    
    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -p 662101,662104,1637691,469598 \
        | csvtk pretty
    taxid     version      change         change-value   name                        rank      lineage                                                                                                                                     lineage-taxids
    469598    2014-08-01   NEW                           Escherichia sp. 3_2_53FAA   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia sp. 3_2_53FAA   131567;2;1224;1236;91347;543;561;469598
    469598    2016-10-01   L_CHANGE_LIN                  Escherichia sp. 3_2_53FAA   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia sp. 3_2_53FAA    131567;2;1224;1236;91347;543;561;469598
    469598    2018-06-01   MERGE          562            Escherichia sp. 3_2_53FAA   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia sp. 3_2_53FAA    131567;2;1224;1236;91347;543;561;469598
    662101    2014-08-01   MERGE          562                                                                                                                                                                                              
    662104    2014-08-01   MERGE          562                                                                                                                                                                                              
    1637691   2015-04-01   DELETE                                                                                                                                                                                                          
    1637691   2015-05-01   NEW                           Escherichia sp. MAR         species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia sp. MAR         131567;2;1224;1236;91347;543;561;1637691
    1637691   2015-11-01   MERGE          562            Escherichia sp. MAR         species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia sp. MAR         131567;2;1224;1236;91347;543;561;1637691  

## Results

Tools:
- [csvtk](https://github.com/shenwei356/csvtk) for query and more maniputations.
- [`pigz`](https://zlib.net/pigz/) is faster than `gzip`.

- Scientific names can change, obviously.

        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f taxid -p 11 -p 152 \
            | csvtk cut -f -lineage,-lineage-taxids \
            | csvtk pretty 
        taxid   version      change         change-value   name                      rank
        11      2014-08-01   NEW                           [Cellvibrio] gilvus       species
        11      2015-05-01   L_CHANGE_LEN                  [Cellvibrio] gilvus       species
        11      2015-11-01   L_CHANGE_LIN                  Cellulomonas gilvus       species
        11      2016-03-01   L_CHANGE_LEN                  Cellulomonas gilvus       species
        152     2014-08-01   NEW                           Treponema stenostrepta    species
        152     2015-06-01   L_CHANGE_LIN                  Treponema stenostreptum   species
                    

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

- Lots of taxids were deleted and added.

        $ csvtk join -f version \
            <(pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f change -p DELETE \
            | csvtk freq -f version) \
            <(pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f change -p NEW \
            | csvtk freq -f version) \
            | csvtk rename -f 2,3 -n deleted,new \
            | csvtk pretty
        version      deleted   new
        2014-08-01   310603    1184830
        2014-09-01   7957      11056
        2014-10-01   6535      9446
        2014-11-01   9568      11886
        2014-12-01   7146      10077
        2015-01-01   7650      9866
        2015-02-01   14906     12599
        2015-03-01   8595      10142
        2015-04-01   13745     12613
        2015-05-01   8379      8917
        2015-06-01   8622      7704
        2015-07-01   12744     19132
        2015-08-01   14678     12600
        2015-09-01   6638      12413
        2015-10-01   16931     18322
        2015-11-01   12168     20340
        2015-12-01   9781      19503
        2016-01-01   7834      13307
        2016-03-01   18820     25782
        2016-04-01   10132     12567
        2016-05-01   13834     19481
        2016-06-01   6302      20348
        2016-08-01   14861     24055
        2016-09-01   8029      13133
        2016-10-01   6420      8295
        2016-11-01   5090      7314
        2016-12-01   5880      10630
        2017-01-01   4207      8902
        2017-02-01   6762      7696
        2017-03-01   8923      18850
        2017-04-01   6717      10804
        2017-05-01   4896      11670
        2017-06-01   12746     14461
        2017-07-01   6973      8357
        2017-08-01   3667      16618
        2017-09-01   6715      6729
        2017-10-01   5763      7316
        2017-12-01   8186      15687
        2018-01-01   7731      6833
        2018-02-01   9020      10781
        2018-03-01   17112     13134
        2018-04-01   14687     33041
        2018-05-01   31548     14744
        2018-06-01   31334     28071
        2018-07-01   35694     28381
        2018-08-01   21034     32171
        2018-09-01   4988      26355
        2018-10-01   78315     46244
        2018-11-01   34242     99919
        2018-12-01   5698      35342
        2019-01-01   3718      7213
        2019-02-01   5478      10399
        2019-03-01   12565     10062
        2019-04-01   12797     31245
        2019-05-01   10497     6554
        2019-06-01   8004      15254
        2019-07-01   5047      8865

- **Deleted taxid can be re-used**, e.g., `7343`.

        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f taxid -p 7343 \
            | csvtk cut -f -lineage,-lineage-taxids \
            | csvtk pretty 
        taxid   version      change         change-value   name                rank
        7343    2014-08-01   DELETE                                            
        7343    2015-04-01   NEW                           Paraliodrosophila   genus
        7343    2016-08-01   L_CHANGE_LEN                  Paraliodrosophila   genus
        7343    2017-03-01   L_CHANGE_LIN                  Paraliodrosophila   genus
            
        # how many deleted taxids were re-used
        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk collapse -f taxid -v change -s ";" \
            | csvtk grep -f change -r -p ".*DELETE.*NEW" \
            | sed 1d | wc -l 
        581144
        
        $ pigz -cd taxid-changelog.csv.gz \
            | csvtk collapse -f taxid -v change -s ";" \
            | csvtk grep -f change -r -p ".*DELETE.*NEW" \
            | csvtk freq -f change -nr \
            | csvtk head -n 10 \
            | csvtk pretty            
        change                                              frequency
        DELETE;NEW                                          360811
        DELETE;NEW;L_CHANGE_LIN                             92968
        DELETE;NEW;L_CHANGE_LEN                             40493
        DELETE;NEW;L_CHANGE_LIN;L_CHANGE_LEN;L_CHANGE_LEN   27705
        DELETE;NEW;L_CHANGE_LEN;L_CHANGE_LIN                15327
        DELETE;NEW;L_CHANGE_LEN;L_CHANGE_LEN                11034
        DELETE;NEW;L_CHANGE_TAX                             8351
        DELETE;NEW;L_CHANGE_LIN;L_CHANGE_LEN                3084
        DELETE;NEW;L_CHANGE_LEN;L_CHANGE_TAX                2517
        DELETE;NEW;MERGE                                    2368

to be continue ...
        
## Method

Data source: https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump_archive/

Dependencies:
    
- rush, https://github.com/shenwei356/rush/
- taxonkit, https://github.com/shenwei356/taxonkit/, version 0.4.1 or later

Hardware requirements:

- DISK: > 15 GiB
- RAM: >= 48 GiB (42 GiB for 57 archives)

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
