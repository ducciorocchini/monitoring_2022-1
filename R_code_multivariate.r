# R code for measuring community interactions

# let's install the vegan package
install.packages("vegan")
library(vegan)

# let's download from virtuale biomes_multivar.RData and put them in the multivar folder inside the lab folder
# set the working directory
setwd("C:/lab/multivar")

# load function to load properly R data. it reload saved datasets. load("x"), where x=the dataset we want to upload
load("biomes_multivar.RData") # NB:include the extension ".RData" even if windows masks it in the name of the file

# list function in R, used to list objects. 
ls() # in this manner we are seeing all the object that we have in R data
# the output is  "biomes",   "biomes_types",   "cl",   "snow2000" 
# if i put
biomes
# i obtain the all data set: plots are rows (so the sites) and columns are species
# es the first plot has only 1 individual of chesnut(castanea sativa) and 0 individual for all other species, this might means that this is plot in a temperate forest not a tropical one
biomes_types
# here we can see for each plot the type of the biome: for instance we can see that the plot 1 is indeed the temperate biome

# biome table composition
# in tropical forest: giant_orb, rafflesia, red_colubus, tree_fern, orangutan, pandinus, pleurotus, dinoponera, lianas, tiger, banana tree, mosses, python
# broadleaf continental forest: beech, alnus, squirrel, fox, toad, maple_acer, oak, viper, deer, brown_bear, chestnut, robin_bird
# coniferous forests: fir_abies, wolves, lynx
# tundra: lichens, reindeer

# byomes types: for each ployt there is the biome type

# we're make use of the detrendence correspondance analysis
# decorana() function
# multivariate analysis really used for species
# we're using decorana funciton with the biome table
multivar <- decorana(biomes)
multivar

# DCA1 51%, DCA2 30%. with 2 axis we have a variability of 81% so we can compact the system in two axis
# let's make a plot
plot(multivar)
# red writings are species. dot are axis of which we see only the point
# the plot is directly showing only the 2 axis that shows the majority of the variability
# the first 2 exis indemitting are explaining the most of the variance it is not by chance
# de me is passing the first axis in the majortìity TAG ca 1.45 h

# lets plot the biomes_type with the function ordiellipse() to see if these species are grouped together in the same biome or not
# ordiellipse (): include all of the plot in a certain biomes. make some groups inside our space
# attach function is used when u want to use a dataset
# attach(): attach set of R objects 
# let's tske a look at the grouping of species. are them in the same biome ?
# tag explain this function

attach(biomes_types)
ordiellipse(multivar, type, col=c("yellow", "red", "purple", "green"), kind="ehull", lwd=3) # this will represent 4 different biomes
# 4 ellipse making a conjunction. taking dome points and include them in the shape of the ellipse
ordispider(multivar, type, col=c("yellow", "red", "purple", "green"), label=TRUE)
# now we have the lable that states for each ellips what it groups
# es in the tropical forest we can see these species are linked together and atteined to the same biome
# there are species in the same xones but a bit a part. the core is the ellipse but 
# we can have some overlapping

# so we started with a certain thable from which we cannot understand how the indi are correlated to each other. so we can make a graph in which the aboundances of ind are shown and also the relation between organisms and biomes
# imagine that in a certain area u destroy the tropical forest biome. the composition of species will change so tha graph will change a lot and all tropical forest will disappear from the graphs
# this is called multivariate analysis a method to see how organisms are related to each other





# now populations: individuals of the same species
install.packages/"sdm")
library(sdm)
# species distribution modeling: modeling of the individual of the same speices
# presentation in virtuale: population ecology



