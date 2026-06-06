##' Import region of interest (ROI)
##'
##' Read `roi.geojson` (default location: `WD/`) and return a `SpatVector`. Optionally save `roi.rds` and assign to global environment.
##' @param wd_dir working directory where `roi.geojson` is located (default: "WD")
##' @param geojson_file filename of the geojson (default: "roi.geojson")
##' @param save_rds logical; save `roi.rds` when TRUE
##' @param assign_to_global logical; if TRUE assign `roi` into the global environment
##' @return SpatVector with the ROI
##' @export
rfv.import_roi <- function(wd_dir = "WD", geojson_file = "roi.geojson", save_rds = TRUE, assign_to_global = FALSE) {
	roi_path <- file.path(wd_dir, geojson_file)

	if (!file.exists(roi_path)) {
		stop(geojson_file, " not found in ", wd_dir, call. = FALSE)
	}

	roi <- terra::vect(roi_path)

	if (isTRUE(save_rds)) {
		saveRDS(roi, file.path(wd_dir, "roi.rds"))
	}

	if (isTRUE(assign_to_global)) {
		assign("roi", roi, envir = .GlobalEnv)
	}

	roi
}
