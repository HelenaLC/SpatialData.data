# SD.data_available

Function for interrogating files across buckets. Please use
paws.storage::s3' to interrogate buckets for zipped zarr archives or raw
readouts for various platforms.

## Usage

``` r
SD.data_available(source = "biocOSN")
```

## Arguments

- source:

  The name of the query bucket.

  biocOSN

  :   Bioc's Open Storage Network (NSF) OSN bucket (spatialdata v0.3.0,
      zarr v2)

  biocOSN_Xenium

  :   Raw Xenium readouts from Bioc's Open Storage Network (NSF) OSN
      bucket.

  sandbox

  :   scverse's spatialdata-sandbox bucket at EMBL.

## Examples

``` r
Sys.setenv(AWS_REGION = "us-east-1")
if (requireNamespace("paws.storage")) {
  SD.data_available("biocOSN")
}
#> checking Bioconductor OSN bucket...
#> [1] "HuLungXenmulti.zip"                     
#> [2] "mcmicro_io.zip"                         
#> [3] "merfish.zarr.zip"                       
#> [4] "mibitof.zip"                            
#> [5] "steinbock_io.zip"                       
#> [6] "visium_associated_xenium_io_aligned.zip"
#> [7] "visium_hd_3.0.0_io.zip"                 
#> [8] "xenium_rep1_io_aligned.zip"             
#> [9] "xenium_rep2_io_aligned.zip"             
```
