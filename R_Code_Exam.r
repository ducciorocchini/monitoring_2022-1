### exam project on monitoring the reforestation projects of the Brazilian atlantic forest

# set the working directories
setwd("C:/lab/exam")

# let's recall the the packages needed
library(ncdf4) # to read and manage nc files from Copernicus
library(raster) # to manage raster file (single layer files)
library(ggplot2) # for ggplots
library(viridis) # colorblind friendly palettes 
# in the paper is mentioned the viridis palette: exactly the palette in we use R. it is very similar, despite the color vision deseases; the scale is mantained
# thanks to this palette even people with disease will not see the esact colors but will at least discriminate between minimukm and maximum
# also cividis is a good inclusive palette
library(patchwork) # to build a multiframe 
library(gridExtra) # to create multiframe ggplot
library(RColorBrewer) # to use brewer palettes
library(RStoolbox) # to unsuperclass

# create a list of the FCOVER files to apply raster function to the list and import all the files in one shot
fcover_list <- list.files(pattern = "c_gls_FCOVER_")
fcover_list
fcover_rast <- lapply(fcover_list, raster)
fcover_rast
# 11 filest imported as raster layers, forest cover from 2000 to 2020, at intervals of 2 years
# create a stack of the raster files
fcover_stack <- stack(fcover_rast)
fcover_stack

# now let's crop on the brazilian atlantic forest
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

# now let's focus just on the FCOVER of 2000 and 2020, the other layers will be used later for quantitative estimate and linear model
# assign these 2 layers to an object to manage and call them more easily
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

# plot with a scale of green to give the idea of the vegetation cover
# using RColorBrewer package and the sequential palette YG1n
clg <- brewer.pal(n=9, name="YlGn") # with n being the n of colors in the palette and mame the name of the palette
par(mfrow=c(1, 2))
plot(FCOVER2000, main= "Forest cover in 2000", col = clg)
plot(FCOVER2020, main= "Forest cover in 2020", col = clg)
# export
png("outputs/plot_fcover_2000_2020_greenscale.png", res= 300, width=3000, height=2000)
par(mfrow=c(1, 2))
plot(FCOVER2000, main= "Forest cover in 2000", col = clg)
plot(FCOVER2020, main= "Forest cover in 2020", col = clg)
dev.off()

# let's make a ggplot. first convert in dataframes
FC2000_dat <- as.data.frame(FCOVER2000, xy = TRUE)
FC2020_dat <- as.data.frame(FCOVER2020, xy = TRUE)

g1 <- ggplot() + geom_raster(FC2000_dat, mapping = aes(x=x, y=y, fill=FCOVER.00)) + scale_fill_viridis(option = "turbo") + ggtitle("Forest cover in 2000") + labs(fill = "FCOVER")
g2 <- ggplot() + geom_raster(FC2020_dat, mapping = aes(x=x, y=y, fill=FCOVER.20)) + scale_fill_viridis(option = "turbo") + ggtitle("Forest cover in 2020") + labs(fill = "FCOVER")
# viridis: color scales in this package allows to make plots that are pretty, better represent your data, easier to read by those with colorblindness, and print well in gray scale.
# thanks to these palettes even people with disease will not see the exact colors but will at least discriminate between minimukm and maximum
# so very inclusive palettes!!!
grid.arrange(g1, g2, nrow=1)
# or through patchwork package g1 + g2

# export
png("outputs/fcover_ggplot.png", res=300, width = 4000, height= 3000)
grid.arrange(g1, g2, nrow=1)
dev.off()


# difference in FCOVER between 2000 nad 2020
dif <- FCOVER2000 - FCOVER2020
cld <- brewer.pal(n=11, name="BrBG")
dev.off()
plot(dif, col =  cld, main="Forest Cover differences between 2000 and 2020")

# export
png("outputs/fcover_dif.png", res = 300, width = 3000, height = 3000)
plot(dif, col=cld, main="Forest Cover differences between 2000 and 2020")
dev.off()




################# Leaf Area Index ###################
LAI_list <- list.files(pattern = "c_gls_LAI")
LAI_list
LAI_rast <- lapply(LAI_list, raster)
LAI_rast
LAI_stack <- stack(LAI_rast)
LAI_stack

# let's crop again on the area of interest
LAIcrop <- crop(LAI_stack, ext)
#assigning names to the layers
names(LAIcrop) <- c("LAI.1", "LAI.2")
# assign each layer to an object to make them more manageble
LAI_2000 <- LAIcrop$LAI.1
LAI_2020 <- LAIcrop$LAI.2


ck <- brewer.pal(n=9, name="GnBu") # create a palette to plot LAI
par(mfrow=c(1, 2))
plot(LAI_2000, col=ck, main = "Leaf Area Index in 2000")
plot(LAI_2020, col=ck, main = "Leaf Area Index in 2020")

# export
png("outputs/LAI_plot.png", res=300, width=3000, height=2000)
par(mfrow=c(1, 2))
plot(LAI_2000, col=ck, main = "Leaf Area Index in 2000")
plot(LAI_2020, col=ck, main = "Leaf Area Index in 2020")
dev.off()

# let's make a ggplot
LAI_2000_df <- as.data.frame(LAI_2000, xy=TRUE)
LAI_2020_df <- as.data.frame(LAI_2020, xy=TRUE)

LAIg1 <- ggplot() + geom_raster(LAI_2000_df, mapping = aes(x=x, y=y, fill=LAI.1)) + scale_fill_viridis(option ="mako") + ggtitle("Leaf Area Index in 2000") + labs(fill = "LAI")
LAIg2 <- ggplot() + geom_raster(LAI_2020_df, mapping = aes(x=x, y=y, fill=LAI.2)) + scale_fill_viridis(option ="mako") + ggtitle("Leaf Area Index in 2020") + labs(fill = "LAI")

LAIg1 + LAIg2 

#export
png("outputs/LAI_ggplot.png", res=250, width=6000, height=3000)
LAIg1 + LAIg2
dev.off()

# difference in LAI between 2000 and 2020
LAIdif <- LAI_2000 - LAI_2020
ckj <- brewer.pal(n=11, name="RdYlBu")
dev.off()
plot(LAIdif, main= "Differences in Leaf Area Index between 2000 and 2020", col=ckj)


# export
png("outputs/LAI_dif.png", res = 300, width = 3000, height = 3000)
plot(LAIdif, main= "Differences in Leaf Area Index between 2000 and 2020", col=ckj)
dev.off()

# let's use this function that return a plot matrix, consisting of scatter plots corresponding to each data frame
pairs(LAIcrop)

# export
png("outputs/LAI_pairs.png", res=300, width=3000, height=3000)
pairs(LAIcrop)
dev.off()




#################### NDVI #############################
NDVI_list <- list.files(pattern="NDVI")
NDVI_list
NDVI_rast <- lapply(NDVI_list, raster)
NDVI_rast
NDVI_stack <- stack(NDVI_rast)
NDVI_stack

# crop on the area of interest
NDVIcrop <- crop(NDVI_stack, ext)
plot(NDVIcrop)

plotRGB(NDVIcrop, r=1, g=2, b=3, stretch="Lin")
plotRGB(NDVIcrop, r=2, g=1, b=3, stretch="Lin")
plotRGB(NDVIcrop, r=2, g=2, b=1, stretch="Lin")
png("outputs/NDVI_RGB.png", res=300, width=3000, height=3000)


names(NDVIcrop) <- c("NDVI.1", "NDVI.2", "NDVI.3")
NDVI2000 <- NDVIcrop$NDVI.1
NDVI2010 <- NDVIcrop$NDVI.2
NDVI2020 <- NDVIcrop$NDVI.3

#click(NDVI2014)
NDVI2000_def <- calc(NDVI2000, fun=function(x){x[x>0.935] <- NA;return(x)})
NDVI2020_def <- calc(NDVI2020, fun=function(x){x[x>0.935] <- NA;return(x)})

cln <- brewer.pal(n=11, name="RdYlGn")
par(mfrow=c(1,2))
plot(NDVI2000_def, main="NDVI in 2000", col=cln)
plot(NDVI2020_def, main="NDVI in 2020", col=cln)


NDVIdif <- NDVI2000_def - NDVI2020_def
plot(NDVIdif, col=cld)

par(mfrow=c(3, 3))
plot(FCOVER2000, main = "Forest cover in 2000", col = clg)
plot(FCOVER2020, main = "Forest cover in 2020", col = clg)
plot(dif, col=cld, main="difference between fcover of 2012 and 2020")
plot(LAI_2000, col=ck, main = "Leaf Area Index in 2000")
plot(LAI_2020, col=ck, main = "Leaf Area Index in 2020")
plot(LAIdif, col=ckj)
plot(NDVI2000_def, main="NDVI in 2014", col=cln)
plot(NDVI2020_def, main="NDVI in 2020", col=cln)
plot(NDVIdif, col=cld)














ext2 <- c(-57, -52, -27, -21)
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

png("outputs/unsuperclass.png", res=300, width=3000, height = 3000)
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
dev.off()


freq(Fclass2000$map)
#     value  count
#[1,]     1 172446
#[2,]     2 203874 high
# calculate the total (excluding NA) to calculate the proportion of high cover
total <- 203874 + 172446
high_prop_00 <- 203874/total

freq(Fclass2002$map)
#    value count
#[1,]    1 198890 high
#[2,]    2 177430
high_prop_02 <- 198890/total

freq(Fclass2004$map)
#     value  count
#[1,]     1 216431
#[2,]     2 159889 high
high_prop_04 <- 159889/total

freq(Fclass2006$map)
#     value  count
#[1,]     1 174687 high
#[2,]     2 201633 
high_prop_06 <- 174687/total

freq(Fclass2008$map)
#     value  count
#[1,]     1 226168
#[2,]     2 150152 high
high_prop_08 <- 150152/total

freq(Fclass2010$map)
#     value  count
#[1,]     1 205295
#[2,]     2 171025 high
high_prop_10 <- 171025 /total

freq(Fclass2012$map)
#     value  count
#[1,]     1 189433
#[2,]     2 186887 high
high_prop_12 <- 186887/total

freq(Fclass2014$map)
#     value  count
#[1,]     1 195527
#[2,]     2 180793 high
high_prop_14 <- 180793/total

freq(Fclass2016$map)
#     value  count
#[1,]     1 160449 high
#[2,]     2 215871
high_prop_16 <- 160449/total

freq(Fclass2018$map)
#   value  count
#[1,]     1 141316 high
#[2,]     2 235004
high_prop_18 <- 141316/total

freq(Fclass2020$map)
     value  count
[1,]     1 231661
[2,]     2 144659 high
high_prop_20 <- 144659/total

high_prop <- c(high_prop_00, high_prop_02, high_prop_04, high_prop_06, high_prop_08, high_prop_10, high_prop_12, high_prop_14, high_prop_16, high_prop_18, high_prop_20)
year <- c(2000, 2002, 2004, 2006, 2008, 2010, 2012, 2014, 2016, 2018, 2020)
dat <- data.frame(year, high_prop)
model <- lm(year~high_prop)
plot(high_prop ~ year)
cor.test(high_prop, year)
abline(2046.33, -80.31)
# no correlation
# prediction








FCOVERcrop2 <- lapply(list_rast, crop, ext2)
FCOVERcrop2



# compare fcover between 2000 and 2020 with a linear regression model (scatterplot)
plot(FC2000_crop2, FC2020_crop2, xlim = c(0,1), ylim = c(0, 1), xlab = "FCOVER 2000", ylab="FCOVER 2020")
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

fcover_class <- lapply(FCOVERcrop2, unsuperClass, nClasses = 2)
plot(fcover_class[[1]]$map)

y <- NULL # create an empty vector to be used for creating a matrix for storing output values (frequencies) of the for loop
for(i in 1:11) {  # calculating the frequencies of each clustered raster layer = for each year
  frequency <- freq(fcover_class[[i]]$map)
  y <- rbind(y, frequency)
}

area <- sum(y[1:2,2])
percentages <- y[, 2]/area*100
percentages <- percentages[-c(1, 3, 5, 7, 10, 12, 14, 15, 17, 20, 22)]
year <- c(2000, 2002, 2004, 2006, 2008, 2010, 2012, 2014, 2016, 2018, 2020)
dat <- data.frame(year, high_prop)


p1 <- ggplot(dataset, aes(x=year, y=percentages)) + 
  geom_bar(stat="identity", fill = "blue") 
p1

model <- lm(percentages~year, data = dat) # create a linear model to describe the correlation between time and percentages
summary(model)


p2 <- ggplot(model, aes(x = year, y = percentages)) + # plot the linear model, visualize the % variation through time with fitted linear model
  geom_point() +
  stat_smooth(method = "lm", col = "red")
print(p2 + labs(title = "Linear model plot", y = "Snow cover (%)", x = "Year"))

f <- as.data.frame(c(2030, 2040)) # create a vector for predict function as to predict the snow cover values for 2030 and 2040
colnames(f) <- "year" 
prediction <- predict(model, newdata = f) 



