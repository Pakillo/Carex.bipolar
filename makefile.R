source("R/helper.R")   # substitute this by packaging in the end!


### Data prep (run only once) ###

#source("data-raw/dataprep.R")
#source("data-raw/clip_bioregions.R")

############

library(rmarkdown)


#### Run Maxent models ####
crosval <- FALSE
spp <- c("allspp", "macloviana", "magellanica", "microglochin", "canescens", "maritima")
for (i in spp) {
  species <- i
  render(input = "analyses/models.Rmd",
         output_file = paste0(species, ".html"))
}




#### Fig 1: occurrence map ####
render("manuscript/figures/Fig1_occmap.Rmd")

#### Fig Present Suitability ####
render("manuscript/figures/Fig_suitability_present_code.Rmd")

#### Fig Future Suitability ####
render("manuscript/figures/Fig_suitability_2050_code.Rmd")

