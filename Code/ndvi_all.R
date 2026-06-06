library(imageRy)

# set working directory to the correct folder:
setwd("./Code")

# Load the already imported raster objects tYYYYMM
# source("import_raw_tiffs.R")

# set working directory to the correct folder:
setwd("../WD")

tile_names <- sort(ls(pattern = "^t[0-9]{6}$"))
if (length(tile_names) == 0) stop("No tYYYYMM raster objects found")

ndvi_names <- sub("^t", "ndvi", tile_names)
ndvi_list <- setNames(vector("list", length(tile_names)), ndvi_names)

for (i in seq_along(tile_names)) {
  tile_name <- tile_names[[i]]
  ndvi_name <- ndvi_names[[i]]
  ndvi_obj <- im.ndvi(get(tile_name), nir = 4, red = 3)
  ndvi_list[[ndvi_name]] <- ndvi_obj
  assign(ndvi_name, ndvi_obj, envir = .GlobalEnv)
}

saveRDS(ndvi_list, "ndvi_all.rds")
message("NDVI rasters created for all dates and saved to ndvi_all.rds")

setwd("../")