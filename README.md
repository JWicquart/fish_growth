# **Individual back-calculated size-at-age based on otoliths from Pacific coral reef fish species**



**This repository contains code and data presented in the article**:

Morat, F., Wicquart, J., Schiettekatte, N. M. D., de Synéty, G., Bienvenu, J., Casey, J. M., Brandl, S. J., Vii, J., Carlot, J., Degregori, S., Mercière, A., Fey, P., Galzin, R., Letourneur, Y., Sasal, P., Parravicini, V. (2020). Individual back-calculated size-at-age based on otoliths from Pacific coral reef fish species. _Scientific Data_, submitted.

[![Generic badge](https://img.shields.io/badge/DOI-10.6084/m9.figshare.12156159.v4-2abb9b.svg)](https://figshare.com/articles/Individual_back-calculated_size-at-age_based_on_otoliths_from_Pacific_coral_reef_fish_species/12156159/4)



## 1. How to download this project?



On the project main page on GitHub, click on the green button `Code` and then click on `Download ZIP`



## 2. Description of the project



### 2.1 Project organization

This project is divided in 4 folders:

* `data` folder contains 11 datasets (see part _2.2 Datasets description_).
* `R` folder contains 3 _R_ codes and a `functions` folder (see part _2.3 Code description_).
* `stan` folder contains 2 _stan_ codes used by the _R_ codes for Bayesian analyses. 
* `output` folder contains an HTML file including basic exploratory analyses. This file must be open in a browser and to zoom on the figure within the file, right click on the figure and open it in a new window.


### 2.2 Datasets description

The dataset **00_von-bertalanffy-literature.xlsx** corresponds to values of Von Bertalanffy growth parameters extracted from scientific literature. The column of the spreadsheet _Data_ are described in the spreadsheet _Metadata_.


The dataset **01_coral_reef_fishes_data.csv** (13 var. and 6,320 obs.) corresponds to the raw data used to generate the back-calculated size-at-age data (**02_back-calculated-size-at-age_morat-et-al.csv**), and contains the following variables:

- `family` Family
- `genus` Genus
- `species` Species
- `id` Unique code identifying each individual
- `agei` Age *i* (*years*)
- `radi` Otolith radius at age *i* (*mm*)
- `agecap` Age at capture (*years*)
- `radcap` Otolith radius at capture (*mm*)
- `lencap` Total length at capture (*mm*)
- `l0p` Total length at hatching (*mm*)
- `weight` Wet body mass at capture (*g*)
- `location` Island of the sampling
- `observer` Name of the person who realized the otolith reading


The dataset **02_back-calculated-size-at-age_morat-et-al.csv** (18 var. and 6,320 obs.) corresponds to the back-calculated size-at-age data, and contains the following variables:

- `Family` Family
- `Genus` Genus
- `Species` Species
- `ID` Unique code identifying each individual
- `Agei` Age *i* (*years*)
- `Ri` Otolith radius at age *i* (*mm*)
- `Agecpt` Age at capture (*years*)
- `Rcpt` Otolith radius at capture (*mm*)
- `Lcpt` Total length at capture (*mm*)
- `L0p` Total length at hatching (*mm*)
- `R0p` Otolith radius at hatching (*mm*)
- `Li_sp_m` Total length (mean, *mm*) at age *i* calculated by species
- `Li_sp_sd` Standard deviation around the value of `Li_sp_m`
- `Li_sploc_m` Total length (mean, *mm*) at age *i* calculated by species and location
- `Li_sploc_sd` Standard deviation around the value of `Li_sploc_m`
- `Weight` Wet body mass at capture (*g*)
- `Location` Island of the sampling
- `Observer` Name of the person who realized the otolith reading


The dataset **03_back-calculated_vbgf_fitted_sp.csv** (8 var. and 5,474 obs.) corresponds to fitted values of Von Bertalanffy growth curve based on back-calculated data by species, and contains the following variables:

- `age` Age *i* (*years*)
- `ypred_m` Mean estimated value of total length at age *i*
- `ypred_lq` Lower 95% confidence interval boundary of the `ypred_m`
- `ypred_uq` Upper 95% confidence interval boundary of the `ypred_m`
- `yrep_m` 
- `yrep_lq` 
- `yrep_uq` 
- `Species` Species


The dataset **03_back-calculated_vbgf_fitted_sploc.csv** (9 var. and 5,016 obs.) corresponds to fitted values of Von Bertalanffy growth curve based on back-calculated data by species and location, and contains the following variables:

- `age` Age *i* (*years*)
- `ypred_m` Mean estimated value of total length at age *i*
- `ypred_lq` Lower 95% confidence interval boundary of the `ypred_m`
- `ypred_uq` Upper 95% confidence interval boundary of the `ypred_m`
- `yrep_m` 
- `yrep_lq` 
- `yrep_uq` 
- `Species` Species
- `Location` Island of the sampling


The dataset **03_back-calculated_vbgf_predictions_sp.csv** (6 var. and 120 obs.) corresponds to estimated values of Von Bertalanffy growth parameters based on back-calculated data by species, and contains the following variables:

- `Species` Family
- `Agei` Age *i* (*years*)
- `Estimate`  Mean estimated value of total length at age *i*
- `Est.Error` Standard deviation around the `Estimate`
- `Q2.5` Lower 95% confidence interval boundary of the `Estimate`
- `Q97.5` Upper 95% confidence interval boundary of the `Estimate`


The dataset **03_back-calculated_vbgf_predictions_sploc.csv** (7 var. and 159 obs.) corresponds to estimated values of Von Bertalanffy growth parameters based on back-calculated data by species and location, and contains the following variables:

- `Species` Family
- `Location` Island of the sampling
- `Agei` Age *i* (*years*)
- `Estimate`  Mean estimated value of total length at age *i*
- `Est.Error` Standard deviation around the `Estimate`
- `Q2.5` Lower 95% confidence interval boundary of the `Estimate`
- `Q97.5` Upper 95% confidence interval boundary of the `Estimate`


The dataset **03_raw_vbgf_fitted_sp.csv** (6 var. and 5,196 obs.) corresponds to fitted values of Von Bertalanffy growth curve based on raw data (age estimated and length at capture) by species, and contains the following variables:

- `Species` Species
- `Agei` Age *i* (*years*)
- `Estimate` Mean estimated value of total length at age *i*
- `Est.Error` Standard deviation around the `Estimate`
- `Q2.5` Lower 95% confidence interval boundary of the `Estimate`
- `Q97.5` Upper 95% confidence interval boundary of the `Estimate`


The dataset **03_raw_vbgf_fitted_sploc.csv** (7 var. and 4,828 obs.) corresponds to fitted values of Von Bertalanffy growth curve based on raw data (age estimated and length at capture) by species, and contains the following variables:

- `Species` Species
- `Location` Island of the sampling
- `Agei` Age *i* (*years*)
- `Estimate` Mean estimated value of total length at age *i*
- `Est.Error` Standard deviation around the `Estimate`
- `Q2.5` Lower 95% confidence interval boundary of the `Estimate`
- `Q97.5` Upper 95% confidence interval boundary of the `Estimate`


The dataset **03_back-calculated_vbgf_predictions_sp.csv** (6 var. and 108 obs.) corresponds to estimated values of Von Bertalanffy growth parameters based on raw data (age estimated and length at capture) by species, and contains the following variables:

- `Species` Species
- `Agei` Age *i* (*years*)
- `Estimate` Mean estimated value of total length at age *i*
- `Est.Error` Standard deviation around the `Estimate`
- `Q2.5` Lower 95% confidence interval boundary of the `Estimate`
- `Q97.5` Upper 95% confidence interval boundary of the `Estimate`


The dataset **03_back-calculated_vbgf_predictions_sploc.csv** (7 var. and 114 obs.) corresponds to estimated values of Von Bertalanffy growth parameters based on raw data (age estimated and length at capture) by species and location, and contains the following variables:

- `Species` Species
- `Location` Island of the sampling
- `Agei` Age *i* (*years*)
- `Estimate` Mean estimated value of total length at age *i*
- `Est.Error` Standard deviation around the `Estimate`
- `Q2.5` Lower 95% confidence interval boundary of the `Estimate`
- `Q97.5` Upper 95% confidence interval boundary of the `Estimate`


### 2.3 Code description


* The _02_back_calculation.R_ code is used to obtain the back-calculated size-at-age.

* The codes _03_vbgf_back_calculated_sp.R_, _03_vbgf_back_calculated_sploc.R_, _03_vbgf_raw_sp.R_ and _03_vbgf_raw_sploc.R_ are respectively used to obtain Von Bertalanffy growth parameters and fitted values with back-calculated data by species, by species and location, with raw data by species, and by species and location. 

* The `functions` folder contains the function _graphical_par.R_ and _theme_graph.R_ which are functions dedicated to graphical representations. The function _bcalc_bayes.R_ is used to fit Von Bertalanffy growth model, the function _growthreg.R_ is used to [...] and the function _pred_vbgf.R_ is used to fit Von Bertalanffy growth curves from values of the three parameters.


### 2.4 How to reproduce the final datasets?

To reproduce the 8 final datasets (*i.e.* those starting by _03_), open and run successively the R codes _02_back_calculation.R_, and all the _R_ codes starting by _03_. Make sure that all required packages were previously installed. Due to the elevated number of iterations from the Bayesian model, the codes necessitate an important amount of time to run. Please note that a full reproduction of the results is not possible, as Bayesian estimations are different at each run.



## 3. How to report issues?



Please report any bugs or issues [HERE](https://github.com/JWicquart/fish_growth/issues).



## 4. Reproducibility parameters



```R
## R version 3.6.3 (2020-02-29)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 10 x64 (build 18362)
## 
## Matrix products: default
## 
## locale:
## [1] LC_COLLATE=French_France.1252  LC_CTYPE=French_France.1252   
## [3] LC_MONETARY=French_France.1252 LC_NUMERIC=C                  
## [5] LC_TIME=French_France.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] rstan_2.19.3         StanHeaders_2.21.0-1 forcats_0.5.0       
##  [4] stringr_1.4.0        dplyr_0.8.4          purrr_0.3.3         
##  [7] readr_1.3.1          tidyr_1.0.2          tibble_2.1.3        
## [10] ggplot2_3.2.1        tidyverse_1.3.0      plyr_1.8.6          

## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.3         lubridate_1.7.4    lattice_0.20-38    prettyunits_1.1.1 
##  [5] ps_1.3.2           assertthat_0.2.1   digest_0.6.25      R6_2.4.1          
##  [9] cellranger_1.1.0   backports_1.1.5    reprex_0.3.0       stats4_3.6.3      
## [13] evaluate_0.14      httr_1.4.1         pillar_1.4.3       rlang_0.4.5       
## [17] lazyeval_0.2.2     readxl_1.3.1       rstudioapi_0.11    callr_3.4.2       
## [21] rmarkdown_2.1      loo_2.2.0          munsell_0.5.0      broom_0.5.5       
## [25] compiler_3.6.3     modelr_0.1.6       xfun_0.12          pkgconfig_2.0.3   
## [29] pkgbuild_1.0.6     htmltools_0.4.0    tidyselect_1.0.0   gridExtra_2.3     
## [33] codetools_0.2-16   matrixStats_0.55.0 fansi_0.4.1        crayon_1.3.4      
## [37] dbplyr_1.4.2       withr_2.1.2        grid_3.6.3         nlme_3.1-144      
## [41] jsonlite_1.6.1     gtable_0.3.0       lifecycle_0.1.0    DBI_1.1.0         
## [45] magrittr_1.5       scales_1.1.0       cli_2.0.2          stringi_1.4.6     
## [49] fs_1.3.1           xml2_1.2.2         generics_0.0.2     vctrs_0.2.3       
## [53] tools_3.6.3        glue_1.3.1         hms_0.5.3          parallel_3.6.3    
## [57] processx_3.4.2     yaml_2.2.1         inline_0.3.15      colorspace_1.4-1  
## [61] rvest_0.3.5        knitr_1.28         haven_2.2.0  
```