#' all logic for finding, caching, loading an OSN-based dataset, hidden
#' 
#' @importFrom spatialdataR readSpatialData
#' @importClassesFrom spatialdataR SpatialData
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
.get_demo_SDdata_old <- function(
    patt, 
    cache=BiocFileCache::BiocFileCache(),
    target=tempfile(),
    source = osn_path()
) {
  # Bioconductor's OSN bucket
  buckprefix <- "https://mghp.osn.xsede.org/bir190004-bucket01"
  
  # work on zipped Zarr archives from scverse SpatialData datasets page
  # sdurls <- paste(buckprefix, "BiocSpatialData", .SD_ZIPS, sep="/")
  sdurls <- file.path(buckprefix, "BiocSpatialData", .SD_ZIPS)
  
  # also work on zipped Xenium minimal outputs, retrieved and zipped in OSN
  # these must be expanded and processed with use_sdio
  # xdurls <- paste(buckprefix, "BiocXenDemo", .SD_Xenium_ZIPS, sep="/")
  xdurls <- file.path(buckprefix, "BiocXenDemo", .SD_Xenium_ZIPS)
  
  # collect names of all zip files  
  # build a tibble with all relevant information
  allz <- c(.SD_ZIPS, .SD_Xenium_ZIPS)
  allurls <- c(sdurls, xdurls)
  
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
    
    # check hits in main xenium list
    chkxen <- grep(patt, .SD_Xenium_ZIPS)
    
    # multiple pattern hits in main xenium list
    if (length(chkxen) > 1) 
      .pattern_not_unique(patt)
    
    # no pattern hits in main list
    if (length(chkxen) == 0) {  # add a zipped zarr
      
      # check main list
      zipind = grep(patt, .SD_ZIPS)  # already ruled out xenium group, must be from spatialdata archive
      
      # no hits in main list
      if (length(zipind) == 0) 
        .pattern_not_found(patt)
      
      # get zipped (zarr?)
      zipname <- .SD_ZIPS[zipind]
      message(sprintf("caching %s", zipname))
      fpath <- sdurls[zipind]
      loc <- BiocFileCache::bfcadd(cache, rname=zipname, fpath=fpath, rtype="web")
      
      # unzip and read with SpatialData(R)
      dir.create(td <- target)
      unzip(loc, exdir=td)
      return(dir(td, full.names=TRUE))
    } # end zipped zarr, now retrieve Xenium, and run use_sdio
    
    # get zipped Xenium readouts
    zipname <- .SD_Xenium_ZIPS[chkxen]
    message(sprintf("caching %s", zipname))
    fpath <- xdurls[chkxen]
    preloc <- BiocFileCache::bfcadd(cache, rname=zipname, fpath=fpath, rtype="web")
    
    # unzip, convert to sd zarr with spatialdata-io
    dir.create(td <- tempfile()) # can't use target'
    unzip(preloc, exdir=td)  # manufacturer output
    if (dir.exists(target)) print("target exists")
    use_sdio("xenium", srcdir=td, dest=target) # zarr in target
    return(target)
  }
  
  # a single pattern hit in cache
  if (chkdf[ind,]$rname %in% .SD_Xenium_ZIPS) { # it is a Xenium 10x output resource
    
    # check if update needed
    stale <- BiocFileCache::bfcneedsupdate(cache, chkdf[ind,]$rid)
    if (stale) 
      BiocFileCache::bfcupdate(cache, chkdf[ind,]$rid, fpath=chkdf[ind,]$fpath, rtype="web")
    
    # get location, unzip, convert to sd zarr with spatialdata-io and 
    # read with SpatialData
    preloc <- chkdf[ind,]$rpath
    dir.create(td <- tempfile()) # can't use target
    unzip(preloc, exdir=td)  # manufacturer output
    use_sdio("xenium", srcdir=td, dest=target) # zarr in target
    return(target)
  }
  
  stale = BiocFileCache::bfcneedsupdate(cache, chkdf[ind,]$rid)
  if (stale) 
    BiocFileCache::bfcupdate(cache, chkdf[ind,]$rid, fpath=chkdf[ind,]$fpath, rtype="web")
  loc <- chkdf[ind,]$rpath
  td <- target
  dir.create(td)
  unzip(loc, exdir=td)
  dir(td, full.names=TRUE)
}

#' provide path to a zip file from 10x genomics for Xenium platform
#' 
#' @param cache cache location BiocFileCache::BiocFileCache()
#' @param zipname character(1) name of zip archive to find
#' @param source source name
#' 
#' @examples
#' Sys.setenv(AWS_REGION = "us-east-1")
#' SpatialData.data:::.path_to_10x_xen_demo()
#' # see ?use_sdio
.path_to_10x_xen_demo <- function(
    cache=BiocFileCache::BiocFileCache(),
    zipname="Xenium_V1_human_Breast_2fov_outs.zip", 
    source = biocOSN_Xenium) {
  info <- BiocFileCache::bfcquery(cache, zipname)
  nrec <- nrow(info)
  if (nrec > 1) {
    message(sprintf("multiple %s found in cache, using last recorded", zipname))
  }
  if (nrec == 1) {
    message("returning path to cached zip")
    return(info$rpath[nrec])
  }
  fp <- file.path(bucket_path(source), zipname)
  message(sprintf("retrieving from %s, caching, and returning path", 
                  bucket_path(source)))
  BiocFileCache::bfcadd(cache, rname=zipname, fpath=fp, rtype="web")
}

#' @title retrieve scverse-curated `SpatialData` .zarr archive
#' @rdname SpatialData-data2
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
#' Sys.setenv(AWS_REGION = "us-east-1")
#' 
#' # load using `load_data`
#' ld <- load_data("ColorectalCarcinomaMIBITOF")
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