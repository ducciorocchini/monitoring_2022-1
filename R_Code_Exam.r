### exam project on monitoring the Brazilian atlantic forest, or Mata Atlantica
setwd("C:/lab/exam")
library(ncdf4) # to read and manage nc files from Copernicus
library(raster) # to manage raster file (single layer files)
library(ggplot2) # plotting package to better represent data with graphs 
library(viridis) # colorblind friendly palettes 
# thanks to this palette even people with color vision disease will not see the esact colors but will at least discriminate between minimukm and maximum. The scale is mantained
library(patchwork) # to build a multiframe 
library(gridExtra) # to create multiframe ggplot
library(RColorBrewer) # to use brewer palettes
library(RStoolbox) # to unsuperclass


########################### FCOVER ###########################
# Monitoring changes in forest cover between 2000 and 2020
# create a list of the FCOVER files to apply raster function to the list and import all the files in one shot
fcover_list <- list.files(pattern = "c_gls_FCOVER_")
fcover_list
fcover_rast <- lapply(fcover_list, raster)
fcover_rast
# 11 filest imported as raster layers, forest cover from 2000 to 2020, at intervals of 2 years
# create a stack of the raster files
fcover_stack <- stack(fcover_rast)
fcover_stack
#crop on the brazilian atlantic forest
ext <- c(-65, -32, -40, -10)
fcover_crop <- crop(fcover_stack, ext)
#check if the cropped area is ok by plotting just one layer
plot(fcover_crop$Fraction.of.green.Vegetation.Cover.1km.1)
# assign a name to each layer of the stack as FCOVER.nn, being nn the last 2 digits of the corresponding year
names(fcover_crop) <- c("FCOVER.00","FCOVER.02","FCOVER.04","FCOVER.06", "FCOVER.08", "FCOVER.10", "FCOVER.12", "FCOVER.14", "FCOVER.16", "FCOVER.18", "FCOVER.20")
plot(fcover_crop)
# temporal evolution of the forest cover of the brazilian atlantic forest each 2 years from 2000 to 2020 
# export
png("outputs/time_series_fcover_2000-2020.png", res = 300, width = 3000, height = 3000)
plot(fcover_crop)
dev.off()

# focus just on the FCOVER of 2000 and 2020. assign these 2 layers to an object to manage and call them more easily
FCOVER2000 <- fcover_crop$FCOVER.00
FCOVER2020 <- fcover_crop$FCOVER.20
# and plot them in a multiframe of 1 row and 2 columns
par(mfrow=c(1, 2))
plot(FCOVER2000, main= "Forest cover in 2000")
plot(FCOVER2020, main= "Forest cover in 2020")
#export
png("outputs/plot_fcover_2000_2020.png", res = 300, width = 3000, height = 3000)
par(mfrow=c(1, 2))
plot(FCOVER2000, main= "Forest cover in 2000")
plot(FCOVER2020, main= "Forest cover in 2020")
dev.off()

# plot with a scale of green to give the idea of the vegetation cover, using RColorBrewer package and the sequential palette YG1n
clg <- brewer.pal(n=9, name="YlGn") # with n being the n of colors in the palette and name the name of the palette
par(mfrow=c(1, 2))
plot(FCOVER2000, main= "Forest cover in 2000", col = clg)
plot(FCOVER2020, main= "Forest cover in 2020", col = clg)
# export
png("outputs/plot_fcover_2000_2020_greenscale.png", res= 300, width=3000, height=2000)
par(mfrow=c(1, 2))
plot(FCOVER2000, main= "Forest cover in 2000", col = clg)
plot(FCOVER2020, main= "Forest cover in 2020", col = clg)
dev.off()

# ggplot. first convert in dataframes
FC2000_dat <- as.data.frame(FCOVER2000, xy = TRUE)
FC2020_dat <- as.data.frame(FCOVER2020, xy = TRUE)
g1 <- ggplot() + geom_raster(FC2000_dat, mapping = aes(x=x, y=y, fill=FCOVER.00)) + scale_fill_viridis() + ggtitle("Forest cover in 2000") + labs(fill = "FCOVER")
g2 <- ggplot() + geom_raster(FC2020_dat, mapping = aes(x=x, y=y, fill=FCOVER.20)) + scale_fill_viridis() + ggtitle("Forest cover in 2020") + labs(fill = "FCOVER")
# viridis: color scales in this package allows to make plots that are pretty, better represent your data, easier to read by those with colorblindness, and print well in gray scale.
# thanks to these palettes even people with disease will not see the exact colors but will at least discriminate between minimukm and maximum; 
# the default one is viridis, but there are others options all very inclusive palettes!!!
grid.arrange(g1, g2, nrow=1)
# or through patchwork package g1 + g2
# export
png("outputs/fcover_ggplot.png", res=300, width = 6000, height= 3000)
grid.arrange(g1, g2, nrow=1)
dev.off()

# difference in FCOVER between 2000 nad 2020
dif <- FCOVER2000 - FCOVER2020 # in this way we obtain a file where the positive values are those in which FCOVER was higher in 2000, while negatives higher in 2020
cld <- brewer.pal(n=11, name="BrBG")
dev.off() # to close the previous par (graphical parameters)
plot(dif, col =  cld, main="Forest Cover differences between 2000 and 2020")
# export
png("outputs/fcover_dif.png", res = 300, width = 3000, height = 3000)
plot(dif, col=cld, main="Forest Cover differences between 2000 and 2020")
dev.off()


##################### Leaf Area Index #####################
# monitoring changes in LAI between 2000 and 2020
# import files and create the stack as before
LAI_list <- list.files(pattern = "c_gls_LAI")
LAI_list
LAI_rast <- lapply(LAI_list, raster)
LAI_rast
LAI_stack <- stack(LAI_rast)
LAI_stack
#crop again on the area of interest
LAIcrop <- crop(LAI_stack, ext)
#assigning names to the layers
names(LAIcrop) <- c("LAI.1", "LAI.2")
# assign each layer to an object to make them more manageble
LAI_2000 <- LAIcrop$LAI.1
LAI_2020 <- LAIcrop$LAI.2
# create a palette to plot LAI
ck <- brewer.pal(n=9, name="GnBu") 
par(mfrow=c(1, 2))
plot(LAI_2000, col=ck, main = "Leaf Area Index in 2000")
plot(LAI_2020, col=ck, main = "Leaf Area Index in 2020")
# export
png("outputs/LAI_plot.png", res=300, width=3000, height=2000)
par(mfrow=c(1, 2))
plot(LAI_2000, col=ck, main = "Leaf Area Index in 2000")
plot(LAI_2020, col=ck, main = "Leaf Area Index in 2020")
dev.off()

# ggplot
LAIg1 <- ggplot() + geom_raster(LAI_2000, mapping = aes(x=x, y=y, fill=LAI.1)) + scale_fill_viridis(option ="mako") + ggtitle("Leaf Area Index in 2000") + labs(fill = "LAI")
LAIg2 <- ggplot() + geom_raster(LAI_2020, mapping = aes(x=x, y=y, fill=LAI.2)) + scale_fill_viridis(option ="mako") + ggtitle("Leaf Area Index in 2020") + labs(fill = "LAI")
LAIg1 + LAIg2
#export
png("outputs/LAI_ggplot.png", res=250, width=6000, height=3000)
LAIg1 + LAIg2
dev.off()

# difference in LAI between 2000 and 2020
LAIdif <- LAI_2000 - LAI_2020 # we obtain the LAIdif layer in which positive values are those in which LAI was higher in 2000 and viceversa
dev.off()
plot(LAIdif, main= "Differences in Leaf Area Index between 2000 and 2020", col=cld)
# export
png("outputs/LAI_dif.png", res = 300, width = 3000, height = 3000)
plot(LAIdif, main= "Differences in Leaf Area Index between 2000 and 2020", col=cld)
dev.off()

# let's use this function that return a plot matrix, consisting of scatter plots corresponding to each data frame
pairs(LAIcrop)
# export
png("outputs/LAI_pairs.png", res=300, width=3000, height=3000)
pairs(LAIcrop)
dev.off()


#################### NDVI #############################
# Monitoring the changes in Normalized difference vegetation index between 2000 and 2020
NDVI_list <- list.files(pattern="NDVI")
NDVI_list
NDVI_rast <- lapply(NDVI_list, raster)
NDVI_rast
NDVI_stack <- stack(NDVI_rast)
NDVI_stack
# crop on the area of interest
NDVIcrop <- crop(NDVI_stack, ext)
plot(NDVIcrop)
# RGB plot to plot NDVI of different years in the different RGB channels
# in this way where there are higher values the image takes the red, green or blue color, according to the year assigned to each channel
# in this way we can understand when and where there's been the higher values.
ggRGB(NDVIcrop, r=1, g=3, b=2, stretch="Lin") 
# red: 2000, blue: 2010, green: 2020
# export
png("outputs/NDVI_RGB.png", res=300, width=3000, height=3000)
ggRGB(NDVIcrop, r=1, g=3, b=2, stretch="Lin") # red: 2000, blue: 2010, green: 2020
dev.off()

# assign names to the layers, and them assign them to objects
names(NDVIcrop) <- c("NDVI.1", "NDVI.2", "NDVI.3")
NDVI2000 <- NDVIcrop$NDVI.1
NDVI2010 <- NDVIcrop$NDVI.2
NDVI2020 <- NDVIcrop$NDVI.3
# click(NDVI2000) # there are background values when plotting NDVI so let's use click function and click on them to understand the value
# then transform them into NA
NDVI2000_def <- calc(NDVI2000, fun=function(x){x[x>0.935] <- NA;return(x)})
NDVI2020_def <- calc(NDVI2020, fun=function(x){x[x>0.935] <- NA;return(x)})
# calc function Calculate values for a new Raster* object from another Raster* object, using a formula.
# now we can plot NDVI without background value
cln <- brewer.pal(n=11, name="RdYlGn") # palette to plot NDVI
par(mfrow=c(1,2))
plot(NDVI2000_def, main="NDVI in 2000", col=cln)
plot(NDVI2020_def, main="NDVI in 2020", col=cln)
# export
png("outputs/NDVI_plot.png", res=300, width=3000, height=2000)
par(mfrow=c(1,2))
plot(NDVI2000_def, main="NDVI in 2000", col=cln)
plot(NDVI2020_def, main="NDVI in 2020", col=cln)
dev.off()

# difference between NDVI 2000 and 2020. positive values where higher in 2000 and viceversa
NDVIdif <- NDVI2000_def - NDVI2020_def
dev.off()
plot(NDVIdif, col=cld, main= "Difference between NDVI in 2000 and 2020")
# export
png("outputs/NDVI_dif.png", res=300, width=3000, height=3000)
plot(NDVIdif, col=cld, main= "Difference between NDVI in 2000 and 2020")
dev.off()

# now let's plot together all the variables, FCOVER, LAI, and NDVI, in 2000, 2020 and the differences
par(mfrow=c(3, 3))
plot(FCOVER2000, main = "Forest cover in 2000", col = clg)
plot(FCOVER2020, main = "Forest cover in 2020", col = clg)
plot(dif, col=cld, main="difference between fcover of 2012 and 2020")
plot(LAI_2000, col=ck, main = "Leaf Area Index in 2000")
plot(LAI_2020, col=ck, main = "Leaf Area Index in 2020")
plot(LAIdif, col=cld,  main = "Difference between LAI in 2000 and 2020")
plot(NDVI2000_def, main="NDVI in 2014", col=cln)
plot(NDVI2020_def, main="NDVI in 2020", col=cln)
plot(NDVIdif, col=cld, main= "Difference between NDVI in 2000 and 2020")
#export
png("outputs/all_variables.png", res=300, width=3000, height=3000)
par(mfrow=c(3, 3))
plot(FCOVER2000, main = "Forest cover in 2000", col = clg)
plot(FCOVER2020, main = "Forest cover in 2020", col = clg)
plot(dif, col=cld, main="Difference between fcover of 2012 and 2020")
plot(LAI_2000, col=ck, main = "Leaf Area Index in 2000")
plot(LAI_2020, col=ck, main = "Leaf Area Index in 2020")
plot(LAIdif, col=cld, main = "Difference between LAI in 2000 and 2020")
plot(NDVI2000_def, main="NDVI in 2014", col=cln)
plot(NDVI2020_def, main="NDVI in 2020", col=cln)
plot(NDVIdif, col=cld, main= "Difference between NDVI in 2000 and 2020")
dev.off()


######################## Analysis of the main deforested area ############################
# from these comparison, mainly from LAI and FCOVER, we can understand which is the most deforested area
# let's crop on that by applying crop function and the new extent to fcover_rast, the list of the 11 imported FCOVER images
ext2 <- c(-56, -50, -26, -20) # coordinate of the most deforested area
FCOVERcrop2 <- lapply(fcover_rast, crop, ext2)
FCOVERcrop2
names(FCOVERcrop2) <- c("FCOVER.1","FCOVER.2","FCOVER.3","FCOVER.4", "FCOVER.5", "FCOVER.6", "FCOVER.7", "FCOVER.8", "FCOVER.9", "FCOVER.10", "FCOVER.11")
FC2000_crop2 <- FCOVERcrop2$FCOVER.1
FC2020_crop2 <- FCOVERcrop2$FCOVER.11
# compare fcover of the main deforested area between 2000 and 2020
par(mfrow=c(1,2))
plot(FC2000_crop2, main="FCOVER 2000")
plot(FC2020_crop2, main="FCOVER, 2020")
#export
png("outputs/fcover_2000-2020_crop2.png", res=300, width=3000, height=2000)
par(mfrow=c(1,2))
plot(FC2000_crop2, main="FCOVER 2000")
plot(FC2020_crop2, main="FCOVER, 2020")
dev.off()

# plot fcover between 2000 and 2020 in that area with a scatterplot
dev.off()
plot(FC2000_crop2, FC2020_crop2, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2020")
abline(0,1, col="red")
# export
png("outputs/fcover_regressionmod.png", res = 300, width = 3000, height = 3000)
plot(FC2000_crop2, FC2020_crop2, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2020", main = "scatterplot fcover 2000-2020 crop2")
abline(0,1, col="red")
dev.off()

# analyze the frequency distribution of fcover values with histograms
par(mfrow=c(1,2))
hist(FC2000_crop2,  main="Frequency distribution FCOVER data in 2000", ylim= c(0, 80000), xlab = "FCOVER 2000", col = "plum3")
hist(FC2020_crop2,  main="Frequency distribution FCOVER data in 2020", ylim= c(0, 80000), xlab = "FCOVER 2020", col = "plum3")
#export
png("outputs/fcover_hist.png", res=300, width=3000, height=3000)
par(mfrow=c(1,2))
hist(FC2000_crop2,  main="Frequency distribution FCOVER data in 2000", ylim= c(0, 80000), xlab = "FCOVER 2000", col = "plum3")
hist(FC2020_crop2,  main="Frequency distribution FCOVER data in 2020", ylim= c(0, 80000), xlab = "FCOVER 2020", col = "plum3")
dev.off()

# unsuperClass function to each layer to divide it in 2 possible values, that will represent mainly high and low cover values
fcover_class <- lapply(FCOVERcrop2, unsuperClass, nClasses = 2)
dev.off()
plot(fcover_class[[1]]$map) #let's plot one map to check the classes
# export
png("outputs/fcover_classes.png", res=300, width=3000, height=3000)
plot(fcover_class[[1]]$map)
dev.off()

# calculate the frequencies of the 2 values for each layer (year)
y <- NULL # create an empty vector in which storing output values
for(i in 1:11) {
  frequency <- freq(fcover_class[[i]]$map)
  y <- rbind(y, frequency)
}
total <- sum(y[1:2,2]) # calculate the total n of pixel of each layer
proportions <- y[, 2]/total*100 # divide each frequency for the total (*100 to get the %)
proportions
# in 2000 55% of high cover and 45% of low cover
# in 2020 37% of high cover and 63% of low cover
cover <- c("high", "low")
prop2000 <- c(55, 45)
proportion2000 <- data.frame(cover, prop2000)
c1 <- ggplot(proportion2000, aes(x=cover, y=prop2000, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,100) + labs(title="cover proportions in 2000", y = "%")
prop2020 <- c(37, 63)
proportion2020 <- data.frame(cover, prop2020)
c2 <- ggplot(proportion2020, aes(x=cover, y=prop2020, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,100) + labs(title="cover proportions in 2020", y = "%")
c1/c2
# export
png("outputs/proportions.png", res=300, width=2000, height=3000)
c1/c2
dev.off()

# create a vector containing just the % of high cover
high_cover_perc <- proportions[-c(2, 3, 5, 7, 9, 11, 14, 16, 17, 20, 21)] # remove from the vector the frequencies of the low cover values
year <- c(2000, 2002, 2004, 2006, 2008, 2010, 2012, 2014, 2016, 2018, 2020) # create the year vector
dat <- data.frame(year, high_cover_perc) # create a dataframe with 2 col, year and the corresponding % of high cover values
dat


############################# linear regression model ###########################
# let's represent the frequency distribution of high cover values (%)
p1 <- ggplot(dat, aes(x=year, y=high_cover_perc, color=year)) + geom_bar(stat="identity", fill = "blue") + labs( title= "Frequency distribution of high cover values (%)", x="year", y = "% of high cover values")
p1
# stat="identity" indicates that R should use the y-value given in the ggplot() function otherwise the default argument is "count", that count the number of observations based on the x-variable groupings
# export
png("outputs/geom_bar.png", res=300, width=3000, height=3000)
p1 <- ggplot(dat, aes(x=year, y=high_cover_perc)) + 
  geom_bar(stat="identity", fill = "blue") +
labs( title= "Frequency distribution of high cover values (%)", x="year", y = "% of high cover values")
p1
dev.off()
# let's plot the 2 variables to see if there is a correlation (quantitative vs quantitative variable -> scatterplot)
plot(high_cover_perc ~ year,
     main = "Correlation between year and % of high cover values" ,
     xlab = "year",
     ylab = "% of high cover values")
# it seems there is correlation: the % of high cover values decreases in time.
cor.test(high_cover_perc, year) # correlation test. p value lower then the treshold so no refuse alternative hypotesis (so there could be correlation)
# indeed cor value is -0.86 -> negative correlation, the 86% of the y variance is explained by x
# let's do a linear regression model to describe the correlation 
model <- lm(high_cover_perc ~ year, data = dat) 
model # find intercept and slope values to plot the line
abline(2218.034, -1.079, col="red")
summary_stats <- summary(model)
# export
png("outputs/model_plot.png", res=300, width=3000, height=3000)
plot(high_cover_perc ~ year,
     main = "Correlation between year and % of high cover values" ,
     xlab = "year",
     ylab = "% of high cover values")
abline(2218.034, -1.079, col="red")
dev.off()

# better represent the model with a ggplot2 using stat_smooth(method = "lm"):
lm_ggplot <- ggplot(model, aes(x = year, y = high_cover_perc)) + 
  geom_point() +
  stat_smooth(method = "lm", col = "red") +
  labs(title = paste( "MODEL:  Intercept =" ,round(model$coef[[1]], 4),
       "Slope =" ,round(model$coef[[2]], 4),
       "Adj R squared =" ,round(summary_stats$adj.r.squared, 4),
       "P value =" ,round(summary_stats$coef[2,4], 7)), 
     y = "High cover values (%)", x= "year")
lm_ggplot
#export
png("outputs/model_ggplot.png", res=300, width=3000, height=3000)
lm_ggplot
dev.off()

