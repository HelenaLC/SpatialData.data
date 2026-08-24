# SD.io_readers

Method to call technology-specific readers by spatialdata-io.

## Usage

``` r
SD.io_readers(sd_version = getOption("sd_version"), verbose = TRUE)
```

## Arguments

- sd_version:

  spatialdata version, should be set to 0.5.0 or 0.8.0. Default: 0.8.0.

- verbose:

  verbose

## Examples

``` r
SD.io_readers()
#> Using spatialdata version 0.5.0
#> Installing pyenv ...
#> Done! pyenv has been installed to '/home/runner/.local/share/r-reticulate/pyenv/bin/pyenv'.
#> Using Python: /home/runner/.pyenv/versions/3.12.0/bin/python3.12
#> Creating virtual environment '/home/runner/.cache/R/basilisk/1.25.0/SpatialData.data/0.99.9/sd_env_05' ... 
#> + /home/runner/.pyenv/versions/3.12.0/bin/python3.12 -m venv /home/runner/.cache/R/basilisk/1.25.0/SpatialData.data/0.99.9/sd_env_05
#> Done!
#> Installing packages: pip, wheel, setuptools
#> + /home/runner/.cache/R/basilisk/1.25.0/SpatialData.data/0.99.9/sd_env_05/bin/python -m pip install --upgrade pip wheel setuptools
#> Installing packages: 'spatialdata==0.5.0', 'spatialdata_io==0.3.0', 'dummy-spatialdata==0.1.7', 'setuptools==75.8.0'
#> + /home/runner/.cache/R/basilisk/1.25.0/SpatialData.data/0.99.9/sd_env_05/bin/python -m pip install --upgrade --no-user 'spatialdata==0.5.0' 'spatialdata_io==0.3.0' 'dummy-spatialdata==0.1.7' 'setuptools==75.8.0'
#> Virtual environment '/home/runner/.cache/R/basilisk/1.25.0/SpatialData.data/0.99.9/sd_env_05' successfully created.
#>  [1] "codex"                     "converters"               
#>  [3] "cosmx"                     "curio"                    
#>  [5] "dbit"                      "generic"                  
#>  [7] "generic_to_zarr"           "geojson"                  
#>  [9] "image"                     "macsima"                  
#> [11] "mcmicro"                   "merscope"                 
#> [13] "seqfish"                   "steinbock"                
#> [15] "stereoseq"                 "visium"                   
#> [17] "visium_hd"                 "xenium"                   
#> [19] "xenium_aligned_image"      "xenium_explorer_selection"
```
