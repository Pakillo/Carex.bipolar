
## Read occurrence data
library(readr)

occs <- read_csv("data-raw/monocot_30m.csv")

occs$species[occs$species == "Carex_macloviana"] <- "macloviana"
occs$species[occs$species == "Carex_magellanica"] <- "magellanica"
occs$species[occs$species == "Carex_microglochin"] <- "microglochin"

write_csv(occs, "data-raw/monocot_30m.csv")



## Prepare bioregions
library(raster)
andes <- shapefile("data-raw/bioregions/regiones_biogeo_andes3.shp")
nearctic <- shapefile("data-raw/bioregions/regiones_biogeo_andes2_nearcti.shp")
regions <- bind(andes, nearctic)

#shapefile(regions, filename = "data-raw/regions.shp")
save(regions, file = "data/regions.rda")

