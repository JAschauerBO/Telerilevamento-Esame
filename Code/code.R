# install_github("ducciorocchini/imageRy")
library(imageRy)
# install.packages("terra")
library(terra)

setwd("C:/Users/jakob/Uni/Erasmus/Telerilevamento/Esame")

# Import of raw tiffs:
source("Code/import_raw_tiffs.R")

# Import of ROI:
source("Code/import_roi.R")

# NDVI calculation for all dates:
source("Code/ndvi_all.R")
