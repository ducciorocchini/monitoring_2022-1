# friday 3 december
# we're dealing with land cover, in particularly forests.
# human activities are going to cut forest for agricultural purposes and today we will measure the amount of forest loss.
# specifically we will analyze an area in Brazil, in the Mato Grosso state, which nowadays is characterized by a mosaic of agricultural areas set by humans. 
# let's set the wd and recall packages we need
library(raster)
setwd("C:/lab/")

# Let's import the images, defor1 and 2, with the brick function applied to a list of objects thanks to the lapply funciton
# defor1 is the last image before the big cut and defor 2 is the resulting images after years of cut. they are composed by NIR, red and green bends.
# first of all let's list the files avaiables with the list.files function. the pattern we will use is defor since is shared by both images' names.
rlist <- list.files(pattern="defor")
rlist # the output is the list of files: defor1 and defor2

# We have now the list of files and we can apply a function to this list with the lapply funtion: lapply(x, function)
list_rast <- lapply(rlist, brick)
list_rast # the output are the 2 files (names: [[1]] and [[2]]) with their features (class, dimesion, resolution etc.)
# in this conditions we do not have to use $ to recall the different files because they're imported as separated files.
# we are going to treat them as separate files so we don't need to build a stack
# for example if we want to plot only defor 1 we can run this code:
plot(list_rast[[1]]) # the output are the images of the 3 bends of this file.

# now let's plot the RGB space. defor files are composed like this: NIR in the 1st bend, red in the 2nd, green in the 3rd. 
plotRGB(list_rast[[1]], r=1, g=2, b=3, stretch="Lin")
# we're putting the NIR in the red channel so we have red in all those areas covered by vegetation.
# to avoid typing everytime list_rast[[1]] we can assign it another name:
l1992 <- list_rast[[1]]
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")

# Let's do the same for defor2
l2006 <- list_rast[[2]]
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
# Now we can estimate in time the amount of forest that has been lost, from 1996 to 2006
# we can classify our image by creating another image in which we can distinguish forest and agricultural areas
# all forest pixels have high values of NIR reflectance and low values of red. so we can say to the forest that all pixels having this reflectance values can be grouped and called forest
# the same for the agricultural areas, whose pixel has low values of NIR reflectance and high of red (also water)
# the classification can be done with unsuperClass funciton, that does unsupervised classification, that is taking the pixels and see if ther are meaningfull groups.
# unsuperClass(img, nSamples, nClasses)
library(RStoolbox)
l1992c <- unsuperClass(l1992, nClasses=2)
l1992c #big object with the map inside. we can see there are 2 values, one is the forest, the other the agricultural areas.
# Let's plot the map
plot(l1992c$map) # the colors depend on the name to which the software gave the forest or agricultural areas
# inside the map the values are only 1 or 2. in this case:
# value 1= agricultural areas and water
# value 2= forests
# now we want to know how many pixels inside the map are forest and how many are agriculural areas
# function freq() generate frequency tables so it will calculate the % of forest pixels and agricultural areas
freq(l1992c$map)
#     value  count
# [1,]     1  34425
# [2,]     2 306867
# now we can calculate the proportion. we have the number of total pixel: 341292
total <- 341292
# proportion of forests and agricultural areas pixel on this total amount
propagri <- 34425/total
propforest <- 306867/total
propagri # 0.1008667 , so 10%
propforest # 0.8991333, so 90%

# to plot we can build a dataframe and then plot
# let's build the dataframe.
cover <- c("Forest", "Agriculture")
prop1992 <- c(0.8991333, 0.1008667)
proportion1992 <- data.frame(cover, prop1992)
# now let's plot using ggplot2 packages. so recall the packages.
library(ggplot2)
# ggplot(x, aesthetic), where x is the object to graph and it is the data.frame so proportion1992
# aestethics is the definition of colors and structure of the graph and we can use the function aes to determine the axes of the graph and what we want to distingush with different colors:
# then we must specify what kind of plot. in our case histogram so we must add the geom_bar funciton to explain the graph we want to obtain)
ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white")

# today we've learnt how to pass from the qualitative sensation we have from our eyes by seing the images to a quantitative graph


### 6th december ###
# let's recall the libraries that we will need today and set the wd
library(raster)
library(RStoolbox) # package used for the classification
library(ggplot2)
setwd("C:/lab/")

# let's import images defor 1 and defor 2 using brick function applied to a list.
# we use the brick function since each image is composed by 3 bends (NIR, red and green). otherwise for single layer we use the raster function (like EN images)
# First let's create the list
rlist <- list.files(pattern="defor")
rlist
# now use lapply function to apply brick function over rlist
list_rast <- lapply(rlist, brick)
list_rast
# lets assign simple names to the images and plot them in RGB space
l1992 <- list_rast[[1]]
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")

l2006 <- list_rast[[2]]
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")

# we can classify our image by creating another image in which we can distinguish forest and agricultural areas
# all forest pixels have high values of NIR reflectance and low values of red. so we can say to R that all pixels having this reflectance values can be grouped and called forest
# the same for the agricultural areas, whose pixel has low values of NIR reflectance and high of red (also water)
# the classification can be done with unsuperClass funciton, that does unsupervised classification, that is taking the pixels and see if ther are meaningfull groups.
# unsuperClass(img, nSamples, nClasses)
l1992c <- unsuperClass(l1992, nClasses=2)
l1992c
# let's plot the map
plot(l1992c$map)
# from the image we obtained and the legend we can observe that:
# value 2= agricultural areas and water
# value 1= forests

# but how to obtain a concrete estimation of agricultural/water areas and forest one?
# function freq() generate frequency tables so it will calculate the % of forest pixels and agricultural areas
freq(l1992c$map)
#     value  count
# [1,]     1  35205
# [2,]     2 306087
# now we can calculate the proportion. we have the number of total pixel: 341292
total1992 <- 341292
# proportion of forests and agricultural areas' pixel on this total amount
propagri1992 <- 35205/total
propforest1992 <- 306087/total
propagri1992 #  0.1031521, so 10%
propforest1992 # 0.8968479, so 90%

# to plot we can build a dataframe and then plot
# let's build the dataframe.
cover <- c("Forest", "Agriculture")
prop1992 <- c(0.8968479, 0.1031521)
proportion1992 <- data.frame(cover, prop1992)

ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)


# Let's do the same for defor2
# lets classify forest and agricultural areas in 12006 with unsuperClass(x, nClasses).
l2006c <- unsuperClass(l2006, nClasses=2) # with this function we can create 2 classes: forest and agricultural areas each one characterized by two different group of pixels sharing similar value of reflectance
# it is an iterative process: time by time the software is going to assign each pixel to a class. so the final values can be a bit different
l2006c

plot(l2006c$map)
# values 1= forest
# values 2= agricultural areas

# now let's calculate the frequencies of values
freq(l2006c$map)
#      value  count
# [1,]     1 178373 # forest
# [2,]     2 164353 # agriculture

# total amount of pixel: 342726
# forest (class 1) = 178373
# agricultural areas and water = 164353
# let's calculate the proportion

total <- 342726
propforest2006 <- 178373/total
propforest2006 # 0.5204537 -> 52%
propagri2006 <- 164353/total
propagri2006 # 0.4795463 -> 48%

# to plot we can build a dataframe and then plot
# let's build the dataframe.
cover <- c("Forest", "Agriculture")
prop2006 <- c(0.5204537, 0.4795463)
proportion2006 <- data.frame(cover, prop2006)
# let's build the graph
ggplot(proportion2006, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)


# let's make comparisons
cover <- c("Forest", "Agriculture")
prop1992 <- c(0.8968479, 0.1031521)
prop2006 <- c(0.5204537, 0.4795463)
proportion <- data.frame(cover, prop1992, prop2006)
proportion

library(gridExtra) # we will a function in this package to buld a multiframe of ggplots
# let's use grid.arrange function: it will put several graphs in the same multiframe
# first let's assign every ggplot to an object
p1 <- ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)
p2 <- ggplot(proportion2006, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)

grid.arrange(p1, p2, nrows=1)
# error

### 13 dec ###
# grid.arrange function didn't worked. solutions:
grid.arrange(p1, p2, nrow=1) # without the plurar s
# or:
# use the package patchwork
install.packages("patchwork")
library(patchwork)
p1+p2 # so simple, right?
# if you run p1/p2 you will have the 2 graphs one on top of the other

# patchwork is working even with raster data but they should be plotted with
# instead of using plotRGB we are going to use ggRGB
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
# let's do the same but with ggRGB
ggRGB(l1992, r=1, g=2, b=3)
# here you have also the coordinates

# Let's play with the stretch
ggRGB(l1992, r=1, g=2, b=3, stretch="lin")
ggRGB(l1992, r=1, g=2, b=3, stretch="hist")
# with this last stretch we can se some horizontal lines. this becasue the imange is taken by a scanner
ggRGB(l1992, r=1, g=2, b=3, stretch="sqrt")
# with this stretch in general you are compacting the data
ggRGB(l1992, r=1, g=2, b=3, stretch="log")
# remember that log in R is not the log in base ten but is the natural log

# let's see all these graphs all together
gp1 <- ggRGB(l1992, r=1, g=2, b=3, stretch="lin")
gp2 <- ggRGB(l1992, r=1, g=2, b=3, stretch="hist")
gp3 <- ggRGB(l1992, r=1, g=2, b=3, stretch="sqrt")
gp4 <- ggRGB(l1992, r=1, g=2, b=3, stretch="log")

gp1 + gp2 + gp3 + gp4

# multitemporal patchwork
gp1 <- ggRGB(l1992, r=1, g=2, b=3)
gp5 <- ggRGB(l2006, r=1, g=2, b=3)

gp1 + gp5
gp1/gp5

# forest passed from 90% of the landscape to 50% of the landscape
# agriculture passed from 10 % to 50% of the landscape
# the aspectances are that afgriculture will continue increase and forests decrease

# we've learnt how to build multiframe in different manners: parmfrow, stack, gridarrange, patchwork





















