\name{rfv.import_roi}
\alias{rfv.import_roi}
\title{Import region of interest}
\description{Read the ROI GeoJSON from the working directory and return it as a \code{SpatVector}.}
\usage{
rfv.import_roi(wd_dir = "WD", geojson_file = "roi.geojson", save_rds = TRUE, assign_to_global = FALSE)
}
\arguments{
  \item{wd_dir}{Working directory containing the ROI file.}
  \item{geojson_file}{Name of the GeoJSON file.}
  \item{save_rds}{Logical; if TRUE, save \code{roi.rds}.}
  \item{assign_to_global}{Logical; if TRUE, assign \code{roi} to the global environment.}
}
\value{
A \code{SpatVector} representing the region of interest.
}
\examples{
\dontrun{
rfv.import_roi()
}
}