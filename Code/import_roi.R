# import_roi.R - script to import ROI from geojson file

# set working directory to the correct folder:
setwd("../WD")
# Check if roi.geojson exists:
if (!file.exists("roi.geojson")) stop("roi.geojson not found")

# Load necessary library:
library(terra)

# Load ROI from geojson file and save as RDS:
roi <- vect("roi.geojson")
saveRDS(roi, "roi.rds")
# Assign ROI to global environment for use in other scripts:
assign("roi", roi, envir = .GlobalEnv)
# Success message:
message("ROI loaded and saved in roi.rds")

# reset working directory to main folder:
setwd("../")
