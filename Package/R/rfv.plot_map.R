##' Plot NDVI rasters as small maps in a multi-frame layout
##'
##' Convenience function to plot multiple NDVI rasters in a grid. Optionally overlay ROI boundary and save to file.
##' @param ndvi_list named list of `SpatRaster` objects (or NULL to read `WD/ndvi_all.rds`)
##' @param data_path path to read `ndvi_all.rds` when `ndvi_list` is NULL
##' @param series character vector of series names to plot
##' @param roi SpatVector ROI or NULL to read `WD/roi.rds`
##' @param output_dir folder used for reading/writing
##' @param ncol number of columns in the plot grid
##' @param nrow number of rows (calculated if NULL)
##' @param main overall main title (optional)
##' @param labels optional vector of labels for each panel
##' @param col_palette color vector or palette function
##' @param zlim numeric(2) z-scale limits for raster plots
##' @param add_roi_border logical; overlay ROI border when TRUE
##' @param save_plot filename to save to (optional)
##' @param width width in inches for saved plot
##' @param height height in inches for saved plot
##' @param res resolution (DPI) for saved PNG
##' @return list with `series` and `saved` flag (invisible)
##' @export
rfv.plot_map <- function(ndvi_list = NULL,
                         data_path = "WD/ndvi_all.rds",
                         series = NULL,
                         roi = NULL,
                         output_dir = "WD",
                         ncol = 3,
                         nrow = NULL,
                         main = NULL,
                         labels = NULL,
                         col_palette = grDevices::colorRampPalette(c("saddlebrown", "white", "forestgreen"))(100),
                         zlim = NULL,
                         add_roi_border = TRUE,
                         save_plot = NULL,
                         width = 10,
                         height = 7,
                         res = 150) {
  if (is.null(ndvi_list)) {
    if (!file.exists(data_path)) stop("Data not found: ", data_path, call. = FALSE)
    ndvi_list <- readRDS(data_path)
  }

  if (is.null(series)) series <- names(ndvi_list)
  if (is.null(series)) stop("No series provided and ndvi_list has no names", call. = FALSE)

  missing_cols <- setdiff(series, names(ndvi_list))
  if (length(missing_cols) > 0) stop("Requested series not found: ", paste(missing_cols, collapse = ", "), call. = FALSE)

  plots <- lapply(series, function(s) ndvi_list[[s]])
  nplots <- length(plots)
  if (is.null(nrow)) nrow <- ceiling(nplots / ncol)

  if (is.null(zlim)) {
    global_min <- min(sapply(plots, function(r) min(terra::values(r), na.rm = TRUE)))
    global_max <- max(sapply(plots, function(r) max(terra::values(r), na.rm = TRUE)))
    zlim <- c(global_min, global_max)
  }

  if (is.null(roi)) {
    roi_path <- file.path(output_dir, "roi.rds")
    if (file.exists(roi_path)) roi <- readRDS(roi_path)
  }

  if (!is.null(save_plot)) {
    png(filename = save_plot, width = width, height = height, units = "in", res = res)
    on.exit(dev.off(), add = TRUE)
  }

  old_par <- par(no.readonly = TRUE)
  on.exit(par(old_par), add = TRUE)
  par(mfrow = c(nrow, ncol), mar = c(2, 2, 2, 2))

  for (i in seq_along(plots)) {
    r <- plots[[i]]
    lbl <- if (!is.null(labels) && length(labels) >= i) labels[[i]] else series[[i]]

    if (!inherits(r, "SpatRaster")) {
      plot.new(); title(main = paste(lbl, "(not a raster)")); next
    }

    terra::plot(r, col = col_palette, main = lbl, zlim = zlim)

    if (add_roi_border && !is.null(roi) && inherits(roi, "SpatVector")) {
      terra::plot(roi, add = TRUE, border = "red", lwd = 2)
    }
  }

  if (!is.null(main)) mtext(main, outer = TRUE, cex = 1.2, line = -1)

  invisible(list(series = series, saved = !is.null(save_plot)))
}
