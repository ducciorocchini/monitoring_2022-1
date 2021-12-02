# 26 november
# R code for chemical cycling study
# We will deal with a time series of [NO2] changes in Europe during the lockdown, the period in which humans have not existed for the ecosystem
# These data came from the Copernicous Sentinell, a satellite launched by the EU union together with the Copernicus programm;
# The Copernicous sentinel has the capability to directly estimate the amounto of NO2 in the air
# So let's see what this satellite has been able to catch. let's import the data. 

# Set the working directory. NB: we've put EN images directly in the EN folder, inside the lab folder.
# So in this case remember you have to set the right wd to arrive at EN
setwd("C:/lab/EN/")  # windows

#to import the data we need the raster function, included on the raster package so let's recall the raster library
library(raster)
# to import data till now we used the brick function to import one file composed by several images.
# but this time we're dealing with several files each one containing just 1 image, 1 layer. 
# In fact EN data are a time series. is a set that is changing in time, one image after the other stating the changing on [NO2] in time.
# So for import these data we will use the raster funciton.
# raster() import each single layer one after the other. It allow to create a RasterLayer object.
# Let's import the first data "EN_0001"
en01 <- raster("EN_0001.png")
# What is the range of the data? so the minimum and the maximum value of [NO2]
# we can put in R the name of the file "en01" and it will give us all the informations
# the range is from 0 to 255, is called 8-bit file. this concept in remote sensing is called radiometric resolution

# Now we can plot this image. let's set the colorRampPalette
cl <- colorRampPalette(c('red','orange','yellow'))(100)
# We've selected the yellow for the maximum value of pollution possible.
# This becasue yellow component is catching our eyes more than the other wavelengths. if you want to focus the attention of your eye in a certain point of the map, use yellow is the best solution.

# Now let's plot the NO2 values of january 2020 by the cl plaette
plot(en01, col=cl)
# with the palette we've used, the red areas are the ones in which we have the smallest pollution while the yellow ones the highest.
# basically the higher is the amount og human beings in a certain city, the higher is the amount of NO2 expected spreading all around europe
# of course air will make the NO2 spread

# Exercise: import the end of march NO2 and plot it 
en13 <- raster("EN_0013.png")
plot(en13, col=cl)

#build a multiframe


#Let's import all the images
EN01 <- raster("EN_0001.png")
EN02 <- raster("EN_0002.png")
EN03 <- raster("EN_0003.png")
EN04 <- raster("EN_0004.png")
EN05 <- raster("EN_0005.png")
EN06 <- raster("EN_0006.png")
EN07 <- raster("EN_0007.png")
EN08 <- raster("EN_0008.png")
EN09 <- raster("EN_0009.png")
EN10 <- raster("EN_0010.png")
EN11 <- raster("EN_0011.png")
EN12 <- raster("EN_0012.png")
EN13 <- raster("EN_0013.png")

# otherwise:
# rlist <- list.files(pattern="EN")
# rlist 
# list_rast <- lapply(rlist, raster)
# ENstack <- stack(list_rast)

#plot all the data together
par(mfrow=c(4,4))
plot(EN01, col=cl)
plot(EN02, col=cl)
plot(EN03, col=cl)
plot(EN04, col=cl)
#Let's import all the images
EN01 <- raster("EN_0001.png")
EN02 <- raster("EN_0002.png")
EN03 <- raster("EN_0003.png")
EN04 <- raster("EN_0004.png")
EN05 <- raster("EN_0005.png")
EN06 <- raster("EN_0006.png")
EN07 <- raster("EN_0007.png")
EN08 <- raster("EN_0008.png")
EN09 <- raster("EN_0009.png")
EN10 <- raster("EN_0010.png")
EN11 <- raster("EN_0011.png")
EN12 <- raster("EN_0012.png")
EN13 <- raster("EN_0013.png")


#plot all the data together
par(mfrow=c(4,4))
plot(EN01, col=cl)
plot(EN02, col=cl)
plot(EN03, col=cl)
plot(EN04, col=cl)
plot(EN05, col=cl)
plot(EN06, col=cl)
plot(EN07, col=cl)
plot(EN08, col=cl)
plot(EN09, col=cl)
plot(EN10, col=cl)
plot(EN11, col=cl)
plot(EN12, col=cl)
plot(EN13, col=cl)


# how to avoid all of this?

# stack function 
ENstack <- stack(EN01, EN02, EN03, EN04, EN05, EN06, EN07, EN08, EN09, EN10, EN11, EN12, EN13)
#we should assign a name to the stack
# Plot the stack all togheter
plot(ENstack, col=cl)

# otherwise:
# rlist <- list.files(pattern="EN")
# rlist 
# list_rast <- lapply(rlist, raster)
# ENstack <- stack(list_rast)

#plot only the first image from the stack
plot(EN$EN_0001, col=cl)

# let's plot an RGB space
plotRGB(EN, r=1, g=7, b=13, stretch="Lin")
#everything that become red will have high value of NO2 in the first image. everithing is green hihg value of NO2 in 7th image ecc


### day 2: 29 nov ###
# we will import all data togheter in one shot
# lapply function: apply a function over a list, in our case raster
# first we should make the list with list.files function
# list.files(path="", pattern=""). 
# path argument can be avoided by setting the working directory. 
# the pattern is something that all the images have in common, like EN in the name for instance

library(raster)
setwd("C:/lab/EN")

rlist <- list.files(pattern="EN")
rlist
# we generated the list, now we can apply the lapply function to apply the raster function to rlist
# the function raster is importing every single file of the list
# lapply(X, FUN)
# X is the list of files
# FUN is the function u want to apply to the list

list_rast <- lapply(rlist, raster)
list_rast

# now let's use stack function to build the stack of all our data imported
EN_stack <- stack(list_rast)
EN_stack

# we can now use the stack to plot the images all together
cl <- colorRampPalette(c("red", "orange", "yellow"))(100)
plot(EN_stack, col=cl)

# exercise: plot only the first image of the stack
cl <- colorRampPalette(c("red", "orange", "yellow"))(100)
plot(EN_stack$EN_0001, col=cl)
# to know the name of the first image go see the output of EN_stack


# difference
ENdif <- EN_stack$EN_0001 - EN_stack$EN_0013
cldif <- colorRampPalette(c("blue", "white", "red"))(100)
# in red the highest variability between the two images


# automated processing Source function
# source: read r code from a file, a connection or expressions
# create a script with the previous code and save it in EN folder as "R_code_automatic_script.txt"
# source(file)
source("R_code_automatic_script.txt")

# today we learnt how to do automatic things like import data all together and a script with a code without copy paste it












