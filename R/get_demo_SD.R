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

#' all logic for finding, caching, loading an OSN-based dataset, hidden
#' @importFrom SpatialData readSpatialData
#' @importClassesFrom SpatialData SpatialData
#' @param patt character(1) sufficient to identify an OSN resource
#' @param cache like `BiocFileCache`
#' @param target character(1), defaults to tempfile(); use a different 
#'   value if you wish to retain the unzipped .zarr store persistently.
# @examples
# # the following are equivalent:
# get_demo_SD("merfish")
# MouseBrainMERFISH()
# 
.get_demo_SD <- function(patt, 
    cache=BiocFileCache::BiocFileCache(),
    target=tempfile()) {
    
    # Bioconductor's OSN bucket
    buckprefix <- "https://mghp.osn.xsede.org/bir190004-bucket01"
    
    # work on zipped Zarr archives from scverse SpatialData datasets page
    sdfold <- "BiocSpatialData"
    
    sdzips <- c(
        "mcmicro_io.zip", "merfish.zarr.zip", 
        "mibitof.zip", "steinbock_io.zip", 
        "visium_associated_xenium_io_aligned.zip", "visium_hd_3.0.0_io.zip",
        "xenium_rep1_io_aligned.zip", "xenium_rep2_io_aligned.zip",
        "HuLungXenmulti.zip")
    
    sdurls <- paste(buckprefix, sdfold, sdzips, sep="/")
    
    # work on zipped Xenium minimal outputs, retrieved and zipped in OSN
    # these must be expanded and processed with use_sdio
    xdfold <- "BiocXenDemo"
    xdzips <- c(
        "Xenium_V1_human_Breast_2fov_outs.zip",
        "Xenium_V1_human_Lung_2fov_outs.zip")
    
    # collect names of all zip files
    allz <- c(sdzips, xdzips)
    # build a tibble with all relevant information
    xdurls <- paste(buckprefix, xdfold, xdzips, sep="/")
    allurls <- c(sdurls, xdurls)
    
    ca <- BiocFileCache::BiocFileCache()
    chk <- lapply(allurls, \(x) BiocFileCache::bfcquery(ca, x))
    chkdf <- do.call(rbind, chk)
    ind <- grep(patt, chkdf$rname)
    nupatt <- "pattern does not uniquely identify a resource, please be more specific"
    if (length(ind) > 1) stop(nupatt)
    if (length(ind) == 0) {
        chkxen <- grep(patt, xdzips)
        if (length(chkxen) > 1) stop(nupatt)
        if (length(chkxen) == 0) {   # add a zipped zarr
            zipind = grep(patt, sdzips)  # already ruled out xenium group, must be from spatialdata archive
            if (length(zipind) == 0) stop("patt not matched in available resources")
            zipname <- sdzips[zipind]
            message(sprintf("caching %s", zipname))
            fpath <- sdurls[zipind]
            loc <- BiocFileCache::bfcadd(cache, rname=zipname, fpath=fpath, rtype="web")
            td <- target
            dir.create(td)
            unzip(loc, exdir=td)
            return(SpatialData::readSpatialData(dir(td, full.names=TRUE)))
        } # end zipped zarr, now retrieve Xenium, run use_sdio, then read
        zipname <- xdzips[chkxen]
        message(sprintf("caching %s", zipname))
        fpath <- xdurls[chkxen]
        preloc <- BiocFileCache::bfcadd(cache, rname=zipname, fpath=fpath, rtype="web")
        td <- tempfile() # can't use target'
        dir.create(td)
        unzip(preloc, exdir=td)  # manufacturer output
        if (dir.exists(target)) print("target exists")
        use_sdio("xenium", srcdir=td, dest=target) # zarr in target
        return(SpatialData::readSpatialData(target))
    }
    # so a single pattern has hit, and it is in cache
    if (chkdf[ind,]$rname %in% xdzips) { # it is a Xenium 10x output resource
        preloc <- chkdf[ind,]$rpath
        td <- tempfile() # can't use target
        dir.create(td)
        unzip(preloc, exdir=td)  # manufacturer output
        use_sdio("xenium", srcdir=td, dest=target) # zarr in target
        return(SpatialData::readSpatialData(target))
    }
    loc <- chkdf[ind,]$rpath
    td <- target
    dir.create(td)
    unzip(loc, exdir=td)
    SpatialData::readSpatialData(dir(td, full.names=TRUE))
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

#' @rdname MouseIntestineVisHD
#' @export
MouseIntestineVisHD <- function(target=tempfile()) { 
    .get_demo_SD("visium_hd_3.0.0", target=target)
}

#' @rdname MouseIntestineVisHD
#' @export
LungAdenocarcinomaMCMICRO <- function(target=tempfile()) {
    .get_demo_SD("mcmicro_io", target=target)
}

#' @rdname MouseIntestineVisHD
#' @export
MouseBrainMERFISH = function(target=tempfile()) {
    .get_demo_SD("merfish", target=target)
}

#' @rdname MouseIntestineVisHD
#' @export
MulticancerSteinbock <- function(target=tempfile()) {
    .get_demo_SD("steinbock_io", target=target)
}

#' @rdname MouseIntestineVisHD
#' @export
ColorectalCarcinomaMIBITOF <- function(target=tempfile()) {
    .get_demo_SD("mibitof", target=target)
}

#' @rdname MouseIntestineVisHD
#' @export
JanesickBreastVisiumEnh <- function(target=tempfile()) {
    .get_demo_SD("visium_associated_xenium_io", target=target)
}

#' @rdname MouseIntestineVisHD
#' @export
JanesickBreastXeniumRep1 <- function(target=tempfile()) {
    .get_demo_SD("xenium_rep1_io", target=target)
}

#' @rdname MouseIntestineVisHD
#' @export
JanesickBreastXeniumRep2 <- function(target=tempfile()) {
    .get_demo_SD("xenium_rep2_io", target=target)
}

#' @rdname MouseIntestineVisHD
#' @export
Breast2fov_10x <- function(target=tempfile()) {
    .get_demo_SD("human_Breast_2fov", target=target)
}

#' @rdname MouseIntestineVisHD
#' @export
Lung2fov_10x <- function(target=tempfile()) {
    .get_demo_SD("human_Lung_2fov", target=target)
}

#' @rdname MouseIntestineVisHD
#' @export
HumanLungMulti_10x <- function(target=tempfile()) {
    .get_demo_SD("HuLungXenmulti", target=target)
}
