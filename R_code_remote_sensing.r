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


#--------------- day2

# B1 is the reflectance in the blue band
# B2 is the reflectance in the green band
# B3 is the reflectance in the red band
# B4 is the reflectance in the NIR band

#we want to plot only green band. 
#in the file the name of this band is B2_sre, u can see it in the "names" line.
#so we must link l2011 with the bend n 2 using $

plot(l2011$B2_sre)

#let's change the colors of the plot. using the colorRampPalette function
cl <- colorRampPalette(c("black", "grey", "light grey"))(100)

# Let's plot the bend 2 with the colors we've decided
plot(l2011$B2_sre, col=cl)

# change the colorRampPalette with dark green, green and light green
clg <- colorRampPalette(c("dark green", "green", "light green"))(100)
# And now let's plot it 
plot(l2011$B2_sre, col=clg)

# do the same with blue. so we must link the bend 1 named B1_sre
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(l2011$B1_sre, col=clb)

#now we want to plot both images in just one multiframe graph 
# let's create a multiframe with 1 row and 2 columns
par(mfrow=c(1,2)) #the first number is the number of rows in the multiframe while the second is the number of columns
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

# Now i  want to see the green bend on top and blue on bottom so 2 rows and 1 column
par(mfrow=c(2,1))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

