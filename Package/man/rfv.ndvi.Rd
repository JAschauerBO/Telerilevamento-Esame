\name{rfv.ndvi}
\alias{rfv.ndvi}
\title{Compute NDVI rasters}
\description{Compute NDVI rasters from imported TIFF stacks and optionally save or assign the results.}
\usage{
rfv.ndvi(imported_tiffs = NULL, raw_data_dir = "WD/Raw Data", output_dir = "WD", red_layer = 3, nir_layer = 4, save_rds = TRUE, assign_to_global = FALSE)
}
\arguments{
  \item{imported_tiffs}{A list as returned by \code{rfv.import_tiff()}, or \code{NULL} to import from disk.}
  \item{raw_data_dir}{Path to the raw data folder used when importing internally.}
  \item{output_dir}{Directory where \code{ndvi_all.rds} is written.}
  \item{red_layer}{Layer index for the red band.}
  \item{nir_layer}{Layer index for the near-infrared band.}
  \item{save_rds}{Logical; if TRUE, save the NDVI list to \code{ndvi_all.rds}.}
  \item{assign_to_global}{Logical; if TRUE, assign outputs to the global environment.}
}
\value{
A named list of \code{SpatRaster} NDVI rasters.
}
\examples{
\dontrun{
rfv.ndvi()
}
}