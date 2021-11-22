### 19 novembre ###
# R code for estimating energy in ecosystems


library(raster)
setwd("C:/lab")

# Importing the data
l1992 <- brick("defor1_.jpg") # Image of 1992
# It gives error becasue additional libraries are needed. so we will install rgdal
install.packages("rgdal")
library(rgdal)
l1992 <- brick("defor1_.jpg") 
l1992 #we can see the amount of pixel, 341292, there are 3 layers, and they are named:
# Bands: defor1_.1, defor1_.2, defor1_.3
#plotRGB
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")

# defor1_.1 = NIR. we're sure this bend is in nir becasue we've put it in red 
# and the image is very red becasue nir is reflected a lot.
# if we put defor1_.1 in the green channel we'll obtain a very green picture
# why water is white in the image? if it was pure water it will become black. 
# but this is white becasue is a reflection of smth that is not water

# defor1_.1 = NIR
# defor1_.2 = red
# defor1_.3 = green

plotRGB(l1992, r=2, g=1, b=3, stretch="Lin")
plotRGB(l1992, r=2, g=3, b=1, stretch="Lin")


#### nov 22 ###
library(raster)
library(rgdal)
setwd("C:/lab/")

#this is the situation of matogrosso forest in 1992
l1992 <- brick("defor1_.jpg")
l1992

plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
# We put nir in red channel, so vegetation looks red in the plot since it reflects lot of nir

#now let's check the situation in 2006
l2006 <- brick("defor2_.jpg")
l2006

plotRGB(l2006, r=1, b=2, g=3, stretch="Lin")

#lot of considerations we can make: rio peixoto, the amount of solid inside the river is smaller 
# (is blue, not white; water might become balck if is pure water, if there is soil in water it will became more and more white)
#let's plot together the images

par(mfrow=c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, b=2, g=3, stretch="Lin")
#remember we are seeing smth that can't be seen by human eyes.
#is there a proof that this is the same area? the flow of the river is the same. 
#but rivers are replicating their shape so do not trust them so much
#so there is the patch that is stating they are the same area? the line above the river
#in the second image al the rectangular shape are not natural components

#let's start with the calculation of energy. we use the index DVI=lmbdaNIR - lambda R. 
#if there is a lot of vegetation the index should be high

#let's calculate energy in 1992
# defor1_.1 is the bend of nir reflectance and defor1_.2 of the red
dev.off()
dvi1992 <- l1992$defor1_.1 - l1992$defor1_.2
[10:14 AM] Duccio Rocchini
# let's calculate energy in 1992

dev.off()
dvi1992 <- l1992$defor1_.1 - l1992$defor1_.2
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) # specifying a color scheme
plot(dvi1992, col=cl)

dvi2006 <- l2006$defor2_.1 - l2006$defor2_.2
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi2006, col=cl)
#all the yellow part are energy completely loss
#in addittion we're losing structure for animals

#let's see how much difference we have in the 2 calculations
# if we make the difference between dvi 1992 and 2006, high values as result are stating there have been a big change

dvidif <- dvi1992 - dvi2006
cld <- colorRampPalette(c('blue','white','red'))(100)
plot(dvidif, col=cld)
#everything which is red means a high value of difference so are the areas in which energy has been completely lost

# let's make a final plot of this are: original images, dvis and dividif
par(mfrow=c(3,2))
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, b=2, g=3, stretch="Lin")
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)
  
#let's create a pdf
pdf("energy.pdf")
par(mfrow=c(3,2))
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, b=2, g=3, stretch="Lin")
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)
dev.off() #needed to close the pdf, explain to r thet it is finished
#i will find the pdf in lab folder becasue at the beginning i've st the wd in lab
  
pdf("dvi.pdf")
par(mfrow=c(3,1))
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)
dev.off() 
