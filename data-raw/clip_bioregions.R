library(readr)
occs <- read_csv("data-raw/monocot_30m.csv")

## Keeping only one record per 50km (half degree) grid cell (as in niche overlap analyses)
library(dplyr)
occs <- distinct(occs, grid, .keep_all = TRUE)

## Now keep only records within selected biogeographical regions!
library(raster)
load("data/regions.rda")
coordinates(occs) <- c("longitude", "latitude")
projection(occs) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
occs.in <- intersect(occs, regions)
occs.in <- as.data.frame(occs.in)
locs <- dplyr::select(occs.in, -cat, -d, -longitude, -latitude)
locs <- rename(locs, longitude = grid_long, latitude = grid_lat)
write_csv(locs, "data/locs_30m.csv")

# library(dplyr)
# count(occs.in, species)
# count(occs, species)


## Now prepare background data (30 minute resolution, only within bioregions)
bioclim <- read_csv("data-raw/monocot_vars_clima_envspace_30m.csv")
coordinates(bioclim) <- c("longitude", "latitude")
projection(bioclim) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
bioclim.in <- intersect(bioclim, regions)
bioclim.pres <- as.data.frame(bioclim.in)
bioclim.pres <- dplyr::select(bioclim.pres, -cat, -d)
write_csv(bioclim.pres, "data/bioclim_pres_30m.csv")
