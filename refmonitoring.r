### let's give it a try with my exam project on monitoring the reforestation projects in brazil

setwd("C:/lab/play/refmonitoring")
library(raster)


rlist <- list.files(pattern = "c_gls_FCOVER")
list_rast <- lapply(rlist, raster)

FCOVERstack <- stack(list_rast)
plot(FCOVERstack)

ext <- c(-50, -40, -20, -15)
FCOVERcrop <- crop(FCOVERstack, ext)
plot(FCOVERcrop)

