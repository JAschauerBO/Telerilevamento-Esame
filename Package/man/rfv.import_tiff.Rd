\name{rfv.import_tiff}
\alias{rfv.import_tiff}
\title{Import TIFF files from raw data folders}
\description{Import per-date TIFF bands from the raw data folder structure and return a named list with band rasters and a stacked raster per folder.}
\usage{
rfv.import_tiff(raw_data_dir = "WD/Raw Data", assign_to_global = FALSE, band_order = c("B04", "B03", "B02", "B08"))
}
\arguments{
  \item{raw_data_dir}{Path to the raw data base folder.}
  \item{assign_to_global}{Logical; if TRUE, assign imported rasters to the global environment.}
  \item{band_order}{Preferred band order for stacking.}
}
\value{
A named list of imported tiles. Each element contains \code{bands} (a named list of \code{SpatRaster} objects) and \code{stack} (a \code{SpatRaster}).
}
\examples{
\dontrun{
rfv.import_tiff()
}
}