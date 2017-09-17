

library(Carex.bipolar)  # load to access package functions


### Data prep (run only once) ###

#source("data-raw/dataprep.R")
#source("data-raw/clip_bioregions.R")

############

library(rmarkdown)

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

#### Fig Future Suitability ####
render("manuscript/figures/Fig_suitability_2050_code.Rmd")



## Calculate SD of predictions for RCP4.5 and RCP8.5 (Suppl Fig)

## Calculate difference Future - Present for both RCP4.5 and RCP8.5 (based on mean) - Suppl Fig
