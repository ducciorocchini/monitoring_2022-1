# let's monitor the deforestation in Mato Grosso, Brazil

setwd("C:/lab/play/refmonitoring/fcover_00-20")

library(ncdf4) # for formatting our files - to manage spatial data from Copernicus, read and manipulate them (in nc)
library(raster) # work with raster file (single layer data)
library(ggplot2) # for plots - to ggplot raster layers - create graphics
library(viridis) # colorblind friendly palettes 
library(patchwork) # for comparing separate ggplots, building a multiframe 
library(gridExtra) # for grid.arrange plotting, creating a multiframe  
library(rgdal) # to open shape file 

FCOVER2000 <- raster("c_gls_FCOVER_200005100000_GLOBE_VGT_V2.0.2.nc")
FCOVER2005 <- raster("c_gls_FCOVER_200505100000_GLOBE_VGT_V2.0.1.nc")
FCOVER2010 <- raster("c_gls_FCOVER_201005100000_GLOBE_VGT_V2.0.1.nc")
FCOVER2015 <- raster("c_gls_FCOVER_201505100000_GLOBE_PROBAV_V2.0.2.nc")
FCOVER2020 <- raster("c_gls_FCOVER_202005100000_GLOBE_PROBAV_V2.0.1.nc")

rlist <- list.files(c(FCOVER2000, FCOVER2005, FCOVER2010, FCOVER2015, FCOVER2020))
list_rast <- lapply(rlist, raster)

FCOVERstack <- stack(list_rast)
plot(FCOVERstack)

names(FCOVERstack) <- c("FCOVER.1","FCOVER.2","FCOVER.3","FCOVER.4", "FCOVER.5")
plot(FCOVERstack)

ext <- c(-60, -50, -14, -9)
FCOVERcrop <- crop(FCOVERstack, ext)
plot(FCOVERcrop)

#export
png("outputs_def/fcover_plot.png", res = 300, width = 3000, height = 3000)
plot(FCOVERcrop)
dev.off()


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

grid.arrange(g1, g2, g3, g4, nrow=3)
#or through patchwork package g2 + g1 + g3 / g4 + g5

# export
png("outputs_def/fcover_ggplot.png", res=300, width = 3000, height= 3000)
grid.arrange(g1, g2, g3, g4, g5, nrow=3)
dev.off()

# plot with real colors
cl <- colorRampPalette(colors = c("#edf8fb", "#b2e2e2", "#66c2a4", "#2ca25f", "#006d2c"))(100)
plot(FCOVERcrop, col = cl)

# export
png("outputs_def/fcover_plot_real.png", res= 300, width=3000, height=3000)
plot(FCOVERcrop, col=cl)
dev.off()



# plot FCOVER for eac year
par(mfrow = c(2,2))
plot(FCOVER2000, main = "Forest cover in 2000", col = cl)
plot(FCOVER2005, main = "Forest cover in 2005", col = cl)
plot(FCOVER2010, main = "Forest cover in 2010", col = cl)
plot(FCOVER2015, main = "Forest cover in 2015", col = cl)
plot(FCOVER2020, main = "Forest cover in 2020", col = cl)

# compare fcover between each year with a linear regression model (scatterplot)
par(mfrow=c(3,4))
plot(FCOVER2000, FCOVER2005, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2010, xlim = c(0,1), ylim= c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2010")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2015, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2015")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2005, FCOVER2010, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2005", ylab="FCOVER 2010")
abline(0,1, col="red")
plot(FCOVER2005, FCOVER2015, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2005", ylab="FCOVER 2015")
abline(0,1, col="red")
plot(FCOVER2005, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2005", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2010, FCOVER2015, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2010", ylab="FCOVER 2015")
abline(0,1, col="red")
plot(FCOVER2010, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2010", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2015, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2015", ylab="FCOVER 2020")
abline(0,1, col="red")

# export
png("outputs_def/fcover_regressionmod.png", res = 300, width = 3000, height = 3000)
par(mfrow=c(3,4))
plot(FCOVER2000, FCOVER2005, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2005")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2010, xlim = c(0,1), ylim= c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2010")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2015, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2015")
abline(0,1, col="red")
plot(FCOVER2000, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2005, FCOVER2010, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2005", ylab="FCOVER 2010")
abline(0,1, col="red")
plot(FCOVER2005, FCOVER2015, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2005", ylab="FCOVER 2015")
abline(0,1, col="red")
plot(FCOVER2005, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2005", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2010, FCOVER2015, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2010", ylab="FCOVER 2015")
abline(0,1, col="red")
plot(FCOVER2010, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2010", ylab="FCOVER 2020")
abline(0,1, col="red")
plot(FCOVER2015, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2015", ylab="FCOVER 2020")
abline(0,1, col="red")
dev.off()


# plot frequency distribution data with histograms
par(mfrow=c(3,2))
hist(FCOVER2000)
hist(FCOVER2005)
hist(FCOVER2010)
hist(FCOVER2015)
hist(FCOVER2020)

#export
png("outputs_def/fcover_hist.png", res = 300, width = 3000, height = 3000)
par(mfrow=c(3,2))
hist(FCOVER2000)
hist(FCOVER2005)
hist(FCOVER2010)
hist(FCOVER2015)
hist(FCOVER2020)
dev.off()

####### or paris

# plot difference between 2000 and 2020
dif <- FCOVER2000 - FCOVER2020
cl1 <- colorRampPalette(colors = c("#ca0020", "#f4a582", "#636363", "#a6dba0", "#008837"))(100)
plot(dif, col=cl1, main="difference between fcover of 2000 and 2020")

# export
png("outputs_def/fcover_dif.png", res = 300, width = 3000, height = 3000)
plot(dif, col=cl1, main="difference between fcover of 2000 and 2020")
dev.off()
