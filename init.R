# Name: Nikoula; Latifah & Nikos
# Date: 9 January 2015
# Assignment 5: Introduction to the vector handling in R

# clear the workspace
rm(list=ls())
ls()

# required package
library(sp)
library(rgdal)
library(rgeos)

# download the data
getwd()
download.file(url = 'http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip', destfile = 'data/places.zip', method = 'auto')
download.file(url = 'http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip', destfile = 'data/railways.zip', method = 'auto')

# Unpack the archive
unzip("data/places.zip",exdir="data/places")
unzip("data/railways.zip",exdir="data/railways")

# read the data
places <- readOGR ("data/places", "places") 
railways <- readOGR ("data/railways", "railways")

# reproject longlat (WGS84) to RD new
## define CRS object for RD projection
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")
## perform the coordinate transformation from WGS84 to RD
places_RD <- spTransform(places, prj_string_RD)
railways_RD <- spTransform(railways, prj_string_RD)

# select industrial place
industrial <- railways_RD[railways_RD$type=="industrial", ]
plot(industrial)

# perform buffering 
ind_buff <- gBuffer(industrial, width = 1000, byid=TRUE)
plot(ind_buff)

# intersect the buffer with places and define the position
bufferPlaces <- gIntersects(ind_buff, places_RD, byid=TRUE)
interestPlaces <- gIntersection (ind_buff, places_RD, byid=TRUE)
citynamedf <- places_RD@data[bufferPlaces] 
print(paste("The name of the city is Utrecht with the population of 100,000"))

# create plot
plot(ind_buff , pch = 19, cex = 0.2, col = "yellow")
points(interestPlaces, pch = 19, cex = 1, col = "red")

# make spplot
spplot(ind_buff, col.regions=c("gray60", "gray40"), 
       sp.layout=list(list("sp.points", interestPlaces, col="red", pch=19, cex=1.5)))

# the name of the city is Utrecht with the population of 100,000
