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

