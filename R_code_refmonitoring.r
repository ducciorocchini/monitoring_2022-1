### let's give it a try with my exam project on monitoring the reforestation projects in brazil

setwd("C:/lab/play/refmonitoring")

library(ncdf4) # for formatting our files - to manage spatial data from Copernicus, read and manipulate them (in nc)
library(raster) # work with raster file (single layer data)
library(ggplot2) # for plots - to ggplot raster layers - create graphics
library(viridis) # colorblind friendly palettes 
library(patchwork) # for comparing separate ggplots, building a multiframe 
library(gridExtra) # for grid.arrange plotting, creating a multiframe  
library(rgdal) # to open shape file 


rlist <- list.files(pattern = "c_gls_FCOVER")
list_rast <- lapply(rlist, raster)

FCOVERstack <- stack(list_rast)
plot(FCOVERstack)

names(FCOVERstack) <- c("FCOVER.1","FCOVER.2","FCOVER.3","FCOVER.4","FCOVER.5")
plot(FCOVERstack)

ext <- c(-50, -40, -20, -15)
FCOVERcrop <- crop(FCOVERstack, ext)
plot(FCOVERcrop)

FCOVER2000 <- FCOVERcrop$FCOVER.1
FCOVER2005 <- FCOVERcrop$FCOVER.2
FCOVER2010 <- FCOVERcrop$FCOVER.3
FCOVER2015 <- FCOVERcrop$FCOVER.4
FCOVER2020 <- FCOVERcrop$FCOVER.5

FCOVER2000_df <- as.data.frame(FCOVER2000, xy=TRUE)
FCOVER2005_df <- as.data.frame(FCOVER2005, xy=TRUE)
FCOVER2010_df <- as.data.frame(FCOVER2010, xy=TRUE)
FCOVER2015_df <- as.data.frame(FCOVER2015, xy=TRUE)
FCOVER2020_df <- as.data.frame(FCOVER2020, xy=TRUE)

g1 <- ggplot() + geom_raster(FCOVER2000_df, mapping = aes(x=x, y=y, fill=FCOVER.1)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2000") + labs(fill = "FCOVER")
g2 <- ggplot() + geom_raster(FCOVER2005_df, mapping = aes(x=x, y=y, fill=FCOVER.2)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2005") + labs(fill = "FCOVER")
g3 <- ggplot() + geom_raster(FCOVER2010_df, mapping = aes(x=x, y=y, fill=FCOVER.3)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2010") + labs(fill = "FCOVER")
g4 <- ggplot() + geom_raster(FCOVER2015_df, mapping = aes(x=x, y=y, fill=FCOVER.4)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2015") + labs(fill = "FCOVER")
g5 <- ggplot() + geom_raster(FCOVER2020_df, mapping = aes(x=x, y=y, fill=FCOVER.5)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2020") + labs(fill = "FCOVER")

grid.arrange(g1, g2, g3, g4, g5, nrow=3)
#or through patchwork package 
g2 + g1 + g3 / g4 + g5

cl <- colorRampPalette(colors = c("#edf8fb", "#b2e2e2", "#66c2a4", "#2ca25f", "#006d2c"))(100)
plot(FCOVERcrop, col = cl)


# plot FCOVER for eac year
par(mfrow = c(2,3))
plot(FCOVER2000, main = "Forest cover in 2000", col = cl)
plot(FCOVER2005, main = "Forest cover in 2005", col = cl)
plot(FCOVER2010, main = "Forest cover in 2010", col = cl)
plot(FCOVER2015, main = "Forest cover in 2015", col = cl)
plot(FCOVER2020, main = "Forest cover in 2020", col = cl)

# compare fcover between each year with a linear regression model (scatterplot)
par(mfrow=c(3,4))
plot(FCOVER2000, FCOVER2005, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2005, xlim = c(0,1), ylim= c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2010, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2015, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
plot(FCOVER2005, FCOVER2010, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
plot(FCOVER2005, FCOVER2015, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
plot(FCOVER2005, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
plot(FCOVER2010, FCOVER2015, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
plot(FCOVER2010, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
plot(FCOVER2015, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
