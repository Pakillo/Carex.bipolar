
##### INSTALLING AND LOADING PACKAGE ####

#if (!require(Carex.bipolar)) devtools::install_github("Pakillo/Carex.bipolar")

library(Carex.bipolar)  # load to access package functions


#### RECREATE PACKAGE ENVIRONMENT ######################

good.date <- "2017-09-19"

## Run line below to recreate package environment for that date ##
## Packages will be downloaded to a local folder ("~/.checkpoint")
# checkpoint::checkpoint(snapshotDate = good.date, use.knitr = TRUE)


## Now install other external packages (not on CRAN)
## NB. pkgs installed to .libPaths() = "~/.checkpoint"
## so this doesn't mess with local user library
# install.packages("dependencies/rSDM_0.3.7.tar.gz", repos = NULL, type = "source")

# Run line below to delete the folder ("~/.checkpoint") containing these package versions
# unlink("~/.checkpoint", recursive = FALSE)

# R version used: 3.4.1
# Restart R session to come back to standard user library afterwards




#######################################################

### Data prep (run only once) ###

#source("data-raw/dataprep.R")
#source("data-raw/clip_bioregions.R")

###################################################


### ANALYSES ####

spp <- c("allspp", "canescens", "macloviana", "magellanica", "maritima",
         "microglochin")


### Use ENMeval to choose best models ###

for (i in spp) {
  species <- i
  render(input = "analyses/fullspp_ENMeval.Rmd",
         output_dir = file.path("analyses/output/fullspp_ENMeval", species),
         output_file = paste0(species, ".html"))
}


#### Make predictions for present and future based on best Maxent models ####
for (i in spp) {
  species <- i
  render(input = "analyses/fullspp_predictions.Rmd",
         output_dir = file.path("analyses/output/fullspp_predictions", species),
         output_file = paste0(species, ".html"))
}




#### Fig 1: occurrence map ####
render("manuscript/figures/Fig1_occmap.Rmd")

#### Fig Present Suitability ####
render("manuscript/figures/Fig_suitability_present_code.Rmd")

#### Figs Future Suitability ####
render("manuscript/figures/Fig_suitability_2050_code.Rmd")


