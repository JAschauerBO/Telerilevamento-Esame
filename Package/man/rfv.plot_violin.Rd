\name{rfv.plot_violin}
\alias{rfv.plot_violin}
\title{Plot NDVI violins}
\description{Create violin plots from the NDVI value data frame and optionally save the figure.}
\usage{
rfv.plot_violin(v_ndvi_df = NULL, data_path = "WD/v_ndvi_df.rds", series = NULL, ylim = NULL, xlab = "Date", ylab = "NDVI", title = NULL, scale = "width", show_points = FALSE, point_size = 0.5, palette = "viridis", save_plot = NULL)
}
\arguments{
  \item{v_ndvi_df}{Data frame with NDVI value vectors as columns, or \code{NULL} to read \code{v_ndvi_df.rds}.}
  \item{data_path}{Path to \code{v_ndvi_df.rds} when \code{v_ndvi_df} is \code{NULL}.}
  \item{series}{Character vector of column names to plot.}
  \item{ylim}{Optional y-axis limits.}
  \item{xlab}{X-axis label.}
  \item{ylab}{Y-axis label.}
  \item{title}{Main title.}
  \item{scale}{Violin scale; one of \code{"area"}, \code{"count"}, or \code{"width"}.}
  \item{show_points}{Logical; if TRUE, overlay jittered points.}
  \item{point_size}{Point size for jittered points.}
  \item{palette}{Fill palette; defaults to \code{"viridis"}.}
  \item{save_plot}{Optional filename for saving the plot.}
}
\value{
An invisible \code{ggplot} object.
}
\examples{
\dontrun{
rfv.plot_violin()
}
}