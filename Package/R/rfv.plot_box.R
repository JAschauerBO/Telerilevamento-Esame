##' Boxplot of NDVI distributions per date
##'
##' Create boxplots from the `v_ndvi_df` structure. Returns a ggplot object invisibly and can save to file.
##' @param v_ndvi_df data.frame with NDVI value vectors as columns (or NULL to read `WD/v_ndvi_df.rds`)
##' @param data_path path to `v_ndvi_df.rds` when `v_ndvi_df` is NULL
##' @param series character vector of column names to plot
##' @param ylim numeric(2) y-axis limits
##' @param xlab x-axis label
##' @param ylab y-axis label
##' @param title main title
##' @param notch logical for boxplot notch
##' @param show_points logical show individual points
##' @param point_size numeric point size for points
##' @param palette character or NULL fill palette name
##' @param save_plot filename to save plot (optional)
##' @return ggplot object (invisible)
##' @export
rfv.plot_box <- function(v_ndvi_df = NULL,
												data_path = "WD/v_ndvi_df.rds",
												series = NULL,
							    				ylim = c(0,0.6),
												xlab = "Date",
												ylab = "NDVI",
												title = NULL,
												notch = FALSE,
												show_points = FALSE,
												point_size = 0.5,
												palette = NULL,
												save_plot = NULL) {
	if (is.null(v_ndvi_df)) {
		if (!file.exists(data_path)) stop("Data not found: ", data_path, call. = FALSE)
		v_ndvi_df <- readRDS(data_path)
	}

	if (!is.data.frame(v_ndvi_df)) stop("v_ndvi_df must be a data.frame or provide a valid data_path", call. = FALSE)

	if (is.null(series)) series <- colnames(v_ndvi_df)
	missing_cols <- setdiff(series, colnames(v_ndvi_df))
	if (length(missing_cols) > 0) stop("Requested series not found: ", paste(missing_cols, collapse = ", "), call. = FALSE)

	df <- v_ndvi_df[, series, drop = FALSE]
	long <- stack(df)
	names(long) <- c("value", "variable")
	long$variable <- factor(long$variable, levels = series)

	if (!requireNamespace("ggplot2", quietly = TRUE)) stop("ggplot2 required for plotting. Please install it.", call. = FALSE)

	p <- ggplot2::ggplot(long, ggplot2::aes(x = variable, y = value)) +
		ggplot2::geom_boxplot(notch = notch, outlier.shape = NA)

	if (isTRUE(show_points)) {
		p <- p + ggplot2::geom_jitter(width = 0.2, size = point_size, alpha = 0.6)
	}

	if (!is.null(palette) && requireNamespace("RColorBrewer", quietly = TRUE)) {
		p <- p + ggplot2::scale_fill_brewer(palette = palette)
	}

	p <- p + ggplot2::labs(x = xlab, y = ylab, title = title)

	if (!is.null(ylim)) p <- p + ggplot2::coord_cartesian(ylim = ylim)

	if (!is.null(save_plot)) {
		ggplot2::ggsave(filename = save_plot, plot = p, width = 8, height = 5)
	}

	invisible(p)
}

