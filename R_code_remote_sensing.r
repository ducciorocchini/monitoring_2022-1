# R code for ecosystem monitoring by remote sensing
# First of all we need to install additional packages
# raster package to manage image data
# https://cran.r-project.org/web/packages/raster/index.html

instal.packages("raster")

library(raster)

#l'et's import our data in R
#rirst set the working directory to make know R where the files are

setwd("C:/lab/")

#we are going to import satellite data
l2011 <- brick("p224r63_2011.grd")

l2011

plot(l2011)

# B1 is the reflectance in the blue band
# B2 is the reflectance in the green band
# B3 is the reflectance in the red band

cl <- colorRampPalette(c("black", "grey", "light grey"))(100)
plot(l2011, col=cl)

plotRGB(l2011, r=3, g=2, b=1, stretch="Lin")


#--------------- day2

# B1 is the reflectance in the blue band
# B2 is the reflectance in the green band
# B3 is the reflectance in the red band
# B4 is the reflectance in the NIR band

#we want to plot only green band. 
#in the file the name of this band is B2_sre, u can see it in the "names" line.
#so we must link l2011 with the bend n 2 using $

plot(l2011$B2_sre)

#let's change the colors of the plot. using the colorRampPalette function
cl <- colorRampPalette(c("black", "grey", "light grey"))(100)

# Let's plot the bend 2 with the colors we've decided
plot(l2011$B2_sre, col=cl)

# change the colorRampPalette with dark green, green and light green
clg <- colorRampPalette(c("dark green", "green", "light green"))(100)
# And now let's plot it 
plot(l2011$B2_sre, col=clg)

# do the same with blue. so we must link the bend 1 named B1_sre
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(l2011$B1_sre, col=clb)

#now we want to plot both images in just one multiframe graph 
# let's create a multiframe with 1 row and 2 columns
par(mfrow=c(1,2)) #the first number is the number of rows in the multiframe while the second is the number of columns
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

# Now i  want to see the green bend on top and blue on bottom so 2 rows and 1 column
par(mfrow=c(2,1))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)



#------------- day 3

#let's plot only the blue bend
plot(l2011$B1_sre)

# let's change the colors. plot the blue band using a blue colorRampPalette
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(l2011$B1_sre, col=clb)

#let's multiframe
par(mfrow=c(2,1)) # the first number is number of rows in the multiframe
#plot the blue band and the green besides, with different colorRampPalette
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(l2011$B1_sre, col=clb)

clg <- colorRampPalette(c("dark green", "green", "light green"))(100)
plot(l2011$B1_sre, col=clg)

#so the complete function to plot in multiframe is 
par(mfrow=c(2,1))
plot(l2011$B1_sre, col=clb)
plot(l2011$B1_sre, col=clg)

#now let's change the multiframe in order to have 2 rows the blue on top and the green on bottom
par(mfrow=c(2,1))
plot(l2011$B1_sre, col=clb)
plot(l2011$B1_sre, col=clg)

#exercise: plot the first 4 bends with 2 rows and 2 columns
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
clg <- colorRampPalette(c("dark green", "green", "light green"))(100)
clr <- colorRampPalette(c("dark red", "red", "pink"))(100)
clnir <- colorRampPalette(c("red", "orange", "yellow"))(100)

par(mfrow=c(2,2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)
plot(l2011$B3_sre, col=clr)
plot(l2011$B4_sre, col=clnir)



#RGB and bends; R->B3, G->B2, B->B1
plotRGB(l2011, r=3, g=2, b=1, stretch="Lin") #natural color
now we are in the visible spectrum

#now we want to wxrwnd our view to the near infrared to see what we cannot see with our eyes
#leaf behaviour: very highe reflectance in NIR. in the mesophile there are the palisat cells 
#but where to put nir? we just have 3 channels, R, G and B
# we should remove b1 and have b2, b3 e b4
#so r=B4, g=B3, b=B2

plotRGB(l2011, r=4, g=3, b=1, stretch="Lin") #false color

#since vegetation reflect lot onfrared and we put infrared wavelenght (B4) in channel R we see a lot of red in the image plotted

#let's imagine we want to change channel in wich we put NIR

plotRGB(l2011, r=3, g=4, b=2, stretch="Lin") 

plotRGB(l2011, r=3, g=2, b=4, stretch="Lin") 

#let's do a multiframe with this 4 images
par(mfrow=c(2,2))

plotRGB(l2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(l2011, r=4, g=3, b=1, stretch="Lin") 
plotRGB(l2011, r=3, g=4, b=2, stretch="Lin") 
plotRGB(l2011, r=3, g=2, b=4, stretch="Lin") 

#in monitoring the first step is observe the current situation. then multitemporal analysis. see how it was back in time to see changes

#in lab there is a file p224r63_1988.rdg and we will use it to make comparison in time
