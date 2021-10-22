# this is my first code in github!

# Here are the input data
# Costanza data on streams
Water <- c(100, 200, 300, 400, 500)
Water

# Marta data on fishes genomes
fishes <- c(10, 50, 60, 100, 200)
fishes

#plot the diversity of fishes (y) versus the amount of water (x)
# a function is used with arguments inside!
plot(Water, fishes)

#the data we developed can be stored in a table
#a table in R is called data frame

streams <- data.frame(Water, fishes)

#from now on we're going to import and/or export data

setwd("C:/lab/")

#let's export our table
#https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/write.table
write.table(streams, file="my_first_table.txt")

#some colleagues did send us a table. how to import it in R?
read.table("my_first_table.txt")

#let's assign it to object inside R
ducciotable <- read.table("my_first_table.txt")

#this is the first statistics for lazy beautiful paople
summary(ducciotable)

#marta does not like water
#marta want to get info only on fishes
summary(ducciotable$fishes)

# let's histogram fishes data
hist(ducciotable$fishes)
#let's do the same with water
hist(ducciotable$Water)
