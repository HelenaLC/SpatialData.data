# \`SpatialData.data\`

`Spatialdata.data` package provides utilities for accessing, reading and
generating SpatialData datasets. Data from a variety of spatial omics
technologies has been made available as `SpatialData` .zarr stores

These *scverse* SpatialData examples are available through

1.  Bioc’s NSF OSN bucket and
2.  scverse’s spatialdata-sandbox
    (<https://spatialdata.scverse.org/en/latest/tutorials/notebooks/datasets/README.html>)

`SpatialData.data` uses `basilisk` to interface and maintain multiple
versions of python’s spatialdata package (0.3.0, 0.5.0 and 0.7.2) for
reading and writing to .zarr stores.

`basilisk` environments (only 0.5.0 and 0.7.2) are also accompanied by
the `dummy-spatialdata` package that generates toy spatialdata examples
whose elements are customized by the user.

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

``` r

library(spatialdataR)
library(SpatialData.data)
library(paws)
Sys.setenv(AWS_REGION = "us-east-1") 
```

### Load SpatialData (.zarr) from Archives

Any spatialdata dataset can be retrieved (once) into some location, and
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

``` r

# TODO: zarr v3 is not complete yet
# from sandbox (Zarr v3)
# (x <- SD.data_load("ColorectalCarcinomaMIBITOF", source = "sandbox"))
```

We can check all available datasets below:

``` r

SD.data_list()
```

    ##                      Function             Technology       S3_buckets
    ## 1         MouseIntestineVisHD              Visium HD biocOSN, sandbox
    ## 2             MouseBrainVisHD              Visium HD          sandbox
    ## 3               MouseBrainVis                 Visium          sandbox
    ## 4   LungAdenocarcinomaMCMICRO CyCIF (MCMICRO output)          biocOSN
    ## 5           MouseBrainMERFISH                MERFISH biocOSN, sandbox
    ## 6           MouseLiverMERFISH                MERFISH          sandbox
    ## 7  ColorectalCarcinomaMIBITOF               MIBI-TOF biocOSN, sandbox
    ## 8        MulticancerSteinbock IMC (Steinbock output)          biocOSN
    ## 9     JanesickBreastVisiumEnh                 Visium biocOSN, sandbox
    ## 10   JanesickBreastXeniumRep1                 Xenium biocOSN, sandbox
    ## 11   JanesickBreastXeniumRep2                 Xenium          biocOSN
    ## 12         HumanLungMulti_10x                 Xenium biocOSN, sandbox
    ## 13             Breast2fov_10x       Xenium (trimmed)   biocOSN_Xenium
    ## 14               Lung2fov_10x       Xenium (trimmed)   biocOSN_Xenium
    ## 15           SpaceMHelaniH3T3                 SpaceM          sandbox
    ##                              Format
    ## 1  0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
    ## 2                   0.3.0 (Zarr v2)
    ## 3                   0.7.2 (Zarr v3)
    ## 4                   0.3.0 (Zarr v2)
    ## 5  0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
    ## 6                   0.7.2 (Zarr v3)
    ## 7  0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
    ## 8                   0.3.0 (Zarr v2)
    ## 9  0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
    ## 10 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
    ## 11                  0.3.0 (Zarr v2)
    ## 12 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
    ## 13 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
    ## 14 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
    ## 15                  0.7.2 (Zarr v3)

To interrogate the bucket for available (zipped) .zarr archives:

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
readouts. These data bundle can then be converted into SpatialData
objects using `spatialdata-io` python package.

``` r

SD.data_available("biocOSN_Xenium")
```

    ## [1] "README.html"                                        
    ## [2] "Xenium_Prime_MultiCellSeg_Mouse_Ileum_tiny_outs.zip"
    ## [3] "Xenium_V1_human_Breast_2fov_outs.zip"               
    ## [4] "Xenium_V1_human_Lung_2fov_outs.zip"

You can use `basilisk` to convert these readouts into various
SpatialData formats:

- **0.3.0** (Zarr v2),
- **0.5.0** (Zarr v2) and
- **0.7.2** (Zarr v3)

We use `options(sd_version)` to set the SpatialData version.

``` r

options(sd_version = "0.3.0")
(x <- SD.data_load("Breast2fov_10x", source = "biocOSN_Xenium"))
```

    ## INFO     reading /tmp/RtmpBTvSFn/file9c7a75c51c15/cell_feature_matrix.h5        
    ## INFO     The SpatialData object is not self-contained (i.e. it contains some    
    ##          elements that are Dask-backed from locations outside                   
    ##          /tmp/RtmpBTvSFn/file9c7a2d1ac24). Please see the documentation of      
    ##          `is_self_contained()` to understand the implications of working with   
    ##          SpatialData objects that are not self-contained.                       
    ## INFO     The Zarr backing store has been changed from None the new file path:   
    ##          /tmp/RtmpBTvSFn/file9c7a2d1ac24

    ## class: SpatialData
    ## - images(1):
    ##   - morphology_focus (5,3529,5792)
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
sd_zarr
```

    ## [1] "/tmp/RtmpBTvSFn/file9c7a7bda4d82.zarr"

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
    ## [1] paws_0.10.0             SpatialData.data_0.99.7 spatialdataR_0.99.44   
    ## [4] BiocStyle_2.41.0       
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.2.1            blob_1.3.0                 
    ##  [3] dplyr_1.2.1                 filelock_1.0.3             
    ##  [5] R.utils_2.13.0              fastmap_1.2.0              
    ##  [7] SingleCellExperiment_1.35.2 BiocFileCache_3.3.0        
    ##  [9] duckdb_1.5.5                digest_0.6.39              
    ## [11] lifecycle_1.0.5             sf_1.1-2                   
    ## [13] RSQLite_3.53.3              paws.storage_0.10.0        
    ## [15] magrittr_2.0.5              compiler_4.6.1             
    ## [17] rlang_1.3.0                 sass_0.4.10                
    ## [19] tools_4.6.1                 yaml_2.3.12                
    ## [21] knitr_1.51                  S4Arrays_1.13.0            
    ## [23] htmlwidgets_1.6.4           bit_4.6.0                  
    ## [25] classInt_0.4-11             curl_7.1.0                 
    ## [27] reticulate_1.46.0           DelayedArray_0.39.6        
    ## [29] xml2_1.6.0                  abind_1.4-8                
    ## [31] KernSmooth_2.23-26          withr_3.0.3                
    ## [33] purrr_1.2.2                 BiocGenerics_0.59.12       
    ## [35] desc_1.4.3                  R.oo_1.27.1                
    ## [37] grid_4.6.1                  stats4_4.6.1               
    ## [39] e1071_1.7-17                SummarizedExperiment_1.43.0
    ## [41] cli_3.6.6                   rmarkdown_2.31             
    ## [43] crayon_1.5.3                ragg_1.5.2                 
    ## [45] generics_0.1.4              otel_0.2.0                 
    ## [47] DBI_1.3.0                   cachem_1.1.0               
    ## [49] proxy_0.4-29                parallel_4.6.1             
    ## [51] BiocManager_1.30.27         XVector_0.53.0             
    ## [53] matrixStats_1.5.0           basilisk_1.25.0            
    ## [55] vctrs_0.7.3                 Matrix_1.7-5               
    ## [57] jsonlite_2.0.0              dir.expiry_1.21.0          
    ## [59] bookdown_0.47               IRanges_2.47.2             
    ## [61] S4Vectors_0.51.7            bit64_4.8.4                
    ## [63] RBGL_1.89.0                 systemfonts_1.3.2          
    ## [65] jquerylib_0.1.4             units_1.0-1                
    ## [67] glue_1.8.1                  pkgdown_2.2.1              
    ## [69] ZarrArray_1.0.1             Rarr_2.0.1                 
    ## [71] GenomicRanges_1.64.0        tibble_3.3.1               
    ## [73] pillar_1.11.1               htmltools_0.5.9            
    ## [75] Seqinfo_1.3.0               graph_1.91.0               
    ## [77] dbplyr_2.6.0                R6_2.6.1                   
    ## [79] httr2_1.3.0                 wk_0.9.5                   
    ## [81] textshaping_1.0.5           evaluate_1.0.5             
    ## [83] lattice_0.22-9              Biobase_2.73.2             
    ## [85] R.methodsS3_1.8.2           png_0.1-9                  
    ## [87] duckspatial_1.2.1           memoise_2.0.1              
    ## [89] paws.common_0.8.10          bslib_0.12.0               
    ## [91] class_7.3-23                uuid_1.2-2                 
    ## [93] Rcpp_1.1.2                  SparseArray_1.13.2         
    ## [95] anndataR_1.3.1              xfun_0.60                  
    ## [97] fs_2.1.0                    MatrixGenerics_1.25.0      
    ## [99] pkgconfig_2.0.3
