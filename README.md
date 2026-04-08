# `SpatialData.data`

> for class infrastructure, see [`SpatialData`](https://github.com/HelenaLC/SpatialData)

> for visualization capabilites, see [`SpatialData.plot`](https://github.com/HelenaLC/SpatialData.plot)

# Introduction

`Spatialdata.data` package provides utilities for accessing, reading and 
generating SpatialData datasets. 

*scverse* SpatialData examples are available through

1. Bioc's NSF OSN bucket and 
2. scverse's spatialdata-sandbox ([https://spatialdata.scverse.org/en/latest/tutorials/notebooks/datasets/README.html](https://spatialdata.scverse.org/en/latest/tutorials/notebooks/datasets/README.html))

which are accessible from within R, using `BiocFileCache`.

`SpatialData.data` uses `basilisk` to interface and maintain multiple 
versions of python's spatialdata package (0.3.0, 0.5.0 and 0.7.2) for reading
and writing to .zarr packages. 

`basilisk` environments (only 0.5.0 and 0.7.2) are also accompanied by the
`dummy-spatialdata` package that generates toy spatialdata examples 
whose elements are customized by the user.

# Installation

```
BiocManager::install("HelenaLC/SpatialData")
BiocManager::install("HelenaLC/SpatialData.data")
```

To *interrogate* our S3 bucket you will need [paws](https://cran.r-project.org/web/packages/paws/index.html) 
installed; it is not necessary for retrievals.

# Introduction

## Zipped .zarr archives

Data from a variety of technologies has been made available as `SpatialData` .zarr stores 
[here](https://spatialdata.scverse.org/en/latest/tutorials/notebooks/datasets/README.html).
These, in turn, have been deposited in Bioconductor's NSF Open Storage Network also and 
can be retrieved with caching support using `r BiocStyle::Biocpkg("BiocFileCache")`.

Any spatialdata dataset can be retrieved (once) into some location, and 
read into R.  We use dataset-specific functions, or `load_data`:

``` r
(x <- load_data("ColorectalCarcinomaMIBITOF")) # stub can be used
```

```
class: SpatialData
- images(3):
  - point16_image (3,1024,1024)
  - point23_image (3,1024,1024)
  - point8_image (3,1024,1024)
- labels(3):
  - point16_labels (1024,1024)
  - point23_labels (1024,1024)
  - point8_labels (1024,1024)
- points(0):
- shapes(0):
- tables(1):
  - table (36,3309)
coordinate systems:
- point16(2): point16_image point16_labels
- point23(2): point23_image point23_labels
- point8(2): point8_image point8_labels
```

or 

``` r
# from biocOSN
x <- ColorectalCarcinomaMIBITOF()

# from sandbox (Zarr v3)
x <- ColorectalCarcinomaMIBITOF(source = bucket_path("sandbox"))
```

We can check all available datasets below:

``` r
SpatialData.data_list()
```

<div><pre><code style="font-size: 12px;">                       Function             Technology       S3_buckets                           Format
1         MouseIntestineVisHD()              Visium HD biocOSN, sandbox 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
2             MouseBrainVisHD()              Visium HD          sandbox                  0.3.0 (Zarr v2)
3               MouseBrainVis()                 Visium          sandbox                  0.7.2 (Zarr v3)
4   LungAdenocarcinomaMCMICRO() CyCIF (MCMICRO output)          biocOSN                  0.3.0 (Zarr v2)
5           MouseBrainMERFISH()                MERFISH biocOSN, sandbox 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
6           MouseLiverMERFISH()                MERFISH          sandbox                  0.7.2 (Zarr v3)
7  ColorectalCarcinomaMIBITOF()               MIBI-TOF biocOSN, sandbox 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
8        MulticancerSteinbock() IMC (Steinbock output)          biocOSN                  0.3.0 (Zarr v2)
9     JanesickBreastVisiumEnh()                 Visium biocOSN, sandbox 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
10   JanesickBreastXeniumRep1()                 Xenium biocOSN, sandbox 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
11   JanesickBreastXeniumRep2()                 Xenium          biocOSN                  0.3.0 (Zarr v2)
12         HumanLungMulti_10x()                 Xenium biocOSN, sandbox 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
13             Breast2fov_10x()       Xenium (trimmed)   biocOSN_Xenium 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
14               Lung2fov_10x()       Xenium (trimmed)   biocOSN_Xenium 0.3.0 (Zarr v2), 0.7.2 (Zarr v3)
15           SpaceMHelaniH3T3()                 SpaceM          sandbox                  0.7.2 (Zarr v3)</code></pre></div>
```

To interrogate the bucket for available (zipped) .zarr archives:

``` r
Sys.setenv(AWS_REGION = "us-east-1")
if (requireNamespace("paws")) available("biocOSN")
```

## SpatialData-io

`SpatialData.data` also provides access to some raw spatial omic readouts. These
data bundle can then be converted into SpatialData objects using `spatialdata-io`
pyton package via `basilisk`.

``` r
available("biocOSN_Xenium")
```

```
checking Bioconductor OSN bucket (Xenium readouts) ...
[1] "README.html"                                         "Xenium_Prime_MultiCellSeg_Mouse_Ileum_tiny_outs.zip"
[3] "Xenium_V1_human_Breast_2fov_outs.zip"                "Xenium_V1_human_Lung_2fov_outs.zip" 
```

We use `basilisk` to convert these readouts into various SpatialData 
formats: 

* **0.3.0** (Zarr v2), 
* **0.5.0** (Zarr v2) and 
* **0.7.2** (Zarr v3)

We use `options(sd_version)` to set the SpatialData version.

```
options(sd_version = "0.3.0")
(x <- Breast2fov_10x(source = bucket_path("biocOSN_Xenium")))
```

```
Using spatialdata version 0.3.0
class: SpatialData
- images(1):
  - morphology_focus (5,3529,5792)
- labels(2):
  - cell_labels (3529,5792)
  - nucleus_labels (3529,5792)
- points(1):
  - transcripts (1113950)
- shapes(3):
  - cell_boundaries (7275,circle)
  - cell_circles (7275,circle)
  - nucleus_boundaries (7020,circle)
- tables(1):
  - table (280,7275)
coordinate systems:
- global(7): morphology_focus cell_labels ... nucleus_boundaries transcripts
```

## Dummy SpatialData objects

`SpatialData.data` package incorporates the `dummy-spatialdata` python package
from PyPI ([https://pypi.org/project/dummy-spatialdata/](https://pypi.org/project/dummy-spatialdata/))
via `basilisk` to generate toy spatialdata objects in multiple spatialdata 
versions. 

``` r
zarrfile <- tempfile(fileext = ".zarr")
generate_dataset(
  file = zarrfile, 
  sd_version = "0.5.0",
  images = list(
    list(type = "rgb", n_layers = 4L, coordinate_system="global"),
    list(type = "grayscale", n_layers = 1L, coordinate_system="global")
  ),
  shapes = list(
    list(n_shapes=12L, coordinate_system="global")
  ),
  points = list(
    list(n_points=12L)
  ),
  coordinate_systems = list(
    global = list(
      transformations = list("affine"), 
      shape = list(x=2000L, y=2000L)
    )
  )
)
```

```
Using spatialdata version 0.5.0
[1] "/var/folders/vf/d8kg507x41xfh6z9vgv9skksdsn29w/T//RtmpXl8ziv/file11cae4154ccb2.zarr"
```

``` r
sd <- SpatialData::readSpatialData(zarrfile)
sd
```

```
class: SpatialData
- images(2):
  - image_0 (3,2000,2000)
  - image_1 (1,2000,2000)
- labels(0):
- points(1):
  - point_0 (12)
- shapes(1):
  - shape_0 (12,polygon)
- tables(0):
coordinate systems:
- global(3): image_0 image_1 shape_0
```

``` r
image(sd, 1)
```

```
class:  ImageArray (MultiScale) 
Scales (4): (3,2000,2000) (3,1000,1000) (3,500,500) (3,250,250)
```



