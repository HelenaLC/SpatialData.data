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

data.frame

## Examples

``` r
SD.data_list()
#>                      Function             Technology       S3_buckets
#> 1         MouseIntestineVisHD              Visium HD biocOSN, sandbox
#> 2             MouseBrainVisHD              Visium HD          sandbox
#> 3               MouseBrainVis                 Visium          sandbox
#> 4   LungAdenocarcinomaMCMICRO CyCIF (MCMICRO output)          biocOSN
#> 5           MouseBrainMERFISH                MERFISH biocOSN, sandbox
#> 6           MouseLiverMERFISH                MERFISH          sandbox
#> 7  ColorectalCarcinomaMIBITOF               MIBI-TOF biocOSN, sandbox
#> 8        MulticancerSteinbock IMC (Steinbock output)          biocOSN
#> 9     JanesickBreastVisiumEnh                 Visium biocOSN, sandbox
#> 10   JanesickBreastXeniumRep1                 Xenium biocOSN, sandbox
#> 11   JanesickBreastXeniumRep2                 Xenium          biocOSN
#> 12         HumanLungMulti_10x                 Xenium biocOSN, sandbox
#> 13             Breast2fov_10x       Xenium (trimmed)   biocOSN_Xenium
#> 14               Lung2fov_10x       Xenium (trimmed)   biocOSN_Xenium
#> 15           SpaceMHelaniH3T3                 SpaceM          sandbox
#>                              Format
#> 1  0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
#> 2                   0.3.0 (Zarr v2)
#> 3                   0.7.2 (Zarr v3)
#> 4                   0.3.0 (Zarr v2)
#> 5  0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
#> 6                   0.7.2 (Zarr v3)
#> 7  0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
#> 8                   0.3.0 (Zarr v2)
#> 9  0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
#> 10 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
#> 11                  0.3.0 (Zarr v2)
#> 12 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
#> 13 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
#> 14 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
#> 15                  0.7.2 (Zarr v3)
SD.data_list(extended = TRUE)
#>                      Function             Technology
#> 1         MouseIntestineVisHD              Visium HD
#> 2             MouseBrainVisHD              Visium HD
#> 3               MouseBrainVis                 Visium
#> 4   LungAdenocarcinomaMCMICRO CyCIF (MCMICRO output)
#> 5           MouseBrainMERFISH                MERFISH
#> 6           MouseLiverMERFISH                MERFISH
#> 7  ColorectalCarcinomaMIBITOF               MIBI-TOF
#> 8        MulticancerSteinbock IMC (Steinbock output)
#> 9     JanesickBreastVisiumEnh                 Visium
#> 10   JanesickBreastXeniumRep1                 Xenium
#> 11   JanesickBreastXeniumRep2                 Xenium
#> 12         HumanLungMulti_10x                 Xenium
#> 13             Breast2fov_10x       Xenium (trimmed)
#> 14               Lung2fov_10x       Xenium (trimmed)
#> 15           SpaceMHelaniH3T3                 SpaceM
#>                                          Sample       S3_buckets
#> 1                                Mouse intestin biocOSN, sandbox
#> 2                                   Mouse brain          sandbox
#> 3                                   Mouse brain          sandbox
#> 4                     Small lung adenocarcinoma          biocOSN
#> 5                                   Mouse brain biocOSN, sandbox
#> 6                                  Mouse liver           sandbox
#> 7                          Colorectal carcinoma biocOSN, sandbox
#> 8  4 different cancers (SCCHN, BCC, NSCLC, CRC)          biocOSN
#> 9                                 Breast Cancer biocOSN, sandbox
#> 10                                Breast Cancer biocOSN, sandbox
#> 11                                Breast Cancer          biocOSN
#> 12                                  Lung Cancer biocOSN, sandbox
#> 13                               Breast (2 FOV)   biocOSN_Xenium
#> 14                                 Lung (2 FOV)   biocOSN_Xenium
#> 15                       Hepa and NIH3T3 cells?          sandbox
#>                              Format FileSize                      Pattern
#> 1  0.3.0 (Zarr v2), 0.7.2 (Zarr v3)     1 GB              visium_hd_3.0.0
#> 2                   0.3.0 (Zarr v2)   174 MB              visium_hd_4.0.1
#> 3                   0.7.2 (Zarr v3)    65 MB           visium_spatialdata
#> 4                   0.3.0 (Zarr v2)   250 MB                   mcmicro_io
#> 5  0.3.0 (Zarr v2), 0.7.2 (Zarr v3)    50 MB                      merfish
#> 6                   0.7.2 (Zarr v3)    66 MB                 mouse_liver 
#> 7  0.3.0 (Zarr v2), 0.7.2 (Zarr v3)    25 MB                      mibitof
#> 8                   0.3.0 (Zarr v2)   820 MB                 steinbock_io
#> 9  0.3.0 (Zarr v2), 0.7.2 (Zarr v3)   1.5 GB  visium_associated_xenium_io
#> 10 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)   2.8 GB               xenium_rep1_io
#> 11                  0.3.0 (Zarr v2)   3.7 GB               xenium_rep2_io
#> 12 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)   5.4 GB HuLungXenmulti, xenium_2.0.0
#> 13 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)   380 MB  Xenium_V1_human_Breast_2fov
#> 14 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)   280 MB    Xenium_V1_human_Lung_2fov
#> 15                  0.7.2 (Zarr v3)    49 MB            spacem_helanih3t3
#>              License
#> 1                CCA
#> 2     CC BY 4.0 DEED
#> 3     CC BY 4.0 DEED
#> 4  CC BY-NC 4.0 DEED
#> 5       CC0 1.0 DEED
#> 6     CC BY 4.0 DEED
#> 7     CC BY 4.0 DEED
#> 8     CC BY 4.0 DEED
#> 9                CCA
#> 10               CCA
#> 11               CCA
#> 12    CC BY 4.0 DEED
#> 13               CCA
#> 14               CCA
#> 15    CC BY 4.0 DEED
```
