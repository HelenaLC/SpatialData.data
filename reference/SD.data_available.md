# SD.data_available

Function for interrogating files across buckets. Please use
paws.storage::s3' to interrogate buckets for zipped zarr archives or raw
readouts for various platforms.

## Usage

``` r
SD.data_available(src = "sandbox")
```

## Arguments

- src:

  The name of the query bucket.

  biocOSN

  :   Bioc's Open Storage Network (NSF) OSN bucket (spatialdata v0.3.0,
      zarr v2)

  sandbox

  :   scverse's spatialdata-sandbox bucket at EMBL.

## Value

a vector of example (zipped) SpatialData stores available at `source`

## Examples

``` r
Sys.setenv(AWS_REGION = "us-east-1")
library(paws.storage)
 
SD.data_available()
#> checking scverse spatialdata-sandbox bucket...
#>  [1] "merfish_spatialdata_0.7.1.zip"                    
#>  [2] "mibitof_spatialdata_0.7.1.zip"                    
#>  [3] "mouse_liver_spatialdata_0.7.1.zip"                
#>  [4] "spacem_helanih3t3_spatialdata_0.7.1.zip"          
#>  [5] "visium_associated_xenium_io_spatialdata_0.7.1.zip"
#>  [6] "visium_hd_3.0.0_io_spatialdata_0.7.1.zip"         
#>  [7] "visium_hd_4.0.1_io_spatialdata_0.7.1.zip"         
#>  [8] "visium_spatialdata_0.7.1.zip"                     
#>  [9] "xenium_2.0.0_io_spatialdata_0.7.1.zip"            
#> [10] "xenium_rep1_io_spatialdata_0.7.1.zip"             
SD.data_available("sandbox")
#> checking scverse spatialdata-sandbox bucket...
#>  [1] "merfish_spatialdata_0.7.1.zip"                    
#>  [2] "mibitof_spatialdata_0.7.1.zip"                    
#>  [3] "mouse_liver_spatialdata_0.7.1.zip"                
#>  [4] "spacem_helanih3t3_spatialdata_0.7.1.zip"          
#>  [5] "visium_associated_xenium_io_spatialdata_0.7.1.zip"
#>  [6] "visium_hd_3.0.0_io_spatialdata_0.7.1.zip"         
#>  [7] "visium_hd_4.0.1_io_spatialdata_0.7.1.zip"         
#>  [8] "visium_spatialdata_0.7.1.zip"                     
#>  [9] "xenium_2.0.0_io_spatialdata_0.7.1.zip"            
#> [10] "xenium_rep1_io_spatialdata_0.7.1.zip"             
SD.data_available("biocOSN")
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
