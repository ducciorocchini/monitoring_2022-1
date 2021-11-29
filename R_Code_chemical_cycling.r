# R code for chemical cycling study
# Let's do time series of NO2 change in Europe during the lockdown
# First let's import the data. 

# Set the working directory
setwd("C:/lab/en/")  # windows

#we need raster function based on the raster package so ler's recall the raster library
library(raster)
#now let's use the function called raster and import the data
en01 <- raster("EN_0001")
# What is the range of the data
#0 to 255, is called 8 bit file. this concept in remote sensing is called radiomating resolution
# https://www.google.com/search?q=R+colours+names&tbm=isch&ved=2ahUKEwiF-77Z1bX0AhULtKQKHQ3WDWYQ2-cCegQIABAA&oq=R+colours+names&gs_lcp=CgNpbWcQAzIECAAQEzoHCCMQ7wMQJzoICAAQCBAeEBNQiQhYnwxgwg1oAHAAeACAAUqIAZYDkgEBNpgBAKABAaoBC2d3cy13aXotaW1nwAEB&sclient=img&ei=vKKgYYWtOovokgWNrLewBg&bih=526&biw=1056#imgrc=OtMzJfyT_OwIiM
cl <- colorRampPalette(c('red','orange','yellow'))(100)
# let's plot
plot(en01, col=cl)

# exercise import the end of march NO2 and plot it 
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












