### exam project on monitoring the reforestation projects in brazil

setwd("C:/lab/play/refmonitoring/fcover_00-12")

library(ncdf4) # for formatting our files - to manage spatial data from Copernicus, read and manipulate them (in nc)
library(raster) # work with raster file (single layer data)
library(ggplot2) # for plots - to ggplot raster layers - create graphics
library(viridis) # colorblind friendly palettes 
library(patchwork) # for comparing separate ggplots, building a multiframe 
library(gridExtra) # for grid.arrange plotting, creating a multiframe  
library(rgdal) # to open shape file 
library(RColorBrewer)

rlist <- list.files(pattern = "c_gls_FCOVER_")
list_rast <- lapply(rlist, raster)

FCOVERstack <- stack(list_rast)
plot(FCOVERstack)

#let's crop on brazil atlantic forest
ext <- c(-52, -32, -20, -4)
FCOVERcrop <- crop(FCOVERstack, ext)
plot(FCOVERcrop)

names(FCOVERcrop) <- c("FCOVER.1","FCOVER.2","FCOVER.3","FCOVER.4", "FCOVER.5")

#export
png("outputs/fcover_plot.png", res = 300, width = 3000, height = 3000)
plot(FCOVERcrop)
dev.off()


FCOVER2012 <- FCOVERcrop$FCOVER.1
FCOVER2014 <- FCOVERcrop$FCOVER.2
FCOVER2016 <- FCOVERcrop$FCOVER.3
FCOVER2018 <- FCOVERcrop$FCOVER.4
FCOVER2020 <- FCOVERcrop$FCOVER.5


FCOVER2012_df <- as.data.frame(FCOVER2012, xy=TRUE)
FCOVER2014_df <- as.data.frame(FCOVER2014, xy=TRUE)
FCOVER2016_df <- as.data.frame(FCOVER2016, xy=TRUE)
FCOVER2018_df <- as.data.frame(FCOVER2018, xy=TRUE)
FCOVER2020_df <- as.data.frame(FCOVER2020, xy=TRUE)

g1 <- ggplot() + geom_raster(FCOVER2012_df, mapping = aes(x=x, y=y, fill=FCOVER.1)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2012") + labs(fill = "FCOVER")
g2 <- ggplot() + geom_raster(FCOVER2014_df, mapping = aes(x=x, y=y, fill=FCOVER.2)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2014") + labs(fill = "FCOVER")
g3 <- ggplot() + geom_raster(FCOVER2016_df, mapping = aes(x=x, y=y, fill=FCOVER.3)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2016") + labs(fill = "FCOVER")
g4 <- ggplot() + geom_raster(FCOVER2018_df, mapping = aes(x=x, y=y, fill=FCOVER.4)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2018") + labs(fill = "FCOVER")
g5 <- ggplot() + geom_raster(FCOVER2020_df, mapping = aes(x=x, y=y, fill=FCOVER.5)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2020") + labs(fill = "FCOVER")

grid.arrange(g1, g2, g3, g4, g5, nrow=3)
#or through patchwork package g2 + g1 + g3 / g4 

# export
png("outputs/fcover_ggplot.png", res=300, width = 3000, height= 3000)
grid.arrange(g1, g2, g3, g4, g5, nrow=3)
dev.off()

# plot with a scale of green to give the idea of the vegetation cover
# using RColorBrewer package and the sequential palette YG1n
clg <- brewer.pal(n=9, name="YlGn") # with n being the n of colors in the palette and mame the name of the palette
plot(FCOVERcrop, col = clg)

# plot FCOVER for each year
par(mfrow = c(2,3))
plot(FCOVER2012, main = "Forest cover in 2012", col = clg)
plot(FCOVER2014, main = "Forest cover in 2014", col = clg)
plot(FCOVER2016, main = "Forest cover in 2016", col = clg)
plot(FCOVER2018, main = "Forest cover in 2018", col = clg)
plot(FCOVER2020, main = "Forest cover in 2020", col = clg)

# export
png("outputs/fcover_plot_greenscale.png", res= 300, width=3000, height=3000)
par(mfrow = c(2,3))
plot(FCOVER2012, main = "Forest cover in 2012", col = clg)
plot(FCOVER2014, main = "Forest cover in 2014", col = clg)
plot(FCOVER2016, main = "Forest cover in 2016", col = clg)
plot(FCOVER2018, main = "Forest cover in 2018", col = clg)
plot(FCOVER2020, main = "Forest cover in 2020", col = clg)
dev.off()

# compare fcover between each year with a linear regression model (scatterplot). n=5 so n*(n-1)/2= 10 --> 10 scatterplots overall 
par(mfrow=c(3,4)) 
plot(FCOVER2012, FCOVER2014, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2012", ylab="FCOVER 2014")
abline(0,1, col="red")
plot(FCOVER2012, FCOVER2016, xlim = c(0,1), ylim= c(0, 1), xlab = "FCOVER 2012", ylab="FCOVER 2016")
abline(0,1, col="red")
plot(FCOVER2012, FCOVER2018, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2012", ylab="FCOVER 2018")
abline(0,1, col="red")
plot(FCOVER2012, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2012", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2014, FCOVER2016, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2014", ylab="FCOVER 2016")
abline(0,1, col="red")
plot(FCOVER2014, FCOVER2018, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2014", ylab="FCOVER 2018")
abline(0,1, col="red")
plot(FCOVER2014, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2014", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2016, FCOVER2018, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2016", ylab="FCOVER 2018")
abline(0,1, col="red")
plot(FCOVER2016, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2016", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2018, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2018", ylab="FCOVER 2020")
abline(0,1, col="red")


# export
png("outputs/fcover_regressionmod.png", res = 300, width = 3000, height = 3000)
par(mfrow=c(4,4))
plot(FCOVER2000, FCOVER2004, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2004")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2008, xlim = c(0,1), ylim= c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2008")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2012, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2012")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2016, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2016")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2008, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2004", ylab="FCOVER 2008")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2012, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2004", ylab="FCOVER 2012")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2016, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2004", ylab="FCOVER 2016")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2004", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2008, FCOVER2012, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2008", ylab="FCOVER 2012")
abline(0,1, col="red")
plot(FCOVER2008, FCOVER2016, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2008", ylab="FCOVER 2012")
abline(0,1, col="red")
plot(FCOVER2008, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2008", ylab="FCOVER 2012")
abline(0,1, col="red")
plot(FCOVER2012, FCOVER2016, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2012", ylab="FCOVER 2016")
abline(0,1, col="red")
plot(FCOVER2012, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2012", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2016, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2016", ylab="FCOVER 2020")
abline(0,1, col="red")
dev.off()


# plot frequency distribution data with histograms
par(mfrow=c(2,3))
hist(FCOVER2012, main="Frequency distribution FCOVER data in 2012", xlab = "FCOVER", col = "plum3")
hist(FCOVER2014, main="Frequency distribution FCOVER data in 2014", xlab = "FCOVER", col = "plum3")
hist(FCOVER2016, main="Frequency distribution FCOVER data in 2016", xlab = "FCOVER", col = "plum3")
hist(FCOVER2018, main="Frequency distribution FCOVER data in 2018", xlab = "FCOVER", col = "plum3")
hist(FCOVER2020, main="Frequency distribution FCOVER data in 2020", xlab = "FCOVER", col = "plum3")

#export
png("outputs/fcover_hist.png", res = 300, width = 3000, height = 3000)
par(mfrow=c(2,3))
hist(FCOVER2012, main="Frequency distribution FCOVER data in 2012", xlab = "FCOVER", col = "plum3")
hist(FCOVER2014, main="Frequency distribution FCOVER data in 2014", xlab = "FCOVER", col = "plum3")
hist(FCOVER2016, main="Frequency distribution FCOVER data in 2016", xlab = "FCOVER", col = "plum3")
hist(FCOVER2018, main="Frequency distribution FCOVER data in 2018", xlab = "FCOVER", col = "plum3")
hist(FCOVER2020, main="Frequency distribution FCOVER data in 2020", xlab = "FCOVER", col = "plum3")
dev.off()

####### or pairs(FCOVERcrop)

# plot difference between 2000 and 2020
dif <- FCOVER2012 - FCOVER2020
cld <- brewer.pal(n=9, name="Set1")
plot(dif, col=cld, main="difference between fcover of 2012 and 2020")

# export
png("outputs/fcover_dif.png", res = 300, width = 3000, height = 3000)
plot(dif, col=cl1, main="difference between fcover of 2012 and 2020")
dev.off()

# having seen the area with the highest difference let's use the 300m resolution to focus there
rlist300 <- list.files(pattern = "FCOVER300")
list_rast300 <- lapply(rlist300, raster)
FCOVER300stack <- stack(list_rast300)
#plot(FCOVER300stack)

ext300 <- c(-46, -39, -18, -6)
FCOVER300crop <- crop(FCOVER300stack, ext)
plot(FCOVER300crop)

names(FCOVER300crop) <- c("FCOVER300.1","FCOVER300.2","FCOVER300.3","FCOVER300.4")

FCOVER300_2014 <- FCOVER300crop$FCOVER300.1
FCOVER300_2016 <- FCOVER300crop$FCOVER300.2
FCOVER300_2018 <- FCOVER300crop$FCOVER300.3
FCOVER300_2020 <- FCOVER300crop$FCOVER300.4


FCOVER300_2014_df <- as.data.frame(FCOVER300_2014, xy=TRUE)
FCOVER300_2016_df <- as.data.frame(FCOVER300_2016, xy=TRUE)
FCOVER300_2018_df <- as.data.frame(FCOVER300_2018, xy=TRUE)
FCOVER300_2020_df <- as.data.frame(FCOVER300_2020, xy=TRUE)

g300.1 <- ggplot() + geom_raster(FCOVER300_2014_df, mapping = aes(x=x, y=y, fill=FCOVER300.1)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2014") + labs(fill = "FCOVER")
g300.2 <- ggplot() + geom_raster(FCOVER300_2016_df, mapping = aes(x=x, y=y, fill=FCOVER300.2)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2016") + labs(fill = "FCOVER")
g300.3 <- ggplot() + geom_raster(FCOVER300_2018_df, mapping = aes(x=x, y=y, fill=FCOVER300.3)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2018") + labs(fill = "FCOVER")
g300.4 <- ggplot() + geom_raster(FCOVER300_2020_df, mapping = aes(x=x, y=y, fill=FCOVER300.4)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2020") + labs(fill = "FCOVER")

grid.arrange(g300.1, g300.2, g300.3, g300.4, nrow=2)


par(mfrow = c(2,2))
plot(FCOVER300_2014, main = "Forest cover in 2014", col = clg)
plot(FCOVER300_2016, main = "Forest cover in 2016", col = clg)
plot(FCOVER300_2018, main = "Forest cover in 2018", col = clg)
plot(FCOVER300_2020, main = "Forest cover in 2020", col = clg)


pairs(FCOVER300crop)


dif300 <- FCOVER300_2014 - FCOVER300_2020
plot(dif300, col=cl1, main="Difference between FCOVER in 2014 and 2022")




## leaf area index

LAIlist <- list.files(pattern = "LAI")
LAIrast <- lapply(LAIlist, raster)
LAIstack <- stack(LAIrast)

names(LAIstack) <- c("LAI.1", "LAI.2", "LAI.3", "LAI.4", "LAI.5", "LAI.6")

LAIcrop <- crop(LAIstack, ext)
plot(LAIcrop)
LAIcl <- colorRampPalette(c("red", "light blue", "yellow"))(100)
plot(LAIcrop, col=LAIcl)

png("outputs/LAI_plot.png", res=300, width=3000, height=3000)
plot(LAIcrop, col=LAIcl)
dev.off()


LAI2000 <- LAIcrop$LAI.1
LAI2004 <- LAIcrop$LAI.2
LAI2008 <- LAIcrop$LAI.3
LAI2012 <- LAIcrop$LAI.4
LAI2016 <- LAIcrop$LAI.5
LAI2020 <- LAIcrop$LAI.6

LAI2000_df <- as.data.frame(LAI2000, xy=TRUE)
LAI2004_df <- as.data.frame(LAI2004, xy=TRUE)
LAI2008_df <- as.data.frame(LAI2008, xy=TRUE)
LAI2012_df <- as.data.frame(LAI2012, xy=TRUE)
LAI2016_df <- as.data.frame(LAI2016, xy=TRUE)
LAI2020_df <- as.data.frame(LAI2020, xy=TRUE)

LAIg1 <- ggplot() + geom_raster(LAI2000_df, mapping = aes(x=x, y=y, fill=LAI.1)) + scale_fill_viridis(option ="plasma") + ggtitle("Leaf Area Index in 2000") + labs(fill = "LAI")
LAIg2 <- ggplot() + geom_raster(LAI2004_df, mapping = aes(x=x, y=y, fill=LAI.2)) + scale_fill_viridis(option ="plasma") + ggtitle("Leaf Area Index in 2004") + labs(fill = "LAI")
LAIg3 <- ggplot() + geom_raster(LAI2008_df, mapping = aes(x=x, y=y, fill=LAI.3)) + scale_fill_viridis(option ="plasma") + ggtitle("Leaf Area Index in 2008") + labs(fill = "LAI")
LAIg4 <- ggplot() + geom_raster(LAI2012_df, mapping = aes(x=x, y=y, fill=LAI.4)) + scale_fill_viridis(option ="plasma") + ggtitle("Leaf Area Index in 2012") + labs(fill = "LAI")
LAIg5 <- ggplot() + geom_raster(LAI2016_df, mapping = aes(x=x, y=y, fill=LAI.5)) + scale_fill_viridis(option ="plasma") + ggtitle("Leaf Area Index in 2016") + labs(fill = "LAI")
LAIg6 <- ggplot() + geom_raster(LAI2020_df, mapping = aes(x=x, y=y, fill=LAI.6)) + scale_fill_viridis(option ="plasma") + ggtitle("Leaf Area Index in 2020") + labs(fill = "LAI")

LAIg1 + LAIg2 + LAIg3 + LAIg4 + LAIg5 + LAIg6

#export
png("outputs/LAI_ggplot.png", res=300, width=3000, height=3000)
LAIg1 + LAIg2 + LAIg3 + LAIg4 + LAIg5 + LAIg6
dev.off()

#plot with cl palette
plot(LAIcrop, col=cl)

#export
png("outputs/LAI_plot_real.png", res=300, width=3000, height=3000)
plot(LAIcrop, col=cl)
dev.off()


LAIdif <- LAI2000 - LAI2020
cl1 <- colorRampPalette(colors = c("#ca0020", "#f4a582", "#636363", "#a6dba0", "#008837"))(100)
plot(LAIdif, col=cl1, main="difference between Leaf Area Index of 2000 and 2020")

# export
png("outputs/LAI_dif.png", res = 300, width = 3000, height = 3000)
plot(LAIdif, col=cl1, main="difference between Leaf Area Index of 2000 and 2020")
dev.off()


pairs(LAIcrop)

png("outputs/LAI_pairs.png", res=300, width=3000, height=3000)
pairs(LAIcrop)
dev.off()










######### NDVI
NDVIlist <- list.files(pattern="NDVI")
NDVIrast <- lapply(NDVIlist, raster)
NDVIstack <- stack(NDVIrast)

# plot(NDVIstack)

# ext
NDVIcrop <- crop(NDVIstack, ext)
plot(NDVIcrop)

names(NDVIstack) <- c("NDVI2014","NDVI2016","NDVI2018","NDVI2020")

plotRGB(NDVIcrop, r=NDVI2014, g=NDVI2018, b=NDVI2020, stretch="Lin")






DMPlist <- list.files(pattern="DMP")
DMPrast <- lapply(DMPlist, raster)
DMPstack <- stack(DMPrast)

# plot(NDVIstack)

# ext
DMPcrop <- crop(DMPstack, ext)
plot(DMPcrop)






SWIlist <- list.files(pattern="SWI")
SWIrast <- lapply(SWIlist, raster)
SWIstack <- stack(SWIrast)

# plot(NDVIstack)

# ext
SWIcrop <- crop(SWIstack, ext)
plot(SWIcrop)









setwd("C:/lab/play")
l2013 <- list.files(pattern="20130730")
r2013 <- lapply(l2013, raster)
s2013 <- stack(r2013)
plotRGB(s2013, r=3, g=2, b=1, stretch="Lin")

l2021 <- list.files(pattern="20210704")
r2021 <- lapply(l2021, raster)
s2021 <- stack(r2021)
plotRGB(s2021, r=3, r=2, b=1, stretch="Lin")

par(mfrow=c(1, 2))
plotRGB(s2013, r=3, g=2, b=1, stretch="Lin")
plotRGB(s2021, r=3, r=2, b=1, stretch="Lin")
                
