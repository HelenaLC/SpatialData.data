# \`SpatialData.data\`

*[SpatialData.data](https://bioconductor.org/packages/3.23/SpatialData.data)*
package provides utilities for accessing, reading and generating
SpatialData datasets. Data from a variety of spatial omics technologies
has been made available as `SpatialData` (zipped) .zarr stores.

These *scverse* SpatialData examples are available through sources

1.  **biocOSN:** Bioc’s NSF OSN bucket,
2.  **sandbox:** scverse’s spatialdata-sandbox
    (<https://spatialdata.scverse.org/en/latest/tutorials/notebooks/datasets/README.html>)

### Installation

You can install
*[SpatialData.data](https://bioconductor.org/packages/3.23/SpatialData.data)*
using:

``` r

if(!requireNamespace("spatialdataR"))
    BiocManager::install("spatialdataR")
if(!requireNamespace("SpatialData.data"))
    BiocManager::install("SpatialData.data")
```

You can also install the development version like so:

``` r

if(!requireNamespace("pak"))
    install.packages("pak")
pak::pak("HelenaLC/SpatialData.data")
```

To *interrogate* our S3 bucket you will need
[paws.storage](https://cran.r-project.org/web/packages/paws.storage/index.html)
installed.

``` r

library(spatialdataR)
library(SpatialData.data)
library(paws.storage)
Sys.setenv(AWS_REGION = "us-east-1") 
```

### Load SpatialData (.zarr) from Archives

Any SpatialData dataset can be retrieved (once) into some location, and
read into R.

``` r

(x <- SD.data_load("ColorectalCarcinomaMIBITOF"))
```

    ## class: SpatialData
    ## - images(3):
    ##   - point16_image (3,1024,1024)
    ##   - point23_image (3,1024,1024)
    ##   - point8_image (3,1024,1024)
    ## - labels(3):
    ##   - point16_labels (1024,1024)
    ##   - point23_labels (1024,1024)
    ##   - point8_labels (1024,1024)
    ## - points(0):
    ## - shapes(0):
    ## - tables(1):
    ##   - table (36,3309) [point8_labels,point16_labels,point23_labels]
    ## coordinate systems(3):
    ## - point16(2): point16_image point16_labels
    ## - point23(2): point23_image point23_labels
    ## - point8(2): point8_image point8_labels

You can also install the same data from different sources, including the
scverse’s `spatialdata` sandbox where SpatialData stores are saved as
Zarr v3.

``` r

(x <- SD.data_load("ColorectalCarcinomaMIBITOF", src ="sandbox"))
```

    ## class: SpatialData
    ## - images(3):
    ##   - point16_image (3,1024,1024)
    ##   - point23_image (3,1024,1024)
    ##   - point8_image (3,1024,1024)
    ## - labels(3):
    ##   - point16_labels (1024,1024)
    ##   - point23_labels (1024,1024)
    ##   - point8_labels (1024,1024)
    ## - points(0):
    ## - shapes(0):
    ## - tables(1):
    ##   - table (36,3309) [point8_labels,point16_labels,point23_labels]
    ## coordinate systems(3):
    ## - point16(2): point16_image point16_labels
    ## - point23(2): point23_image point23_labels
    ## - point8(2): point8_image point8_labels

We can check all available datasets and their sources with:

``` r

SD.data_list()
```

    ##  [1] "MouseIntestineVisHD"        "MouseBrainVisHD"           
    ##  [3] "MouseBrainVis"              "LungAdenocarcinomaMCMICRO" 
    ##  [5] "MouseBrainMERFISH"          "MouseLiverMERFISH"         
    ##  [7] "ColorectalCarcinomaMIBITOF" "MulticancerSteinbock"      
    ##  [9] "JanesickBreastVisiumEnh"    "JanesickBreastXeniumRep1"  
    ## [11] "JanesickBreastXeniumRep2"   "HumanLungMulti_10x"        
    ## [13] "SpaceMHelaniH3T3"

or as below for a detailed overview and metadata on all datasets:

``` r

View(SD.data_list(metadata = TRUE))
```

You can also interrogate the sources (S3 buckets) for available (zipped)
.zarr archives:

``` r

SD.data_available("biocOSN")
```

    ## [1] "HuLungXenmulti.zip"                     
    ## [2] "mcmicro_io.zip"                         
    ## [3] "merfish.zarr.zip"                       
    ## [4] "mibitof.zip"                            
    ## [5] "steinbock_io.zip"                       
    ## [6] "visium_associated_xenium_io_aligned.zip"
    ## [7] "visium_hd_3.0.0_io.zip"                 
    ## [8] "xenium_rep1_io_aligned.zip"             
    ## [9] "xenium_rep2_io_aligned.zip"

## Session info

    ## R version 4.6.1 (2026-06-24)
    ## Platform: x86_64-pc-linux-gnu
    ## Running under: Ubuntu 24.04.5 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
    ## 
    ## locale:
    ##  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
    ##  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
    ##  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
    ## [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
    ## 
    ## time zone: UTC
    ## tzcode source: system (glibc)
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] paws.storage_0.11.0      SpatialData.data_0.99.10 spatialdataR_0.99.44    
    ## [4] BiocStyle_2.41.0        
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.2.1            blob_1.3.0                 
    ##  [3] dplyr_1.2.1                 filelock_1.0.3             
    ##  [5] R.utils_2.13.0              fastmap_1.2.0              
    ##  [7] SingleCellExperiment_1.35.2 BiocFileCache_3.3.0        
    ##  [9] digest_0.6.39               lifecycle_1.0.5            
    ## [11] sf_1.1-3                    RSQLite_3.53.3             
    ## [13] magrittr_2.0.5              compiler_4.6.1             
    ## [15] rlang_1.3.0                 sass_0.4.10                
    ## [17] tools_4.6.1                 yaml_2.3.12                
    ## [19] knitr_1.52                  S4Arrays_1.13.2            
    ## [21] htmlwidgets_1.6.4           bit_4.6.0                  
    ## [23] classInt_0.4-11             curl_8.0.0                 
    ## [25] reticulate_1.47.0           DelayedArray_0.39.8        
    ## [27] xml2_1.6.0                  abind_1.4-8                
    ## [29] KernSmooth_2.23-26          withr_3.0.3                
    ## [31] purrr_1.2.2                 BiocGenerics_0.59.12       
    ## [33] desc_1.4.3                  R.oo_1.27.1                
    ## [35] grid_4.6.1                  stats4_4.6.1               
    ## [37] e1071_1.7-17                SummarizedExperiment_1.43.0
    ## [39] cli_3.6.6                   rmarkdown_2.32             
    ## [41] crayon_1.5.3                ragg_1.5.2                 
    ## [43] generics_0.1.4              otel_0.2.0                 
    ## [45] DBI_1.3.0                   cachem_1.1.0               
    ## [47] proxy_0.4-29                BiocManager_1.30.27        
    ## [49] XVector_0.53.0              matrixStats_1.5.0          
    ## [51] vctrs_0.7.3                 Matrix_1.7-5               
    ## [53] jsonlite_2.0.0              bookdown_0.48              
    ## [55] IRanges_2.47.5              S4Vectors_0.51.10          
    ## [57] bit64_4.8.6                 RBGL_1.89.0                
    ## [59] systemfonts_1.3.2           jquerylib_0.1.4            
    ## [61] units_1.0-1                 glue_1.8.1                 
    ## [63] pkgdown_2.2.1               ZarrArray_1.0.1            
    ## [65] Rarr_2.0.1                  GenomicRanges_1.65.4       
    ## [67] tibble_3.3.1                pillar_1.11.1              
    ## [69] htmltools_0.5.9             Seqinfo_1.3.2              
    ## [71] graph_1.91.0                dbplyr_2.6.0               
    ## [73] R6_2.6.1                    httr2_1.3.0                
    ## [75] textshaping_1.0.5           evaluate_1.0.5             
    ## [77] lattice_0.22-9              Biobase_2.73.2             
    ## [79] R.methodsS3_1.8.2           png_0.1-9                  
    ## [81] duckspatial_1.2.1           memoise_2.0.1              
    ## [83] paws.common_0.9.0           bslib_0.12.0               
    ## [85] class_7.3-23                Rcpp_1.1.2                 
    ## [87] SparseArray_1.13.4          anndataR_1.2.2             
    ## [89] xfun_0.61                   fs_2.1.0                   
    ## [91] MatrixGenerics_1.25.0       pkgconfig_2.0.3
