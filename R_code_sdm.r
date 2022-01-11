# R code for species distribution modelling, namely the distribution of individuals of a population in space

install packages ("sdm")
# let's recall the packages we'll need
library(raster)
library(sdm) # predictors
library(rgdal) # species

# system.file() function that shows all the files in a certain package. find names of R system files, in this case in the package sdm
file <- system.file("external/species.shp", package="sdm") 
file # the output is the path to reach the data
species <- shapefile(file)

# let's plot the species data
# recreating a file inside R with the function shape.file() 
species <- shapefile(file) # exacltly as raster function for raster files
# let's plot
plot(species, pch=19, col=red) # pch dor the shape of the points in the plot



#### 10 January
# let's recall the libraries we need
library(sdm)
library(raster) #predictor, the env variables i use to predict where the species can be found in the space
library(rgdal) #species, vector data: arrays of coordinates
# OSGeo project
# we are working with 2 dimensions
# we are going to deal with series of coordinates in space. species are an array of x and y points (see notes)

# species data. inside external, a folder inside sdm package, there are all the data
file <- system.file("external/species.shp", package="sdm")
file
# shapefile is the correspondent funciton of raster, it cathces the points and put them in R
species <- shapefile(file) # exatcly as the raster function for raster files
species
# just one variable: occurrence. if u put species$Occurrence u have the occurrence for all the species. all the point are recorded with 0 and 1 
species$Occurrence
# i want to make a subset. let's use sql, language for subsetting the data. let's make a subset of the species which are presents, so the 1.
# how many occurrences are there?
# u can count all the 1 but we are lazy
# i will put my dataset and inside i make the query, wich is done by []
presences <- species[species$Occurrence == 1,] # i want to subsetonly the occurrences equal to 1. in this case the symble is double equal, ==. if u want to take the occurrences different from 1 only single equal and !, !=.
# control symble, used to explain to the software theìat the query is finished. in R is a comma
# u obtain the datafram with 94 points which are the points equal to 1
# let's hsk for the occurrences equal to zero
absences <- species[species$Occurrence == 0,] #or != 1
# now we can plot all the datas
plot(species, pch=19) #we have all the points
# let's plot only presences
plot(presences, pch=19, col="blue") # less points
#let's add to this plot also the absences. so make a single plot with presences and absences, differentiated by color
# to add points to a plot use points()
points(absences, pch=19, col="red")

# predictors (tag till the end)
# look at the path
path <- system.file("external", package="sdm")
path #u obtain the folder of the predictors data, that all have the same extention, asc sort of txt. the type of file is ASCII
# the environmental variables are in the same folder of the species but with the extenction asc
# let's make a list with all the variables
lst <- list.files(path, pattern="asc", full.names=T)
# tag why full names
# let's make the stack of this list
# u can use the lapply function with the raster function but in this case is not needed since the data are inside the package and have asc extention
preds <- stack(lst)
preds

#plot preds
cl <- colorRampPalette(c("blue", "orange", "red", "yellow"))(100)
plot(preds, col=cl)

plot(preds$elevation, col=cl)
points(presences, pch=19)



plot(preds$temperature, col=cl)
points(presences, pch=19)

plot(preds$vegetation, col=cl)
points(presences, pch=19)


# 11 january
# importing the source script
# let's set the wd to upload the entire script "R_code_source_sdm.r" that we've saved in lab folder from virtuale
setwd("C:/lab/")

# we're going to use the source function: read R code from a File
# source("name of the file")
source("R_code_source_sdm.r")

# we had created 'presences' and 'absences' (of species) objects, then we made a stack of predictors called 'preds'
preds # the output are all the predictors we use: elevation, precipitation, temperature and vegetation

# in the theoretical slide of SDMs we should use individual species and predictors

# let's build the model
# first we should explain to the software what are the date we're going to use
# predictors can be called also explanatory variable
# the species data are also called training data: we are training, explaining to the models where the species are

# let's explain the model what are the training and predictors, in our case 'species' and 'preds', with sdmData function
datasdm <- sdmData(train=species, predictors=preds)
datasdm
# one species in column called occurrence and 4 features (predictors). the type of data is presence-absence: 94-106.
# we are going to make an sdm model
# sdm function:fit and evaluate species distribution models. sdm(formula, data, methods, ...)
# the formula: is the formula that explains the relationship (x/y graph) between presence-absence (y=occurrence) of species and the parameter (x). 
# any line's formula is y=bx + a. a is the intercept while b is the slope. this is called linear model lm
# if we add more predictors the formula became y= bx + a + b1x1 and so on
# there are different methods in sdm but the more used is the generalized linear model
m1 <- sdm(Occurrence ~ temperature+elevation+precipitation+vegetation, data=datasdm, methods="glm")









