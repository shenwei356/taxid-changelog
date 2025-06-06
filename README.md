![changes.png](stats/changes.png)

# taxid-changelog

NCBI taxonomic identifier (taxIDs) changelog, 
tracking taxIDs deletion, new adding, merge, reuse, and rank/name changes.

Please cite [TaxonKit](https://github.com/shenwei356/taxonkit): [https://doi.org/10.1016/j.jgg.2021.03.006](https://www.sciencedirect.com/science/article/pii/S1673852721000837)


## Table of contents

<!-- TOC -->
- [Download](#download)
- [Format](#format)
- [Results](#results)
    - [TaxIDs were deleted, newly added and re-used](#taxids-were-deleted-newly-added-and-re-used)
    - [Scientific names and ranks changed](#scientific-names-and-ranks-changed)
    - [Lineage TaxIDs remained but lineage changed](#lineage-taxids-remained-but-lineage-changed)
    - [Rank changed from subspecies and species](#rank-changed-from-subspecies-and-species)
    - [A superkingdom disappeared](#a-superkingdom-disappeared)
- [Method](#method)
- [Citation](#citation)
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
                    #   CHANGE_NAME     scientific name changed
                    #   CHANGE_RANK     rank changed
                    #   CHANGE_LIN_LIN  lineage taxids remain but lineage changed
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

Example 2 (SARS-CoV-2)

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -p 2697049 \
        | csvtk pretty
        
    taxid     version      change           change-value   name                                              rank      lineage                                                                                                                                                                                                                                                        lineage-taxids                                                                                  
    -------   ----------   --------------   ------------   -----------------------------------------------   -------   ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   ------------------------------------------------------------------------------------------------
    2697049   2020-02-01   NEW                             Wuhan seafood market pneumonia virus              species   Viruses;Riboviria;Nidovirales;Cornidovirineae;Coronaviridae;Orthocoronavirinae;Betacoronavirus;unclassified Betacoronavirus;Wuhan seafood market pneumonia virus                                                                                               10239;2559587;76804;2499399;11118;2501931;694002;696098;2697049                                 
    2697049   2020-03-01   CHANGE_NAME                     Severe acute respiratory syndrome coronavirus 2   no rank   Viruses;Riboviria;Nidovirales;Cornidovirineae;Coronaviridae;Orthocoronavirinae;Betacoronavirus;Sarbecovirus;Severe acute respiratory syndrome-related coronavirus;Severe acute respiratory syndrome coronavirus 2                                              10239;2559587;76804;2499399;11118;2501931;694002;2509511;694009;2697049                         
    2697049   2020-03-01   CHANGE_RANK                     Severe acute respiratory syndrome coronavirus 2   no rank   Viruses;Riboviria;Nidovirales;Cornidovirineae;Coronaviridae;Orthocoronavirinae;Betacoronavirus;Sarbecovirus;Severe acute respiratory syndrome-related coronavirus;Severe acute respiratory syndrome coronavirus 2                                              10239;2559587;76804;2499399;11118;2501931;694002;2509511;694009;2697049                         
    2697049   2020-03-01   CHANGE_LIN_LEN                  Severe acute respiratory syndrome coronavirus 2   no rank   Viruses;Riboviria;Nidovirales;Cornidovirineae;Coronaviridae;Orthocoronavirinae;Betacoronavirus;Sarbecovirus;Severe acute respiratory syndrome-related coronavirus;Severe acute respiratory syndrome coronavirus 2                                              10239;2559587;76804;2499399;11118;2501931;694002;2509511;694009;2697049                         
    2697049   2020-06-01   CHANGE_LIN_LEN                  Severe acute respiratory syndrome coronavirus 2   no rank   Viruses;Riboviria;Orthornavirae;Pisuviricota;Pisoniviricetes;Nidovirales;Cornidovirineae;Coronaviridae;Orthocoronavirinae;Betacoronavirus;Sarbecovirus;Severe acute respiratory syndrome-related coronavirus;Severe acute respiratory syndrome coronavirus 2   10239;2559587;2732396;2732408;2732506;76804;2499399;11118;2501931;694002;2509511;694009;2697049 
    2697049   2020-07-01   CHANGE_RANK                     Severe acute respiratory syndrome coronavirus 2   isolate   Viruses;Riboviria;Orthornavirae;Pisuviricota;Pisoniviricetes;Nidovirales;Cornidovirineae;Coronaviridae;Orthocoronavirinae;Betacoronavirus;Sarbecovirus;Severe acute respiratory syndrome-related coronavirus;Severe acute respiratory syndrome coronavirus 2   10239;2559587;2732396;2732408;2732506;76804;2499399;11118;2501931;694002;2509511;694009;2697049 
    2697049   2020-08-01   CHANGE_RANK                     Severe acute respiratory syndrome coronavirus 2   no rank   Viruses;Riboviria;Orthornavirae;Pisuviricota;Pisoniviricetes;Nidovirales;Cornidovirineae;Coronaviridae;Orthocoronavirinae;Betacoronavirus;Sarbecovirus;Severe acute respiratory syndrome-related coronavirus;Severe acute respiratory syndrome coronavirus 2   10239;2559587;2732396;2732408;2732506;76804;2499399;11118;2501931;694002;2509511;694009;2697049 
    2697049   2025-05-01   CHANGE_LIN_TAX                  Severe acute respiratory syndrome coronavirus 2   no rank   Viruses;Riboviria;Orthornavirae;Pisuviricota;Pisoniviricetes;Nidovirales;Cornidovirineae;Coronaviridae;Orthocoronavirinae;Betacoronavirus;Sarbecovirus;Betacoronavirus pandemicum;Severe acute respiratory syndrome coronavirus 2                              10239;2559587;2732396;2732408;2732506;76804;2499399;11118;2501931;694002;2509511;3418604;2697049

Example 3 (*E.coli* with taxid `562`)

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -p 562 \
        | csvtk pretty
        
    taxid   version      change           change-value    name               rank      lineage                                                                                                                                          lineage-taxids                              
    -----   ----------   --------------   -------------   ----------------   -------   ----------------------------------------------------------------------------------------------------------------------------------------------   --------------------------------------------
    562     2013-02-21   NEW                              Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia coli                 131567;2;1224;1236;91347;543;561;562        
    562     2013-02-21   ABSORB           662101;662104   Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia coli                 131567;2;1224;1236;91347;543;561;562        
    562     2015-11-01   ABSORB           1637691         Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Escherichia;Escherichia coli                 131567;2;1224;1236;91347;543;561;562        
    562     2016-10-01   CHANGE_LIN_LIN                   Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia coli                  131567;2;1224;1236;91347;543;561;562        
    562     2018-06-01   ABSORB           469598          Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia coli                  131567;2;1224;1236;91347;543;561;562        
    562     2021-11-01   ABSORB           1806490         Escherichia coli   species   cellular organisms;Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia coli                  131567;2;1224;1236;91347;543;561;562        
    562     2023-02-01   CHANGE_LIN_LIN                   Escherichia coli   species   cellular organisms;Bacteria;Pseudomonadota;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia coli                  131567;2;1224;1236;91347;543;561;562        
    562     2024-12-01   CHANGE_LIN_LEN                   Escherichia coli   species   cellular organisms;Bacteria;Pseudomonadati;Pseudomonadota;Gammaproteobacteria;Enterobacterales;Enterobacteriaceae;Escherichia;Escherichia coli   131567;2;3379134;1224;1236;91347;543;561;562

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

Example 4 (All subspecies and strain in *Akkermansia muciniphila* 239935)

    # species in Akkermansia
    $ taxonkit list --show-rank --show-name --ids 239935
    239935 [species] Akkermansia muciniphila
      349741 [strain] Akkermansia muciniphila ATCC BAA-835
      1263034 [strain] Akkermansia muciniphila CAG:154


    
    # check them all  
    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -P <(echo 239935 | taxonkit list --indent "") \
        | csvtk pretty

    taxid     version      change           change-value   name                                   rank      lineage                                                                                                                                                                                                         lineage-taxids                                                           
    -------   ----------   --------------   ------------   ------------------------------------   -------   -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   -------------------------------------------------------------------------
    239935    2013-02-21   NEW                             Akkermansia muciniphila                species   cellular organisms;Bacteria;Chlamydiae/Verrucomicrobia group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Verrucomicrobiaceae;Akkermansia;Akkermansia muciniphila                                        131567;2;51290;74201;203494;48461;203557;239934;239935                   
    239935    2015-05-01   CHANGE_LIN_TAX                  Akkermansia muciniphila                species   cellular organisms;Bacteria;Chlamydiae/Verrucomicrobia group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila                                            131567;2;51290;74201;203494;48461;1647988;239934;239935                  
    239935    2016-03-01   CHANGE_LIN_TAX                  Akkermansia muciniphila                species   cellular organisms;Bacteria;PVC group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila                                                                   131567;2;1783257;74201;203494;48461;1647988;239934;239935                
    239935    2016-05-01   ABSORB           1834199        Akkermansia muciniphila                species   cellular organisms;Bacteria;PVC group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila                                                                   131567;2;1783257;74201;203494;48461;1647988;239934;239935                
    239935    2023-03-01   CHANGE_LIN_LIN                  Akkermansia muciniphila                species   cellular organisms;Bacteria;PVC group;Verrucomicrobiota;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila                                                                 131567;2;1783257;74201;203494;48461;1647988;239934;239935                
    239935    2024-06-01   CHANGE_LIN_LIN                  Akkermansia muciniphila                species   cellular organisms;Bacteria;PVC group;Verrucomicrobiota;Verrucomicrobiia;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila                                                                 131567;2;1783257;74201;203494;48461;1647988;239934;239935                
    239935    2025-01-01   CHANGE_LIN_LEN                  Akkermansia muciniphila                species   cellular organisms;Bacteria;Pseudomonadati;PVC group;Verrucomicrobiota;Verrucomicrobiia;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila                                                  131567;2;3379134;1783257;74201;203494;48461;1647988;239934;239935        
 
    349741    2013-02-21   NEW                             Akkermansia muciniphila ATCC BAA-835   no rank   cellular organisms;Bacteria;Chlamydiae/Verrucomicrobia group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Verrucomicrobiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila ATCC BAA-835   131567;2;51290;74201;203494;48461;203557;239934;239935;349741            
    349741    2015-05-01   CHANGE_LIN_TAX                  Akkermansia muciniphila ATCC BAA-835   no rank   cellular organisms;Bacteria;Chlamydiae/Verrucomicrobia group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila ATCC BAA-835       131567;2;51290;74201;203494;48461;1647988;239934;239935;349741           
    349741    2016-03-01   CHANGE_LIN_TAX                  Akkermansia muciniphila ATCC BAA-835   no rank   cellular organisms;Bacteria;PVC group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila ATCC BAA-835                              131567;2;1783257;74201;203494;48461;1647988;239934;239935;349741         
    349741    2020-07-01   CHANGE_RANK                     Akkermansia muciniphila ATCC BAA-835   strain    cellular organisms;Bacteria;PVC group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila ATCC BAA-835                              131567;2;1783257;74201;203494;48461;1647988;239934;239935;349741         
    349741    2023-03-01   CHANGE_LIN_LIN                  Akkermansia muciniphila ATCC BAA-835   strain    cellular organisms;Bacteria;PVC group;Verrucomicrobiota;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila ATCC BAA-835                            131567;2;1783257;74201;203494;48461;1647988;239934;239935;349741         
    349741    2024-06-01   CHANGE_LIN_LIN                  Akkermansia muciniphila ATCC BAA-835   strain    cellular organisms;Bacteria;PVC group;Verrucomicrobiota;Verrucomicrobiia;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila ATCC BAA-835                            131567;2;1783257;74201;203494;48461;1647988;239934;239935;349741         
    349741    2025-01-01   CHANGE_LIN_LEN                  Akkermansia muciniphila ATCC BAA-835   strain    cellular organisms;Bacteria;Pseudomonadati;PVC group;Verrucomicrobiota;Verrucomicrobiia;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila ATCC BAA-835             131567;2;3379134;1783257;74201;203494;48461;1647988;239934;239935;349741 

    1263034   2013-02-21   DELETE                                                                                                                                                                                                                                                                                                                                                                    
    1263034   2014-06-03   REUSE_DEL                       Akkermansia muciniphila CAG:154        species   cellular organisms;Bacteria;Chlamydiae/Verrucomicrobia group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Verrucomicrobiaceae;Akkermansia;environmental samples;Akkermansia muciniphila CAG:154          131567;2;51290;74201;203494;48461;203557;239934;512293;1263034           
    1263034   2015-05-01   CHANGE_LIN_TAX                  Akkermansia muciniphila CAG:154        species   cellular organisms;Bacteria;Chlamydiae/Verrucomicrobia group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;environmental samples;Akkermansia muciniphila CAG:154              131567;2;51290;74201;203494;48461;1647988;239934;512293;1263034          
    1263034   2016-03-01   CHANGE_LIN_TAX                  Akkermansia muciniphila CAG:154        species   cellular organisms;Bacteria;PVC group;Verrucomicrobia;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;environmental samples;Akkermansia muciniphila CAG:154                                     131567;2;1783257;74201;203494;48461;1647988;239934;512293;1263034        
    1263034   2023-03-01   CHANGE_LIN_LIN                  Akkermansia muciniphila CAG:154        species   cellular organisms;Bacteria;PVC group;Verrucomicrobiota;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;environmental samples;Akkermansia muciniphila CAG:154                                   131567;2;1783257;74201;203494;48461;1647988;239934;512293;1263034        
    1263034   2023-08-01   CHANGE_RANK                     Akkermansia muciniphila CAG:154        strain    cellular organisms;Bacteria;PVC group;Verrucomicrobiota;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila CAG:154                                 131567;2;1783257;74201;203494;48461;1647988;239934;239935;1263034        
    1263034   2023-08-01   CHANGE_LIN_TAX                  Akkermansia muciniphila CAG:154        strain    cellular organisms;Bacteria;PVC group;Verrucomicrobiota;Verrucomicrobiae;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila CAG:154                                 131567;2;1783257;74201;203494;48461;1647988;239934;239935;1263034        
    1263034   2024-06-01   CHANGE_LIN_LIN                  Akkermansia muciniphila CAG:154        strain    cellular organisms;Bacteria;PVC group;Verrucomicrobiota;Verrucomicrobiia;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila CAG:154                                 131567;2;1783257;74201;203494;48461;1647988;239934;239935;1263034        
    1263034   2025-01-01   CHANGE_LIN_LEN                  Akkermansia muciniphila CAG:154        strain    cellular organisms;Bacteria;Pseudomonadati;PVC group;Verrucomicrobiota;Verrucomicrobiia;Verrucomicrobiales;Akkermansiaceae;Akkermansia;Akkermansia muciniphila;Akkermansia muciniphila CAG:154                  131567;2;3379134;1783257;74201;203494;48461;1647988;239934;239935;1263034


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
        | csvtk grep -f change -p MERGE \
        | csvtk freq -f version) \
        <(pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f change -p REUSE_DEL \
        | csvtk freq -f version) \
        <(pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f change -p REUSE_MER \
        | csvtk freq -f version) \
        | csvtk rename -f -1 -n deleted,newly_added,merged,deleted_reused,merged_reused \
        | csvtk pretty
    
    version      deleted   newly_added   merged   deleted_reused   merged_reused
    2014-08-01   310603    1184830       33153                     
    2014-09-01   7957      3362          211      7694             
    2014-10-01   6535      3856          381      5590             
    2014-11-01   9568      5849          463      6037             
    2014-12-01   7147      3699          255      6378             
    2015-01-01   7650      5104          295      4762             
    2015-02-01   14911     2699          240      9900             
    2015-03-01   9123      4117          273      6025             
    2015-04-01   13748     3398          316      9951             
    2015-05-01   8381      2639          554      6279             
    2015-06-01   8629      3320          447      4385             
    2015-07-01   12746     4140          438      14992            
    2015-08-01   14680     4300          232      8300             
    2015-09-01   6646      4083          404      8330             
    2015-10-01   16933     6052          342      12273            
    2015-11-01   12169     4727          620      15613            
    2015-12-01   9782      6298          436      13206            
    2016-01-01   7834      4133          446      9175             
    2016-03-01   18825     13532         1230     12250            
    2016-04-01   10135     6106          469      6461             
    2016-05-01   13835     4704          449      14778            1
    2016-06-01   6303      6110          434      14237            1
    2016-08-01   14866     13730         633      10324            2
    2016-09-01   8033      4683          273      8450             
    2016-10-01   6420      2084          219      6213             
    2016-11-01   5097      3548          1419     3765             2
    2016-12-01   5881      3517          219      7113             1
    2017-01-01   4208      3102          298      5800             
    2017-02-01   6762      3108          310      4588             
    2017-03-01   8929      13341         371      5509             
    2017-04-01   6721      4026          347      6778             
    2017-05-01   4904      4306          217      7364             
    2017-06-01   12789     9715          287      4746             
    2017-07-01   6974      4622          329      3735             3
    2017-08-01   3669      2483          285      14135            
    2017-09-01   6716      2853          253      3892             
    2017-10-01   5766      2451          369      4865             
    2017-12-01   8194      7087          564      8602             
    2018-01-01   7732      2711          382      4123             1
    2018-02-01   9020      4106          325      6676             
    2018-03-01   17113     9415          326      3743             
    2018-04-01   14688     16683         422      16358            
    2018-05-01   31551     4950          292      9794             
    2018-06-01   31336     6040          430      22034            
    2018-07-01   35696     10657         260      17726            
    2018-08-01   21046     11585         246      20586            
    2018-09-01   4992      10658         404      15697            
    2018-10-01   78319     34128         384      12118            
    2018-11-01   34245     31692         509      68228            
    2018-12-01   5699      1856          210      33487            
    2019-01-01   3722      2562          330      4653             
    2019-02-01   5488      5990          404      4411             
    2019-03-01   12567     6473          219      3598             
    2019-04-01   12807     19580         271      11672            1
    2019-05-01   10502     2453          345      4103             
    2019-06-01   8008      1458          509      13797            
    2019-07-01   5050      2192          371      6695             
    2019-08-01   6041      1611          256      6501             
    2019-09-01   4975      2541          191      5328             
    2019-10-01   10854     32970         278      3497             
    2019-11-01   10648     2025          223      3530             
    2019-12-01   11905     5727          351      7961             
    2020-01-01   8928      4337          262      15423            
    2020-02-01   8566      2024          292      8309 
    2020-03-01   5752      3051          390      3998             
    2020-04-01   6982      2149          522      4085 
    2020-05-01   6380      2277          434      7099             
    2020-06-01   5648      3182          429      5504             
    2020-07-01   6715      1982          366      4379
    2020-08-01   8667      2053          632      4155             
    2020-09-01   7135      1457          325      5425
    2020-10-01   6091      2567          346      6654             
    2020-11-01   5126      1479          365      4754 
    2020-12-01   5726      3696          358      4986             
    2021-01-01   5506      1661          472      3561             
    2021-02-01   4320      2260          559      6528             
    2021-03-01   7015      1395          400      5145
    2021-04-01   5230      2101          650      4633             1
    2021-05-01   7419      1687          549      4324             2
    2021-06-01   6654      2052          321      4623 
    
[The paper of NCBI Taxonomy database](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3245000/):

> Taxids are stable and persistent—they may be deleted
> (when taxa are removed from the database),
> and they may be merged (when taxa are synonymized), 
> but they will never be reused to identify a different taxon.

**Deleted taxid can be re-used**, e.g., `1157319` was reused to identify the same taxon.

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
    1157319   2020-06-01   CHANGE_LIN_LEN                  Lactococcus phage ASCC   species   Viruses;Duplodnaviria;Heunggongvirae;Uroviricota;Caudoviricetes;Caudovirales;Siphoviridae;Skunavirus;unclassified Skunavirus;Lactococcus phage ASCC                                                                                                                                                                                                                                           10239;2731341;2731360;2731618;2731619;28883;10699;1623305;2050979;1157319

The full list:

    $ pigz -cd taxid-changelog.csv.gz \
        | grep REUSE_DEL \
        | csvtk cut -f 1 \
        > reuse_del.txt
    
    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -P reuse_del.txt \
        | csvtk fold -f taxid -v change \
        | csvtk grep -f change -r -p ^DELETE -v \
        | csvtk cut -f taxid \
        > reuse_del.afterAug2014.txt
        
    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f taxid -P reuse_del.afterAug2014.txt \
        > reuse_del.afterAug2014.txt.detail

Don't worry, reused taxIDs are assigned to the same taxon.
    
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
    2019-08-01   423            70
    2019-09-01   287            14
    2019-10-01   465            11
    2019-11-01   378            78
    2020-01-01   497            40
    2020-02-01   361            24
    2020-03-01   805            33
    2020-04-01   572            15
    2020-05-01   848            36
    2020-06-01   495            775
    2020-07-01   611            215932
    2020-08-01   631            167799
    2020-09-01   748            34
    2020-10-01   1206           42
    2020-11-01   610            126
    2020-12-01   566            84
    2021-01-01   983            48
    2021-02-01   1931           51
    2021-03-01   1327           50
        
What happend on 2020-07-01?

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f version -p 2020-07-01 \
        | csvtk grep -f change -p CHANGE_RANK \
        | csvtk freq -f rank -nr \
        | csvtk pretty
        
    rank              frequency
    isolate           111108
    strain            101971
    serotype          1144
    clade             822
    forma specialis   740
    serogroup         71
    genotype          20
    biotype           17
    species           14
    morph             11
    pathogroup        5
    subvariety        5
    family            1
    genus             1
    subgenus          1
    tribe             1
    
    # where are they from
    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f version -p 2020-07-01 \
        | csvtk grep -f change -p CHANGE_RANK \
        | csvtk cut -f taxid \
        > rank-changed-2020-07.taxid
    # ranks before 2020-07-01
    pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f taxid -P rank-changed-2020-07.taxid \
            | csvtk grep -f version -p 2020-07-01 -p 2020-08-01 -p 2020-09-01 -v \
            | csvtk cut -f taxid,version,rank \
            | csvtk sort -k taxid:n -k version:r \
            | csvtk uniq -f taxid \
            > rank-changed-2020-07.taxid.before-2020-07.csv
    # ranks on 2020-07-01
    $ pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f taxid -P rank-changed-2020-07.taxid \
            | csvtk grep -f version -p 2020-07-01 \
            | csvtk cut -f taxid,version,rank \
            > rank-changed-2020-07.taxid.2020-07.csv
    # join
    $ csvtk join --outer-join -f taxid rank-changed-2020-07.taxid.before-2020-07.csv rank-changed-2020-07.taxid.2020-07.csv \
        | csvtk rename -f 3 -n "<2020.07" \
        | csvtk rename -f 5 -n 2020.07 \
        | csvtk freq -f "<2020.07,2020.07" -nr \
        | csvtk pretty
    <2020.07     2020.07           frequency
    no rank      isolate           110937
    no rank      strain            102294
    no rank      serotype          1144
    no rank      clade             939
    no rank      forma specialis   759
    species      isolate           663
    no rank      serogroup         71
    no rank      genotype          20
    no rank      biotype           17
    no rank      species           14
    no rank      morph             11
    subspecies   species           11
    no rank      pathogroup        5
    no rank      subvariety        5
    species      strain            3
    subfamily    family            3
    subfamily    tribe             3
    varietas     species           3
    genus        subgenus          2
    subgenus     genus             2
    
What happend on 2020-08-01?

    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f version -p 2020-08-01 \
        | csvtk grep -f change -p CHANGE_RANK \
        | csvtk freq -f rank -nr \
        | csvtk pretty
    rank         frequency
    no rank      167603
    serotype     106
    clade        59
    species      15
    subspecies   9
    subgenus     3
    varietas     3
    family       1
    
Well, lots of "isolate" and "strain" are changed back to "no rank" again.

    # taxid with rank changed to "no rank" on 2020-08-01
    $ pigz -cd taxid-changelog.csv.gz \
        | csvtk grep -f version -p 2020-08-01 \
        | csvtk grep -f rank -p "no rank" \
        | csvtk cut -f taxid \
        > norank-2020-08.taxid

    # ranks before 2020-07-01
    $ pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f taxid -P norank-2020-08.taxid \
            | csvtk grep -f version -p 2020-07-01 -p 2020-08-01 -p 2020-09-01 -v \
            | csvtk cut -f taxid,version,rank \
            | csvtk sort -k taxid:n -k version:r \
            | csvtk uniq -f taxid \
            > norank-2020-08.taxid.before-2020-07.csv

    # ranks on 2020-07-01
    $ pigz -cd taxid-changelog.csv.gz \
            | csvtk grep -f taxid -P norank-2020-08.taxid \
            | csvtk grep -f version -p 2020-07-01 \
            | csvtk cut -f taxid,version,rank \
            > norank-2020-08.taxid.2020-07.csv

    # join  
    $ csvtk join --outer-join -f taxid norank-2020-08.taxid.before-2020-07.csv norank-2020-08.taxid.2020-07.csv \
        | csvtk rename -f 3 -n "<2020.07" \
        | csvtk rename -f 5 -n 2020.07 \
        | csvtk mutate2 -n 2020.08 -e '"no rank"' \
        | csvtk freq -f "<2020.07,2020.07,2020.08" -nr \
        | csvtk pretty        
    <2020.07   2020.07    2020.08   frequency
    no rank    isolate    no rank   109585
    no rank    strain     no rank   57724
    species    isolate    no rank   660
                          no rank   198
    no rank               no rank   186
    species               no rank   59
    no rank    serotype   no rank   52
               isolate    no rank   18
    no rank    no rank    no rank   9
    species    species    no rank   3
               no rank    no rank   2
    species    strain     no rank   2
    
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
    8492    2020-07-01   CHANGE_RANK                     Archosauria             clade     cellular organisms;Eukaryota;Opisthokonta;Metazoa;Eumetazoa;Bilateria;Deuterostomia;Chordata;Craniata;Vertebrata;Gnathostomata;Teleostomi;Euteleostomi;Sarcopterygii;Dipnotetrapodomorpha;Tetrapoda;Amniota;Sauropsida;Sauria;Archelosauria;Archosauria                    131567;2759;33154;33208;6072;33213;33511;7711;89593;7742;7776;117570;117571;8287;1338369;32523;32524;8457;32561;1329799;8492

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
    $ csvtk nrow t.f.txt
    651
   
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
    2019-08-01   6
    2019-09-01   3
    2019-10-01   1
    2019-11-01   4
    2019-11-01   4
    2019-12-01   1
    2020-02-01   6
    2020-03-01   9
    2020-04-01   2
    2020-05-01   6
    2020-06-01   170
    2020-07-01   5
    2020-08-01   5
    2020-09-01   1
    2020-10-01   7
    2020-11-01   8

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

- DISK: > 30 GiB
- RAM: >= 100 GiB (79 GiB for 131 archives, in 43 min, 2025/05/01)

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
            --immediate-output  -c -C _download.rush

    # --------- unzip ---------

    ls taxdmp*.zip \
        | rush -j 1 'unzip {} names.dmp nodes.dmp merged.dmp delnodes.dmp -d {@_(.+)\.}' \
        -c -C _unzip.rush --eta

    # optionally compress .dmp files with pigz, for saving disk space
    fd .dmp$ | rush -j 4 'pigz {}' --eta

    # --------- create log ---------

    cd ..
    time taxonkit taxid-changelog -i archive -o taxid-changelog.csv.gz --verbose

## Citation

> Shen, W., Ren, H., TaxonKit: a practical and efficient NCBI Taxonomy toolkit,
> Journal of Genetics and Genomics, [https://doi.org/10.1016/j.jgg.2021.03.006](https://www.sciencedirect.com/science/article/pii/S1673852721000837)

## Contributing

We welcome pull requests, bug fixes and issue reports.

## License

[MIT License](https://github.com/shenwei356/taxid-changelog/blob/master/LICENSE)
