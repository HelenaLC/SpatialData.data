# `SpatialData.data`

> for class infrastructure, see [`SpatialData`](https://github.com/HelenaLC/SpatialData)

> for visualization capabilites, see [`SpatialData.plot`](https://github.com/HelenaLC/SpatialData.plot)

# Introduction

`SpatialData.data` makes *scverse* data examples available through Bioc's 
NSF OSN bucket, and accessible from within R, using `BiocFileCache`.
Also, there is an interface to Python's 'spatialdata-io' for reading 
and writing to .zarr, and to align data into a common (identity) space.

# Installation

```
BiocManager::install("HelenaLC/SpatialData")
BiocManager::install("HelenaLC/SpatialData.data")
```

To *interrogate* our S3 bucket you will need [paws](https://cran.r-project.org/web/packages/paws/index.html) 
installed; it is not necessary for retrievals.

# Ingestion workflow

**Query Bioconductor's OSN bucket:**

```
> availableOSN()  # as of May 19 2025
checking Bioconductor OSN bucket...
[1] "HuLungXenmulti.zip"                     
[2] "mcmicro_io.zip"                         
[3] "merfish.zarr.zip"                       
[4] "mibitof.zip"                            
[5] "steinbock_io.zip"                       
[6] "visium_associated_xenium_io_aligned.zip"
[7] "visium_hd_3.0.0_io.zip"                 
[8] "xenium_rep1_io_aligned.zip"             
[9] "xenium_rep2_io_aligned.zip"               
```

**Bring a *.zip* archive into your local cache:**

```
dir.create(tf <- tempfile())
pa = SpatialData.data:::.unzip_spd_demo(
  zipname="mibitof.zip", 
  destination=tf, 
  source="biocOSN")
dir(pa, full.names=TRUE) # see the files
```

**Import the `SpatialData` instance, and work with it:**

```
(mibi <- readSpatialData(pa))
```

```
> mibi
class: SpatialData
images(3): point16_image point23_image point8_image
labels(3): point16_labels point23_labels point8_labels
shapes(0):
points(0):
tables(1): table
```

```
> table(mibi)
class: SingleCellExperiment 
dim: 36 3309 
metadata(1): spatialdata_attrs
assays(1): X
rownames(36): ASCT2 ATP5A ... XBP1 vimentin
rowData names(0):
colnames(3309): 9376-1 9377-1 ... 4273-0 4274-0
colData names(12): row_num point ... batch library_id
reducedDimNames(3): X_scanorama X_umap spatial
mainExpName: NULL
altExpNames(0):
```

**TODO: build provenance for each example**

```
make_spd_prov = function( outfile=tempfile(), zarr_url,
   prose_tag,
   pub_url,
   date_uploaded) {
   if (missing(date_uploaded)) stop("must supply upload date")
   if (missing(pub_url)) stop("must supply pub_url")
   if (missing(prose_tag)) stop("must supply upload prose_tag")
   basic = list(
    SpatialDataTag = prose_tag,
    zarr_url = zarr_url,
    pub_url = pub_url,
    date_uploaded = date_uploaded)
  jsonlite::write_json(jsonlite::toJSON(basic), outfile)
}

make_spd_prov(zarr_url = "https://s3.embl.de/spatialdata/spatialdata-sandbox/xenium_rep1_io_aligned.zip",
   prose_tag = "spatialdata notebooks aligned rep1",
   pub_url = "https://pubmed.ncbi.nlm.nih.gov/38114474/",
   date_uploaded = "2024.11.10")
```
