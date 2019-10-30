# **Reef fish growth dataset: annual otolith sagittal growth for Pacific coral reef fishes**



**This repository contains code and data presented in the article**:

Morat, F., Wicquart, J., de Synéty, G., Bienvenu, J., Brandl, S. J., Carlot, J., Casey, J. M., Degregori, S., Mercière, A., Fey, P., Galzin, R., Letourneur, Y., Sasal, P., Schiettekatte, N. M. D., Vii, J., Parravicini, V. (2019). Reef fish growth dataset: annual otolith sagittal growth for Pacific coral reef fishes. _Ecology_, submitted.



## 1. How to download this project?



On the project main page on GitHub, click on the green button `clone or download` and then click on `Download ZIP`



## 2. Description of the project



### 2.1 Project organization

This project is divided in three folder:

* `R` folder contains three script and the `functions` folder. The two scripts are 01_clean_otolithometry.Rmd (combine otolithometry and morphometric data files), 02_back_calculation.Rmd (back-calculation of size-at-age) and 03_exploratory_analysis.Rmd (exploratory analysis). The _.Rmd_ format was choosed because it allows to keep a track of intermediate results through _.html_ files.  The functions folder contains all the functions specifically developed for the study.
* `data` folder contains the data file used to produce the final data file associated with the article (**_size_at_age_coral_reef_fishes_data_**)
* `stan` folder contains the stan script used in the back-calculation procedure



### 2.2 Dataset description

The dataset **_coral_reef_fishes_data_** contains the following variables:

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
- `biomass` Wet body mass of the fish at capture (*g*)
- `location` Island of the sampling
- `observer` Name of the person who realized the otolith reading



The dataset associated to the article (**_size_at_age_coral_reef_fishes_data_**) contains the following variables:

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
- `Biomass` Wet body mass of the fish at capture (*g*)
- `Location` Island of the sampling
- `Observer` Name of the person who realized the otolith reading



### 2.3 How to reproduce the final dataset?

The _01_clean_otolithometry.Rmd_ script use several dataset on otolithometry readings and morphometric measurements to generate the file **_coral_reef_fishes_data_**. This file is used by the script _02_back_calculation.Rmd_ to estimate the back-calculated size-at-age and export the file **_size_at_age_coral_reef_fishes_data_**. Finally exploratory analysis are done on this file with the script _03_exploratory_analysis.Rmd_.

Note that data used for the first R script (_01_clean_otolithometry.Rmd_) are not available on Github because we believe that the data cleaning is not interesting for the data users.



### 2.4 How to use the final dataset?

The dataset associated to the article (**_size_at_age_coral_reef_fishes_data_**) can be used for two purpose:

1. **Estimation of growth parameters and growth curves**. Growth parameters can be obtained using the variables `Agei` and `Li_sp_m` (by species across all locations) or `Li_sploc_m` (by species and location).

2. **Estimation of length-weight relationship**. The relationship _W = aL^b_ (with W = weight and L = length) can be used to estimate the biomass of a fish from its length. To do so the parameters _a_ and _b_ are needed and can be obtained by fitting an allometric model using measured biomass and length of several individuals of a given species. Our dataset provide such data and make it possible to estimate _a_ and _b_ parameters. The variables `Biomass` and `Lcpt` can be used for that purpose.



## 3. Reproducibility parameters



```R
## R version 3.6.1 (2019-07-05)
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
## [1] rstan_2.19.2       ggplot2_3.2.1      StanHeaders_2.19.0
## [4] tidyr_1.0.0        dplyr_0.8.3        plyr_1.8.4        
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.2         pillar_1.4.2       compiler_3.6.1    
##  [4] prettyunits_1.0.2  tools_3.6.1        zeallot_0.1.0     
##  [7] digest_0.6.22      pkgbuild_1.0.6     evaluate_0.14     
## [10] lifecycle_0.1.0    tibble_2.1.3       gtable_0.3.0      
## [13] pkgconfig_2.0.3    rlang_0.4.1        cli_1.1.0         
## [16] parallel_3.6.1     yaml_2.2.0         xfun_0.10         
## [19] loo_2.1.0          gridExtra_2.3      withr_2.1.2       
## [22] stringr_1.4.0      knitr_1.25         vctrs_0.2.0       
## [25] stats4_3.6.1       grid_3.6.1         tidyselect_0.2.5  
## [28] glue_1.3.1         inline_0.3.15      R6_2.4.0          
## [31] processx_3.4.1     rmarkdown_1.16     callr_3.3.2       
## [34] purrr_0.3.3        magrittr_1.5       codetools_0.2-16  
## [37] matrixStats_0.55.0 ps_1.3.0           backports_1.1.5   
## [40] scales_1.0.0       htmltools_0.3.6    assertthat_0.2.1  
## [43] colorspace_1.4-1   stringi_1.4.3      lazyeval_0.2.2    
## [46] munsell_0.5.0      crayon_1.3.4
```