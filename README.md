

<!-- README.md is generated from README.qmd. Please edit that file -->

# Introduction

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

## Using spatialdata-io

`SpatialData.data` also provides access to some raw spatial omic
readouts. These data bundle can then be converted into SpatialData
objects using `spatialdata-io` python package.

``` r
SD.data_available("biocOSN_Xenium")
#> checking Bioconductor OSN bucket (Xenium readouts) ...
#> [1] "Xenium_Prime_MultiCellSeg_Mouse_Ileum_tiny_outs.zip"
#> [2] "Xenium_V1_human_Breast_2fov_outs.zip"               
#> [3] "Xenium_V1_human_Lung_2fov_outs.zip"
```

We use `options(sd_version)` to set the SpatialData version.

``` r
options(sd_version = "0.3.0")
(x <- SD.data_load("Breast2fov_10x", source = "biocOSN_Xenium"))
#> checking Bioconductor OSN bucket (Xenium readouts) ...
#> Using spatialdata version 0.3.0
#> Warning: Error updating pyenv [exit code 1]
#> Using Python: /Users/amanuky/.pyenv/versions/3.12.0/bin/python3.12
#> Creating virtual environment '/Users/amanuky/Library/Caches/org.R-project.R/R/basilisk/1.25.0/SpatialData.data/0.99.8/sd_env_03' ...
#> + /Users/amanuky/.pyenv/versions/3.12.0/bin/python3.12 -m venv /Users/amanuky/Library/Caches/org.R-project.R/R/basilisk/1.25.0/SpatialData.data/0.99.8/sd_env_03
#> Done!
#> Installing packages: pip, wheel, setuptools
#> + /Users/amanuky/Library/Caches/org.R-project.R/R/basilisk/1.25.0/SpatialData.data/0.99.8/sd_env_03/bin/python -m pip install --upgrade pip wheel setuptools
#> Installing packages: 'spatialdata==0.3.0', 'datashader==0.19.0', 'spatialdata_io==0.1.7', 'setuptools==75.8.0'
#> + /Users/amanuky/Library/Caches/org.R-project.R/R/basilisk/1.25.0/SpatialData.data/0.99.8/sd_env_03/bin/python -m pip install --upgrade --no-user 'spatialdata==0.3.0' 'datashader==0.19.0' 'spatialdata_io==0.1.7' 'setuptools==75.8.0'
#> Virtual environment '/Users/amanuky/Library/Caches/org.R-project.R/R/basilisk/1.25.0/SpatialData.data/0.99.8/sd_env_03' successfully created.
#> [34mINFO    [0m reading                                                                
#>          [35m/var/folders/vf/d8kg507x41xfh6z9vgv9skksdsn29w/T/RtmpmDUbtF/file67c23bf[0m
#>          [35mbfb3c/[0m[95mcell_feature_matrix.h5[0m                                           
#> [34mINFO    [0m The SpatialData object is not self-contained [1m([0mi.e. it contains some    
#>          elements that are Dask-backed from locations outside                   
#>          [35m/var/folders/vf/d8kg507x41xfh6z9vgv9skksdsn29w/T/RtmpmDUbtF/[0m[95mfile67c21c2[0m
#>          [95mb3ee8[0m[1m)[0m. Please see the documentation of `[1;35mis_self_contained[0m[1m([0m[1m)[0m` to       
#>          understand the implications of working with SpatialData objects that   
#>          are not self-contained.                                                
#> [34mINFO    [0m The Zarr backing store has been changed from [3;35mNone[0m the new file path:   
#>          [35m/var/folders/vf/d8kg507x41xfh6z9vgv9skksdsn29w/T/RtmpmDUbtF/[0m[95mfile67c21c2[0m
#>          [95mb3ee8[0m
#> duckdb is storing downloaded extensions and secrets under ~/.duckdb:
#> ℹ /Users/amanuky/.duckdb
#> This persists across sessions and is shared with the DuckDB CLI and other clients.
#> ℹ Run duckdb(shared_home = FALSE) to use a temporary directory instead.
#> ℹ See ?duckdb_storage for details and alternatives.
#> class: SpatialData
#> - images(1):
#>   - morphology_focus (5,3529,5792)
#> - labels(2):
#>   - cell_labels (3529,5792)
#>   - nucleus_labels (3529,5792)
#> - points(1):
#>   - transcripts (1113950)
#> - shapes(3):
#>   - cell_boundaries (7275,circle)
#>   - cell_circles (0,circle)
#>   - nucleus_boundaries (7020,circle)
#> - tables(1):
#>   - table (280,7275) [cell_circles]
#> coordinate systems(1):
#> - global(7): morphology_focus cell_labels ... nucleus_boundaries
#>   transcripts
```

## Generating dummy SpatialData objects

`SpatialData.data` package incorporates the `dummy-spatialdata` python
package (<https://pypi.org/project/dummy-spatialdata/>) via `basilisk`
to generate toy spatialdata objects in multiple spatialdata versions.

``` r
zarrfile <- tempfile(fileext = ".zarr")
generate_dataset(
  file = zarrfile, 
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
#> Using spatialdata version 0.5.0
#> Warning: Error updating pyenv [exit code 1]
#> Using Python: /Users/amanuky/.pyenv/versions/3.12.0/bin/python3.12
#> Creating virtual environment '/Users/amanuky/Library/Caches/org.R-project.R/R/basilisk/1.25.0/SpatialData.data/0.99.8/sd_env_05' ...
#> + /Users/amanuky/.pyenv/versions/3.12.0/bin/python3.12 -m venv /Users/amanuky/Library/Caches/org.R-project.R/R/basilisk/1.25.0/SpatialData.data/0.99.8/sd_env_05
#> Done!
#> Installing packages: pip, wheel, setuptools
#> + /Users/amanuky/Library/Caches/org.R-project.R/R/basilisk/1.25.0/SpatialData.data/0.99.8/sd_env_05/bin/python -m pip install --upgrade pip wheel setuptools
#> Installing packages: 'spatialdata==0.5.0', 'spatialdata_io==0.6.0', 'dummy-spatialdata==0.1.7', 'setuptools==75.8.0'
#> + /Users/amanuky/Library/Caches/org.R-project.R/R/basilisk/1.25.0/SpatialData.data/0.99.8/sd_env_05/bin/python -m pip install --upgrade --no-user 'spatialdata==0.5.0' 'spatialdata_io==0.6.0' 'dummy-spatialdata==0.1.7' 'setuptools==75.8.0'
#> Virtual environment '/Users/amanuky/Library/Caches/org.R-project.R/R/basilisk/1.25.0/SpatialData.data/0.99.8/sd_env_05' successfully created.
#> [1] "/var/folders/vf/d8kg507x41xfh6z9vgv9skksdsn29w/T//RtmpmDUbtF/file67c23cfea265.zarr"
sd <- spatialdataR::readSpatialData(zarrfile)
```
