# this is my first code in github!

# Here are the input data
# Costanza data on streams
Water <- c(100, 200, 300, 400, 500)
water

# Marta data on fishes genomes
fishes <- c(10, 50, 60, 100, 200)
fishes

#plot the diversity of fishes (y) versus the amount of water (x)
# a function is used with arguments inside!
plot(Water, fishes)

#the data we developed can be stored in a table
#a table in R is called data frame

streams <- data.frame(Water, fishes)
