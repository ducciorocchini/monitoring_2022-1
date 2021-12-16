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
# to see how many layers are unside copernicus data:
# snow20211214 <- brick("c_gls_SCE_202112140000_NHEMI_VIIRS_V1.0.1.nc")
# if just one layer is better to use raster

snow20211214
# this is a raster layer, with 212400000 pixels. it is a real resolution based on coordinates in degrees
# the name inside the data set is Snow.Cover.Extent and it can be acronimized as sce

# let's plot the image
plot(snow20211214)
# we can clearly see that in the northern part the ice cover is grater then the south

## 16 december

# we can change colors of the plot by using the common color ramp palette
cl <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)

# or we can use viridis
# paper on virtuale that states which palette are better to avoid
# viridis palette: exacly the palette in we use R. it is very similar, despite the color vision deseases; the scale is mantained
# thanks to this palette even people with disease will not see the esact colors but will at least discriminate between minimukm and maximum
# also cividis is a good inclusive palette

# example of a bad palette
cl <- colorRampPalette(c("blue", "green", "red"))(100)

# so we will use palette with colors that can be seen by everyone
# let's install viridis package
install.packages("viridis")
# let's recall the packages we will need
library(viridis)
library(RStoolbox)
library(ggplot2)

# https://ggplot2.tidyverse.org/reference/geom_tile.html
# geom_raster is the geometry we want to use. es we've used geom bar that makes histograms
# fill is the name of what we want to plot that can be found by running the name of the file snow20211214
# now let's avoid viridis and use the default legend
ggplot() + 
geom_raster(snow20211214, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent))

# now let's plot with the viridis palette
# the function to prepare the colors is scale_fill_viridis()
ggplot() + 
geom_raster(snow20211214, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent)) +
scale_fill_viridis()
# this is a plot that all people can see
# human eyes is cathced by the yellow color so this palette is great since the maximum values are showed with the yellow color
# now we can change from viridis to other legends. you can see them from the paper

# let's use cividis
ggplot() + 
geom_raster(snow20211214, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent)) +
scale_fill_viridis(option = "cividis")
# in this case we have to specify inside the scale:fill_viridis function the palette we can use, because viridis is the default one
# even in these case i'm sure even color blind people will see

# u can add a title for the name of the palette
ggplot() + 
geom_raster(snow20211214, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent)) +
scale_fill_viridis(option = "cividis") +
ggtitle("cividis palette")

# so just open a ggplot window with ggplot()
# then use geom raster to 
# and then chose the colors thanks to the scale_fill_viridis() function
# and eventually add a title

# now let's go to copernicus and download another image of the same set
