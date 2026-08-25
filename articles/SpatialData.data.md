# \`SpatialData.data\`

*[SpatialData.data](https://bioconductor.org/packages/3.23/SpatialData.data)*
package provides utilities for accessing, reading and generating
SpatialData datasets. Data from a variety of spatial omics technologies
has been made available as `SpatialData` (zipped) .zarr stores.

These *scverse* SpatialData examples are available through sources

1.  **biocOSN:** Bioc’s NSF OSN bucket,
2.  **biocOSN_Xenium:** Bioc’s NSF OSN bucket for raw data outputs from
    some Xenium datasets and
3.  **sandbox:** scverse’s spatialdata-sandbox
    (<https://spatialdata.scverse.org/en/latest/tutorials/notebooks/datasets/README.html>)

*[SpatialData.data](https://bioconductor.org/packages/3.23/SpatialData.data)*
uses `basilisk` to interface and maintain multiple versions of scverse’s
`spatialdata` module (0.5 and 0.8) for reading and writing to .zarr
stores.

The package also incorporates `dummy-spatialdata` python module that
generates toy SpatialData examples whose elements are customized by the
user. These examples can be generated again using `spatialdata` module
versions 0.5 and 0.8

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

(x <- SD.data_load("ColorectalCarcinomaMIBITOF", source = "sandbox"))
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
    ## [13] "Breast2fov_10x"             "Lung2fov_10x"              
    ## [15] "SpaceMHelaniH3T3"

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

### Using spatialdata-io

`SpatialData.data` also provides access to some raw spatial omic
readouts. After installation from the source (i.e. `biocOSN_Xenium`),
these data bundles can then be converted into SpatialData objects using
`spatialdata-io` python package.

You can use `basilisk` to convert these readouts into SpatialData zarr
stores using multiple `spatialdata` module versions, each associated
with a different Zarr format:

- **0.5.0** (Zarr v2) and
- **0.8.0** (Zarr v3)

We use `options(sd_version)` to set the `spatialdata` module version.

``` r

options(sd_version = "0.5.0")
(x <- SD.data_load("Breast2fov_10x", source = "biocOSN_Xenium"))
```

    ## INFO     reading /tmp/RtmpfM65Py/file601d3b2a631a/cell_feature_matrix.h5        
    ## INFO     The SpatialData object is not self-contained (i.e. it contains some    
    ##          elements that are Dask-backed from locations outside                   
    ##          /tmp/RtmpfM65Py/file601d5d7c5aac). Please see the documentation of     
    ##          `is_self_contained()` to understand the implications of working with   
    ##          SpatialData objects that are not self-contained.                       
    ## INFO     The Zarr backing store has been changed from None the new file path:   
    ##          /tmp/RtmpfM65Py/file601d5d7c5aac

    ## class: SpatialData
    ## - images(1):
    ##   - morphology_focus (4,3529,5792)
    ## - labels(2):
    ##   - cell_labels (3529,5792)
    ##   - nucleus_labels (3529,5792)
    ## - points(1):
    ##   - transcripts (1113950)
    ## - shapes(3):
    ##   - cell_boundaries (7275,circle)
    ##   - cell_circles (0,circle)
    ##   - nucleus_boundaries (7020,circle)
    ## - tables(1):
    ##   - table (280,7275) [cell_circles]
    ## coordinate systems(1):
    ## - global(7): morphology_focus cell_labels ... nucleus_boundaries
    ##   transcripts

### Generating dummy SpatialData objects

`SpatialData.data` package incorporates the `dummy-spatialdata` python
package (<https://pypi.org/project/dummy-spatialdata/>) via `basilisk`
to generate toy spatialdata objects in multiple spatialdata versions.

``` r

sd_zarr <- generate_dataset(
  sd_version = "0.5.0",
  images = list(
    list(type = "rgb", scale_factors = c(2L,2L,2L), coordinate_system="global"),
    list(type = "grayscale", n_layers = c(), coordinate_system="global")
  ),
  shapes = list(
    list(n=12L, type="polygon", coordinate_system="global")
  ),
  points = list(
    list(n=12L)
  ),
  coordinate_systems = list(
    global = list(
      transformations = list("affine"), 
      shape = list(x=2000L, y=2000L)
    )
  )
)
```

    ## INFO     no axes information specified in the object, setting `dims` to: ('c',  
    ##          'y', 'x')                                                              
    ## INFO     no axes information specified in the object, setting `dims` to: ('c',  
    ##          'y', 'x')                                                              
    ## INFO     The Zarr backing store has been changed from None the new file path:   
    ##          /tmp/RtmpfM65Py/file601d4b9346c9.zarr

``` r

sd_zarr
```

    ## [1] "/tmp/RtmpfM65Py/file601d4b9346c9.zarr"

Now we can read the SpatialData object with SpatialData.

``` r

sd <- readSpatialData(sd_zarr)
sd
```

    ## class: SpatialData
    ## - images(2):
    ##   - image_0 (3,2000,2000)
    ##   - image_1 (1,2000,2000)
    ## - labels(0):
    ## - points(1):
    ##   - point_0 (12)
    ## - shapes(1):
    ##   - shape_0 (12,polygon)
    ## - tables(0):
    ## coordinate systems(2):
    ## - global(3): image_0 image_1 shape_0
    ## - point_0(1): point_0

We can also get individual elements

``` r

image(sd, 1)
```

    ## class: SpatialDataImage (MultiScale) 
    ## Scales (4): (3,2000,2000 3,1000,1000 3,500,500 3,250,250)

## Session info

    ## R version 4.6.1 (2026-06-24)
    ## Platform: x86_64-pc-linux-gnu
    ## Running under: Ubuntu 24.04.4 LTS
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
    ## [1] paws.storage_0.10.0     SpatialData.data_0.99.9 spatialdataR_0.99.44   
    ## [4] BiocStyle_2.41.0       
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.2.1            blob_1.3.0                 
    ##  [3] dplyr_1.2.1                 filelock_1.0.3             
    ##  [5] R.utils_2.13.0              fastmap_1.2.0              
    ##  [7] SingleCellExperiment_1.35.2 BiocFileCache_3.3.0        
    ##  [9] duckdb_1.5.5                digest_0.6.39              
    ## [11] lifecycle_1.0.5             sf_1.1-2                   
    ## [13] RSQLite_3.53.3              magrittr_2.0.5             
    ## [15] compiler_4.6.1              rlang_1.3.0                
    ## [17] sass_0.4.10                 tools_4.6.1                
    ## [19] yaml_2.3.12                 knitr_1.51                 
    ## [21] S4Arrays_1.13.0             htmlwidgets_1.6.4          
    ## [23] bit_4.6.0                   classInt_0.4-11            
    ## [25] curl_7.1.0                  reticulate_1.46.0          
    ## [27] DelayedArray_0.39.6         xml2_1.6.0                 
    ## [29] abind_1.4-8                 KernSmooth_2.23-26         
    ## [31] withr_3.0.3                 purrr_1.2.2                
    ## [33] BiocGenerics_0.59.12        desc_1.4.3                 
    ## [35] R.oo_1.27.1                 grid_4.6.1                 
    ## [37] stats4_4.6.1                e1071_1.7-17               
    ## [39] SummarizedExperiment_1.43.0 cli_3.6.6                  
    ## [41] rmarkdown_2.31              crayon_1.5.3               
    ## [43] ragg_1.5.2                  generics_0.1.4             
    ## [45] otel_0.2.0                  DBI_1.3.0                  
    ## [47] cachem_1.1.0                proxy_0.4-29               
    ## [49] parallel_4.6.1              BiocManager_1.30.27        
    ## [51] XVector_0.53.0              matrixStats_1.5.0          
    ## [53] basilisk_1.25.0             vctrs_0.7.3                
    ## [55] Matrix_1.7-5                jsonlite_2.0.0             
    ## [57] dir.expiry_1.21.0           bookdown_0.47              
    ## [59] IRanges_2.47.2              S4Vectors_0.51.7           
    ## [61] bit64_4.8.4                 RBGL_1.89.0                
    ## [63] systemfonts_1.3.2           jquerylib_0.1.4            
    ## [65] units_1.0-1                 glue_1.8.1                 
    ## [67] pkgdown_2.2.1               ZarrArray_1.0.1            
    ## [69] Rarr_2.0.1                  GenomicRanges_1.64.0       
    ## [71] tibble_3.3.1                pillar_1.11.1              
    ## [73] htmltools_0.5.9             Seqinfo_1.3.0              
    ## [75] graph_1.91.0                dbplyr_2.6.0               
    ## [77] R6_2.6.1                    httr2_1.3.0                
    ## [79] wk_0.9.5                    textshaping_1.0.5          
    ## [81] evaluate_1.0.5              lattice_0.22-9             
    ## [83] Biobase_2.73.2              R.methodsS3_1.8.2          
    ## [85] png_0.1-9                   duckspatial_1.2.1          
    ## [87] memoise_2.0.1               paws.common_0.8.10         
    ## [89] bslib_0.12.0                class_7.3-23               
    ## [91] uuid_1.2-2                  Rcpp_1.1.2                 
    ## [93] SparseArray_1.13.2          anndataR_1.3.1             
    ## [95] xfun_0.60                   fs_2.1.0                   
    ## [97] MatrixGenerics_1.25.0       pkgconfig_2.0.3
