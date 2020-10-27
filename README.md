# **Individual back-calculated size-at-age based on otoliths from Pacific coral reef fish species**



**This repository contains code and data presented in the article**:

[Morat, F., Wicquart, J., Schiettekatte, N. M. D., de Synéty, G., Bienvenu, J., Casey, J. M., Brandl, S. J., Vii, J., Carlot, J., Degregori, S., Mercière, A., Fey, P., Galzin, R., Letourneur, Y., Sasal, P., Parravicini, V. Individual back-calculated size-at-age based on otoliths from Pacific coral reef fish species. _Scientific Data_, 7, 370 (2020).](https://doi.org/10.1038/s41597-020-00711-y)


[![Generic badge](https://img.shields.io/badge/DOI-10.6084/m9.figshare.12156159.v5-2abb9b.svg)](https://figshare.com/articles/Individual_back-calculated_size-at-age_based_on_otoliths_from_Pacific_coral_reef_fish_species/12156159/5)



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

The dataset **00_von-bertalanffy-literature.xlsx** corresponds to values of Von Bertalanffy growth parameters extracted from scientific literature. The columns of the spreadsheet _Data_ are described in the spreadsheet _Metadata_.


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


The dataset **02_back-calculated-size-at-age_morat-et-al.csv** (18 var. and 6,320 obs.) corresponds to the dataset stored on [figshare](https://figshare.com/articles/Individual_back-calculated_size-at-age_based_on_otoliths_from_Pacific_coral_reef_fish_species/12156159/5) with the back-calculated size-at-age data, and contains the following variables:

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
- `ypred_m` Mean estimated value of total length at age *i* at population-level
- `ypred_lq` Lower 95% credible interval boundary of the `ypred_m`
- `ypred_uq` Upper 95% credible interval boundary of the `ypred_m`
- `yrep_m`  Mean estimated value of total length at age *i* at individual-level
- `yrep_lq` Lower 95% credible interval boundary of the `yrep_m`
- `yrep_uq` Upper 95% credible interval boundary of the `yrep_m`
- `Species` Species


The dataset **03_back-calculated_vbgf_fitted_sploc.csv** (9 var. and 5,016 obs.) corresponds to fitted values of Von Bertalanffy growth curve based on back-calculated data by species and location, and contains the following variables:

- `age` Age *i* (*years*)
- `ypred_m` Mean estimated value of total length at age *i* at population-level
- `ypred_lq` Lower 95% credible interval boundary of the `ypred_m`
- `ypred_uq` Upper 95% credible interval boundary of the `ypred_m`
- `yrep_m` Mean estimated value of total length at age *i* at individual-level
- `yrep_lq` Lower 95% credible interval boundary of the `yrep_m`
- `yrep_uq` Upper 95% credible interval boundary of the `yrep_m`
- `Species` Species
- `Location` Island of the sampling


The dataset **03_back-calculated_vbgf_predictions_sp.csv** (6 var. and 120 obs.) corresponds to estimated values of Von Bertalanffy growth parameters based on back-calculated data by species, and contains the following variables:

- `Species` Family
- `Agei` Age *i* (*years*)
- `Estimate`  Mean estimated value of total length at age *i*
- `Est.Error` Standard deviation around the `Estimate`
- `Q2.5` Lower 95% credible interval boundary of the `Estimate`
- `Q97.5` Upper 95% credible interval boundary of the `Estimate`


The dataset **03_back-calculated_vbgf_predictions_sploc.csv** (7 var. and 159 obs.) corresponds to estimated values of Von Bertalanffy growth parameters based on back-calculated data by species and location, and contains the following variables:

- `Species` Family
- `Location` Island of the sampling
- `Agei` Age *i* (*years*)
- `Estimate`  Mean estimated value of total length at age *i*
- `Est.Error` Standard deviation around the `Estimate`
- `Q2.5` Lower 95% credible interval boundary of the `Estimate`
- `Q97.5` Upper 95% credible interval boundary of the `Estimate`


The dataset **03_raw_vbgf_fitted_sp.csv** (6 var. and 5,196 obs.) corresponds to fitted values of Von Bertalanffy growth curve based on raw data (age estimated and length at capture) by species, and contains the following variables:

- `Species` Species
- `Agei` Age *i* (*years*)
- `Estimate` Mean estimated value of total length at age *i*
- `Est.Error` Standard deviation around the `Estimate`
- `Q2.5` Lower 95% credible interval boundary of the `Estimate`
- `Q97.5` Upper 95% credible interval boundary of the `Estimate`


The dataset **03_raw_vbgf_fitted_sploc.csv** (7 var. and 4,828 obs.) corresponds to fitted values of Von Bertalanffy growth curve based on raw data (age estimated and length at capture) by species, and contains the following variables:

- `Species` Species
- `Location` Island of the sampling
- `Agei` Age *i* (*years*)
- `Estimate` Mean estimated value of total length at age *i*
- `Est.Error` Standard deviation around the `Estimate`
- `Q2.5` Lower 95% credible interval boundary of the `Estimate`
- `Q97.5` Upper 95% credible interval boundary of the `Estimate`


The dataset **03_back-calculated_vbgf_predictions_sp.csv** (6 var. and 108 obs.) corresponds to estimated values of Von Bertalanffy growth parameters based on raw data (age estimated and length at capture) by species, and contains the following variables:

- `Species` Species
- `Agei` Age *i* (*years*)
- `Estimate` Mean estimated value of total length at age *i*
- `Est.Error` Standard deviation around the `Estimate`
- `Q2.5` Lower 95% credible interval boundary of the `Estimate`
- `Q97.5` Upper 95% credible interval boundary of the `Estimate`


The dataset **03_back-calculated_vbgf_predictions_sploc.csv** (7 var. and 114 obs.) corresponds to estimated values of Von Bertalanffy growth parameters based on raw data (age estimated and length at capture) by species and location, and contains the following variables:

- `Species` Species
- `Location` Island of the sampling
- `Agei` Age *i* (*years*)
- `Estimate` Mean estimated value of total length at age *i*
- `Est.Error` Standard deviation around the `Estimate`
- `Q2.5` Lower 95% credible interval boundary of the `Estimate`
- `Q97.5` Upper 95% credible interval boundary of the `Estimate`


### 2.3 Code description


* The _02_back_calculation.R_ code is used to obtain the back-calculated size-at-age.

* The codes _03_vbgf_back_calculated_sp.R_, _03_vbgf_back_calculated_sploc.R_, _03_vbgf_raw_sp.R_ and _03_vbgf_raw_sploc.R_ are respectively used to obtain Von Bertalanffy growth parameters and fitted values with back-calculated data by species, by species and location, with raw data by species, and by species and location. 

* The `functions` folder contains the function _graphical_par.R_ and _theme_graph.R_ which are functions dedicated to graphical representations. The function _bcalc_bayes.R_ is used to fit Von Bertalanffy growth model, the function _growthreg.R_ is used to extract growth parameters from back-calculated data and the function _pred_vbgf.R_ is used to fit Von Bertalanffy growth curves from values of the three parameters.


### 2.4 How to reproduce the final datasets?

To reproduce the 8 final datasets (*i.e.* those starting by _03_), open and run successively the R codes _02_back_calculation.R_, and all the _R_ codes starting by _03_. Make sure that all required packages were previously installed. Due to the elevated number of iterations from the Bayesian model, the codes necessitate an important amount of time to run. Please note that a full reproduction of the results is not possible, as Bayesian estimations are different at each run.



## 3. How to report issues?



Please report any bugs or issues [HERE](https://github.com/JWicquart/fish_growth/issues).



## 4. Reproducibility parameters



```R
R version 3.6.3 (2020-02-29)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 18363)

Matrix products: default

locale:
[1] LC_COLLATE=French_France.1252  LC_CTYPE=French_France.1252    LC_MONETARY=French_France.1252
[4] LC_NUMERIC=C                   LC_TIME=French_France.1252    

attached base packages:
[1] parallel  stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] formattable_0.2.0.1  kableExtra_1.1.0     plotly_4.9.2.1       readxl_1.3.1        
 [5] brms_2.13.0          Rcpp_1.0.4.6         bayesplot_1.7.2      rstan_2.19.3        
 [9] StanHeaders_2.21.0-5 plyr_1.8.6           rfishbase_3.0.4      forcats_0.5.0       
[13] stringr_1.4.0        dplyr_1.0.0          purrr_0.3.4          readr_1.3.1         
[17] tidyr_1.1.0          tibble_3.0.1         ggplot2_3.3.2        tidyverse_1.3.0     

loaded via a namespace (and not attached):
  [1] colorspace_1.4-1     ellipsis_0.3.1       ggridges_0.5.2       rsconnect_0.8.16    
  [5] estimability_1.3     htmlTable_2.0.1      markdown_1.1         base64enc_0.1-3     
  [9] fs_1.4.1             rstudioapi_0.11      DT_0.13              gh_1.1.0            
 [13] fansi_0.4.1          mvtnorm_1.1-1        lubridate_1.7.9      xml2_1.3.2          
 [17] bridgesampling_1.0-0 splines_4.0.1        knitr_1.28           shinythemes_1.1.2   
 [21] Formula_1.2-3        jsonlite_1.6.1       packrat_0.5.0        broom_0.5.6         
 [25] cluster_2.1.0        dbplyr_1.4.4         png_0.1-7            shiny_1.5.0         
 [29] compiler_4.0.1       httr_1.4.1           emmeans_1.5.0        backports_1.1.7     
 [33] lazyeval_0.2.2       assertthat_0.2.1     Matrix_1.2-18        fastmap_1.0.1       
 [37] cli_2.0.2            later_1.1.0.1        acepack_1.4.1        htmltools_0.5.0     
 [41] prettyunits_1.1.1    tools_4.0.1          igraph_1.2.5         coda_0.19-3         
 [45] gtable_0.3.0         glue_1.4.1           reshape2_1.4.4       cellranger_1.1.0    
 [49] vctrs_0.3.1          nlme_3.1-148         crosstalk_1.1.0.1    xfun_0.14           
 [53] ps_1.3.3             rvest_0.3.6          miniUI_0.1.1.1       mime_0.9            
 [57] lifecycle_0.2.0      gtools_3.8.2         zoo_1.8-8            scales_1.1.1        
 [61] colourpicker_1.0     hms_0.5.3            promises_1.1.1       Brobdingnag_1.2-6   
 [65] inline_0.3.15        shinystan_2.5.0      RColorBrewer_1.1-2   yaml_2.2.1          
 [69] memoise_1.1.0        gridExtra_2.3        loo_2.2.0            rpart_4.1-15        
 [73] latticeExtra_0.6-29  stringi_1.4.6        dygraphs_1.1.1.6     checkmate_2.0.0     
 [77] pkgbuild_1.0.8       rlang_0.4.6          pkgconfig_2.0.3      matrixStats_0.56.0  
 [81] evaluate_0.14        lattice_0.20-41      rstantools_2.0.0     htmlwidgets_1.5.1   
 [85] processx_3.4.2       tidyselect_1.1.0     magrittr_1.5         R6_2.4.1            
 [89] generics_0.0.2       Hmisc_4.4-0          DBI_1.1.0            pillar_1.4.4        
 [93] haven_2.3.1          foreign_0.8-80       withr_2.2.0          xts_0.12-0          
 [97] survival_3.1-12      abind_1.4-5          nnet_7.3-14          modelr_0.1.8        
[101] crayon_1.3.4         rmarkdown_2.3        jpeg_0.1-8.1         grid_4.0.1          
[105] data.table_1.12.8    blob_1.2.1           callr_3.4.3          threejs_0.3.3       
[109] webshot_0.5.2        reprex_0.3.0         digest_0.6.25        xtable_1.8-4        
[113] httpuv_1.5.4         RcppParallel_5.0.1   stats4_4.0.1         munsell_0.5.0       
[117] viridisLite_0.3.0    shinyjs_1.1      
```