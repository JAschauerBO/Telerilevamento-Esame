\name{rfv.plot_box}
\alias{rfv.plot_box}
\title{Plot NDVI boxplots}
\description{Create boxplots from the NDVI value data frame and optionally save the figure.}
\usage{
rfv.plot_box(v_ndvi_df = NULL, data_path = "WD/v_ndvi_df.rds", series = NULL, ylim = c(0, 0.6), xlab = "Date", ylab = "NDVI", title = NULL, notch = FALSE, show_points = FALSE, point_size = 0.5, palette = NULL, save_plot = NULL)
}
\arguments{
  \item{v_ndvi_df}{Data frame with NDVI value vectors as columns, or \code{NULL} to read \code{v_ndvi_df.rds}.}
  \item{data_path}{Path to \code{v_ndvi_df.rds} when \code{v_ndvi_df} is \code{NULL}.}
  \item{series}{Character vector of column names to plot.}
  \item{ylim}{Numeric vector of length 2 with y-axis limits.}
  \item{xlab}{X-axis label.}
  \item{ylab}{Y-axis label.}
  \item{title}{Main title.}
  \item{notch}{Logical; if TRUE, use notched boxplots.}
  \item{show_points}{Logical; if TRUE, overlay jittered points.}
  \item{point_size}{Point size for jittered points.}
  \item{palette}{Optional fill palette name.}
  \item{save_plot}{Optional filename for saving the plot.}
}
\value{
An invisible \code{ggplot} object.
}
\examples{
\dontrun{
rfv.plot_box()
}
}