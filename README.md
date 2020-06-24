# **Individual back-calculated size-at-age based on otoliths from Pacific coral reef fish species**



**This repository contains code and data presented in the article**:

Morat, F., Wicquart, J., Schiettekatte, N. M. D., de Synéty, G., Bienvenu, J., Casey, J. M., Brandl, S. J., Carlot, J., Degregori, S., Mercière, A., Fey, P., Galzin, R., Letourneur, Y., Sasal, P., Vii, J., Parravicini, V. (2020). Individual back-calculated size-at-age based on otoliths from Pacific coral reef fish species. _Scientific Data_, submitted.


[![Generic badge](https://img.shields.io/badge/DOI-10.6084/m9.figshare.12156159.v1-2abb9b.svg)](https://figshare.com/articles/Individual_back-calculated_size-at-age_based_on_otoliths_from_Pacific_coral_reef_fish_species/12156159/1)



## 1. How to download this project?



On the project main page on GitHub, click on the green button `Clone` and then click on `Download ZIP`



## 2. Description of the project



### 2.1 Project organization

This project is divided in three folder:

* `R` folder contains the script 02_back_calculation.Rmd and the `functions` folder.  The _.Rmd_ format was selected because it allows to keep a track of intermediate results through _.html_ files. The `functions` folder contains the function _bcalc_bayes.R_ used for bayesian back-calculation.
* `data` folder contains the data file used to produce the final data file associated with the article (**_back-calculated-size-at-age_morat-et-al_**)
* `stan` folder contains the stan script used in the back-calculation procedure



### 2.2 Dataset description

The raw dataset **_coral_reef_fishes_data_** contains the following variables:

- `family` Family
- `genus` Genus
- `species` Species
- `id` Unique code identifying each individual
- `agei` Age *i* (*years*)
- `radi` Otolith radius at age *i* (*mm*)
- `agecap` Age of the fish at capture (*years*)
- `radcap` Radius of the otolith at capture (*mm*)
- `lencap` Length of the fish at capture (*total length, mm*)
- `l0p` Length of the fish at hatching (*mm*)
- `weight` Wet weight of the fish at capture (*g*)
- `location` Island of the sampling
- `observer` Name of the person who realized the otolith reading



The dataset associated to the article (**_back-calculated-size-at-age_morat-et-al_**) contains the following variables:

- `Family` Family
- `Genus` Genus
- `Species` Species
- `ID` Unique code identifying each individual
- `Agei` Age *i* (*years*)
- `Ri` Otolith radius at age *i* (*mm*)
- `Agecpt` Age of the fish at capture (*years*)
- `Rcpt` Radius of the otolith at capture (*mm*)
- `Lcpt` Length of the fish at capture (*total length, mm*)
- `L0p` Length of the fish at hatching (*mm*)
- `R0p` Radius of the fish at hatching (*mm*)
- `Li_sp_m` Total length (mean) of the fish at age *i* calculated by species (*mm*)
- `Li_sp_sd` Standard deviation around the value of `Li_sp_m` (_mm_)
- `Li_sploc_m` Total length (mean) of the fish at age *i* calculated by species and location (*mm*)
- `Li_sploc_sd` Standard deviation around the value of `Li_sploc_m` (_mm_)
- `Weight` Wet weight of the fish at capture (*g*)
- `Location` Island of the sampling
- `Observer` Name of the person who realized the otolith reading



### 2.3 How to reproduce the final dataset?

The **_coral_reef_fishes_data_** file is used by the script _02_back_calculation.Rmd_ to estimate the back-calculated size-at-age and export the final file **_back-calculated-size-at-age_morat-et-al_**. To reproduce the final file, open the script _02_back_calculation.Rmd_ and click on `knit`. Make sure that all required packages were previously downloaded.



### 2.4 How to use the final dataset?

The dataset associated to the article (**_back-calculated-size-at-age_morat-et-al_**) can be used for two purpose:

1. **Estimation of growth parameters and growth curves**. Growth parameters can be obtained using the variables `Agei` and `Li_sp_m` (by species across all locations) or `Li_sploc_m` (by species and location). The growth parameters can then be used to predict community level biomass production.
2. **Estimation of length-weight relationship**. The relationship _W = aL^b_ (with W = weight and L = length) can be used to estimate the weight of a fish from its length. To do so the parameters _a_ and _b_ are needed and can be obtained by fitting an allometric model using measured weight and length of several individuals of a given species. Our dataset provide such data and make it possible to estimate _a_ and _b_ parameters. The variables `Weight` and `Lcpt` can be used for that purpose.



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