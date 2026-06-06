library(terra)

source("Code/import_raw_tiffs.R")
source("Code/import_roi.R")

if (!exists("roi") || !inherits(roi, "SpatVector")) {
  stop("roi is not available")
}

if (!exists("tile_names") || length(tile_names) == 0) {
  tile_names <- sort(ls(pattern = "^t[0-9]{6}$"))
}

if (length(tile_names) == 0) {
  stop("No tYYYYMM raster objects found")
}

plot_band_multiframe <- function(band_index, band_label, output_file) {
  band_names <- paste0(band_label, "_", sub("^t", "", tile_names))
  band_list <- setNames(vector("list", length(tile_names)), band_names)
  band_ranges <- matrix(NA_real_, nrow = length(tile_names), ncol = 2)

  for (i in seq_along(tile_names)) {
    tile_name <- tile_names[[i]]
    band_name <- band_names[[i]]
    band_obj <- mask(crop(get(tile_name)[[band_index]], roi), roi)
    band_list[[band_name]] <- band_obj
    assign(band_name, band_obj, envir = .GlobalEnv)
    band_values <- values(band_obj, na.rm = TRUE)
    band_ranges[i, ] <- range(band_values, na.rm = TRUE)
  }

  band_list <- band_list[order(names(band_list))]
  band_limits <- range(band_ranges, na.rm = TRUE)
  band_colors <- colorRampPalette(c("#f7fbff", "#6baed6", "#08306b"))(100)
  band_breaks <- seq(band_limits[1], band_limits[2], length.out = length(band_colors) + 1)

  panel_count <- length(band_list)
  n_cols <- 5
  n_rows <- ceiling(panel_count / n_cols)

  png(output_file, width = 2400, height = 960, res = 200)
  par(mfrow = c(n_rows, n_cols), mar = c(1, 1, 2.5, 1), oma = c(0, 0, 0, 0))

  for (i in seq_along(band_list)) {
    raster_obj <- band_list[[i]]
    raster_name <- names(band_list)[i]
    date_code <- sub(paste0("^", band_label, "_"), "", raster_name)
    date_label <- format(as.Date(paste0(date_code, "01"), format = "%Y%m%d"), "%Y-%m")

    plot(
      raster_obj,
      col = band_colors,
      breaks = band_breaks,
      zlim = band_limits,
      legend = FALSE,
      axes = FALSE,
      box = FALSE,
      main = date_label
    )
    plot(roi, add = TRUE, border = "black", lwd = 1.2)
  }

  if (panel_count < n_rows * n_cols) {
    for (j in seq_len(n_rows * n_cols - panel_count)) {
      plot.new()
    }
  }

  dev.off()
  message("Multi-frame ", band_label, " raster plot saved to ", output_file)
}

plot_band_multiframe(1, "b04", "Images/b04_rasters_multiframe.png")
plot_band_multiframe(4, "b08", "Images/b08_rasters_multiframe.png")
