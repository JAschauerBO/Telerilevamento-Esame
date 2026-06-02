library(terra)

# Load ROI via separate script (creates roi.rds and assigns `roi`)
#if (file.exists("import_roi.R")) {
#source("import_roi.R")
#}

# Set working directory to the folder containing the raw tiff files:
setwd("../WD/Raw Data")

# Get list of subdirectories:
dirs <- list.dirs(".", recursive = FALSE, full.names = TRUE) 

for (dir in dirs) { # Loop through each subdirectory

  # Get list of tiff files in subdirectory:
  dir_files <- list.files(dir, recursive = FALSE, full.names = TRUE, pattern = "\\.tiff$", ignore.case = TRUE) 

  for (file in dir_files) { # Loop through each tiff file in subdirectory

    # Get folder name and remove dashes:
    folder_name <- gsub("-", "", basename(dir))
    # Get band name by removing file extension:
    band_name <- tools::file_path_sans_ext(basename(file))
    # Create variable name based on folder and band names:
    var_name <- paste0("t", folder_name, "_", band_name)

    # Assign the raster object to a variable with the correct name:
    assign(var_name, rast(file), envir = .GlobalEnv)
  }

  # Create variable name for the multi-layer raster object:
  var_name2 <- paste0("t", folder_name)
  # Create a multi-layer raster object with R, G, B and NIR bands in the correct order (B04, B03, B02, B08)
  assign(var_name2, c(get(paste0("t", folder_name, "_B04")), get(paste0("t", folder_name, "_B03")), get(paste0("t", folder_name, "_B02")), get(paste0("t", folder_name, "_B08"))), envir = .GlobalEnv)
}

# reset working directory to main folder:
setwd("../")