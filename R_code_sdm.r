# R code for species distribution modelling, namely the distribution of individuals of a population in space
# now let's move to population analysis thanks to the species distribution modelling: distribution of individuals of the same species
# we will need the package sdm
install.packages/"sdm")
# let's recall the packages we'll need
library(raster)
library(sdm) # predictors
library(rgdal) # species

# system.file() function that shows the files in a certain package. in this case in the package sdm
file <- system.file("external/species.shp", package="sdm") #the first argument is the path for the file: external folder inside sdm folder inside R folder / name of the file, and then the package in which there is the file
file # the output is the path to reach the data
# recreating a file inside R with the function shape.file() 
species <- shapefile(file) # shapefile() function to read or write a shapefile (in raster package)g. exacltly as raster function for raster files
# let's plot
plot(species, pch=19, col=red) # pch dor the shape of the points in the plot



#### 10 January ####
# let's recall the libraries we need
library(sdm)
library(raster) # we will use to plot all predictors, the env variables i use to predict where the species can be found in the space
library(rgdal) # for species data, vector data: arrays of coordinates; species are an array of x and y points (since we are working in 2 dimensions

# species data. inside "external", a folder inside sdm package, there are all the data
file <- system.file("external/species.shp", package="sdm") #
file # u have the path to where to find the data species.shp in the computer
# inside external a part form species.shp (graphical part) there are different others files; es species.dbf (table), species.prj (info about coordinate system), species.shx (links every point to a row in the dbf table)

# shapefile() function is the correspondent funciton of raster, it cathces the points and import them in R
species <- shapefile(file) # exatcly as the raster function for raster files
species
# class: spatial points data frame
# just one variable: occurrence. if u put species$Occurrence u have the occurrence for all the species. all the point are recorded with 0 (absent) and 1 (present) 
species$Occurrence

# let's make a subset of the species which are presents, so the 1. let's use sql, language for subsetting the data
# i want to subset only the occurrences so only the data equal to 1. in this case i use the [] to make a query and extract only the data equals to 1.
# symbol for "equal to": == , symbol for "different from": !=
presences <- species[species$Occurrence == 1,] # control symble, used to explain to the software theìat the query is finished. in R is a comma
presences
# u obtain the dataframe with 94 points which are the points equal to 1
# let's ask for the occurrences equal to zero, we expect that are 106 since the total is 200
absences <- species[species$Occurrence == 0,] #or != 1
absences

# now we can plot all the datas
plot(species, pch=19) # plot all the points

plot(presences, pch=19, col="blue") # plot only presences, so we have less points
#let's add to this plot also the absences. so make a single plot with presences and absences, differentiated by color
# to add points to a plot use points()
points(absences, pch=19, col="red")

# predictors are environmental variables can be used to predict what will be the presence of a certain species in a certain part of the map (es maybe where u don't have observed data)
# these are all raster data. let's explain the path to where to find these data with system.file function and the assign it to an object, path
path <- system.file("external", package="sdm")
path #u obtain the path for the folder of the predictors data, which is the same folder of the species (external) 
# environmental variables have all the same extention, asc, a sort of txt. the type of file is ASCII
# let's make a list with all the environmental variables, that share the extention asc
lst <- list.files(path, pattern="asc", full.names=T) #full.names = true to explain u want the full name of the file if not he cannot read the extension

# let's make directly the stack of this list
# u could use the lapply function with the raster function but in this case is not needed since the data are inside the package and have asc extention
preds <- stack(lst)
preds

#plot preds
cl <- colorRampPalette(c("blue", "orange", "red", "yellow"))(100)
plot(preds, col=cl)
# north and west part is at low elevation, infact in this areas there are higher temperatures. peak in elevation that could be a mountain and very low T 
# precipitations are mainly in mountains at lower T but also in the valley so they do not follow only elevation

# let's plot the presences with every single variables
#elevation
plot(preds$elevation, col=cl)
points(presences, pch=19)
# most insividuals aer found in the low elevation areas

#temperatue
plot(preds$temperature, col=cl)
points(presences, pch=19)
# most individuals are found in middle-high temperatures

#vegetation
plot(preds$vegetation, col=cl)
points(presences, pch=19)
# individuals are found where there is vegetation cover

# precipitation
plot(preds$precipitation, col=cl)
points(presences, pch=19)
# intermediate precipitation

# u could plot all the graphs together with par

# there are some parts in the map for which we have no data. for these parts we can make a model with our predictors


# 11 january
# importing the source script in order to continue from where we left without copy paste the previous code
# let's set the wd to upload the entire script "R_code_source_sdm.r" that we've saved in lab folder from virtuale
setwd("C:/lab/")

# we're going to use the source function: read R code from a File
# source("name of the file")
source("R_code_source_sdm.r")

# let's build the model
# first we should explain to the software what are the data we're going to use: individuals of a species and predictors
# predictors can be called also explanatory variable
# the species data are also called training data: we are training, explaining to the models where the species is or is not

# let's explain the model what are the training and predictors, in our case 'species' and 'preds', with sdmData function, and assign this to the object "datasdm"
datasdm <- sdmData(train=species, predictors=preds)
datasdm
# one species in column called occurrence and 4 features (predictors). the type of data is presence-absence: 94-106.
# we are going to make an sdm model
# sdm function: fit and evaluate species distribution models. sdm(formula, data, methods, ...)
# the formula: is the formula that explains the relationship (x/y graph) between presence-absence (y=occurrence) of species and the parameter (x). 
# any line's formula is y=bx + a. a is the intercept while b is the slope. this is called linear model lm
# if we add more predictors the formula became y= bx + a + b1x1 and so on
# there are different methods in sdm but the more used is the generalized linear model
m1 <- sdm(Occurrence ~ temperature+elevation+precipitation+vegetation, data=datasdm, methods="glm")
m1
# the model at the end is the very final application of the formula; now we should use it and make the prediction
# divide our map in pixels and for each of them stating the probability of occurrence according to our model

#####  12 january
# the final occurrence probability will be the sum of everything (a+b0x0 + b1x1 ...)
# this is a model. now let's try to make the prediction.
# predict function: can be applied to any model to make prediction, applying that model to the predictors
# predict(model, data)
p1 <- predict(m1, newdata=preds)
p1 # it is a raster layer
# let's plot this prediction
plot(p1, col=cl)
# we make a prediction on the probability of presence of species from 0 to 1. we can expect that some part of the model are good, others not
# let's plot the presences on top of this to verify this
points(presences)
# points() function will add presence's points to the previous graph
# most of the point are located in those parts in which there is an higher probability of finding the species
# but we have also some points in areas where the probability is low: so the model is not in line with the origina datas
# this could happen because we are not considering all the predictors that are important for that species

# now let's make a final stack with everything all together: predictors and final prediction
s1 <- stack(preds, p1)
# plot the final stack
plot(s1, col=cl)
# u can find species in all yellow area. u can relate this probability of presence to the predictors: we will find mainly species at low elevation, at high temperatures and so on
# let's change the names of the maps with the names() function
names(s1) <- c('Elevation', 'Precipitation', 'Temperatures', 'Vegetation', 'Probability')
# then replot
plot(s1, col=cl)








