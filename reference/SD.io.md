# Use Python's 'spatialdata-io' to transform manufacturer output to .zarr with specific folder structure.

Use Python's 'spatialdata-io' to transform manufacturer output to .zarr
with specific folder structure.

## Usage

``` r
SD.io(platform = "xenium", srcdir, dest)
```

## Arguments

- platform:

  character(1) must be an element of \`SD.io_readers()\` output

- srcdir:

  character(1) path to folder holding manufacturer output files

- dest:

  character(1) a path to a desired destination for zarr representation

## Examples

``` r
Sys.setenv(AWS_REGION = "us-east-1")

# read & write to .zarr w/ 'spatialdata-io'
target <- tempfile()
options(sd_version = "0.5.0")
# turn of basilisk on GHA
# SD.io("xenium", srcdir=td, dest=target)

# read with spatialdataR
# br2fov <- spatialdataR::readSpatialData(target)
# br2fov
```
