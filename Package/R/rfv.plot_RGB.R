rfv.plot_RGB <- function(rast, r = 1, g = 2, b = 3) {
    library(imageRy)
    imageRy::im.plotRGB(rast, r = r, g = g, b = b)
}