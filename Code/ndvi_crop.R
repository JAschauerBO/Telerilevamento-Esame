# This script crops the NDVI rasters to the ROI, extracts the values,
# and saves both the cropped rasters and the value vectors for all dates.

# sets working directory
setwd("./WD")

# check if ndvi rasters exist:
if (length(ndvi_names) == 0) stop("No ndviYYYYMM raster objects found")

# make names for cropped rasters and value vectors:
roi_ndvi_names <- sub("^t", "roi_ndvi", tile_names)
roi_ndvi_list <- setNames(vector("list", length(tile_names)), roi_ndvi_names)
v_ndvi_names <- sub("^roi_ndvi", "v_ndvi", roi_ndvi_names)
v_ndvi_list <- setNames(vector("list", length(tile_names)), v_ndvi_names)


# Runs through all ndvi rasters, crops to ROI,
# extracts values, and  saves both the cropped rasters and the value vectors
# to lists and as separate objects in the global environment.
for (i in seq_along(ndvi_names)) {

  # Crop raster to ROI and save to list and global environment
  ndvi_name <- ndvi_names[[i]]
  roi_ndvi_name <- roi_ndvi_names[[i]]
  roi_ndvi_obj <- mask(crop(get(ndvi_name), roi), roi)
  roi_ndvi_list[[roi_ndvi_name]] <- roi_ndvi_obj
  assign(roi_ndvi_name, roi_ndvi_obj, envir = .GlobalEnv)


  # Extract values, remove NA, and save to list and global environment
  v_ndvi_name <- v_ndvi_names[[i]]
  v_ndvi_values <- as.vector(values(roi_ndvi_obj, na.rm = TRUE))
  v_ndvi_list[[v_ndvi_name]] <- v_ndvi_values
  assign(v_ndvi_name, v_ndvi_values, envir = .GlobalEnv)
}

# Saves all to .rds files for later use in plotting and analysis
# and gives success messages for each step.
saveRDS(roi_ndvi_list, "roi_ndvi_all.rds")
message("NDVI rasters cropped for all dates and saved to roi_ndvi_all.rds")
v_ndvi_df <- as.data.frame(v_ndvi_list, check.names = FALSE)
colnames(v_ndvi_df) <- sub("^v_ndvi", "", names(v_ndvi_list))
saveRDS(v_ndvi_list, "v_ndvi_all.rds")
message("NDVI values extracted for all dates and saved to v_ndvi_all.rds")
saveRDS(v_ndvi_df, "v_ndvi_df.rds")
message("NDVI values dataframe saved to v_ndvi_df.rds")

# reset working directory
setwd("../")