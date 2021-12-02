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

#build a multiframe window with 2 rows and 1 column with the par function
par(mfrow=c(2,1))
plot(en01, col=cl)
plot(en13, col=cl)
# we can compare the amount of NO2 at the beginning and the end of the lockdown. there has been a visible reduction.

#Now let's import all the images
en01 <- raster("EN_0001.png")
en02 <- raster("EN_0002.png")
en03 <- raster("EN_0003.png")
en04 <- raster("EN_0004.png")
en05 <- raster("EN_0005.png")
en06 <- raster("EN_0006.png")
en07 <- raster("EN_0007.png")
en08 <- raster("EN_0008.png")
en09 <- raster("EN_0009.png")
en10 <- raster("EN_0010.png")
en11 <- raster("EN_0011.png")
en12 <- raster("EN_0012.png")
en13 <- raster("EN_0013.png")


# plot all the data together with the common par()
par(mfrow=c(4,4))
plot(en01, col=cl)
plot(en02, col=cl)
plot(en03, col=cl)
plot(en04, col=cl)
plot(en05, col=cl)
plot(en06, col=cl)
plot(en07, col=cl)
plot(en08, col=cl)
plot(en09, col=cl)
plot(en10, col=cl)
plot(en11, col=cl)
plot(en12, col=cl)
plot(en13, col=cl)
# we obtain a multiframe composed by 13 images, showing the changes in [NO2] during the lock down period

# how to avoid all of this? how to plot all the images in one shot?
# thanks to the stack function 
# we have 13 files. before we have imported each of them one after the other with the raster function
# now we can built a stack, that contains all the images. Let's assign to the stack the name ENstack
EN <- stack(en01, en02, enN03, en04, en05, en06, en07, en08, en09, en10, en11, en12, en13)

# now let's plot the stack, so all the images togheter
plot(EN, col=cl)

# NB: this is what satelite images are: stack of several images

# Exercise: plot only the first image from the stack
plot(EN$EN_0001, col=cl)
# you can see the original name of the images by typing the name of the stack in R console and then run it

# let's plot an RGB space
plotRGB(EN, r=1, g=7, b=13, stretch="Lin")
# red component: beginning of lockdown so, 1st image. everything that become red will have high value of NO2 in the first image, so in january
# green component: middle of lockdown, 7th image. everything is green means that has hihg value of NO2 in 7th image
# blue components: end of the lockdown: 13th image.  blue part is where there are high values in the 13 image, so in the end of march
# we can state now that the pianura padanar region had high values also during the lockdown, because of the agricultural activites. in fact the area is white (sum of the other colors) becasue the [NO2] were high all the time

# today we had a time series of several images and we built them all together in a stack to make an analisis



######## day 2: 29 nov ########
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












