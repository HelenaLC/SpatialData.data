####
# Bucket paths #### 
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

####
# Main readers and auxiliary #### 
####

#' all logic for finding, caching, loading an OSN-based dataset, hidden
#' 
#' @importFrom SpatialData readSpatialData
#' @importClassesFrom SpatialData SpatialData
#' @param patt character(1) sufficient to identify an OSN resource
#' @param cache like `BiocFileCache`
#' @param target character(1), defaults to tempfile(); use a different 
#'   value if you wish to retain the unzipped .zarr store persistently.
#' @param source the name of the source bucket.
#' @note This function checks for stale element in cache and uses bfcupdate to rectify
#' before retrieving from cache.
#' 
# @examples
# # the following are equivalent:
# get_demo_SDdata("merfish")
# MouseBrainMERFISH()
get_demo_SDdata <- function(
    patt, 
    cache=BiocFileCache::BiocFileCache(),
    target=tempfile(),
    source = bucket_path("biocOSN")
) {
  
  # get file and urls
  allz <- if (source == bucket_path("biocOSN")) {
    .OSN_DATA
  } else if (source == bucket_path("biocOSN_Xenium")) {
    .OSN_Xenium_DATA
  } else if (source == bucket_path("sandbox")) {
    .SANDBOX_DATA
  } else {
    stop("Unknown source")
  }
  allurls <- file.path(source, allz)
  
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
  if(source == bucket_path("biocOSN_Xenium")){
    dir.create(td <- tempfile()) # can't use target'
    unzip(loc, exdir=td)  # manufacturer output
    if (dir.exists(target)) 
      warning("target exists")
    use_sdio("xenium", srcdir=td, dest=target) # zarr in target
    return(target)
  } else {
    dir.create(td <- target)
    unzip(loc, exdir=td)
    return(dir(td, full.names=TRUE)) 
  }
}

#' read the data with SpatialData::readSpatialData
#' @noRd
#' @importFrom SpatialData readSpatialData
.read_demo_SDdata <- function(
  patt, 
  cache=BiocFileCache::BiocFileCache(),
  target=tempfile(), 
  source=bucket_path("biocOSN")
) {
  SpatialData::readSpatialData(
    get_demo_SDdata(
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

# TODO: get rid of this later

#' provide path to a zip file from 10x genomics for Xenium platform
#' @param zipname character(1) name of zip archive to find
#' @examples
#' SpatialData.data:::.path_to_10x_xen_demo()
#' # see ?use_sdio
.path_to_10x_xen_demo <- function(
    cache=BiocFileCache::BiocFileCache(),
    zipname="Xenium_V1_human_Breast_2fov_outs.zip", 
    source = bucket_path("biocOSN_Xenium")) {
  info <- BiocFileCache::bfcquery(cache, zipname)
  nrec <- nrow(info)
  if (nrec > 1) {
    message(sprintf("multiple %s found in cache, using last recorded", zipname))
  }
  if (nrec == 1) {
    message("returning path to cached zip")
    return(info$rpath[nrec])
  }
  fp <- file.path(source, zipname)
  message(sprintf("retrieving from %s, caching, and returning path", source))
  BiocFileCache::bfcadd(cache, rname=zipname, fpath=fp, rtype="web")
}

####
# Tech specific readers #### 
####


#' SpatialData.data_list
#'
#' Returns metadata of available data from Bioc OSN and scverse spatialdata-
#' sandbox S3 buckets
#' 
#' @param extended if TRUE, all columns will be returned, e.g. File size, 
#' License etc.
#'
#' @returns data.frame
#' 
#' @export
#' 
#' @examples
#' SpatialData.data_list()
#' SpatialData.data_list(extended = TRUE)
SpatialData.data_list <- function(extended = FALSE) {
  data_file <- system.file("data", "demo_spatialdata.csv", package = "SpatialData.data")
  x <- read.csv(data_file, sep = ";")
  if(extended) x else x[,c("Function", "Technology", "S3_buckets", "Format")]
}

#' @title retrieve scverse-curated `SpatialData` .zarr archive
#' @rdname SpatialData-data
#' 
#' @aliases 
#' MouseIntestineVisHD
#' MouseBrainVisHD
#' MouseBrainVis
#' LungAdenocarcinomaMCMICRO
#' MouseBrainMERFISH
#' MouseLiverMERFISH
#' MulticancerSteinbock
#' ColorectalCarcinomaMIBITOF
#' JanesickBreastVisiumEnh
#' JanesickBreastXeniumRep1
#' JanesickBreastXeniumRep2
#' Breast2fov_10x
#' Lung2fov_10x
#' HumanLungMulti_10x
#' SpaceMHelaniH3T3
#' 
#' @description
#' This function consolidates the retrieval and caching and transformation 
#' of scverse-curated Zarr archives and 10x-curated Xenium archives.
#' 
#' @param stub character(1) a string that identifies a resource
#' @param target character(1), defaults to tempfile(); use a different 
#'   value if you wish to retain the unzipped .zarr store persistently.
#' @param target character(1), defaults to tempfile(); use a different 
#'   value if you wish to retain the unzipped .zarr store persistently.
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
#' # load using `load_data`
#' ld <- load_data("ColorectalCarcinomaMIBITOF")
#' ld
#' 
#' # uses biocOSN as source
#' ld <- ColorectalCarcinomaMIBITOF()
#' ld 
#' 
#' # TODO: zarr v3 read is not complete
#' # # use sandbox as source
#' # ld <- ColorectalCarcinomaMIBITOF(source = bucket_path("sandbox"))
#' 
#' @return an instance of SpatialData, or NULL if the stub does not
#' uniquely match (using grep()) the name of any resource
#' 
#' @export
load_data = function(stub, 
                     target = tempfile(), 
                     source = bucket_path("biocOSN")) { 
  opts = SpatialData.data_list()
  hit = grep(stub, opts$Function, value=TRUE)
  if (!is.na(hit[1]) && length(hit)==1L) 
    return(get(hit)(target = target,
                    source = source))
  else if (is.na(hit[1])) {
    message("stub provided has no match in OSN resources")
    message("returning NULL")
  }
  else {
    message("stub does not uniquely match an OSN resource")
    message("matched: ")
    print(hit)
    message("returning NULL")
  }
  NULL
}

#' @describeIn SpatialData-data
#' \describe{
#'   Visium HD 3.0.0 (10x Genomics) dataset of mouse intestine; source:
#'   \url{https://www.10xgenomics.com/datasets/visium-hd-cytassist-gene-expression-libraries-of-mouse-intestine}
#' }
#' @export
MouseIntestineVisHD <- function(target=tempfile(), 
                                source = bucket_path("biocOSN")) { 
    .read_demo_SDdata("visium_hd_3.0.0", target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'   Visium HD 4.0.1 (10x Genomics) dataset of mouse brain; source:
#'   \url{https://www.10xgenomics.com/datasets/visium-hd-three-prime-mouse-brain-fresh-frozen}
#' }
#' @export
MouseBrainVisHD <- function(target=tempfile(), 
                                source = bucket_path("sandbox")) { 
  .read_demo_SDdata("visium_hd_4.0.1", target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'   Visium (10x Genomics) dataset of mouse brain; source:
#'   \url{https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-11114}
#' }
#' @export
MouseBrainVis <- function(target=tempfile(), 
                            source = bucket_path("sandbox")) { 
  .read_demo_SDdata("visium_spatialdata", target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'    MCMICRO dataset of human small cell lung adenocarcinoma
#' }
#' @export
LungAdenocarcinomaMCMICRO <- function(target=tempfile(), 
                                      source = bucket_path("biocOSN")) {
    .read_demo_SDdata("mcmicro_io", target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'   MERFISH dataset of mouse brain tissue
#' }
#' @export
MouseBrainMERFISH = function(target=tempfile(), 
                             source = bucket_path("biocOSN")) {
    .read_demo_SDdata("merfish", target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'    MERFISH dataset of mouse liver tissue (SPArrOW output); source:
#'    \url{https://www.biorxiv.org/content/10.1101/2024.07.04.601829v1}
#' }
#' @export
MouseLiverMERFISH = function(target=tempfile(), 
                             source = bucket_path("sandbox")) {
  .read_demo_SDdata("mouse_liver", target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'   imaging mass cytometry dataset of four cancers; source:
#'   \url{https://www.nature.com/articles/s41596-023-00881-0}
#' }
#' @export
MulticancerSteinbock <- function(target=tempfile(), 
                                 source = bucket_path("biocOSN")) {
    .read_demo_SDdata("steinbock_io", target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'   MIBI-TOF dataset of colorectal carcinoma
#' }
#' @export
ColorectalCarcinomaMIBITOF <- function(target=tempfile(),
                                       source = bucket_path("biocOSN")) {
    .read_demo_SDdata("mibitof", target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'   Visium (10x Genomics) dataset of breast cancer; source: 
#'   \url{https://www.nature.com/articles/s41467-023-43458-x}
#' }
#' @export
JanesickBreastVisiumEnh <- function(target=tempfile(),
                                    source = bucket_path("biocOSN")) {
    .read_demo_SDdata("visium_associated_xenium_io", 
                      target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'   two Xenium (10x Genomics) sections associated with
#'   the above Visium section from Janesick \emph{et al.}
#' }
#' @export
JanesickBreastXeniumRep1 <- function(target=tempfile(), 
                                     source = bucket_path("biocOSN")) {
    .read_demo_SDdata("xenium_rep1_io", target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'   two Xenium (10x Genomics) sections associated with
#'   the above Visium section from Janesick \emph{et al.}
#' }
#' @export
JanesickBreastXeniumRep2 <- function(target=tempfile(), 
                                     source = bucket_path("biocOSN")) {
    .read_demo_SDdata("xenium_rep2_io", target=target, source = source)
}

#' @describeIn SpatialData-data 
#' \describe{
#'   Xenium (10x Genomics) data on breast cancer, trimmed to 2 FOVs; source: 
#'   \url{https://www.10xgenomics.com/support/software/xenium-onboard-analysis/latest/resources/xenium-example-data}
#' }
#' @export
Breast2fov_10x <- function(target=tempfile(),
                           source = bucket_path("biocOSN_Xenium")) {
    .read_demo_SDdata("human_Breast_2fov", target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'   Xenium (10x Genomics) data on lung cancer, trimmed to 2 FOVs; source: 
#'   \url{https://www.10xgenomics.com/support/software/xenium-onboard-analysis/latest/resources/xenium-example-data}
#' }
#' @export
Lung2fov_10x <- function(target=tempfile(),
                         source = bucket_path("biocOSN_Xenium")) {
    .read_demo_SDdata("human_Lung_2fov", target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'   Xenium (10x Genomics) data on lung cancer; source:
#'   \url{https://www.10xgenomics.com/datasets/preview-data-ffpe-human-lung-cancer-with-xenium-multimodal-cell-segmentation-1-standard}
#' }
#' @export
HumanLungMulti_10x <- function(target=tempfile(), 
                               source = bucket_path("biocOSN")) {
    .read_demo_SDdata("HuLungXenmulti", target=target, source = source)
}

#' @describeIn SpatialData-data
#' \describe{
#'    SpaceM on Hepa and NIH3T3 cells; more info:
#'    \url{https://github.com/giovp/spatialdata-sandbox/blob/main/spacem_helanih3t3/README.md}
#' }
#' @export
SpaceMHelaniH3T3 <- function(target=tempfile(), 
                             source = bucket_path("sandbox")) {
  .read_demo_SDdata("spacem_helanih3t3", target=target, source = source)
}

