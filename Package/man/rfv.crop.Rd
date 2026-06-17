\name{rfv.crop}
\alias{rfv.crop}
\title{Crop NDVI rasters to the ROI}
\description{Crop NDVI rasters to the region of interest, extract non-NA values, and build summary structures.}
\usage{
rfv.crop(ndvi_list = NULL, roi = NULL, output_dir = "WD", save_rds = TRUE, assign_to_global = FALSE)
}
\arguments{
  \item{ndvi_list}{Named list of \code{SpatRaster} NDVI rasters, or \code{NULL} to read \code{ndvi_all.rds}.}
  \item{roi}{ROI \code{SpatVector}, or \code{NULL} to read \code{roi.rds} or import the ROI.}
  \item{output_dir}{Directory used for reading and writing WD files.}
  \item{save_rds}{Logical; if TRUE, save the output RDS files.}
  \item{assign_to_global}{Logical; if TRUE, assign output objects to the global environment.}
}
\value{
A list with \code{roi_ndvi_list}, \code{v_ndvi_list}, and \code{v_ndvi_df}.
}
\examples{
\dontrun{
rfv.crop()
}
}