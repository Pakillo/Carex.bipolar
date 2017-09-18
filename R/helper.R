#' Load present climate
#'
#' Load current climate layers from my hard drive (note path is hard-coded).
#'
#' @return A raster stack, cropped by bioregions.
#' @export
#' @import raster
read_presclim <- function() {
  bioclim.pres <- list.files("C:/Users/FRS/Dropbox/GIS.layers/WORLDCLIM/Present/bio_10m/",
                             full.names = TRUE, pattern = ".bil")
  bioclim.pres <- stack(bioclim.pres)
  bioclim.pres <- aggregate(bioclim.pres, fact = 3, fun = mean)
  bioclim.pres <- crop_bioregions(bioclim.pres)
  bioclim.pres
}






#' Read future climate layers
#'
#' @details Note path to GIS layers is hard-coded.
#'
#' @param gcmdata character Model and scenario (e.g. "miroc5_rcp45_bio_2050").
#'
#' @return A raster stack, cropped by bioregions.
#' @export
#' @import raster
#' @importFrom gtools mixedsort
read_futclim <- function(gcmdata) {  # e.g. miroc <- read_futclim("miroc5_rcp45_bio_2050")

  ras <- stack(gtools::mixedsort(
    unzip(paste0("C:/Users/FRS/Dropbox/GIS.layers/WORLDCLIM/Future/", gcmdata, ".zip"),
          exdir = tempdir())))
  names(ras) <- paste0("bio", 1:19)
  ras <- aggregate(ras, fact = 3, fun = mean)  # reduce resolution to 30 minutes
  ras <- crop_bioregions(ras)
  ras

}


#' Crop raster by bioregions
#'
#' @param ras Raster* object
#'
#' @return Cropped Raster* object.
#' @export
#' @import raster
crop_bioregions <- function(ras) {

  data(regions)
  ras.crop <- crop(ras, regions)
  ras.mask <- mask(ras.crop, regions)
  ras.mask

}



#' Read present suitability raster for all species
#'
#' @return A RasterStack with the present potential distribution of all species according to Maxent models.
#' @export
#' @import raster
#'

read_pres_suitab <- function() {

  root <- rprojroot::find_rstudio_root_file()
  spp <- c("canescens", "macloviana", "magellanica", "maritima",
           "microglochin", "allspp")
  ras <- list()
  for (i in 1:6) {
    ras[[i]] <- raster(paste0(root, "/analyses/output/fullspp_predictions/", spp[i], "/", spp[i], "_proj_pres.grd"))
  }
  pres.suitab <- stack(ras)
  names(pres.suitab) <- c(spp[1:5], "all species")
  pres.suitab

}




#' Combine future predictions from a Maxent model
#'
#' @param model A maxent model, as created by dismo.
#' @param scenario Character. Either "rcp45" or "rcp85".
#'
#' @return A rasterstack.
#' @export
#' @import raster
#' @import dismo
combine_pred <- function(model, scenario) {

  ## load future climate

  if (scenario == "rcp45") {
    ccsm <- read_futclim("ccsm4_rcp45_bio_2050")
    gfdl <- read_futclim("gfdl-cm3_rcp45_bio_2050")
    giss <- read_futclim("giss-e2_rcp45_bio_2050")
    hadgem <- read_futclim("hadgem2-es_rcp45_bio_2050")
    miroc <- read_futclim("miroc5_rcp45_bio_2050")
  }

  if (scenario == "rcp85") {
    ccsm <- read_futclim("ccsm4_rcp85_bio_2050")
    gfdl <- read_futclim("gfdl-cm3_rcp85_bio_2050")
    giss <- read_futclim("giss-e2_rcp85_bio_2050")
    hadgem <- read_futclim("hadgem2-es_rcp85_bio_2050")
    miroc <- read_futclim("miroc5_rcp85_bio_2050")
  }



  ## projections
  ccsm.proj <- predict(model, ccsm, args = c("outputformat=logistic"))
  gfdl.proj <- predict(model, gfdl, args = c("outputformat=logistic"))
  giss.proj <- predict(model, giss, args = c("outputformat=logistic"))
  hadgem.proj <- predict(model, hadgem, args = c("outputformat=logistic"))
  miroc.proj <- predict(model, miroc, args = c("outputformat=logistic"))

  projs <- stack(ccsm.proj, gfdl.proj, giss.proj, hadgem.proj, miroc.proj)
  names(projs) <- c("CCSM", "GFDL", "GISS", "HADGEM", "MIROC")

  projs



}




#' Aggregate future predictions: Calculate ensemble mean
#'
#' @param species character Species name, as specified when fitting Maxent models.
#' @param scenario Character. Either "rcp45" or "rcp85".
#'
#' @return A RasterLayer with the predicted average suitability per species.
#' @export
#' @import raster
#' @import rasterVis
#' @importFrom rprojroot find_rstudio_root_file
ensemble_mean <- function(species, scenario) {

  root <- rprojroot::find_rstudio_root_file()
  borders <- rnaturalearth::ne_coastline(scale = 'small', returnclass = "sp")

  preds <- brick(paste0(root, "/analyses/output/fullspp_predictions/", species, "/", species, "_proj_", scenario, ".grd"))

  print(levelplot(preds, par.settings = viridisTheme, at = seq(0, 1, 0.1),
            main = paste0("Carex ", species, ": Suitability 2050 ", scenario)) +
    layer(sp.lines(borders, lwd = 0.8, col = 'darkgray')))

  ### calculate average of all 5 layers
  preds.avg <- mean(preds)
  names(preds.avg) <- species
  print(levelplot(preds.avg, par.settings = viridisTheme, at = seq(0, 1, 0.1),
            main = paste0("Carex ", species, ": Suitability 2050 ", scenario)) +
    layer(sp.lines(borders, lwd = 0.8, col = 'darkgray')))

  return(preds.avg)

}



#' Aggregate future predictions: Calculate ensemble standard deviation (SD)
#'
#' @param species character Species name, as specified when fitting Maxent models.
#' @param scenario Character. Either "rcp45" or "rcp85".
#'
#' @return A RasterLayer with the standard deviation of the predicted suitability among climate models.
#' @export
#' @import raster
#' @import rasterVis
#' @importFrom rprojroot find_rstudio_root_file
ensemble_sd <- function(species, scenario) {

  root <- rprojroot::find_rstudio_root_file()

  preds <- brick(paste0(root, "/analyses/output/fullspp_predictions/", species, "/", species, "_proj_", scenario, ".grd"))

  ### calculate sd of all 5 layers
  beginCluster()
  preds.sd <- calc(preds, sd)  # sloooow
  endCluster()
  names(preds.sd) <- species

  borders <- rnaturalearth::ne_coastline(scale = 'small', returnclass = "sp")
  print(levelplot(preds.sd, par.settings = viridisTheme, at = seq(0, 0.5, 0.05),
                  main = paste0("Carex ", species, ": Suitability 2050 ", scenario, " (SD)")) +
          layer(sp.lines(borders, lwd = 0.8, col = 'darkgray')))


  return(preds.sd)

}


#' Plot ensemble mean or standard deviation
#'
#' @param mean.sd character Either "mean" or "sd" to return the ensemble mean or standard deviation, respectively.
#' @param scenario Character. Either "rcp45" or "rcp85".
#'
#' @return A RasterStack and a plot.
#' @export
#' @import raster
#' @import rasterVis
plot_ensemble <- function(mean.sd, scenario) {

  spp <- c("canescens", "macloviana", "magellanica", "maritima",
           "microglochin", "allspp")

  if (mean.sd == "mean") {
    all.preds <- lapply(spp, ensemble_mean, scenario)
    maptype <- "suitab"
  }

  if (mean.sd == "sd") {
    all.preds <- lapply(spp, ensemble_sd, scenario)
    maptype = "sd"
  }

  futu.suitab <- stack(all.preds)
  names(futu.suitab) <- c(spp[1:5], "all species")

  plot6maps(futu.suitab, maptype = maptype)

  return(futu.suitab)
}



#' Compare future vs present suitability per species
#'
#' @param futu.suitab RasterStack (6 layers) containing future suitabilities per species.
#'
#' @return A plot, and a RasterStack with the difference in suitabilities (future - present)
#' @export
#' @import raster
#' @import rasterVis
#' @importFrom rnaturalearth ne_coastline
#'

compare_suitab_futu_pres <- function(futu.suitab) {

  pres.suitab <- read_pres_suitab()
  diff <- futu.suitab - pres.suitab

  plot6maps(diff, maptype = "diff")

  return(diff)

}



#' Plotting function: six maps
#'
#' @param ras RasterStack or RasterBrick with 6 layers (one per species, plus all species).
#' @param maptype Character. Either "suitab" for suitability values between 0 and 1, "sd" for plotting standard deviations (between 0 and 0.5), or "diff" for plotting differences in suitability (between -0.5 and +0.5).
#'
#' @return A plot
#' @export
#' @importFrom rnaturalearth ne_coastline
#' @import rasterVis
#'
plot6maps <- function(ras, maptype) {

  if (maptype == "suitab") zvals <- seq(0, 1, 0.1)
  if (maptype == "sd") zvals <- seq(0, 0.5, 0.05)
  if (maptype == "diff") zvals <- seq(-0.5, 0.5, 0.1)

  borders <- rnaturalearth::ne_coastline(scale = 'small', returnclass = "sp")

  print(levelplot(ras, par.settings = viridisTheme, at = zvals) +
    latticeExtra::layer(sp::sp.lines(borders, lwd = 0.8, col = 'darkgray')))

}
