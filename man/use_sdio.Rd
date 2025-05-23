% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sdio.R
\name{use_sdio}
\alias{use_sdio}
\title{Use Python's 'spatialdata-io' to transform manufacturer 
output to .zarr with specific folder structure.}
\usage{
use_sdio(platform = "xenium", srcdir, dest)
}
\arguments{
\item{platform}{character(1) must be an element of `available_sdio()` output}

\item{srcdir}{character(1) path to folder holding manufacturer output files}

\item{dest}{character(1) a path to a desired destination for zarr representation}
}
\description{
Use Python's 'spatialdata-io' to transform manufacturer 
output to .zarr with specific folder structure.
}
\examples{
# unzip flat files
pa <- SpatialData.data:::.path_to_10x_xen_demo()
dir.create(td <- tempfile())
unzip(pa, exdir=td)

# read & write to .zarr w/ 'spatialdata-io'
target <- tempfile()
use_sdio("xenium", srcdir=td, dest=target)

# read into R
(br2fov <- SpatialData::readSpatialData(target))

}
