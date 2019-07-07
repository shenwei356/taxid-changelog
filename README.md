# taxid-changelog

NCBI taxonomic identifier (taxid) changelog, 
tracking taxids deletion, new adding, merge, reuse, and rank/name changes.

## Table of contents

<!-- TOC -->
- [Download](#download)
- [Format](#format)
- [Results](#results)
    - [Taxids were deleted, newly added and re-used](#taxids-were-deleted-newly-added-and-re-used)
    - [Scientific names and ranks changed](#scientific-names-and-ranks-changed)
    - [Lineage taxids remained but lineage changed](#lineage-taxids-remained-but-lineage-changed)
    - [Rank changed from subspecies and species](#rank-changed-from-subspecies-and-species)
    - [A superkingdom disappeared](#a-superkingdom-disappeared)
- [Method](#method)
- [Contributing](#contributing)
- [License](#license)
<!-- /TOC -->

## Download

[Release](https://github.com/shenwei356/taxid-changelog/releases)

## Format

File format (CSV format with 8 fields):

    # fields        comments
    taxid           # taxid
    version         # version / time of archive, e.g, 2019-07-01
    change          # change, values:
                    #   NEW             newly added
                    #   REUSE_DEL       deleted taxids being reused
                    #   REUSE_MER       merged taxids being reused
                    #   DELETE          deleted
                    #   MERGE           merged into another taxid
                    #   ABSORB          other taxids merged into this one
                    #   CHANGE_NAME     scientific changed
                    #   CHANGE_RANK     rank changed
                    #   CHANGE_LIN_LIN  lineage taxids remain but lineage remain
                    #   CHANGE_LIN_TAX  lineage taxids changed
                    #   CHANGE_LIN_LEN  lineage length changed
    change-value    # variable values for changes: 
                    #   1) new taxid for MERGE
                    #   2) merged taxids for ABSORB
                    #   3) empty for others
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
    taxid   version      change           change-value    name               rank      lineage                                                                                                                            lineage-taxids
    562     2014-08-01   NEW                              Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia coli   131567;2;1224;1236;91347;543;561;562
    562     2014-08-01   ABSORB           662101;662104   Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia coli   131567;2;1224;1236;91347;543;561;562
    562     2015-11-01   ABSORB           1637691         Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia coli   131567;2;1224;1236;91347;543;561;562
    562     2016-10-01   CHANGE_LIN_LIN                   Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia coli    131567;2;1224;1236;91347;543;561;562
    562     2018-06-01   ABSORB           469598          Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia coli    131567;2;1224;1236;91347;543;561;562

    # merged taxids
    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -p 662101,662104,1637691,469598 \
        | csvtk pretty
    taxid     version      change           change-value   name                        rank      lineage                                                                                                                                     lineage-taxids
    469598    2014-08-01   NEW                             Escherichia sp. 3_2_53FAA   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia sp. 3_2_53FAA   131567;2;1224;1236;91347;543;561;469598
    469598    2016-10-01   CHANGE_LIN_LIN                  Escherichia sp. 3_2_53FAA   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia sp. 3_2_53FAA    131567;2;1224;1236;91347;543;561;469598
    469598    2018-06-01   MERGE            562            Escherichia sp. 3_2_53FAA   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia sp. 3_2_53FAA    131567;2;1224;1236;91347;543;561;469598
    662101    2014-08-01   MERGE            562                                                                                                                                                                                              
    662104    2014-08-01   MERGE            562                                                                                                                                                                                              
    1637691   2015-04-01   DELETE                                                                                                                                                                                                            
    1637691   2015-05-01   REUSE_DEL                       Escherichia sp. MAR         species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia sp. MAR         131567;2;1224;1236;91347;543;561;1637691
    1637691   2015-11-01   MERGE            562            Escherichia sp. MAR         species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia sp. MAR         131567;2;1224;1236;91347;543;561;1637691

Example 3 (All subspecies and strain in *Akkermansia muciniphila* 239935)

    # species in Akkermansia
    $ taxonkit list --show-rank --show-name --ids 239935
    239935 [species] Akkermansia muciniphila
      349741 [no rank] Akkermansia muciniphila ATCC BAA-835
    
    # check them all  
    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -P <(taxonkit list --indent "" --ids 239935) \
        | csvtk pretty
    taxid    version      change           change-value   name                                   rank      lineage                                                                                                                                                                                                         lineage-taxids
    239935   2014-08-01   NEW                             Akkermansia muciniphila                species   cellular organisms;Bacteria;Chlamydiae/Verrucomicrobia group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Verrucomicrobiaceae;Akkermansia;Akkermansia muciniphila                                        131567;2;51290;74201;203494;48461;203557;239934;239935
    239935   2015-05-01   CHANGE_LIN_TAX                  Akkermansia muciniphila                species   cellular organisms;Bacteria;Chlamydiae/Verrucomicrobia group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila                                            131567;2;51290;74201;203494;48461;1647988;239934;239935
    239935   2016-03-01   CHANGE_LIN_TAX                  Akkermansia muciniphila                species   cellular organisms;Bacteria;PVC group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila                                                                   131567;2;1783257;74201;203494;48461;1647988;239934;239935
    239935   2016-05-01   ABSORB           1834199        Akkermansia muciniphila                species   cellular organisms;Bacteria;PVC group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila                                                                   131567;2;1783257;74201;203494;48461;1647988;239934;239935
    349741   2014-08-01   NEW                             Akkermansia muciniphila ATCC BAA-835   no rank   cellular organisms;Bacteria;Chlamydiae/Verrucomicrobia group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Verrucomicrobiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila ATCC BAA-835   131567;2;51290;74201;203494;48461;203557;239934;239935;349741
    349741   2015-05-01   CHANGE_LIN_TAX                  Akkermansia muciniphila ATCC BAA-835   no rank   cellular organisms;Bacteria;Chlamydiae/Verrucomicrobia group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila ATCC BAA-835       131567;2;51290;74201;203494;48461;1647988;239934;239935;349741
    349741   2016-03-01   CHANGE_LIN_TAX                  Akkermansia muciniphila ATCC BAA-835   no rank   cellular organisms;Bacteria;PVC group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila ATCC BAA-835                              131567;2;1783257;74201;203494;48461;1647988;239934;239935;349741

## Results

Tools used:

- [csvtk](https://github.com/shenwei356/csvtk) for query and more maniputations.
- [`pigz`](https://zlib.net/pigz/) is faster than `gzip`.

### Taxids were deleted, newly added and re-used

Stats:

    $ csvtk join -k -f version \
        <(pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f change -p DELETE \
        | csvtk freq -f version) \
        <(pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f change -p NEW \
        | csvtk freq -f version) \
        <(pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f change -p REUSE_DEL \
        | csvtk freq -f version) \
        <(pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f change -p REUSE_MER \
        | csvtk freq -f version) \
        | csvtk rename -f -1 -n deleted,newly-added,deleted-reused,merged-reused \
        | csvtk pretty
    
    version      deleted   newly-added   deleted-reused   merged-reused
    2014-08-01   310603    1184830                        
    2014-09-01   7957      3362          7694             
    2014-10-01   6535      3856          5590             
    2014-11-01   9568      5849          6037             
    2014-12-01   7147      3699          6378             
    2015-01-01   7650      5104          4762             
    2015-02-01   14911     2699          9900             
    2015-03-01   9123      4117          6025             
    2015-04-01   13748     3398          9951             
    2015-05-01   8381      2639          6279             
    2015-06-01   8629      3320          4385             
    2015-07-01   12746     4140          14992            
    2015-08-01   14680     4300          8300             
    2015-09-01   6646      4083          8330             
    2015-10-01   16933     6052          12273            
    2015-11-01   12169     4727          15613            
    2015-12-01   9782      6298          13206            
    2016-01-01   7834      4133          9175             
    2016-03-01   18825     13532         12250            
    2016-04-01   10135     6106          6461             
    2016-05-01   13835     4704          14778            1
    2016-06-01   6303      6110          14237            1
    2016-08-01   14866     13730         10324            2
    2016-09-01   8033      4683          8450             
    2016-10-01   6420      2084          6213             
    2016-11-01   5097      3548          3765             2
    2016-12-01   5881      3517          7113             1
    2017-01-01   4208      3102          5800             
    2017-02-01   6762      3108          4588             
    2017-03-01   8929      13341         5509             
    2017-04-01   6721      4026          6778             
    2017-05-01   4904      4306          7364             
    2017-06-01   12789     9715          4746             
    2017-07-01   6974      4622          3735             3
    2017-08-01   3669      2483          14135            
    2017-09-01   6716      2853          3892             
    2017-10-01   5766      2451          4865             
    2017-12-01   8194      7087          8602             
    2018-01-01   7732      2711          4123             1
    2018-02-01   9020      4106          6676             
    2018-03-01   17113     9415          3743             
    2018-04-01   14688     16683         16358            
    2018-05-01   31551     4950          9794             
    2018-06-01   31336     6040          22034            
    2018-07-01   35696     10657         17726            
    2018-08-01   21046     11585         20586            
    2018-09-01   4992      10658         15697            
    2018-10-01   78319     34128         12118            
    2018-11-01   34245     31692         68228            
    2018-12-01   5699      1856          33487            
    2019-01-01   3722      2562          4653             
    2019-02-01   5488      5990          4411             
    2019-03-01   12567     6473          3598             
    2019-04-01   12807     19580         11672            1
    2019-05-01   10502     2453          4103             
    2019-06-01   8008      1458          13797            
    2019-07-01   5050      2192          6695                  


[The paper of NCBI Taxonomy database](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3245000/):

> Taxids are stable and persistent—they may be deleted
> (when taxa are removed from the database),
> and they may be merged (when taxa are synonymized), 
> but they will never be reused to identify a different taxon.

Deleted taxid can be re-used**, e.g., `1157319` was reused to identify the same taxon.

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -p 7343,1157319 \
        | csvtk pretty 
    taxid     version      change           change-value   name                     rank      lineage                                                                                                                                                                                                                                                                                                                                                                                       lineage-taxids
    7343      2014-08-01   DELETE                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    7343      2015-04-01   REUSE_DEL                       Paraliodrosophila        genus     cellular organisms;Eukaryota;Opisthokonta;Metazoa;Eumetazoa;Bilateria;Protostomia;Ecdysozoa;Panarthropoda;Arthropoda;Mandibulata;Pancrustacea;Hexapoda;Insecta;Dicondylia;Pterygota;Neoptera;Endopterygota;Diptera;Brachycera;Muscomorpha;Eremoneura;Cyclorrhapha;Schizophora;Acalyptratae;Ephydroidea;Drosophilidae;Drosophilinae;Drosophilini;Drosophilina;Drosophiliti;Paraliodrosophila   131567;2759;33154;33208;6072;33213;33317;1206794;88770;6656;197563;197562;6960;50557;85512;7496;33340;33392;7147;7203;43733;480118;480117;43738;43741;43746;7214;43845;46877;46879;186285;7343
    7343      2015-06-01   DELETE                          Paraliodrosophila        genus     cellular organisms;Eukaryota;Opisthokonta;Metazoa;Eumetazoa;Bilateria;Protostomia;Ecdysozoa;Panarthropoda;Arthropoda;Mandibulata;Pancrustacea;Hexapoda;Insecta;Dicondylia;Pterygota;Neoptera;Endopterygota;Diptera;Brachycera;Muscomorpha;Eremoneura;Cyclorrhapha;Schizophora;Acalyptratae;Ephydroidea;Drosophilidae;Drosophilinae;Drosophilini;Drosophilina;Drosophiliti;Paraliodrosophila   131567;2759;33154;33208;6072;33213;33317;1206794;88770;6656;197563;197562;6960;50557;85512;7496;33340;33392;7147;7203;43733;480118;480117;43738;43741;43746;7214;43845;46877;46879;186285;7343
    7343      2016-05-01   REUSE_DEL                       Paraliodrosophila        genus     cellular organisms;Eukaryota;Opisthokonta;Metazoa;Eumetazoa;Bilateria;Protostomia;Ecdysozoa;Panarthropoda;Arthropoda;Mandibulata;Pancrustacea;Hexapoda;Insecta;Dicondylia;Pterygota;Neoptera;Endopterygota;Diptera;Brachycera;Muscomorpha;Eremoneura;Cyclorrhapha;Schizophora;Acalyptratae;Ephydroidea;Drosophilidae;Drosophilinae;Drosophilini;Drosophilina;Drosophiliti;Paraliodrosophila   131567;2759;33154;33208;6072;33213;33317;1206794;88770;6656;197563;197562;6960;50557;85512;7496;33340;33392;7147;7203;43733;480118;480117;43738;43741;43746;7214;43845;46877;46879;186285;7343
    7343      2016-08-01   CHANGE_LIN_LEN                  Paraliodrosophila        genus     cellular organisms;Eukaryota;Opisthokonta;Metazoa;Eumetazoa;Bilateria;Protostomia;Ecdysozoa;Panarthropoda;Arthropoda;Mandibulata;Pancrustacea;Hexapoda;Insecta;Dicondylia;Pterygota;Neoptera;Endopterygota;Diptera;Brachycera;Muscomorpha;Eremoneura;Cyclorrhapha;Schizophora;Acalyptratae;Ephydroidea;Drosophilidae;Drosophilinae;Drosophilini;Paraliodrosophila                             131567;2759;33154;33208;6072;33213;33317;1206794;88770;6656;197563;197562;6960;50557;85512;7496;33340;33392;7147;7203;43733;480118;480117;43738;43741;43746;7214;43845;46877;7343
    7343      2017-03-01   CHANGE_LIN_LIN                  Paraliodrosophila        genus     cellular organisms;Eukaryota;Opisthokonta;Metazoa;Eumetazoa;Bilateria;Protostomia;Ecdysozoa;Panarthropoda;Arthropoda;Mandibulata;Pancrustacea;Hexapoda;Insecta;Dicondylia;Pterygota;Neoptera;Holometabola;Diptera;Brachycera;Muscomorpha;Eremoneura;Cyclorrhapha;Schizophora;Acalyptratae;Ephydroidea;Drosophilidae;Drosophilinae;Drosophilini;Paraliodrosophila                              131567;2759;33154;33208;6072;33213;33317;1206794;88770;6656;197563;197562;6960;50557;85512;7496;33340;33392;7147;7203;43733;480118;480117;43738;43741;43746;7214;43845;46877;7343
    1157319   2014-08-01   NEW                             Lactococcus phage ASCC   no rank   Viruses;dsDNA viruses, no RNA stage;Caudovirales;Siphoviridae;unclassified Siphoviridae;Lactococcus phage 936 sensu lato;Lactococcus phage ASCC                                                                                                                                                                                                                                               10239;35237;28883;10699;196894;354259;1157319
    1157319   2018-06-01   CHANGE_LIN_LEN                  Lactococcus phage ASCC   no rank   Viruses;dsDNA viruses, no RNA stage;Caudovirales;Siphoviridae;Sk1virus;unclassified Sk1virus;Lactococcus phage 936 sensu lato;Lactococcus phage ASCC                                                                                                                                                                                                                                          10239;35237;28883;10699;1623305;2050979;354259;1157319
    1157319   2019-04-01   CHANGE_LIN_LEN                  Lactococcus phage ASCC   no rank   Viruses;Caudovirales;Siphoviridae;Skunavirus;unclassified Sk1virus;Lactococcus phage 936 sensu lato;Lactococcus phage ASCC                                                                                                                                                                                                                                                                    10239;28883;10699;1623305;2050979;354259;1157319
    1157319   2019-05-01   CHANGE_LIN_LIN                  Lactococcus phage ASCC   no rank   Viruses;Caudovirales;Siphoviridae;Skunavirus;unclassified Skunavirus;Lactococcus phage 936 sensu lato;Lactococcus phage ASCC                                                                                                                                                                                                                                                                  10239;28883;10699;1623305;2050979;354259;1157319
    1157319   2019-06-01   DELETE                          Lactococcus phage ASCC   no rank   Viruses;Caudovirales;Siphoviridae;Skunavirus;unclassified Skunavirus;Lactococcus phage 936 sensu lato;Lactococcus phage ASCC                                                                                                                                                                                                                                                                  10239;28883;10699;1623305;2050979;354259;1157319
    1157319   2019-07-01   REUSE_DEL                       Lactococcus phage ASCC   species   Viruses;Caudovirales;Siphoviridae;Skunavirus;unclassified Skunavirus;Lactococcus phage ASCC                                                                                                                                                                                                                                                                                                   10239;28883;10699;1623305;2050979;1157319

Merged taxid can also be re-used (become independent again?), e.g.,

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -p 101480,36032 \
        | csvtk pretty
    taxid    version      change      change-value   name                         rank      lineage                                                                                                                                                                                                              lineage-taxids
    36032    2014-08-01   MERGE       1249076                                                                                                                                                                                                                                                                    
    36032    2016-06-01   REUSE_MER                  Barnettozyma wickerhamii     species   cellular organisms;Eukaryota;Opisthokonta;Fungi;Dikarya;Ascomycota;saccharomyceta;Saccharomycotina;Saccharomycetes;Saccharomycetales;Phaffomycetaceae;Barnettozyma;Barnettozyma wickerhamii                          131567;2759;33154;4751;451864;4890;716545;147537;4891;4892;115784;599802;36032
    101480   2014-08-01   MERGE       63407                                                                                                                                                                                                                                                                      
    101480   2016-05-01   REUSE_MER                  Trichophyton interdigitale   species   cellular organisms;Eukaryota;Opisthokonta;Fungi;Dikarya;Ascomycota;saccharomyceta;Pezizomycotina;leotiomyceta;Eurotiomycetes;Eurotiomycetidae;Onygenales;Arthrodermataceae;Trichophyton;Trichophyton interdigitale   131567;2759;33154;4751;451864;4890;716545;147538;716546;147545;451871;33183;34384;5550;101480
        
### Scientific names and ranks changed

Scientific changed, e.g.,

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -p 11,152 \
        | csvtk cut -f -lineage,-lineage-taxids \
        | csvtk pretty 
    taxid   version      change           change-value   name                      rank
    11      2014-08-01   NEW                             [Cellvibrio] gilvus       species
    11      2015-05-01   CHANGE_LIN_LEN                  [Cellvibrio] gilvus       species
    11      2015-11-01   CHANGE_NAME                     Cellulomonas gilvus       species
    11      2015-11-01   CHANGE_LIN_LIN                  Cellulomonas gilvus       species
    11      2016-03-01   CHANGE_LIN_LEN                  Cellulomonas gilvus       species
    152     2014-08-01   NEW                             Treponema stenostrepta    species
    152     2015-06-01   CHANGE_NAME                     Treponema stenostreptum   species
    152     2015-06-01   CHANGE_LIN_LIN                  Treponema stenostreptum   species

Rank changed, e.g.,

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -p 1189,2763 \
        | csvtk cut -f -lineage,-lineage-taxids \
        | csvtk pretty 
    taxid   version      change           change-value   name              rank
    1189    2014-08-01   NEW                             Stigonematales    order
    1189    2016-03-01   CHANGE_LIN_LEN                  Stigonematales    order
    1189    2016-09-01   CHANGE_NAME                     Stigonemataceae   family
    1189    2016-09-01   CHANGE_RANK                     Stigonemataceae   family
    1189    2016-09-01   CHANGE_LIN_LEN                  Stigonemataceae   family
    2763    2014-08-01   NEW                             Rhodophyta        no rank
    2763    2019-02-01   CHANGE_RANK                     Rhodophyta        phylum

Stats:

    $ csvtk join -k -f version \
        <(pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f change -p CHANGE_NAME \
        | csvtk freq -f version) \
        <(pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f change -p CHANGE_RANK \
        | csvtk freq -f version) \
        | csvtk rename -f -1 -n name-changed,rank-changed \
        | csvtk pretty
    version      name-changed   rank-changed
    2014-09-01   386            32
    2014-10-01   643            51
    2014-11-01   468            71
    2014-12-01   460            48
    2015-01-01   483            104
    2015-02-01   407            82
    2015-03-01   553            86
    2015-04-01   595            64
    2015-05-01   415            44
    2015-06-01   1278           31
    2015-07-01   673            141
    2015-08-01   280            31
    2015-09-01   418            36
    2015-10-01   529            34
    2015-11-01   1087           58
    2015-12-01   1063           104
    2016-01-01   929            107
    2016-03-01   2032           173
    2016-04-01   1190           123
    2016-05-01   706            31
    2016-06-01   573            153
    2016-08-01   1073           338
    2016-09-01   884            109
    2016-10-01   994            50
    2016-11-01   898            174
    2016-12-01   853            174
    2017-01-01   732            43
    2017-02-01   948            91
    2017-03-01   2022           408
    2017-04-01   784            102
    2017-06-01   574            361
    2017-05-01   606            276
    2017-07-01   523            88
    2017-08-01   568            22
    2017-09-01   660            97
    2017-10-01   894            96
    2017-12-01   1829           109
    2018-01-01   733            28
    2018-02-01   701            29
    2018-03-01   706            97
    2018-04-01   1562           75
    2018-05-01   640            70
    2018-06-01   721            54
    2018-07-01   1028           220
    2018-08-01   718            122
    2018-09-01   599            147
    2018-10-01   536            61
    2018-11-01   371            69
    2018-12-01   244            34
    2019-01-01   532            77
    2019-02-01   372            572
    2019-03-01   395            59
    2019-04-01   537            297
    2019-05-01   415            580
    2019-06-01   326            293
    2019-07-01   293            37

### Lineage taxids remained but lineage changed
  
Because scientifics name of itself (`730`) changed, or these of part taxids with higher ranks (`8492`).

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -p 730,8492 \
        | csvtk pretty
    taxid   version      change           change-value   name                    rank      lineage                                                                                                                                                                                                                                                                    lineage-taxids
    730     2014-08-01   NEW                             Haemophilus ducreyi     species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Pasteurellales;Pasteurellaceae;Haemophilus;Haemophilus ducreyi                                                                                                                                              131567;2;1224;1236;135625;712;724;730
    730     2015-06-01   CHANGE_NAME                     [Haemophilus] ducreyi   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Pasteurellales;Pasteurellaceae;Haemophilus;[Haemophilus] ducreyi                                                                                                                                            131567;2;1224;1236;135625;712;724;730
    730     2015-06-01   CHANGE_LIN_LIN                  [Haemophilus] ducreyi   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Pasteurellales;Pasteurellaceae;Haemophilus;[Haemophilus] ducreyi                                                                                                                                            131567;2;1224;1236;135625;712;724;730
    8492    2014-08-01   NEW                             Archosauria             no rank   cellular organisms;Eukaryota;Opisthokonta;Metazoa;Eumetazoa;Bilateria;Deuterostomia;Chordata;Craniata;Vertebrata;Gnathostomata;Teleostomi;Euteleostomi;Sarcopterygii;Dipnotetrapodomorpha;Tetrapoda;Amniota;Sauropsida;Sauria;Testudines + Archosauria group;Archosauria   131567;2759;33154;33208;6072;33213;33511;7711;89593;7742;7776;117570;117571;8287;1338369;32523;32524;8457;32561;1329799;8492
    8492    2015-01-01   CHANGE_LIN_LIN                  Archosauria             no rank   cellular organisms;Eukaryota;Opisthokonta;Metazoa;Eumetazoa;Bilateria;Deuterostomia;Chordata;Craniata;Vertebrata;Gnathostomata;Teleostomi;Euteleostomi;Sarcopterygii;Dipnotetrapodomorpha;Tetrapoda;Amniota;Sauropsida;Sauria;Archelosauria;Archosauria                    131567;2759;33154;33208;6072;33213;33511;7711;89593;7742;7776;117570;117571;8287;1338369;32523;32524;8457;32561;1329799;8492

### Rank changed from subspecies and species

Steps:

    # get taxids which change rank to species
    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f change -p CHANGE_RANK \
        | csvtk grep -f rank -p species \
        | csvtk cut -f taxid \
        > t.txt
    
    # filter taxids which change rank from subspecies from species
    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -P t.txt \
        | csvtk collapse -f taxid -v rank -s ";" \
        | csvtk grep -f rank -r -p "subspecies.*species" \
        | csvtk cut -f taxid \
        > t.f.txt
    
    # count
    $ csvtk dim t.f.txt
    file      num_cols   num_rows
    t.f.txt          1        432 
   
When did these happend?

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -P t.f.txt \
        | csvtk grep -f change -p CHANGE_RANK \
        | csvtk grep -f rank -p species \
        | csvtk freq -f version -k \
        | csvtk pretty
    version      frequency
    2014-09-01   14
    2014-11-01   29
    2014-12-01   6
    2015-01-01   1
    2015-02-01   9
    2015-03-01   5
    2015-04-01   3
    2015-05-01   2
    2015-06-01   3
    2015-07-01   3
    2015-08-01   3
    2015-09-01   3
    2015-10-01   6
    2015-11-01   2
    2016-01-01   4
    2016-03-01   6
    2016-04-01   4
    2016-05-01   1
    2016-06-01   105
    2016-08-01   11
    2016-09-01   6
    2016-10-01   2
    2016-11-01   6
    2016-12-01   20
    2017-01-01   10
    2017-02-01   2
    2017-03-01   8
    2017-04-01   1
    2017-05-01   6
    2017-06-01   2
    2017-07-01   3
    2017-08-01   5
    2017-09-01   43
    2017-10-01   6
    2017-12-01   9
    2018-01-01   4
    2018-02-01   4
    2018-03-01   3
    2018-04-01   9
    2018-05-01   3
    2018-06-01   2
    2018-07-01   22
    2018-08-01   7
    2018-09-01   4
    2018-10-01   2
    2018-11-01   1
    2018-12-01   1
    2019-01-01   7
    2019-02-01   1
    2019-03-01   2
    2019-04-01   4
    2019-05-01   5
    2019-06-01   3
    
Examples:

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -p 8757,40746,41264 \
        | csvtk cut -f -lineage,-lineage-taxids \
        | csvtk pretty    
    taxid   version      change           change-value   name                                     rank
    8757    2014-08-01   NEW                             Sistrurus catenatus tergeminus           subspecies
    8757    2014-08-01   ABSORB           8761           Sistrurus catenatus tergeminus           subspecies
    8757    2017-08-01   CHANGE_NAME                     Sistrurus tergeminus                     subspecies
    8757    2017-08-01   CHANGE_LIN_LEN                  Sistrurus tergeminus                     subspecies
    8757    2017-12-01   CHANGE_RANK                     Sistrurus tergeminus                     species
    
    40746   2014-08-01   NEW                             Langloisia setosissima subsp. punctata   subspecies
    40746   2014-12-01   ABSORB           1570882        Langloisia punctata                      species
    40746   2014-12-01   CHANGE_NAME                     Langloisia punctata                      species
    40746   2014-12-01   CHANGE_RANK                     Langloisia punctata                      species
    40746   2014-12-01   CHANGE_LIN_LEN                  Langloisia punctata                      species
    40746   2019-06-01   CHANGE_LIN_LIN                  Langloisia punctata                      species
    
    41264   2014-08-01   NEW                             Gerbilliscus kempi gambiana              subspecies
    41264   2014-08-01   ABSORB           410304         Gerbilliscus kempi gambiana              subspecies
    41264   2014-12-01   CHANGE_NAME                     Gerbilliscus gambianus                   species
    41264   2014-12-01   CHANGE_RANK                     Gerbilliscus gambianus                   species
    41264   2014-12-01   CHANGE_LIN_LEN                  Gerbilliscus gambianus                   species
    41264   2017-04-01   CHANGE_LIN_TAX                  Gerbilliscus gambianus                   species

### A superkingdom disappeared

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f rank -p superkingdom \
        | csvtk pretty 
    taxid   version      change   change-value   name        rank           lineage                        lineage-taxids
    2       2014-08-01   NEW                     Bacteria    superkingdom   cellular organisms;Bacteria    131567;2
    2157    2014-08-01   NEW                     Archaea     superkingdom   cellular organisms;Archaea     131567;2157
    2759    2014-08-01   NEW                     Eukaryota   superkingdom   cellular organisms;Eukaryota   131567;2759
    10239   2014-08-01   NEW                     Viruses     superkingdom   Viruses                        10239
    12884   2014-08-01   NEW                     Viroids     superkingdom   Viroids                        12884
    12884   2019-05-01   DELETE                  Viroids     superkingdom   Viroids                        12884


to be continue ...
        
## Method

Data source: https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump_archive/

Dependencies:
    
- rush, https://github.com/shenwei356/rush/
- taxonkit, https://github.com/shenwei356/taxonkit/, version 0.4.3 or later

Hardware requirements:

- DISK: > 15 GiB
- RAM: >= 48 GiB (40 GiB for 57 archives, in 11 min)

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
