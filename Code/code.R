# install_github("ducciorocchini/imageRy")
library(imageRy)
# install.packages("terra")
library(terra)

# set working directory to the correct folder:
setwd("C:/Users/jakob/Uni/Erasmus/Telerilevamento/Esame")

# Import of raw tiffs:
source("Code/import_raw_tiffs.R")

# Import of ROI:
source("Code/import_roi.R")

# NDVI calculation for all dates:
source("Code/ndvi_all.R")

# Crop NDVI rasters to ROI for all dates:
source("Code/ndvi_crop.R")

# Plot NDVI values for all dates:
source("Code/plot_ndvi_df.R")