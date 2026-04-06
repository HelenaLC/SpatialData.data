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