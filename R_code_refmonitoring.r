### let's give it a try with my exam project on monitoring the reforestation projects in brazil

setwd("C:/lab/play/refmonitoring/fcover_00-12")

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

names(FCOVERstack) <- c("FCOVER.1","FCOVER.2","FCOVER.3","FCOVER.4")
plot(FCOVERstack)

ext <- c(-46.5, -44, -20, -17)
FCOVERcrop <- crop(FCOVERstack, ext)
plot(FCOVERcrop)

#export
png("outputs/fcover_plot.png", res = 300, width = 3000, height = 3000)
plot(FCOVERcrop)
dev.off()


FCOVER2000 <- FCOVERcrop$FCOVER.1
FCOVER2004 <- FCOVERcrop$FCOVER.2
FCOVER2008 <- FCOVERcrop$FCOVER.3
FCOVER2012 <- FCOVERcrop$FCOVER.4


FCOVER2000_df <- as.data.frame(FCOVER2000, xy=TRUE)
FCOVER2004_df <- as.data.frame(FCOVER2004, xy=TRUE)
FCOVER2008_df <- as.data.frame(FCOVER2008, xy=TRUE)
FCOVER2012_df <- as.data.frame(FCOVER2012, xy=TRUE)

g1 <- ggplot() + geom_raster(FCOVER2000_df, mapping = aes(x=x, y=y, fill=FCOVER.1)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2000") + labs(fill = "FCOVER")
g2 <- ggplot() + geom_raster(FCOVER2004_df, mapping = aes(x=x, y=y, fill=FCOVER.2)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2004") + labs(fill = "FCOVER")
g3 <- ggplot() + geom_raster(FCOVER2008_df, mapping = aes(x=x, y=y, fill=FCOVER.3)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2008") + labs(fill = "FCOVER")
g4 <- ggplot() + geom_raster(FCOVER2012_df, mapping = aes(x=x, y=y, fill=FCOVER.4)) + scale_fill_viridis(option = "magma") + ggtitle("Percentage of forest in 2012") + labs(fill = "FCOVER")

grid.arrange(g1, g2, g3, g4, nrow=3)
#or through patchwork package g2 + g1 + g3 / g4 

# export
png("outputs/fcover_ggplot.png", res=300, width = 3000, height= 3000)
grid.arrange(g1, g2, g3, g4, nrow=3)
dev.off()

# plot with real colors
cl <- colorRampPalette(colors = c("#edf8fb", "#b2e2e2", "#66c2a4", "#2ca25f", "#006d2c"))(100)
plot(FCOVERcrop, col = cl)

# export
png("outputs/fcover_plot_real.png", res= 300, width=3000, height=3000)
plot(FCOVERcrop, col=cl)
dev.off()



# plot FCOVER for eac year
par(mfrow = c(2,2))
plot(FCOVER2000, main = "Forest cover in 2000", col = cl)
plot(FCOVER2004, main = "Forest cover in 2004", col = cl)
plot(FCOVER2008, main = "Forest cover in 2008", col = cl)
plot(FCOVER2012, main = "Forest cover in 2012", col = cl)

# compare fcover between each year with a linear regression model (scatterplot)
par(mfrow=c(3,4))
plot(FCOVER2000, FCOVER2004, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2004")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2008, xlim = c(0,1), ylim= c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2008")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2012, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2012")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2008, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2004", ylab="FCOVER 2008")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2012, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2004", ylab="FCOVER 2012")
abline(0,1, col="red")
plot(FCOVER2008, FCOVER2012, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2008", ylab="FCOVER 2012")
abline(0,1, col="red")


# export
png("outputs/fcover_regressionmod.png", res = 300, width = 3000, height = 3000)
par(mfrow=c(3,2))
plot(FCOVER2000, FCOVER2004, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2004")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2008, xlim = c(0,1), ylim= c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2008")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2012, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2012")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2008, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2004", ylab="FCOVER 2008")
abline(0,1, col="red")
plot(FCOVER2004, FCOVER2012, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2004", ylab="FCOVER 2012")
abline(0,1, col="red")
plot(FCOVER2008, FCOVER2012, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2008", ylab="FCOVER 2012")
abline(0,1, col="red")
dev.off()


# plot frequency distribution data with histograms
par(mfrow=c(2,2))
hist(FCOVER2000)
hist(FCOVER2004)
hist(FCOVER2008)
hist(FCOVER2012)

#export
png("outputs/fcover_hist.png", res = 300, width = 3000, height = 3000)
par(mfrow=c(2,2))
hist(FCOVER2000)
hist(FCOVER2004)
hist(FCOVER2008)
hist(FCOVER2012)
dev.off()

####### or paris

# plot difference between 2000 and 2020
dif <- FCOVER2000 - FCOVER2012
cl1 <- colorRampPalette(colors = c("#ca0020", "#f4a582", "#636363", "#a6dba0", "#008837"))(100)
plot(dif, col=cl1, main="difference between fcover of 2000 and 2012")

# export
png("outputs/fcover_dif.png", res = 300, width = 3000, height = 3000)
plot(dif, col=cl1, main="difference between fcover of 2000 and 2012")
dev.off()


## leaf area index
