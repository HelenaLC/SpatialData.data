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

Data from a variety of technologies has been made available as `SpatialData` .zarr stores 
[here](https://spatialdata.scverse.org/en/latest/tutorials/notebooks/datasets/README.html).
These, in turn, have been deposited in both Bioconductor's NSF Open Storage Network and 
scverse's spatialdata-sandbox bucketS, and can be retrieved with caching support 
using `r BiocStyle::Biocpkg("BiocFileCache")`.

Any spatialdata dataset can be retrieved (once) into some location, and 
read into R.  We use dataset-specific functions, or `load_data`:

``` r
(x <- load_data("ColorectalCarcinomaMIBITOF")) # stub can be used
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

<div><pre><code style="font-size: 13px;">                       Function             Technology       S3_buckets                           Format
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