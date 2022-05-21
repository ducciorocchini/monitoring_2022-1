### exam project on monitoring the reforestation projects of the Brazilian atlantic forest

setwd("C:/lab/play/refmonitoring/fcover_00-12")

# let's recall the the packages needed
library(ncdf4) # to read and manage nc files from Copernicus
library(raster) # to manage raster file (single layer files)
library(ggplot2) # for ggplots
library(viridis) # colorblind friendly palettes 
library(patchwork) # to build a multiframe 
library(gridExtra) # to create multiframe ggplot
library(RColorBrewer) # to use brewer paleettes
library(RStoolbox) # to unsuperclass

# create a list of the FCOVER files to apply raster function to the list and import all the files in one shot
rlist <- list.files(pattern = "c_gls_FCOVER_")
list_rast <- lapply(rlist, raster)

# create a stack of the raster objects
FCOVERstack <- stack(list_rast)


# now let's crop on the brazilian atlantic forest
ext <- c(-59, -32, -37, -4)
# ext <- c(-79, -44, 12, -16)
FCOVERcrop <- crop(FCOVERstack, ext)
# assign a name to each file of the stack 
names(FCOVERcrop) <- c("FCOVER.1","FCOVER.2","FCOVER.3","FCOVER.4", "FCOVER.5", "FCOVER.6", "FCOVER.7", "FCOVER.8", "FCOVER.9", "FCOVER.10", "FCOVER.11")
# to check the cropped area let's plot just one object to have a more rapid check
plot(FCOVERcrop$FCOVER.1)

# assign each file of the stack to an object to manage and call them more easily
FCOVER2000 <- FCOVERcrop$FCOVER.1
FCOVER2002 <- FCOVERcrop$FCOVER.2
FCOVER2004 <- FCOVERcrop$FCOVER.3
FCOVER2006 <- FCOVERcrop$FCOVER.4
FCOVER2008 <- FCOVERcrop$FCOVER.5
FCOVER2010 <- FCOVERcrop$FCOVER.6
FCOVER2012 <- FCOVERcrop$FCOVER.7
FCOVER2014 <- FCOVERcrop$FCOVER.8
FCOVER2016 <- FCOVERcrop$FCOVER.9
FCOVER2018 <- FCOVERcrop$FCOVER.10
FCOVER2020 <- FCOVERcrop$FCOVER.11

# now let's plot FCOVER of 2000 and 2020
par(mfrow=c(1, 2))
plot(FCOVER2000, main= "Forest cover in 2000")
plot(FCOVER2020, main= "Forest cover in 2020")

#export
png("outputs/fcover_plot.png", res = 300, width = 3000, height = 3000)
par(mfrow=c(1, 2))
plot(FCOVER2000, main= "Forest cover in 2000")
plot(FCOVER2020, main= "Forest cover in 2020")
dev.off()

# plot with a scale of green to give the idea of the vegetation cover
# using RColorBrewer package and the sequential palette YG1n
clg <- brewer.pal(n=9, name="YlGn") # with n being the n of colors in the palette and mame the name of the palette
par(mfrow=c(1, 2))
plot(FCOVER2000, main= "Forest cover in 2000", col = clg)
plot(FCOVER2020, main= "Forest cover in 2020", col = clg)

# export
png("outputs/fcover_plot_greenscale.png", res= 300, width=3000, height=3000)
par(mfrow=c(1, 2))
plot(FCOVER2000, main= "Forest cover in 2000", col = clg)
plot(FCOVER2020, main= "Forest cover in 2020", col = clg)
dev.off()

# difference in FCOVER between 2000 nad 2020
dif <- FCOVER2000 - FCOVER2020
cld <- brewer.pal(n=11, name="PiYG")
dev.off()
plot(dif, col=cld, main="difference between fcover in 2000 and 2020")

# export

ext2 <- c(-60, -50, -30, -20)
FCOVERcrop2 <- crop(FCOVERstack, ext2)
names(FCOVERcrop2) <- c("FCOVER.1","FCOVER.2","FCOVER.3","FCOVER.4", "FCOVER.5", "FCOVER.6", "FCOVER.7", "FCOVER.8", "FCOVER.9", "FCOVER.10", "FCOVER.11")
# to check the cropped area let's plot just one object to have a more rapid check
plot(FCOVERcrop2$FCOVER.1)
FCOVER2000 <- FCOVERcrop2$FCOVER.1
FCOVER2002 <- FCOVERcrop2$FCOVER.2
FCOVER2004 <- FCOVERcrop2$FCOVER.3
FCOVER2006 <- FCOVERcrop2$FCOVER.4
FCOVER2008 <- FCOVERcrop2$FCOVER.5
FCOVER2010 <- FCOVERcrop2$FCOVER.6
FCOVER2012 <- FCOVERcrop2$FCOVER.7
FCOVER2014 <- FCOVERcrop2$FCOVER.8
FCOVER2016 <- FCOVERcrop2$FCOVER.9
FCOVER2018 <- FCOVERcrop2$FCOVER.10
FCOVER2020 <- FCOVERcrop2$FCOVER.11

# let's make a ggplot. first conver in dataframes
FC2000_dat <- as.data.frame(FCOVER2000, xy=TRUE)
FC2020_dat <- as.data.frame(FCOVER2020, xy=TRUE)

g1 <- ggplot() + geom_raster(FC2000_dat, mapping = aes(x=x, y=y, fill=FCOVER.1)) + scale_fill_viridis(option = "magma") + ggtitle("Forest cover in 2000") + labs(fill = "FCOVER")
g2 <- ggplot() + geom_raster(FC2020_dat, mapping = aes(x=x, y=y, fill=FCOVER.11)) + scale_fill_viridis(option = "magma") + ggtitle("Forest cover in 2020") + labs(fill = "FCOVER")

grid.arrange(g1, g2, nrow=1)
# or through patchwork package g1 + g2

# export
png("outputs/fcover_ggplot.png", res=300, width = 3000, height= 3000)
grid.arrange(g1, g2, nrow=1)
dev.off()

# compare fcover between 2000 and 2020 with a linear regression model (scatterplot)
plot(FCOVER2000, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2020")
abline(0,1, col="red")

# export
png("outputs/fcover_regressionmod.png", res = 300, width = 3000, height = 3000)
plot(FCOVER2000, FCOVER2020, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2020")
abline(0,1, col="red")
dev.off()

# plot frequency distribution data with histograms
par(mfrow=c(1,2))
hist(FCOVER2000, main="Frequency distribution FCOVER data in 2000", xlab = "FCOVER", col = "plum3")
hist(FCOVER2020, main="Frequency distribution FCOVER data in 2020", xlab = "FCOVER", col = "plum3")

#export
png("outputs/fcover_hist.png", res = 300, width = 3000, height = 3000)
par(mfrow=c(1,2))
hist(FCOVER2000, main="Frequency distribution FCOVER data in 2000", xlab = "FCOVER", col = "plum3")
hist(FCOVER2020, main="Frequency distribution FCOVER data in 2020", xlab = "FCOVER", col = "plum3")
dev.off()


# quantitative estimate and model
Fclass2000 <- unsuperClass(FCOVER2000, nClasses=2)
Fclass2002 <- unsuperClass(FCOVER2002, nClasses=2)
Fclass2004 <- unsuperClass(FCOVER2004, nClasses=2)
Fclass2006 <- unsuperClass(FCOVER2006, nClasses=2)
Fclass2008 <- unsuperClass(FCOVER2008, nClasses=2)
Fclass2010 <- unsuperClass(FCOVER2010, nClasses=2)
Fclass2012 <- unsuperClass(FCOVER2012, nClasses=2)
Fclass2014 <- unsuperClass(FCOVER2014, nClasses=2)
Fclass2016 <- unsuperClass(FCOVER2016, nClasses=2)
Fclass2018 <- unsuperClass(FCOVER2018, nClasses=2)
Fclass2020 <- unsuperClass(FCOVER2020, nClasses=2)

par(mfrow=c(4,3))
plot(Fclass2000$map)
plot(Fclass2002$map)
plot(Fclass2004$map)
plot(Fclass2006$map)
plot(Fclass2008$map)
plot(Fclass2010$map)
plot(Fclass2012$map)
plot(Fclass2014$map)
plot(Fclass2016$map)
plot(Fclass2018$map)
plot(Fclass2020$map)

freq(Fclass2000$map)
#     value  count
#[1,]     1 574084
#[2,]     2 680082 high
#[3,]    NA    234
# calculate the total (excluding NA) to calculate the proportion of high cover
total <- 680082 + 574084 
high_prop_00 <- 680082/total

freq(Fclass2002$map)
#     value  count
#[1,]     1 694578 high
#[2,]     2 559588
#[3,]    NA    234
high_prop_02 <- 694578/total

freq(Fclass2004$map)
#     value  count
#[1,]     1 579737 high
#[2,]     2 674429
#[3,]    NA    234
high_prop_04 <- 579737/total

freq(Fclass2006$map)
#     value  count
#[1,]     1 694662 high
#[2,]     2 559504
#[3,]    NA    234
high_prop_06 <- 694662/total

freq(Fclass2008$map)
#     value  count
#[1,]     1 462446
#[2,]     2 791720 high
#[3,]    NA    234
high_prop_08 <- 791720/total

freq(Fclass2010$map)
#     value  count
#[1,]     1 470959
#[2,]     2 783207 high
#[3,]    NA    234
high_prop_10 <- 783207/total

freq(Fclass2012$map)
#     value  count
#[1,]     1 592043
#[2,]     2 662123 high
#[3,]    NA    234
high_prop_12 <- 662123/total

freq(Fclass2014$map)
#     value  count
#[1,]     1 568677
#[2,]     2 685489 high
#[3,]    NA    234
high_prop_14 <- 685489/total

freq(Fclass2016$map)
#    value  count
#[1,]     1 483291
#[2,]     2 770875 high
#[3,]    NA    234
high_prop_16 <- 770875/total

freq(Fclass2018$map)
#     value  count
#[1,]     1 454759
#[2,]     2 799407 high
#[3,]    NA    234
high_prop_18 <- 799407/total

freq(Fclass2020$map)
#     value  count
#[1,]     1 704609 high
#[2,]     2 549557
#[3,]    NA    234
high_prop_20 <- 704609/total

high_prop <- c(high_prop_00, high_prop_02, high_prop_04, high_prop_06, high_prop_08, high_prop_10, high_prop_12, high_prop_14, high_prop_16, high_prop_18, high_prop_20)
year <- c(2000, 2002, 2004, 2006, 2008, 2010, 2012, 2014, 2016, 2018, 2020)
dat <- data.frame(year, high_prop)
model <- lm(year~high_prop)
plot(high_prop ~ year)
cor.test(high_prop, year)
# no correlation
# prediction

###### Leaf Area Index
LAIlist <- list.files(pattern = "c_gls_LAI")
LAIrast <- lapply(LAIlist, raster)
LAIstack <- stack(LAIrast)

LAIcrop <- crop(LAIstack, ext2)
ck <- brewer.pal(n=9, name="GnBu")
plot(LAIcrop, col=ck)

names(LAIcrop) <- c("LAI.1", "LAI.2")
LAI_2014 <- LAIcrop$LAI.1
LAI_2020 <- LAIcrop$LAI.2

png("outputs/LAI_plot.png", res=300, width=3000, height=3000)
par(mfrow=c(1, 2))
plot(LAI_2014, col=ck, main = "Leaf Area Index in 2014")
plot(LAI_2020, col=ck, main = "Leaf Area Index in 2020")
dev.off()


LAI_2014_df <- as.data.frame(LAI_2014, xy=TRUE)
LAI_2020_df <- as.data.frame(LAI_2020, xy=TRUE)

LAIg1 <- ggplot() + geom_raster(LAI_2014_df, mapping = aes(x=x, y=y, fill=LAI.1)) + scale_fill_viridis(option ="plasma") + ggtitle("Leaf Area Index in 2014") + labs(fill = "LAI")
LAIg2 <- ggplot() + geom_raster(LAI_2020_df, mapping = aes(x=x, y=y, fill=LAI.2)) + scale_fill_viridis(option ="plasma") + ggtitle("Leaf Area Index in 2020") + labs(fill = "LAI")

LAIg1 + LAIg2 

#export
png("outputs/LAI_ggplot.png", res=250, width=6000, height=3000)
LAIg1 + LAIg2
dev.off()

LAIdif <- LAI_2014 - LAI_2020
ckj <- brewer.pal(n=11, name="RdYlBu")
plot(LAIdif, col=ckj)
    
# export
png("outputs/LAI_dif.png", res = 300, width = 3000, height = 3000)
plot(LAIdif, main= "Differences in Leaf Area Index between 2014 and 2020", col=ckj)
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

# plotRGB(NDVIcrop, r=1, g=2, b=4, stretch="Lin")

names(NDVIcrop) <- c("NDVI.1", "NDVI.2")
NDVI2000 <- NDVIcrop$NDVI.1
NDVI2020 <- NDVIcrop$NDVI.2
#NDVI2020 <- NDVIcrop$NDVI.3

#click(NDVI2014)
NDVI2000_def <- calc(NDVI2000, fun=function(x){x[x>0.935] <- NA;return(x)})
NDVI2020_def <- calc(NDVI2020, fun=function(x){x[x>0.935] <- NA;return(x)})

cln <- brewer.pal(n=11, name="RdYlGn")
par(mfrow=c(1,2))
plot(NDVI2000_def, main="NDVI in 2000", col=cln)
plot(NDVI2020_def, main="NDVI in 2020", col=cln)


NDVIdif <- NDVI2014_def - NDVI2020_def
plot(NDVIdif, col=cld)

par(mfrow=c(3, 3))
plot(FCOVER2000, main = "Forest cover in 2000", col = clg)
plot(FCOVER2020, main = "Forest cover in 2020", col = clg)
plot(dif, col=cld, main="difference between fcover of 2012 and 2020")
plot(LAI_2014, col=ck, main = "Leaf Area Index in 2000")
plot(LAI_2020, col=ck, main = "Leaf Area Index in 2020")
plot(LAIdif, col=ckj)
plot(NDVI2000_def, main="NDVI in 2014", col=cln)
plot(NDVI2020_def, main="NDVI in 2020", col=cln)
plot(NDVIdif, col=cld)


