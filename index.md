# Introduction

`SpatialData.data` package provides utilities for accessing example
SpatialData datasets. Data from a variety of spatial omics technologies
(Visium, Visium HD, Xenium, MERFISH etc.) has been made available as
`SpatialData` (zipped) .zarr stores.

These *scverse* SpatialData examples are available through the following
S3 buckets:

1.  **sandbox:** (Default) scverse’s spatialdata-sandbox
    (<https://spatialdata.scverse.org/en/latest/tutorials/notebooks/datasets/README.html>)
2.  **biocOSN:** Bioc’s NSF OSN bucket,

# Installation

``` r

if(!requireNamespace("BiocManager"))
  install.packages("BiocManager")
BiocManager::install("spatialdataR")
BiocManager::install("SpatialData.data")
```

``` r

library(spatialdataR)
#> Warning: package 'spatialdataR' was built under R version 4.6.1
#> 
#> Attaching package: 'spatialdataR'
#> The following object is masked from 'package:stats':
#> 
#>     filter
library(SpatialData.data)
```

To *interrogate* either of two S3 buckets you will need
[paws.storage](https://cran.r-project.org/web/packages/paws.storage/index.html)
installed.

``` r

if(!requireNamespace("paws.storage"))
  install.packages("paws.storage")
library(paws.storage)
Sys.setenv(AWS_REGION = "us-east-1") 
```

## Load SpatialData (.zarr) from Archives

Any spatialdata dataset can be retrieved (once) into some location, and
read into R.

``` r

(x <- SD.data_load("ColorectalCarcinomaMIBITOF"))
#> checking Bioconductor OSN bucket...
#> class: SpatialData
#> - images(3):
#>   - point16_image (3,1024,1024)
#>   - point23_image (3,1024,1024)
#>   - point8_image (3,1024,1024)
#> - labels(3):
#>   - point16_labels (1024,1024)
#>   - point23_labels (1024,1024)
#>   - point8_labels (1024,1024)
#> - points(0):
#> - shapes(0):
#> - tables(1):
#>   - table (36,3309) [point8_labels,point16_labels,point23_labels]
#> coordinate systems(3):
#> - point16(2): point16_image point16_labels
#> - point23(2): point23_image point23_labels
#> - point8(2): point8_image point8_labels
```

You can view a list of available datasets using:

``` r

SD.data_list()
#>  [1] "MouseIntestineVisHD"        "MouseBrainVisHD"           
#>  [3] "MouseBrainVis"              "LungAdenocarcinomaMCMICRO" 
#>  [5] "MouseBrainMERFISH"          "MouseLiverMERFISH"         
#>  [7] "ColorectalCarcinomaMIBITOF" "MulticancerSteinbock"      
#>  [9] "JanesickBreastVisiumEnh"    "JanesickBreastXeniumRep1"  
#> [11] "JanesickBreastXeniumRep2"   "HumanLungMulti_10x"        
#> [13] "SpaceMHelaniH3T3"
```
