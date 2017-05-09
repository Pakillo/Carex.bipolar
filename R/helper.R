read_presclim <- function() {
  bioclim.pres <- list.files("C:/Users/FRS/Dropbox/GIS.layers/WORLDCLIM/Present/bio_10m/",
                             full.names = TRUE, pattern = ".bil")
  bioclim.pres <- stack(bioclim.pres)
  bioclim.pres <- crop_bioregions(bioclim.pres)
  bioclim.pres
}






read_futclim <- function(gcmdata) {  # e.g. miroc <- read_futclim("miroc5_rcp45_bio_2050")

  ras <- stack(gtools::mixedsort(
    unzip(paste0("C:/Users/FRS/Dropbox/GIS.layers/WORLDCLIM/Future/", gcmdata, ".zip"),
          exdir = tempdir())))
  names(ras) <- paste0("bio", 1:19)
  ras <- crop_bioregions(ras)
  ras

}


crop_bioregions <- function(ras) {

  load("./data/regions.rda")
  ras.crop <- crop(ras, regions)
  ras.mask <- mask(ras.crop, regions)
  ras.mask

}


combine_pred <- function(model) {

  ## load future climate
  ccsm <- read_futclim("ccsm4_rcp45_bio_2050")
  gfdl <- read_futclim("gfdl-esm2g_rcp45_bio_2050")
  giss <- read_futclim("giss-e2_rcp45_bio_2050")
  hadgem <- read_futclim("hadgem2-es_rcp45_bio_2050")
  miroc <- read_futclim("miroc5_rcp45_bio_2050")


  ## projections
  ccsm.proj <- predict(model, ccsm)
  gfdl.proj <- predict(model, gfdl)
  giss.proj <- predict(model, giss)
  hadgem.proj <- predict(model, hadgem)
  miroc.proj <- predict(model, miroc)

  projs <- stack(ccsm.proj, gfdl.proj, giss.proj, hadgem.proj, miroc.proj)
  names(projs) <- c("CCSM", "GFDL", "GISS", "HADGEM", "MIROC")

  projs



}




aggregate_preds <- function(species) {

  preds <- brick(paste0("./analyses/maxent/", species, "/", species, "_proj_fut.grd"))
  print(levelplot(preds, par.settings = viridisTheme, at = seq(0, 1, 0.1),
            main = paste0("Carex ", species, ": Suitability 2050 RCP45")) +
    layer(sp.lines(borders, lwd = 0.8, col = 'darkgray')))

  ### calculate average and sd of all 5 layers
  preds.avg <- mean(preds)
  beginCluster()
  preds.sd <- calc(preds, sd)  # sloooow
  endCluster()
  preds.summary <- stack(preds.avg, preds.sd)
  names(preds.summary) <- c("mean", "sd")
  print(levelplot(preds.summary, par.settings = viridisTheme, at = seq(0, 1, 0.1),
            main = paste0("Carex ", species, ": Suitability 2050 RCP45")) +
    layer(sp.lines(borders, lwd = 0.8, col = 'darkgray')))

  names(preds.avg) <- species
  return(preds.avg)

}
