\name{rfv.plot_map}
\alias{rfv.plot_map}
\title{Plot NDVI rasters in a multi-panel layout}
\description{Draw multiple NDVI rasters as a grid of maps and optionally overlay the ROI boundary.}
\usage{
rfv.plot_map(ndvi_list = NULL, data_path = "WD/ndvi_all.rds", series = NULL, roi = NULL, output_dir = "WD", ncol = 3, nrow = NULL, main = NULL, labels = NULL, col_palette = grDevices::colorRampPalette(c("saddlebrown", "white", "forestgreen"))(100), zlim = NULL, add_roi_border = TRUE, save_plot = NULL, width = 10, height = 7, res = 150)
}
\arguments{
  \item{ndvi_list}{Named list of \code{SpatRaster} objects, or \code{NULL} to read \code{ndvi_all.rds}.}
  \item{data_path}{Path to \code{ndvi_all.rds} when \code{ndvi_list} is \code{NULL}.}
  \item{series}{Character vector of series names to plot.}
  \item{roi}{ROI \code{SpatVector}, or \code{NULL} to read \code{roi.rds}.}
  \item{output_dir}{Directory used for reading and writing files.}
  \item{ncol}{Number of columns in the plot grid.}
  \item{nrow}{Number of rows in the plot grid.}
  \item{main}{Overall main title.}
  \item{labels}{Optional vector of panel labels.}
  \item{col_palette}{Color vector or palette function.}
  \item{zlim}{Numeric vector of length 2 with raster scale limits.}
  \item{add_roi_border}{Logical; if TRUE, overlay the ROI border.}
  \item{save_plot}{Optional filename for saving the plot.}
  \item{width}{Width in inches when saving.}
  \item{height}{Height in inches when saving.}
  \item{res}{Resolution in DPI when saving.}
}
\value{
An invisible list with \code{series} and \code{saved}.
}
\examples{
\dontrun{
rfv.plot_map()
}
}