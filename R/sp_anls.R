# Name: Nikoula, Latifah & Nikos
# Date: 8 January 2015
# Dependencies: sp, rgdal, rgeos

# the Function perform a simple spatial analysis for two input shapefiles 
# the user can perform an intersection between the inputs 
# in this example, we use places and railways as shapefiles input. 

# load libraries
library(sp)
library(rgdal)
library(rgeos)

sp_anls<- function(places, railways, type, width) { 
  # @param places is a shapefile
  # @param railways is a shapefile
  # type is the object inside shapefile where we can perform a buffer
  # width is the buffer width
  
  places <- readOGR("data/url", places)
  railways <- readOGR("data/url", railways)
  
# transform to the selected projection system
places_proj<-spTransform(places, prj_string_RD)
railways_proj<-spTransform(railways, prj_string_RD)
  
# make a subset according to the type that is specified by the user, input should be within "".
subset <- railways_proj[railways_proj$type == type, ] # type is one of fieldname in the railways shapefile
  
# perform a buffer zone for the specified subset
buffer<- gBuffer(subset, width= width, byid= TRUE)
  
# perform an intersection between the buffer object from the 2nd input with an    object in the 1st input that we want to define
a<- gIntersection(buffer,places_proj, byid=TRUE)
b<- gIntersects(buffer,places_proj, byid=TRUE)
 
# select the name of the object which intersect with the buffered object
selected<-places_proj@data[b]
  
#plot the final outputs
plot(buffer,col='lightblue' )
points(a, col="red", pch=22)
mtext(side = 3, line = 1, paste(selected[2]), cex = 0.8)
text<-print(paste("The name of the city is", selected[2], "and the population is equal to",selected[4])) 
} 