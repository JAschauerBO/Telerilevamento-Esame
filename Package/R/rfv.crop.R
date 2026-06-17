##' Crop NDVI rasters to ROI and extract values
##'
##' Crop each NDVI raster to the ROI, extract non-NA values and return lists and a dataframe. Writes `roi_ndvi_all.rds`, `v_ndvi_all.rds`, `v_ndvi_df.rds` when requested. # nolint: line_length_linter.
##' @param ndvi_list named list of `SpatRaster` NDVI rasters (or NULL to read `WD/ndvi_all.rds`) # nolint: line_length_linter.
##' @param roi SpatVector ROI (or NULL to read `WD/roi.rds` / import via `rfv.import_roi()`) # nolint: line_length_linter.
##' @param output_dir directory for reading/writing WD files
##' @param save_rds logical; save output RDS files when TRUE
##' @param assign_to_global logical; if TRUE assign output objects into the global environment # nolint: line_length_linter.
##' @return list with `roi_ndvi_list`, `v_ndvi_list`, `v_ndvi_df`
##' @export
rfv.crop <- function(ndvi_list = NULL, roi = NULL, output_dir = "WD", save_rds = TRUE, assign_to_global = FALSE) {
	if (!dir.exists(output_dir)) {
		stop("The directory does not exist: ", output_dir, call. = FALSE)
	}

	if (is.null(ndvi_list)) {
		ndvi_path <- file.path(output_dir, "ndvi_all.rds")
		if (!file.exists(ndvi_path)) {
			stop("ndvi_all.rds not found in ", output_dir, call. = FALSE)
		}
		ndvi_list <- readRDS(ndvi_path)
	}

	if (is.null(roi)) {
		if (FALSE) rfv.import_roi <- function(...) NULL
		roi <- rfv.import_roi(wd_dir = output_dir, save_rds = FALSE, assign_to_global = FALSE)
	}

	if (length(ndvi_list) == 0) {
		stop("No ndviYYYYMM raster objects found", call. = FALSE)
	}

	ndvi_names <- names(ndvi_list)
	if (is.null(ndvi_names) || any(ndvi_names == "")) {
		ndvi_names <- paste0("ndvi", seq_along(ndvi_list))
	}

	roi_ndvi_names <- sub("^ndvi", "roi_ndvi", ndvi_names)
	v_ndvi_names <- sub("^roi_ndvi", "v_ndvi", roi_ndvi_names)

	roi_ndvi_list <- setNames(vector("list", length(ndvi_list)), roi_ndvi_names)
	v_ndvi_list <- setNames(vector("list", length(ndvi_list)), v_ndvi_names)

	for (i in seq_along(ndvi_list)) {
		ndvi_object <- ndvi_list[[i]]
		if (!inherits(ndvi_object, "SpatRaster")) {
			stop("ndvi_list element at position ", i, " is not a SpatRaster", call. = FALSE)
		}

		roi_ndvi_name <- roi_ndvi_names[[i]]
		roi_for_crop <- if (inherits(roi, "SpatVector")) terra::ext(roi) else roi
		roi_ndvi_obj <- terra::crop(ndvi_object, roi_for_crop)
		if (inherits(roi, "SpatVector")) {
			roi_ndvi_obj <- terra::mask(roi_ndvi_obj, roi)
		}
		roi_ndvi_list[[roi_ndvi_name]] <- roi_ndvi_obj

		if (isTRUE(assign_to_global)) {
			assign(roi_ndvi_name, roi_ndvi_obj, envir = .GlobalEnv)
		}

		v_ndvi_name <- v_ndvi_names[[i]]
		v_ndvi_values <- as.vector(terra::values(roi_ndvi_obj))
		v_ndvi_values <- v_ndvi_values[!is.na(v_ndvi_values)]
		v_ndvi_list[[v_ndvi_name]] <- v_ndvi_values

		if (isTRUE(assign_to_global)) {
			assign(v_ndvi_name, v_ndvi_values, envir = .GlobalEnv)
		}
	}

	v_ndvi_df <- as.data.frame(v_ndvi_list, check.names = FALSE)
	colnames(v_ndvi_df) <- sub("^v_ndvi", "", names(v_ndvi_list))

	if (isTRUE(save_rds)) {
		saveRDS(roi_ndvi_list, file.path(output_dir, "roi_ndvi_all.rds"))
		saveRDS(v_ndvi_list, file.path(output_dir, "v_ndvi_all.rds"))
		saveRDS(v_ndvi_df, file.path(output_dir, "v_ndvi_df.rds"))
	}

	list(
		roi_ndvi_list = roi_ndvi_list,
		v_ndvi_list = v_ndvi_list,
		v_ndvi_df = v_ndvi_df
	)
}
