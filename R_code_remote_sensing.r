# R code for ecosystem monitoring by remote sensing
# First of all we need to install additional packages
# raster package allows the reading, writing, manipulating, analyzing and modeling of spatial data
# https://cran.r-project.org/web/packages/raster/index.html
# to use a new package in R we need to install it first. 
# this can be done by using the function install.packages(), with the name of the package under quotes as an argument
instal.packages("raster")
# up to now it's like we have bought a book and we have put it in our library. then when we want to read the book we must take it from the library and open it
# the same for the packages! when we need to use them we recall them with the function library() with the name of the package as an argument. NB: this time without "" since the package is already in R
library(raster)

# let's import our data in R
# first set the working directory to make know R where the files are
setwd("C:/lab/")

# we are going to import satellite data in R with brick function.
# it is a function needed to read satellite images and it is inside the raster package, that's why we need it.
# inside the brackets the name of the file we want to import under quotes since we are exiting R
# finally let's assign the file imported to the object l2011 for it to be more manageable
l2011 <- brick("p224r63_2011.grd")
l2011 
# here we have the summary of the file with all its features: 
# class: rasterbrick, 
# dimensions n of rows and columns -> n of pixel (cells), n of layers
# resolution of each pixel
# extent: resolution based on utm system
# source: data in my computer 
# crs, coordinate reference system, refers to the way in which spatial data that represent the earth's surface (which is round 3D) are flattened so that you can “Draw” them on a 2D surface
# names: name of bends. Ex B1_sre, where sre means spectrum reflectance. there are 7 layers so 7 bends from B1 to B7
# min and max values. they refers to values of reflectance that can range from 0 (only absorption) to 1 (only reflectance)

# now let's plot it to see the satellite image
plot(l2011)

# Each band have a range of nm of light that correspond to the wavelenght of the light they're measuring
# The first 3 bends are the visible part of the satellite images
# B1 is the reflectance in the blue band
# B2 is the reflectance in the green band
# B3 is the reflectance in the red band

# At first r shows you the plot with a default colour palette, but you can chage the colors 
# colorRampPalette function extend a color palette to a color ramp so it is changing color u want to use to show different bends
cl <- colorRampPalette(c("black", "grey", "light grey"))(100)
plot(l2011, col=cl)

# now let's make an RGB plot: Make a Red-Green-Blue plot based on three layers (in a RasterBrick or RasterStack).
# red green and blue are the basic colors used in computers. then we have the bends and we associate to each computer component a certain bend
# We are maching the bends we have in the RGB components of the computer
# The function used is plotRGB(). red.green.blue plot of a multi-layered raster object
# the arguments are the rasterbrick object to plot, the bend to put in the red channel, in the green channel and in the blue one
# stretch argument: Option to stretch the values to increase the contrast of the image. "Lin" is the linear stretch of values in a Raster object
# the reflectance can assume values from 0 to 1. But then the object might reflecting for example from 0.4 to 0.6. so i'm not using the total range from 0 to 1 but only from 0.4 to 0.7.
# So i can stretch this range until reaching for visualization goals all the range from 0 to 1
# if i'm stretching using a straight line it is called linear stretch
plotRGB(l2011, r=3, g=2, b=1, stretch="Lin")


####### day2 #######
# we said that our l2011 file is a satellite image composed by 7 layers. each one is measuring the reflectance of objects in the landscape with a certain wavelength:
# B1 is the reflectance in the blue band
# B2 is the reflectance in the green band
# B3 is the reflectance in the red band
# B4 is the reflectance in the NIR band (near infrared)
# B5 is the reflectance in the short-wave infrared
# B6 is the reflectance in the thermal infrared
# B7 is the reflectance in the short wave infrared
# Then each layer has different pixel wich have different values. Each pixel correspond to the amount of the wavelenght reflected that the layer is measuring.

# we want to plot only green band. 
# in the file the name of this band is B2_sre, u can see it in the "names" line, from l2011 output.
# so we must link l2011 with the bend n 2 using $
plot(l2011$B2_sre)

# let's change the colors of the plot. using the colorRampPalette function
cl <- colorRampPalette(c("black", "grey", "light grey"))(100)
plot(l2011$B2_sre, col=cl)
# Black is the colors of the objects that are absorbing light, light grey is the color for obj that are reflecting a lot and everything in the middle will be grey
# So the scale is from 0 to 1. 0:black, 1:lightgrey, And in the middle grey

# change the colorRampPalette with dark green, green and light green
clg <- colorRampPalette(c("dark green", "green", "light green"))(100)
# And now let's plot it 
plot(l2011$B2_sre, col=clg)

# do the same with blue. so we must link the bend 1 named B1_sre
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(l2011$B1_sre, col=clb)


### NB something ultrausefull
# Now we have the same plot every time with changed colors but once we create one we cancel and pass to the next
# Imagine we want the green and the blue together one beside the other. This is done with a function called par
# par() function: it sets or query graphicl parameters. So used to do any change to a graph
# We take the window of the graph and doing the multiframe. The multiframe is recalled by the argument mfrow
# let's create a multiframe with 1 row and 2 columns
par(mfrow=c(1,2)) #the first number is the number of rows in the multiframe while the second is the number of columns
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

# Now i  want to see the green bend on top and blue on bottom so 2 rows and 1 column
par(mfrow=c(2,1))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)



###### day 3 ######
# exercise: plot the first 4 bends with 2 rows and 2 columns
# first let's set the color palette for each image
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
clg <- colorRampPalette(c("dark green", "green", "light green"))(100)
clr <- colorRampPalette(c("dark red", "red", "pink"))(100)
clnir <- colorRampPalette(c("red", "orange", "yellow"))(100)
# then let's do the multiframe
par(mfrow=c(2,2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)
plot(l2011$B3_sre, col=clr)
plot(l2011$B4_sre, col=clnir)

dev.off () # to close the multiframe. if not the next plot RGB will come up as a small image of the previous multiframe

# RGB and bends; R->B3, G->B2, B->B1. in this way we are going to see the image as human being does, in natural colours since we're using from the B1 to the B3 wavelenght which are the visible one
plotRGB(l2011, r=3, g=2, b=1, stretch="Lin") #natural color, we are in the visible spectrum

# now we want to extend our view to the near infrared to see what we cannot see with our eyes
# leaf behaviour: very high reflectance in green and NIR wavelength. in the mesophile there are the palisat cells responsible for the reflectance in NIR
# higher the thickness of a leaf, higher the reflectance in NIR
# but where to put nir? we just have 3 channels, R, G and B
# we should remove b1 and have b2, b3 e b4. so r=B4, g=B3, b=B2
plotRGB(l2011, r=4, g=3, b=1, stretch="Lin") #false color
# since vegetation reflects a lot infrared and we put infrared wavelenght (B4) in channel R we see a lot of red in the image plotted
# Areas which are not red are the ones in which we have destroyed the forest for agriculture
#	If we put B4 in G we will se a lot of green and if in B lot of blue
# let's do it:
plotRGB(l2011, r=3, g=4, b=2, stretch="Lin") 
plotRGB(l2011, r=3, g=2, b=4, stretch="Lin") 

#let's do a multiframe with this 4 images
par(mfrow=c(2,2))
plotRGB(l2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(l2011, r=4, g=3, b=1, stretch="Lin") 
plotRGB(l2011, r=3, g=4, b=2, stretch="Lin") 
plotRGB(l2011, r=3, g=2, b=4, stretch="Lin") 

#in monitoring the first step is observe the current situation. then multitemporal analysis. see how it was back in time to see changes
#in lab there is a file p224r63_1988.rdg and we will use it to make comparison in time


######## day 4 ########
# final day on this tropical forest reserve
# first of all set working directory and recall raster package

library(raster)
setwd("C:/lab/")
l2011 <- brick("p224r63_2011.grd")
# let's plot it in RGB channels
plotRGB(l2011, r=4, g=3, b=2, stretch= "Lin")
# let's make use of a different stretch: histogram stretching. it enhance a lot the differences from one place to another
# in this case to stretch the values of reflectance instead of using a line we use like a sigmoid that enhance the extremes
plotRGB(l2011, r=4, g=3, b=2, stretch= "Hist")
# the differences from one place to another are enhanced
# we can see a large part of the forest destroied by agriculture. 

# let's see the differences with the forest in 1988. importing past data:
l1988 <- brick("p224r63_1988.grd")
l1988 # bends are the same to the previous file

# let's plot both files (2011 and 1988) to make comparisons.
par(mfrow=c(2, 1))
plotRGB(l1988, r=4, g=3, b=2, stretch= "Lin")
plotRGB(l2011, r=4, g=3, b=2, stretch= "Lin")
# in 1988 the forest was there. then they started builting some small agricultural areas and then in 2011 there is a completely opening of several part of the forest to agriculture
# put the NIR in the blue channel to enhance agricultural areas (that will appear in yellow)
par(mfrow=c(2, 1))
plotRGB(l1988, r=2, g=3, b=4, stretch= "Lin")
plotRGB(l2011, r=2, g=3, b=4, stretch= "Lin")





