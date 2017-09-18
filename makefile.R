

library(Carex.bipolar)  # load to access package functions
library(rmarkdown)

### Data prep (run only once) ###

#source("data-raw/dataprep.R")
#source("data-raw/clip_bioregions.R")

############

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


