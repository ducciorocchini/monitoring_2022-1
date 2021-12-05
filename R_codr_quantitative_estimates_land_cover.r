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







