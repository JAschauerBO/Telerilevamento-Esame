library(terra)


# Set working directory to the folder containing the raw tiff files
setwd("C:/Users/jakob/Uni/Erasmus/Telerilevamento/Esame/Raw Data")
dirs <- list.dirs(".", recursive = FALSE, full.names = TRUE) # Get list of subdirectories

for (dir in dirs) { # Loop through each subdirectory
  dir_files <- list.files(dir, recursive = FALSE, full.names = TRUE, pattern = "\\.tiff$", ignore.case = TRUE) # Get list of tiff files in subdirectory
  for (file in dir_files) { # Loop through each tiff file in subdirectory
    folder_name <- gsub("-", "", basename(dir)) # Get folder name and remove dashes
    band_name <- tools::file_path_sans_ext(basename(file)) # Get band name by removing file extension
    var_name <- paste0("t", folder_name, "_", band_name) # Create variable name based on folder and band names
    assign(var_name, rast(file), envir = .GlobalEnv) # Assign the raster object to a variable with a name based on the folder and band names
  }
var_name2 <- paste0("t", folder_name) # Create variable name for the multi-layer raster object based on the folder name
# Assign the four bands to a list to create a multi-layer raster object with R, G, B and NIR bands in the correct order (B04, B03, B02, B08)
assign(var_name2, c(get(paste0("t", folder_name, "_B04")), get(paste0("t", folder_name, "_B03")), get(paste0("t", folder_name, "_B02")), get(paste0("t", folder_name, "_B08"))), envir = .GlobalEnv)
}
