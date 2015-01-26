# Name: Nikoula, Latifah & Nikos
# Date: 9 January 2015

rm(list=ls()) # clear the workspace

# load libraries
library(sp)
library(rgdal)
library(rgeos)

getwd()# make sure the data directory

# call the functions
source('R/unzipURL.R')
source('R/sp_anls.R')

# Select the url links that you want to download 
URLs <- c("http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip",               # all Netherlands Places 
          "http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip")
# all Netherlands Railways

# download and unzip the selected shapefiles
lapply(URLs, unzipURL)

# specify the projection
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")

# spatial analysis
# In this example we want to define which places are intersect with railways when we perform a buffer of 1000m width to industrial railways 
sp_anls("places", "railways", "industrial", 1000)
