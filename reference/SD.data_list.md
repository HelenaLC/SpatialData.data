# SD.data_list

Returns metadata of available data from Bioc OSN and scverse
spatialdata- sandbox S3 buckets

## Usage

``` r
SD.data_list(extended = FALSE)
```

## Arguments

- extended:

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
SD.data_list(extended = TRUE)
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
#>                                          Sample     S3_buckets Zarr_Format
#> 1                               Mouse intestine        biocOSN          v2
#> 2                               Mouse intestine        sandbox          v3
#> 3                                   Mouse brain        sandbox          v3
#> 4                                   Mouse brain        sandbox          v3
#> 5               Human small lung adenocarcinoma        biocOSN          v2
#> 6                                   Mouse brain        biocOSN          v2
#> 7                                   Mouse brain        sandbox          v3
#> 8                                  Mouse liver         sandbox          v3
#> 9                    Human colorectal carcinoma        biocOSN          v2
#> 10                   Human colorectal carcinoma        sandbox          v3
#> 11 4 different cancers (SCCHN, BCC, NSCLC, CRC)        biocOSN          v2
#> 12                          Human breast cancer        biocOSN          v2
#> 13                          Human breast cancer        sandbox          v3
#> 14                          Human breast cancer        biocOSN          v2
#> 15                          Human breast cancer        sandbox          v3
#> 16                          Human breast cancer        biocOSN          v2
#> 17                            Human lung Cancer        biocOSN          v2
#> 18                            Human lung Cancer        sandbox          v3
#> 19                              Breast (2 FOVs) biocOSN_Xenium          v2
#> 20                              Breast (2 FOVs) biocOSN_Xenium          v3
#> 21                                Lung (2 FOVs) biocOSN_Xenium          v2
#> 22                                Lung (2 FOVs) biocOSN_Xenium          v3
#> 23                        Hepa and NIH3T3 cells        sandbox          v3
#>    FileSize           License                     Pattern
#> 1      1 GB               CCA             visium_hd_3.0.0
#> 2      1 GB               CCA             visium_hd_3.0.0
#> 3    174 MB    CC BY 4.0 DEED             visium_hd_4.0.1
#> 4     65 MB    CC BY 4.0 DEED          visium_spatialdata
#> 5    250 MB CC BY-NC 4.0 DEED                  mcmicro_io
#> 6     50 MB      CC0 1.0 DEED                     merfish
#> 7     50 MB      CC0 1.0 DEED                     merfish
#> 8     66 MB    CC BY 4.0 DEED                 mouse_liver
#> 9     25 MB    CC BY 4.0 DEED                     mibitof
#> 10    25 MB    CC BY 4.0 DEED                     mibitof
#> 11   820 MB    CC BY 4.0 DEED                steinbock_io
#> 12   1.5 GB               CCA visium_associated_xenium_io
#> 13   1.5 GB               CCA visium_associated_xenium_io
#> 14   2.8 GB               CCA              xenium_rep1_io
#> 15   2.8 GB               CCA              xenium_rep1_io
#> 16   3.7 GB               CCA              xenium_rep2_io
#> 17   5.4 GB    CC BY 4.0 DEED              HuLungXenmulti
#> 18   5.4 GB    CC BY 4.0 DEED                xenium_2.0.0
#> 19   380 MB               CCA Xenium_V1_human_Breast_2fov
#> 20   380 MB               CCA Xenium_V1_human_Breast_2fov
#> 21   280 MB               CCA   Xenium_V1_human_Lung_2fov
#> 22   280 MB               CCA   Xenium_V1_human_Lung_2fov
#> 23    49 MB    CC BY 4.0 DEED           spacem_helanih3t3
```
