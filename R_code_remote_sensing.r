# R code for ecosystem monitoring by remote sensing
# First of all we need to install additional packages
# raster package to manage image data
# https://cran.r-project.org/web/packages/raster/index.html

instal.packages("raster")

library(raster)

#l'et's import our data in R
#rirst set the working directory to make know R where the files are

setwd("C:/lab/")

#we are going to import satellite data
l2011 <- brick("p224r63_2011.grd")

l2011

plot(l2011)

# B1 is the reflectance in the blue band
# B2 is the reflectance in the green band
# B3 is the reflectance in the red band

cl <- colorRampPalette(c("black", "grey", "light grey"))(100)
plot(l2011, col=cl)

plotRGB(l2011, r=3, g=2, b=1, stretch="Lin")
