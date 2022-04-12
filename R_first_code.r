# Hello there! This is my first code in github!

# Here are the input data
# Costanza data on streams
water <- c(100, 200, 300, 400, 500)
water
# Marta data on fishes genomes
fishes <- c(10, 50, 60, 100, 200)
fishes

# Now let's graphically represent the diversity of fishes (y) versus the amount of water (x)
# the plot() function is used with arguments inside, that are our variables x and y!
plot(water, fishes) # the first argument u put inside the brackets will be the x

# the data developped can be stored in a table, that in R is called data frame
# to build it let's use the data.frame() function, as usual inside () there are the arguments that are our variables x and y
# let's store the data frame into the object "streams"
streams <- data.frame(water, fishes)
streams

# from now on we're going to import and/or export data. There fore we need to set the working directory
# they will tell R where to export or import the file in our computer. in this case the lab folder created
# since i've created the folder inside C: the path is C:/lab/. since we are exiting R put the path into ""
# setwd() function to set the working directory
setwd("C:/lab/")

# let's export our table
# write.table() function to export data frames. 
# the first argument is the object to be written so streams.  our file that must be a matrix or a data frame. if not R will coerce it into a data frame
# the second argument is the name that the fille will end up with in our folder
# NB use "" since we are exiting R
write.table(streams, file="my_first_table.txt")
# now this file is in my lab folder in txt format

# some colleagues send us a table. how to import it in R?
# in this case we need the function read.table(). the argument will be the file to import
# NB use "" since we are exiting R
read.table("my_first_table.txt")

#let's assign it to the object ducciotable inside R
ducciotable <- read.table("my_first_table.txt")

# now let's do the summary statistics of the dataframe
summary(ducciotable) # you obtain all the statistic info on the data frame: minimum value, 1st quartile, median, mean, 3rd quantile and maximum value

# marta does not like water, she wants to get info only about fishes
# to select only the fishes information from the table, link ducciotable to fishes with the symbol $
summary(ducciotable$fishes)

# let's do an histogram with fishes data. hist() function and the data as argument
hist(ducciotable$fishes)
#let's do the same with water
hist(ducciotable$Water)
