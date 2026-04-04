####
# Bucket paths #### 
####

#' @export
osn_path <- function() {
  "https://mghp.osn.xsede.org/bir190004-bucket01/BiocSpatialData"
}

#' @export
osn_xenium_path <- function() {
  "https://mghp.osn.xsede.org/bir190004-bucket01/BiocXenDemo"
}

#' @export
sandbox_path <- function() {
  "https://s3.embl.de/spatialdata/spatialdata-sandbox"
}

####
# Main readers and auxiliary #### 
####

#' @title a data.frame with information about available resources
#' @docType data
#' @examples
#' utils::data(demo_spatialdata)
#' if (requireNamespace("DT")) {
#'   DT::datatable(demo_spatialdata)
#' }
#' @note This information was scraped from 
#' [scverse spatialdata](https://spatialdata.scverse.org/en/latest/tutorials/notebooks/datasets/README.html) download site on 5 Dec 2024.
#' The bracketed numbers under "Sample" refer to footnotes provided at that site.
#' The individual functions in this package give similarly detailed references.
"demo_spatialdata"

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

#' all logic for finding, caching, loading an OSN-based dataset, hidden
#' 
#' @importFrom SpatialData readSpatialData
#' @importClassesFrom SpatialData SpatialData
#' @param patt character(1) sufficient to identify an OSN resource
#' @param cache like `BiocFileCache`
#' @param target character(1), defaults to tempfile(); use a different 
#'   value if you wish to retain the unzipped .zarr store persistently.
#' @note This function checks for stale element in cache and uses bfcupdate to rectify
#' before retrieving from cache.
#' 
# @examples
# # the following are equivalent:
# .get_demo_SDdata("merfish")
# MouseBrainMERFISH()
.get_demo_SDdata <- function(
    patt, 
    cache=BiocFileCache::BiocFileCache(),
    target=tempfile(),
    source = osn_path()
) {
  
  # get file and urls
  allz <- if (source == osn_path()) {
    .OSN_DATA
  } else if (source == osn_xenium_path()) {
    .OSN_Xenium_DATA
  } else if (source == sandbox_path()) {
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
  if(source == osn_xenium_path()){
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

#' read the data with S
#' @noRd
#' @importFrom SpatialData readSpatialData
.read_demo_SDdata <- function(
  patt, 
  cache=BiocFileCache::BiocFileCache(),
  target=tempfile(), 
  source=osn_path()
) {
  SpatialData::readSpatialData(
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

#' @title retrieve scverse-curated `SpatialData` .zarr archive
#' @aliases MouseIntestineVisHD
#' 
#' @description
#' This function consolidates the retrieval and caching and transformation 
#' of scverse-curated Zarr archives and 10x-curated Xenium archives.
#' 
#' @param target character(1), defaults to tempfile(); use a different 
#'   value if you wish to retain the unzipped .zarr store persistently.
#' 
#' @details
#' \describe{
#' \item{
#'   \code{MouseIntestineVisHD()}}{
#'   Visium HD 3.0.0 (10x Genomics) dataset of mouse intestine; source:
#' \emph{https://www.10xgenomics.com/datasets/visium-hd-cytassist-gene-expression-libraries-of-mouse-intestine}}
#' \item{
#'   \code{LungAdenocarcinomaMCMICRO()}}{
#'   MCMICRO dataset of human small cell lung adenocarcinoma}
#' \item{
#'   \code{MouseBrainMERFISH()}}{
#'   MERFISH dataset of mouse brain tissue}
#' \item{
#'   \code{MulticancerSteinbock()}}{
#'   imaging mass cytometry dataset of four cancers; source:
#'   \emph{https://www.nature.com/articles/s41596-023-00881-0}}
#' \item{
#'   \code{ColorectalCarcinomaMIBITOF()}}{
#'   MIBI-TOF dataset of colorectal carcinoma}
#' \item{
#'   \code{JanesickBreastVisiumEnh()}}{
#'   Visium (10x Genomics) dataset of breast cancer; source: 
#'   \emph{https://www.nature.com/articles/s41467-023-43458-x}}
#' \item{
#'   \code{JanesickBreastXeniumRep1/2()}}{
#'   two Xenium (10x Genomics) sections associated with
#'   the above Visium section from Janesick \emph{et al.}}
#' \item{
#'   \code{Breast2fov_10x()}}{
#'   Xenium (10x Genomics) data on breast cancer, trimmed to 2 FOVs; source: 
#'   \emph{https://www.10xgenomics.com/support/software/xenium-onboard-analysis/latest/resources/xenium-example-data}}
#' \item{
#'   \code{Lung2fov_10x()}}{
#'   Xenium (10x Genomics) data on lung cancer, trimmed to 2 FOVs; source: 
#'   \emph{https://www.10xgenomics.com/support/software/xenium-onboard-analysis/latest/resources/xenium-example-data}}
#' \item{
#'   \code{HumanLungMulti_10x()}}{
#'   Xenium (10x Genomics) data on lung cancer;
#'   source: \emph{https://www.10xgenomics.com/datasets/preview-data-ffpe-human-lung-cancer-with-xenium-multimodal-cell-segmentation-1-standard}}
#' }

####
# Tech specific readers #### 
####

#' @rdname MouseIntestineVisHD
#' @export
MouseIntestineVisHD <- function(target=tempfile()) { 
    .read_demo_SDdata("visium_hd_3.0.0", 
                      target=target,
                      source = osn_path())
}

#' @rdname MouseIntestineVisHD
#' @export
LungAdenocarcinomaMCMICRO <- function(target=tempfile()) {
    .read_demo_SDdata("mcmicro_io", 
                      target=target, 
                      source = osn_path())
}

#' @rdname MouseIntestineVisHD
#' @export
MouseBrainMERFISH = function(target=tempfile()) {
    .read_demo_SDdata("merfish", 
                      target=target, 
                      source = osn_path())
}

#' @rdname MouseIntestineVisHD
#' @export
MulticancerSteinbock <- function(target=tempfile()) {
    .read_demo_SDdata("steinbock_io", 
                      target=target,
                      source = osn_path())
}

#' @rdname MouseIntestineVisHD
#' @export
ColorectalCarcinomaMIBITOF <- function(target=tempfile()) {
    .read_demo_SDdata("mibitof", 
                      target=target, 
                      source = osn_path())
}

#' @rdname MouseIntestineVisHD
#' @export
JanesickBreastVisiumEnh <- function(target=tempfile()) {
    .read_demo_SDdata("visium_associated_xenium_io", 
                      target=target, 
                      source = osn_path())
}

#' @rdname MouseIntestineVisHD
#' @export
JanesickBreastXeniumRep1 <- function(target=tempfile()) {
    .read_demo_SDdata("xenium_rep1_io", 
                      target=target, 
                      source = osn_path())
}

#' @rdname MouseIntestineVisHD
#' @export
JanesickBreastXeniumRep2 <- function(target=tempfile()) {
    .read_demo_SDdata("xenium_rep2_io", 
                      target=target, 
                      source = osn_path())
}

#' @rdname MouseIntestineVisHD
#' @export
Breast2fov_10x <- function(target=tempfile()) {
    .read_demo_SDdata("human_Breast_2fov", 
                      target=target, 
                      source = osn_xenium_path())
}

#' @rdname MouseIntestineVisHD
#' @export
Lung2fov_10x <- function(target=tempfile()) {
    .read_demo_SDdata("human_Lung_2fov", 
                      target=target, 
                      source = osn_xenium_path())
}

#' @rdname MouseIntestineVisHD
#' @export
HumanLungMulti_10x <- function(target=tempfile()) {
    .read_demo_SDdata("HuLungXenmulti", 
                      target=target, 
                      source = osn_path())
}
