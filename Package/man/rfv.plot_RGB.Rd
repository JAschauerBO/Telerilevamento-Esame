\name{rfv.plot_RGB}
\alias{rfv.plot_RGB}
\title{Plot an RGB raster}
\description{Plot a raster as an RGB image using \code{imageRy}.}
\usage{
rfv.plot_RGB(rast, r = 1, g = 2, b = 3)
}
\arguments{
  \item{rast}{Raster object to plot.}
  \item{r}{Layer index for the red channel.}
  \item{g}{Layer index for the green channel.}
  \item{b}{Layer index for the blue channel.}
}
\value{
The function is called for its plotting side effect.
}
\examples{
\dontrun{
rfv.plot_RGB(rast)
}
}