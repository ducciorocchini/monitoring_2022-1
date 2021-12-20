# ice melt in greenland
# proxy: LST- land surface temperature. it is a measurement of the temperature at the soil or the highest part of vegetation.


setwd("C:/lab/greenland/")
library(raster)
library(ggplot2)
library(RStoolbox)
library(patchwork)
library(viridis)

# we've downloaded some files inside a folder in virtuale and we've put them inside the greenland folder we've created inside lab folder
# let's create a list of these files. their common pattern is lst
rlist <- list.files(pattern="lst")
rlist
# we can see they are single layers images so to import them we use lapply function to appl the raster function
import <- lapply(rlist, raster)
import
# let's create a stack: take all the data together
# TAG ca. 35
# 16 bit images means 2^16 values

tgr <- stack(import)
tgr

cl <- colorRampPalette(c("blue", "light blue", "pink", "yellow"))(100)
plot(tgr, col=cl)
# all external areas has lower temperature (???)

# ggplot of first and finala images 2000 vs 2015

p1 <- ggplot() +
geom_raster(tgr$lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) +
scale_fill_viridis(option="magma")
ggtitle("LST in 2000")
# black color has a lower amount of spread in space that means there are higher T

p2 <- ggplot() +
geom_raster(tgr$lst_2015, mapping = aes(x=x, y=y, fill=lst_2015)) +
scale_fill_viridis(option="magma") +
ggtitle("LST in 2015")

# in extreme environment u can see direct effects of climate change

# now let's look at the distribution of these data
# notes

# plotting frequency sistributions of data
par(mfrow=c(1, 2))
hist(tgr$lst_2000)
hist(tgr$lst_2015)

# in 20015 2 picks.


par(mfrow=c(2, 2))
hist(tgr$lst_2000)
hist(tgr$lst_2005)
hist(tgr$lst_2010)
hist(tgr$lst_2015)

# let's plot 2010 and 2015 (notes)
plot(tgr$lst_2010, tgr$lst_2015, xlim=c(12500,15000), ylim=c(12500,15000))
abline(0,1,col="red")

# let's do this for all the value, histogram and regression line
par(mfrow=c(4,4))
hist(tgr$lst_2000)
hist(tgr$lst_2005)
hist(tgr$lst_2010)
hist(tgr$lst_2015)
plot(tgr$lst_2010, tgr$lst_2015, xlim=c(12500,15000), ylim=c(12500,15000))
plot(tgr$lst_2010, tgr$lst_2000, xlim=c(12500,15000), ylim=c(12500,15000))

# or using the stackthanks to the paris function
paris(tgr)

# 
