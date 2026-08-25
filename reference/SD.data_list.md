# SD.data_list

Returns metadata of available data from Bioc OSN and scverse
spatialdata- sandbox S3 buckets

## Usage

``` r
SD.data_list(metadata = FALSE)
```

## Arguments

- metadata:

  if TRUE, all columns will be returned, e.g. File size, License etc.

## Value

a vector of dataset names or a data.frame

## Examples

``` r
SD.data_list()
#>  [1] "MouseIntestineVisHD"        "MouseBrainVisHD"           
#>  [3] "MouseBrainVis"              "LungAdenocarcinomaMCMICRO" 
#>  [5] "MouseBrainMERFISH"          "MouseLiverMERFISH"         
#>  [7] "ColorectalCarcinomaMIBITOF" "MulticancerSteinbock"      
#>  [9] "JanesickBreastVisiumEnh"    "JanesickBreastXeniumRep1"  
#> [11] "JanesickBreastXeniumRep2"   "HumanLungMulti_10x"        
#> [13] "Breast2fov_10x"             "Lung2fov_10x"              
#> [15] "SpaceMHelaniH3T3"          
SD.data_list(metadata = TRUE)
#>                          Name             Technology
#> 1         MouseIntestineVisHD              Visium HD
#> 2         MouseIntestineVisHD              Visium HD
#> 3             MouseBrainVisHD              Visium HD
#> 4               MouseBrainVis                 Visium
#> 5   LungAdenocarcinomaMCMICRO CyCIF (MCMICRO output)
#> 6           MouseBrainMERFISH                MERFISH
#> 7           MouseBrainMERFISH                MERFISH
#> 8           MouseLiverMERFISH                MERFISH
#> 9  ColorectalCarcinomaMIBITOF               MIBI-TOF
#> 10 ColorectalCarcinomaMIBITOF               MIBI-TOF
#> 11       MulticancerSteinbock IMC (Steinbock output)
#> 12    JanesickBreastVisiumEnh                 Visium
#> 13    JanesickBreastVisiumEnh                 Visium
#> 14   JanesickBreastXeniumRep1                 Xenium
#> 15   JanesickBreastXeniumRep1                 Xenium
#> 16   JanesickBreastXeniumRep2                 Xenium
#> 17         HumanLungMulti_10x                 Xenium
#> 18         HumanLungMulti_10x                 Xenium
#> 19             Breast2fov_10x       Xenium (trimmed)
#> 20             Breast2fov_10x       Xenium (trimmed)
#> 21               Lung2fov_10x       Xenium (trimmed)
#> 22               Lung2fov_10x       Xenium (trimmed)
#> 23           SpaceMHelaniH3T3                 SpaceM
#>                                          Sample Table (Nfeat,Nobs)
#> 1                               Mouse intestine    (19059,5479660)
#> 2                               Mouse intestine    (19059,5479660)
#> 3                                   Mouse brain      (33696,84031)
#> 4                                   Mouse brain       (31053,6484)
#> 5               Human small lung adenocarcinoma         (12,11607)
#> 6                                   Mouse brain         (268,2389)
#> 7                                   Mouse brain         (268,2389)
#> 8                                  Mouse liver           (99,3375)
#> 9                    Human colorectal carcinoma          (36,3309)
#> 10                   Human colorectal carcinoma          (36,3309)
#> 11 4 different cancers (SCCHN, BCC, NSCLC, CRC)         (40,47859)
#> 12                          Human breast cancer       (18085,4992)
#> 13                          Human breast cancer       (18085,4992)
#> 14                          Human breast cancer       (313,167780)
#> 15                          Human breast cancer       (313,167780)
#> 16                          Human breast cancer       (313,118752)
#> 17                            Human lung Cancer       (377,162254)
#> 18                            Human lung Cancer       (377,162254)
#> 19                              Breast (2 FOVs)         (280,7275)
#> 20                              Breast (2 FOVs)         (280,7275)
#> 21                                Lung (2 FOVs)        (289,11898)
#> 22                                Lung (2 FOVs)        (289,11898)
#> 23                        Hepa and NIH3T3 cells        (327,14425)
#>        Image (dim) Nmolecules File Size     S3 buckets Zarr Format
#> 1  (3,21943,23618)         NA      1 GB        biocOSN          v2
#> 2  (3,21943,23618)         NA      1 GB        sandbox          v3
#> 3    (3,5492,6000)         NA    174 MB        sandbox          v3
#> 4    (3,2000,1969)         NA     65 MB        sandbox          v3
#> 5   (12,3139,2511)         NA    250 MB        biocOSN          v2
#> 6      (1,522,575)    3714642     50 MB        biocOSN          v2
#> 7      (1,522,575)    3714642     50 MB        sandbox          v3
#> 8    (1,6432,6432)    1153548     66 MB        sandbox          v3
#> 9    (3,1024,1024)         NA     25 MB        biocOSN          v2
#> 10   (3,1024,1024)         NA     25 MB        sandbox          v3
#> 11    (40,600,600)         NA    820 MB        biocOSN          v2
#> 12 (3,21571,19505)         NA    1.5 GB        biocOSN          v2
#> 13 (3,21571,19505)         NA    1.5 GB        sandbox          v3
#> 14 (1,25778,35416)   42638083    2.8 GB        biocOSN          v2
#> 15 (1,25778,35416)   42638083    2.8 GB        sandbox          v3
#> 16 (1,25779,35411)   31997227    3.7 GB        biocOSN          v2
#> 17 (5,17098,51187)   12165021    5.4 GB        biocOSN          v2
#> 18 (5,17098,51187)   12165021    5.4 GB        sandbox          v3
#> 19   (4,3529,5792)    1113950    380 MB biocOSN_Xenium          v2
#> 20   (4,3529,5792)    1113950    380 MB biocOSN_Xenium          v3
#> 21   (1,3553,5791)     825885    280 MB biocOSN_Xenium          v2
#> 22   (1,3553,5791)     825885    280 MB biocOSN_Xenium          v3
#> 23   (2,2675,2675)         NA     49 MB        sandbox          v3
#>              License                     Pattern
#> 1                CCA             visium_hd_3.0.0
#> 2                CCA             visium_hd_3.0.0
#> 3     CC BY 4.0 DEED             visium_hd_4.0.1
#> 4     CC BY 4.0 DEED          visium_spatialdata
#> 5  CC BY-NC 4.0 DEED                  mcmicro_io
#> 6       CC0 1.0 DEED                     merfish
#> 7       CC0 1.0 DEED                     merfish
#> 8     CC BY 4.0 DEED                 mouse_liver
#> 9     CC BY 4.0 DEED                     mibitof
#> 10    CC BY 4.0 DEED                     mibitof
#> 11    CC BY 4.0 DEED                steinbock_io
#> 12               CCA visium_associated_xenium_io
#> 13               CCA visium_associated_xenium_io
#> 14               CCA              xenium_rep1_io
#> 15               CCA              xenium_rep1_io
#> 16               CCA              xenium_rep2_io
#> 17    CC BY 4.0 DEED              HuLungXenmulti
#> 18    CC BY 4.0 DEED                xenium_2.0.0
#> 19               CCA Xenium_V1_human_Breast_2fov
#> 20               CCA Xenium_V1_human_Breast_2fov
#> 21               CCA   Xenium_V1_human_Lung_2fov
#> 22               CCA   Xenium_V1_human_Lung_2fov
#> 23    CC BY 4.0 DEED           spacem_helanih3t3
```
