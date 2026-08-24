# Introduction

`SpatialData.data` package provides utilities for accessing, reading and
generating SpatialData datasets. Data from a variety of spatial omics
technologies has been made available as `SpatialData` (zipped) .zarr
stores.

These *scverse* SpatialData examples are available through sources

1.  **biocOSN:** Bioc’s NSF OSN bucket,
2.  **biocOSN_Xenium:** Bioc’s NSF OSN bucket for raw data outputs from
    some Xenium datasets and
3.  **sandbox:** scverse’s spatialdata-sandbox
    (<https://spatialdata.scverse.org/en/latest/tutorials/notebooks/datasets/README.html>)

`SpatialData.data` uses `basilisk` to interface and maintain multiple
versions of scverse’s `spatialdata` module (0.5 and 0.8) for reading and
writing to .zarr stores.

The package also incorporates `dummy-spatialdata` python module that
generates toy SpatialData examples whose elements are customized by the
user. These examples can be generated again using `spatialdata` module
versions 0.5 and 0.8.

Please visit the **vignette** for more information.

# Installation

``` r

if(!requireNamespace("BiocManager"))
  install.packages("BiocManager")
BiocManager::install("spatialdataR")
BiocManager::install("SpatialData.data")
```

``` r

library(spatialdataR)
#> 
#> Attaching package: 'spatialdataR'
#> The following object is masked from 'package:stats':
#> 
#>     filter
library(SpatialData.data)
```

To *interrogate* our S3 bucket you will need
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
#> [13] "Breast2fov_10x"             "Lung2fov_10x"              
#> [15] "SpaceMHelaniH3T3"
```
