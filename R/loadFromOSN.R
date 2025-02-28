#' use a string to identify a resource in SpatialData format and
#' ingest via SpatialData::readSpatialData
#' @param stub character(1) a string that identifies a resource
#' @return an instance of SpatialData, or NULL if the stub does not
#' uniquely match (using grep()) the name of any resource
#' @examples
#' lu = loadFromOSN("Lung2")
#' lu
#' @export
loadFromOSN = function(stub) { 
  opts = ls("package:SpatialData.data")
  hit = grep(stub, opts, value=TRUE)
  if (!is.na(hit[1]) && length(hit)==1L) return(get(hit)())
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

