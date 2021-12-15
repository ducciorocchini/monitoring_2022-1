### 15 december ###
# R code for uploading and visualizing Copernicus data in R

# Let's install a new package that we will nedd
install.packages("ncdf4")

# let's recall the packages we're going to use
library(ncdf4)
library(raster)

# as usual set the wd. we've put the data in the copernicus folder inside the lab folder. so the correct wd are:
setwd("C:/lab/copernicus/")

# first of all let's upload our data. in general these are single layer data so the raster function can be used
# nameassigned <- raster("name of the file in the folder")
snow20211214 <- raster("c_gls_SCE_202112140000_NHEMI_VIIRS_V1.0.1.nc")
snow20211214
# this is a raster layer, with 212400000 pixels. it is a real resolution based on coordinates in degrees
# the name inside the data set is Snow.Cover.Extent and it can be acronimized as sce

# let's plot the image
# we can clearly see that in the northern part the ice cover is grater then the south
