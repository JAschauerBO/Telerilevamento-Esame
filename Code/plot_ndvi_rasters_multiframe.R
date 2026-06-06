library(terra)

source("Code/import_raw_tiffs.R")
source("Code/import_roi.R")
source("Code/ndvi_all.R")
source("Code/ndvi_crop.R")

if (!exists("roi_ndvi_list") || !is.list(roi_ndvi_list) || length(roi_ndvi_list) == 0) {
  stop("roi_ndvi_list is not available")
}

roi_ndvi_list <- roi_ndvi_list[order(names(roi_ndvi_list))]

panel_count <- length(roi_ndvi_list)
n_cols <- 3
n_rows <- 4

ndvi_colors <- colorRampPalette(c("#4a2c16", "#9c6b3a", "#d9f0d3", "#31a354"))(100)
ndvi_breaks <- seq(-1, 1, length.out = length(ndvi_colors) + 1)
ndvi_limits <- c(-1, 1)

png("Images/ndvi_rasters_multiframe.png", width = 1800, height = 1500, res = 200)
par(mfrow = c(n_rows, n_cols), mar = c(0.05, 0.05, 0.85, 0.05), oma = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")

for (i in seq_along(roi_ndvi_list)) {
  raster_obj <- roi_ndvi_list[[i]]
  raster_name <- names(roi_ndvi_list)[i]
  date_code <- sub("^roi_ndvi", "", raster_name)
  date_label <- format(as.Date(paste0(date_code, "01"), format = "%Y%m%d"), "%Y-%m")

  plot(raster_obj,
       col = ndvi_colors,
      breaks = ndvi_breaks,
      zlim = ndvi_limits,
     legend = FALSE,
       axes = FALSE,
       box = FALSE,
      main = date_label,
      cex.main = 0.85)
  plot(roi, add = TRUE, border = "black", lwd = 1.2)
}

# Bottom-right legend panel
par(mar = c(1.4, 0.6, 0.8, 3.2), xpd = NA)
plot.new()
plot.window(xlim = c(0, 1), ylim = ndvi_limits, xaxs = "i", yaxs = "i")

y_breaks <- seq(ndvi_limits[1], ndvi_limits[2], length.out = length(ndvi_colors) + 1)
for (i in seq_along(ndvi_colors)) {
  rect(0.12, y_breaks[i], 0.42, y_breaks[i + 1], col = ndvi_colors[i], border = NA)
}
axis(4, at = pretty(ndvi_limits, n = 5), las = 1, cex.axis = 0.8)
mtext("NDVI", side = 4, line = 1.8, cex = 0.9, font = 2)
box()

dev.off()
message("Multi-frame NDVI raster plot saved to Images/ndvi_rasters_multiframe.png")
