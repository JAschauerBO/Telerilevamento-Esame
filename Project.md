# Project

## Idea

After a major rockfall there is usually just a deposit of rockfall debris. But there are many fossile rockfalls that are already covered by vegetation.
My goal is to get an idea of how the vegetation is covering the debris.
I'm comparing the NDVI images from the summers of 2018 and 2025.

## Data handling

### Download of raw data

The raw data was downloaded from [Copernicus Data Browser](https://browser.dataspace.copernicus.eu). In addition to visualizing the data, this platform makes it possible to download Sentinel2 data for specific days and regions of interest (ROIs) as geotiff. This format is suitable for further processing.

![Download options for sentinel images](Images/download_options.png)

For every year a day in the summer months August or September has been chosen to compare yearly effects and not the plant's physiology. The days have been chosen to have less than 15% of cloud coverage and ideally, none in the selected ROI. For every downloaded time, the four bands B02 (blue), B03 (green), B04 (red) and B08 (NIR) have been downloaded [click here for more specifications](https://docs.sentinel-hub.com/api/latest/data/sentinel-2-l2a/#available-bands-and-data).

The downloaded data comes in following structure:

```markdown
wd/
├── YYYY-MM1/          # e.g. 2017-07
│   ├── B02.tiff
│   ├── B03.tiff
│   ├── B04.tiff
│   ├── B08.tiff
│
├── YYYY-MM2/          # e.g. 2026-05
│   ├── B02.tiff
│   ├── B03.tiff
│   ├── B04.tiff
│   ├── B08.tiff
│...
```

### Loading the tiff files into R

A small script was used to load the tiffs file into R and to assign the proper variable names. This script uses the package `terra` for its command `rast()`. In addition to the import it also already creates multilayer raster objects from the files.

```r
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
```

The naming syntax is following: `tYYYYMM` for the multilayered raster objects and `tYYYYMM_B0X` for the single band raster objects.
Example: `t202605` is the multilayered raster object for May 2026, and `t202605_B02` is the blue band for this date.

### Visualizing the data as natural color image

To view the satellite image, the red, green and blue (RGB) bands of one shot have to be stacked. They bands are already stacked in the multilayered raster object, but they also have to be stacked in the visualization. The function `im.plotRGB.auto()` from the package `imageRy` does this very nicely.

```r
library(imageRy)

im.plotRGB.auto(t201707)
```

The result is a natural color image, here the one from July 2017:

![RGB image from July 2017](Images/RGBt201707.png)

It is clearly visible that there are some clouds in the bottom right corner. The center of the picture is quite dark beacause of the shadow from the mountain.

### Visualizing the data as false color image

Of course it's also possible to make a false color image. Usually the blue band is not used in the false color images. Instead, the green band is shown in blue, the red band is shown in green and the NIR band is shown in red.
With the function `im.plotRGB` you can specify the used bands. Here the 4th layer (NIR) of the multilayered raster object is used for R, and so on.

```r
im.plotRGB(t201707, r=4, g=3, b=2)
```

![False color image from July 2017](images/falsecolor_t201707.png)

In this view, the shadow is still very well dark, as the reflected light is very low. Similarily the cloud, as it reflects all spectra. The red color represents vegetation, as it reflects NIR very well.

### Visualizing the data as NDVI images

Another way of visualization is with the DVI/NDVI.
The DVI is the Difference Vegetation Index. It is calculated for each pixel by substracting the red band value from the NIR band value:

$$
\mathrm{DVI} = \mathrm{NIR} - \mathrm{R}
$$

The NDVI is the normalized DVI, the calculation is a bit more complicated:

$$
\mathrm{DVI} = \frac{\mathrm{NIR} - \mathrm{R}}
                    {\mathrm{NIR} + \mathrm{R}}
$$

A high NDVI means that there is much more reflected NIR than red. Healthy plants strongly reflect NIR, but absorb red light. This means, that healthy plants have a high NDVI value.

Luckily, both can be visualized quite easily with `im.dvi()`and `im.ndvi()` from `imageRy`. The functions only create the raster, so you have to manually `plot()` the raster.

```r
par(mfrow = c(1, 2)) # make 2 pictures side by side
plot(im.dvi(t201707, nir = 4, red = 3))
plot(im.ndvi(t201707, nir = 4, red = 3))
```

![DVI and NDVI of July 2017](Images/dvindvi_t201707.png)

The difference is quite cleary visible.
First of all, the scale of values and the units are different. For DVI (left) the highest number is very high, and the unit has to do with the intensity of the reflection. In the shaded arees, the DVI value is also quite low.

For NDVI (right) the value range is from 0 to 1 without a unit. And it doesn't show the shadow anymore, as the values have been normalized by the sum of reflected light. This way we can also make the shaded areas of a valley visible. This is also, why the NDVI is used for the project.

NDVI values from 0 to 0.2 indicate barren soil, whereas water, snow and clouds have negative values. Vegetation has values from 0.3 to 0.8. Healthy vegetation has higher values than stressed vegetation.

In the image, an elongated area of very low NDVI can be observed in the center. This area contains almost only rockfall debris without vegetation. The surrounding areas have quite high NDVI values, indicating that theres a lot of healthy vegetation. Comparison with the natural colors image shows a dense forest there.

## Multitemporal analysis

Comparing the NDVI plots of 2018 and 2025 it becomes visible, that the NDVI changes in parts of the debris body.

```r
ndvi201809 <- im.ndvi(t201809, nir = 4, red = 3)
ndvi202508 <- im.ndvi(t202508, nir = 4, red = 3)
par(mfrow = c(1, 2)) # make 2 pictures side by side
plot(ndvi201809)
plot(ndvi202508)
```

![Comparison of 2018 and 2025](Images/ndvi20182025.png)

It becomes even more visible when looking at a difference map. The NDVI difference can be calculated by substraction of the NDVI 2018 map from the NDVI 2025 map.

$$
\delta \mathrm{NDVI} = \mathrm{NDVI}\textsubscript{2025} - \mathrm{NDVI}\textsubscript{2018}
$$

I'm using a palette that starts with red for the negative values (less/stressed vegetation), white around zero (similar state) and green for the positive values (more/healthier vegetation).

```r
# use a red-white-green diverging palette (approximation of ggthemes' Red-Green-White Diverging)
cols <- colorRampPalette(c("red", "white", "forestgreen"))(100)
d_ndvi20252018 <- ndvi202508 - ndvi201809
plot(d_ndvi20252018, col = cols)
```

![Difference map of the NDVIs](Images/d_ndvi20252018.png)

Here it becomes clearly visible that in the debris area the NDVI has increased. It seems to be stronger along the rim of that area. Also, the river network can clearly be observed.
In the steeper parts of the slopes, in some areas the NDVI has decreased a lot. This can be the case after erosional processes.
