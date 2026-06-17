##' Import TIFFs from raw data folders
##'
##' Minimal wrapper to import per-date TIFF bands and return a list with `bands` and `stack` per folder.
##' @param raw_data_dir path to the raw data base folder (default: "WD/Raw Data")
##' @param assign_to_global logical; if TRUE assign objects into the global environment
##' @param band_order preferred band order for stacking
##' @return named list of imported tiles; each element contains `bands` (list) and `stack` (SpatRaster)
##' @export
rfv.import_tiff <- function(raw_data_dir = "WD/Raw Data", assign_to_global = FALSE, band_order = c("B04", "B03", "B02", "B08")) {
	if (!dir.exists(raw_data_dir)) {
		stop("The directory does not exist: ", raw_data_dir, call. = FALSE)
	}

	subdirs <- list.dirs(raw_data_dir, recursive = FALSE, full.names = TRUE)
	imported <- list()

	for (subdir in subdirs) {
		tif_files <- list.files(
			subdir,
			recursive = FALSE,
			full.names = TRUE,
			pattern = "\\.tiff?$",
			ignore.case = TRUE
		)

		if (length(tif_files) == 0) {
			next
		}

		file_names <- tools::file_path_sans_ext(basename(tif_files))
		band_index <- match(file_names, band_order)
		import_order <- order(ifelse(is.na(band_index), length(band_order) + seq_along(file_names), band_index), file_names)
		tif_files <- tif_files[import_order]
		file_names <- file_names[import_order]

		band_rasters <- setNames(lapply(tif_files, terra::rast), file_names)

		folder_name <- gsub("-", "", basename(subdir))
		stack_name <- paste0("t", folder_name)

		imported[[folder_name]] <- list(
			bands = band_rasters,
			stack = terra::rast(tif_files)
		)

		if (isTRUE(assign_to_global)) {
			for (band_name in names(band_rasters)) {
				assign(paste0(stack_name, "_", band_name), band_rasters[[band_name]], envir = .GlobalEnv)
			}
			assign(stack_name, imported[[folder_name]]$stack, envir = .GlobalEnv)
		}
	}

	imported
}
