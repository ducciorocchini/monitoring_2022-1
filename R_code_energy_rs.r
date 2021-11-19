### 19 novembre ###
# R code for estimating energy in ecosystems


library(raster)
setwd("C:/lab")

# Importing the data
l1992 <- brick("defor1_.jpg") # Image of 1992
# It gives error becasue additional libraries are needed. so we will install rgdal
install.packages("rgdal")
library(rgdal)
l1992 <- brick("defor1_.jpg") 
l1992 #we can see the amount of pixel, 341292, there are 3 layers, and they are named:
# Bands: defor1_.1, defor1_.2, defor1_.3
#plotRGB
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")

# defor1_.1 = NIR. we're sure this bend is in nir becasue we've put it in red 
# and the image is very red becasue nir is reflected a lot.
# if we put defor1_.1 in the green channel we'll obtain a very green picture
# why water is white in the image? if it was pure water it will become black. 
# but this is white becasue is a reflection of smth that is not water

# defor1_.2 = 
