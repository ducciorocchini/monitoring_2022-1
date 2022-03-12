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

# we're going to make use of the detrendence correspondance analysis
# is a simple multivariate technique for arranging species and samples along environmental gradients.
# we will use decorana() function with the biomes table and store in the "multivar" object
multivar <- decorana(biomes)
multivar
# the output is a table with 3 raws: Eigenevalues, decorana values and axis length, and 4 columns that represents the axis
# Eigenvalues represents the amount of variance explained by the different axis. actually these are the original vegan values, the real variance is explained by decorana values row
# axis length means the real final lenth of the axis
# DCA1 51%, DCA2 30%. with 2 axis we have a variability of 81% so we can compact the system in two axis
# let's use them to make a plot
plot(multivar)
# red writings are species. dots are axis of which we see only the point
# the plot is directly showing only the first 2 axis that shows the majority of the variability
# it is "aauthomatic" that the first 2 axis in the method are explaining the most of the variance, it is not by chance
# the method is being thought to pass the 1st axis in the highest range possible of the data, and it will be even longer (axis lenth), then the variability represented by axis and so their lenght will be decreasing.
# it is not cosen by the operator, is a methodological point

# let's take a look at the grouping of species to see if those species are in the same biome
# lets plot the biomes_type in the previous plot with the function attach() and ordiellipse() to see if these species are grouped together in the same biome or not
# attach function is used when u want to use a dataset. attach(): attach set of R objects to search path
# ordiellipse (): include all of the plots in a certain biomes. make some groups inside our space
# arguments of this function: the first is the multivariate space in which we want to put the ellipse that is the object to which we associated the decorana function, so "multivar"
# then the type of biome that we can find in the 2nd column of the biomes_types table that is named "type"
# then u can chose a color for each biome
# then we should explain the kind (kind=) of graph we want to use, that is "ehull" convex shape that incorporates all the plot
# then the thickness of the lin lwd=

attach(biomes_types)
ordiellipse(multivar, type, col=c("yellow", "red", "purple", "green"), kind="ehull", lwd=3) # this will represent 4 different biomes
# the output is the previous graph with 4 ellipse making a conjunction of all the plots in a common shape. the most small ellipse possible containing all the plots of that biome
# nb that for this to work u must mantain open the plot obtained with plot(multivar)

#now we can name the ellipses with the name of the biome that represents with the ordispider() function with simila arguments of ordiellipse
ordispider(multivar, type, col=c("yellow", "red", "purple", "green"), label=TRUE)
# thanks to this function we have joined in the label the single plots
# es in the tropical forest we can see these species are living together and atteined to the same biome
# there are species in the same zones but a bit far form the ellipse. the core is the ellipse but they are part of the same biome
# we can have some overlapping, some individuals attaining to different biomes

# so we started with a certain table from which we cannot understand how the ind are related to each other. so we can make a graph to see how the aboundances of ind are connected to eachother and with the type of biome
# imagine that in a certain area u destroy the tropical forest biome. the composition of species will change so the graph will change a lot and all tropical forest will disappear from the graph
# this is called multivariate analysis a method to see how in a community organisms are related to each other
