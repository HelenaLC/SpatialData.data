# generate_dataset

Generate spatialdata datasets using dummy-spatialdata

## Usage

``` r
generate_dataset(
  file = tempfile(fileext = ".zarr"),
  sd_version = getOption("sd_version"),
  images = NULL,
  labels = NULL,
  shapes = NULL,
  points = NULL,
  tables = NULL,
  coordinate_systems = NULL,
  seed = 42L
)
```

## Arguments

- file:

  location that zarr file will be written

- sd_version:

  spatialdata version, see
  [SD.io_readers](https://helenalc.github.io/SpatialData.data/reference/SD.io_readers.md)

- images:

  image element

- labels:

  labels element

- shapes:

  shapes element

- points:

  points element

- tables:

  tables element (anndata)

- coordinate_systems:

  list of coordinate systems

- seed:

  seed

## Examples

``` r
options(sd_version = "0.5.0")
generate_dataset()
#> Using spatialdata version 0.5.0
#> SpatialData object written to '/tmp/RtmpZKIm20/file1e3b197a2171.zarr'
#> [1] "/tmp/RtmpZKIm20/file1e3b197a2171.zarr"

# write spatialdata in 0.5.0 version
zarrfile <- tempfile(fileext = ".zarr")
generate_dataset(
  file = zarrfile, 
  sd_version = "0.5.0",
  points = list(
    list(n=12L)
  )
)
#> Using spatialdata version 0.5.0
#> SpatialData object written to '/tmp/RtmpZKIm20/file1e3b4c79de5b.zarr'
#> [1] "/tmp/RtmpZKIm20/file1e3b4c79de5b.zarr"

# write spatialdata in 0.8.0 version
generate_dataset(
  sd_version = "0.8.0",
  images = list(
    list(type = "rgb", scale_factors = c(2L,2L,2L), coordinate_system="global"),
    list(type = "grayscale", coordinate_system="global")
  ),
  shapes = list(
    list(n=12L, type ="polygon", coordinate_system="global")
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
#> Using spatialdata version 0.8.0
#> Using Python: /home/runner/.pyenv/versions/3.12.0/bin/python3.12
#> Creating virtual environment '/home/runner/.cache/R/basilisk/1.25.0/SpatialData.data/0.99.9/sd_env' ... 
#> + /home/runner/.pyenv/versions/3.12.0/bin/python3.12 -m venv /home/runner/.cache/R/basilisk/1.25.0/SpatialData.data/0.99.9/sd_env
#> Done!
#> Installing packages: pip, wheel, setuptools
#> + /home/runner/.cache/R/basilisk/1.25.0/SpatialData.data/0.99.9/sd_env/bin/python -m pip install --upgrade pip wheel setuptools
#> Installing packages: 'zarr==3.1.5', 'spatialdata==0.8.0', 'spatialdata_io==0.7.1', 'dummy-spatialdata==0.1.10', 'setuptools==75.8.0'
#> + /home/runner/.cache/R/basilisk/1.25.0/SpatialData.data/0.99.9/sd_env/bin/python -m pip install --upgrade --no-user 'zarr==3.1.5' 'spatialdata==0.8.0' 'spatialdata_io==0.7.1' 'dummy-spatialdata==0.1.10' 'setuptools==75.8.0'
#> Virtual environment '/home/runner/.cache/R/basilisk/1.25.0/SpatialData.data/0.99.9/sd_env' successfully created.
#> [1] "/tmp/RtmpZKIm20/file1e3bb11c4d4.zarr"
```
