##' Compute NDVI rasters from imported TIFF stacks
##'
##' Generate NDVI rasters for all imported tiles. Returns a named list of `SpatRaster` objects and optionally writes `ndvi_all.rds`.
##' @param imported_tiffs list as returned by `rfv.import_tiff()` or NULL to import from disk
##' @param raw_data_dir path to raw data (used when importing inside the function)
##' @param output_dir directory where `ndvi_all.rds` will be written
##' @param red_layer integer index for red band (default 3)
##' @param nir_layer integer index for NIR band (default 4)
##' @param save_rds logical; save `ndvi_all.rds` when TRUE
##' @param assign_to_global logical; if TRUE assign outputs to the global environment
##' @return named list of `SpatRaster` NDVI rasters
##' @export
rfv.ndvi <- function(imported_tiffs = NULL, raw_data_dir = "WD/Raw Data", output_dir = "WD", red_layer = 3, nir_layer = 4, save_rds = TRUE, assign_to_global = FALSE) {
	if (is.null(imported_tiffs)) {
		if (FALSE) rfv.import_tiff <- function(...) NULL
		imported_tiffs <- rfv.import_tiff(raw_data_dir = raw_data_dir, assign_to_global = assign_to_global)
	}

	if (length(imported_tiffs) == 0) {
		stop("No imported raster objects found", call. = FALSE)
	}

	if (!dir.exists(output_dir)) {
		stop("The directory does not exist: ", output_dir, call. = FALSE)
	}

	tile_names <- names(imported_tiffs)
	if (is.null(tile_names) || any(tile_names == "")) {
		tile_names <- paste0("tile", seq_along(imported_tiffs))
	}

	ndvi_names <- ifelse(startsWith(tile_names, "t"), sub("^t", "ndvi", tile_names), paste0("ndvi", tile_names))
	ndvi_list <- setNames(vector("list", length(imported_tiffs)), ndvi_names)

	for (i in seq_along(imported_tiffs)) {
		tile_object <- imported_tiffs[[i]]

		tile_raster <- if (inherits(tile_object, "SpatRaster")) {
			tile_object
		} else if (is.list(tile_object) && !is.null(tile_object$stack)) {
			tile_object$stack
		} else {
			stop("Unsupported imported_tiffs element at position ", i, call. = FALSE)
		}

		ndvi_object <- (tile_raster[[nir_layer]] - tile_raster[[red_layer]]) / (tile_raster[[nir_layer]] + tile_raster[[red_layer]])
		ndvi_name <- ndvi_names[[i]]
		ndvi_list[[ndvi_name]] <- ndvi_object

		if (isTRUE(assign_to_global)) {
			assign(ndvi_name, ndvi_object, envir = .GlobalEnv)
		}
	}

	if (isTRUE(save_rds)) {
		saveRDS(ndvi_list, file.path(output_dir, "ndvi_all.rds"))
	}

	ndvi_list
}
