####
# Bucket data #### 
####

#' @noRd
.OSN_DATA <- c(
  "mcmicro_io.zip", 
  "merfish.zarr.zip", 
  "mibitof.zip", 
  "steinbock_io.zip", 
  "visium_associated_xenium_io_aligned.zip", 
  "visium_hd_3.0.0_io.zip",
  "xenium_rep1_io_aligned.zip", 
  "xenium_rep2_io_aligned.zip",
  "HuLungXenmulti.zip")

#' @noRd
.OSN_Xenium_DATA <- c(
  "Xenium_V1_human_Breast_2fov_outs.zip",
  "Xenium_V1_human_Lung_2fov_outs.zip")

#' @noRd
.SANDBOX_DATA <- c(
  "merfish_spatialdata_0.7.1.zip",          
  "mibitof_spatialdata_0.7.1.zip",                   
  "mouse_liver_spatialdata_0.7.1.zip",        
  "spacem_helanih3t3_spatialdata_0.7.1.zip",
  "visium_associated_xenium_io_spatialdata_0.7.1.zip",
  "visium_hd_3.0.0_io_spatialdata_0.7.1.zip",
  "visium_hd_4.0.1_io_spatialdata_0.7.1.zip",         
  "visium_spatialdata_0.7.1.zip",        
  "xenium_2.0.0_io_spatialdata_0.7.1.zip",            
  "xenium_rep1_io_spatialdata_0.7.1.zip" 
)

.DATASETS <- list(
  MouseIntestineVisHD        = "visium_hd_3.0.0",
  MouseBrainVisHD            = "visium_hd_4.0.1",
  MouseBrainVis              = "visium_spatialdata",
  LungAdenocarcinomaMCMICRO  = "mcmicro_io",
  MouseBrainMERFISH          = "merfish",
  MouseLiverMERFISH          = "mouse_liver",
  MulticancerSteinbock       = "steinbock_io",
  ColorectalCarcinomaMIBITOF = "mibitof",
  JanesickBreastVisiumEnh    = "visium_associated_xenium_io",
  JanesickBreastXeniumRep1   = "xenium_rep1_io",
  JanesickBreastXeniumRep2   = "xenium_rep2_io",
  Breast2fov_10x             = "human_Breast_2fov",
  Lung2fov_10x               = "human_Lung_2fov",
  HumanLungMulti_10x         = "HuLungXenmulti",
  SpaceMHelaniH3T3           = "spacem_helanih3t3"
)

####
# Bucket path #### 
####

.OSN_PATH <- "https://mghp.osn.xsede.org/bir190004-bucket01/BiocSpatialData"
.OSN_Xenium_PATH <- "https://mghp.osn.xsede.org/bir190004-bucket01/BiocXenDemo"
.SANDBOX_PATH <- "https://s3.embl.de/spatialdata/spatialdata-sandbox"

#' bucket_path
#' 
#' Function for interrogating path to buckets.
#' 
#' @param source The name of the query bucket.
#' \describe{
#'  \item{biocOSN}{
#'    Bioc's Open Storage Network (NSF) OSN bucket (spatialdata v0.3.0, zarr v2)
#'  }
#'  \item{biocOSN_Xenium}{
#'    Raw Xenium readouts from Bioc's Open Storage Network (NSF) OSN bucket.
#'  }
#'  \item{sandbox}{
#'    scverse's spatialdata-sandbox bucket at EMBL.
#'  }
#' }
#' 
#' @examples
#' bucket_path()
#' 
#' @export
bucket_path <- function(source = "biocOSN"){
  switch(source, 
         biocOSN = .OSN_PATH,
         biocOSN_Xenium = .OSN_Xenium_PATH,
         sandbox = .SANDBOX_PATH, 
         {
           stop("Unknown bucket! Available values are ", 
                "'biocOSN', 'biocOSN_Xenium' and 'sandbox'.")
         })
}

####
# Main readers #### 
####

#' SD.data_list
#'
#' Returns metadata of available data from Bioc OSN and scverse spatialdata-
#' sandbox S3 buckets
#' 
#' @param extended if TRUE, all columns will be returned, e.g. File size, 
#' License etc.
#'
#' @importFrom utils read.csv
#' 
#' @returns data.frame
#' 
#' @export
#' 
#' @examples
#' SD.data_list()
#' SD.data_list(extended = TRUE)
SD.data_list <- function(extended = FALSE) {
  data_file <- system.file("extdata", "demo_spatialdata.csv", package = "SpatialData.data")
  x <- utils::read.csv(data_file, sep = ";")
  if(extended) x else x[,c("Function", "Technology", "S3_buckets", "Format")]
}

#' @title retrieve scverse-curated `SpatialData` .zarr archive
#' @rdname SD.data_load
#' 
#' @description
#' This function consolidates the retrieval and caching and transformation 
#' of scverse-curated Zarr archives and 10x-curated Xenium archives.
#' 
#' @param id character string; dataset identifier
#' @param target character(1), defaults to tempfile(); use a different 
#'   value if you wish to retain the unzipped .zarr store persistently.
#' @param source The name of the source, i.e. query bucket.
#' \describe{
#'  \item{biocOSN}{
#'    Bioc's Open Storage Network (NSF) OSN bucket (spatialdata v0.3.0, zarr v2)
#'  }
#'  \item{biocOSN_Xenium}{
#'    Raw Xenium readouts from Bioc's Open Storage Network (NSF) OSN bucket.
#'  }
#'  \item{sandbox}{
#'    scverse's spatialdata-sandbox bucket at EMBL.
#'  }
#' }
#' 
#' @return an instance of SpatialData, or throws an error if the dataset 
#' identifier (id)does not uniquely match the name of any resource, see 
#' \link{SD.data_list} for the list of datasets.
#' 
#' @examples
#' Sys.setenv(AWS_REGION = "us-east-1")
#' 
#' # load using `SD.data_load`
#' ld <- SD.data_load("ColorectalCarcinomaMIBITOF")
#' ld
#' 
#' # TODO: zarr v3 read is not complete
#' # # use sandbox as source
#' # ld <- SD.data_load("ColorectalCarcinomaMIBITOF", source = "sandbox")
#' 
#' @export
#' 
#' @details
#' \itemize{
#'   \item MouseIntestineVisHD:
#'     Visium HD 3.0.0 (10x Genomics) dataset of mouse intestine;
#'     source (biocOSN):
#'     \url{https://www.10xgenomics.com/datasets/visium-hd-cytassist-gene-expression-libraries-of-mouse-intestine}
#'   \item MouseBrainVisHD:
#'     Visium HD 4.0.1 (10x Genomics) dataset of mouse brain;
#'     source (sandbox):
#'     \url{https://www.10xgenomics.com/datasets/visium-hd-three-prime-mouse-brain-fresh-frozen}
#'   \item MouseBrainVis:
#'     Visium (10x Genomics) dataset of mouse brain;
#'     source (sandbox):
#'     \url{https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-11114}
#'   \item LungAdenocarcinomaMCMICRO:
#'     MCMICRO dataset of human small cell lung adenocarcinoma;
#'     source (biocOSN)
#'   \item MouseBrainMERFISH:
#'     MERFISH dataset of mouse brain tissue;
#'     source (biocOSN)
#'   \item MouseLiverMERFISH:
#'     MERFISH dataset of mouse liver tissue (SPArrOW output);
#'     source (sandbox):
#'     \url{https://www.biorxiv.org/content/10.1101/2024.07.04.601829v1}
#'   \item MulticancerSteinbock:
#'     imaging mass cytometry dataset of four cancers;
#'     source (biocOSN):
#'     \url{https://www.nature.com/articles/s41596-023-00881-0}
#'   \item ColorectalCarcinomaMIBITOF:
#'     MIBI-TOF dataset of colorectal carcinoma;
#'     source (biocOSN)
#'   \item JanesickBreastVisiumEnh:
#'     Visium (10x Genomics) dataset of breast cancer;
#'     source (biocOSN):
#'     \url{https://www.nature.com/articles/s41467-023-43458-x}
#'   \item JanesickBreastXeniumRep1:
#'     first of two Xenium (10x Genomics) sections associated with
#'     the Visium section from Janesick \emph{et al.};
#'     source (biocOSN)
#'   \item JanesickBreastXeniumRep2:
#'     second of two Xenium (10x Genomics) sections associated with
#'     the Visium section from Janesick \emph{et al.};
#'     source (biocOSN)
#'   \item Breast2fov_10x:
#'     Xenium (10x Genomics) data on breast cancer, trimmed to 2 FOVs;
#'     source (biocOSN_Xenium):
#'     \url{https://www.10xgenomics.com/support/software/xenium-onboard-analysis/latest/resources/xenium-example-data}
#'   \item Lung2fov_10x:
#'     Xenium (10x Genomics) data on lung cancer, trimmed to 2 FOVs;
#'     source (biocOSN_Xenium):
#'     \url{https://www.10xgenomics.com/support/software/xenium-onboard-analysis/latest/resources/xenium-example-data}
#'   \item HumanLungMulti_10x:
#'     Xenium (10x Genomics) data on lung cancer;
#'     source (biocOSN):
#'     \url{https://www.10xgenomics.com/datasets/preview-data-ffpe-human-lung-cancer-with-xenium-multimodal-cell-segmentation-1-standard}
#'   \item SpaceMHelaniH3T3:
#'     SpaceM on Hepa and NIH3T3 cells; source (sandbox);
#'     more info:
#'     \url{https://github.com/giovp/spatialdata-sandbox/blob/main/spacem_helanih3t3/README.md}
#' }
SD.data_load = function(id, 
                        target = tempfile(), 
                        source) { 
  opts <- SD.data_list()
  if(missing(source)){
    source <- opts[opts$Function == id, "S3_buckets"]
    source <- strsplit(source, split = ", ")[[1]][1]
  }
  if(id %in% opts$Function) {
    .read_demo_SDdata(.DATASETS[[id]], target=target, source = source)
  } else {
    stop("Dataset not found!")
  }
}

####
# Auxiliary #### 
####


#' all logic for finding, caching, loading an OSN-based dataset, hidden
#' 
#' @importFrom spatialdataR readSpatialData
#' @param patt character(1) sufficient to identify an OSN resource
#' @param cache like `BiocFileCache`
#' @param target character(1), defaults to tempfile(); use a different 
#'   value if you wish to retain the unzipped .zarr store persistently.
#' @param source the name of the source bucket.
#' 
#' @importFrom utils unzip
#' 
#' @note This function checks for stale element in cache and uses bfcupdate to rectify
#' before retrieving from cache.
#' 
#' @noRd
.get_demo_SDdata <- function(
    patt, 
    cache=BiocFileCache::BiocFileCache(),
    target=tempfile(),
    source = "biocOSN"
) {
  
  # get file and urls
  allz <- if (source == "biocOSN") {
    .OSN_DATA
  } else if (source == "biocOSN_Xenium") {
    .OSN_Xenium_DATA
  } else if (source == "sandbox") {
    .SANDBOX_DATA
  } else {
    stop("Unknown source")
  }
  allurls <- file.path(bucket_path(source), allz)
  
  # get availables in cache
  ca <- BiocFileCache::BiocFileCache()
  chk <- lapply(allurls, \(x) BiocFileCache::bfcquery(ca, x))
  chkdf <- do.call(rbind, chk)
  
  # match patterns with cache
  ind <- grep(patt, chkdf$rname)
  
  # multiple pattern hits in cache
  if (length(ind) > 1)
    .pattern_not_unique(patt)
  
  # not pattern hits in cache
  if (length(ind) == 0) {
    
    # check main list
    zipind = grep(patt, allz)
    
    # no hits in main list
    if (length(zipind) == 0) 
      .pattern_not_found(patt)
    
    # get location
    zipname <- allz[zipind]
    message(sprintf("caching %s", zipname))
    fpath <- allurls[zipind]
    loc <- BiocFileCache::bfcadd(cache, rname=zipname, fpath=fpath, rtype="web")
  }
  
  # single pattern, length(ind) == 1
  if (length(ind) == 1) {
    stale <- BiocFileCache::bfcneedsupdate(cache, chkdf[ind,]$rid)
    if (stale) 
      BiocFileCache::bfcupdate(cache, chkdf[ind,]$rid, fpath=chkdf[ind,]$fpath, rtype="web")
    loc <- chkdf[ind,]$rpath
  }

  # unzip (convert to zarr if needed using spatialdata-io)
  # and return to target
  if(source == "biocOSN_Xenium"){
    dir.create(td <- tempfile()) # can't use target'
    utils::unzip(loc, exdir=td)  # manufacturer output
    if (dir.exists(target)) 
      warning("target exists")
    SD.io("xenium", srcdir=td, dest=target) # zarr in target
    return(target)
  } else {
    dir.create(td <- target)
    utils::unzip(loc, exdir=td)
    return(dir(td, full.names=TRUE)) 
  }
}

#' read the data with spatialdataR::readSpatialData
#' @noRd
#' @importFrom spatialdataR readSpatialData
.read_demo_SDdata <- function(
  patt, 
  cache=BiocFileCache::BiocFileCache(),
  target=tempfile(), 
  source="biocOSN"
) {
  spatialdataR::readSpatialData(
    .get_demo_SDdata(
      patt = patt,
      cache = cache,
      target = target,
      source = source
    )
  )
}

.pattern_not_unique <- function(patt) {
  stop("pattern '", patt ,"' does not uniquely identify a resource, please be more specific")
}

.pattern_not_found <- function(patt) {
  stop("pattern '", patt ,"' not matched in available resources")
}