library(readr)

occs <- read_csv("data-raw/monocot_30m.csv")

occs$species[occs$species == "Carex_macloviana"] <- "macloviana"
occs$species[occs$species == "Carex_magellanica"] <- "magellanica"
occs$species[occs$species == "Carex_microglochin"] <- "microglochin"

write_csv(occs, "data-raw/monocot_30m.csv")
