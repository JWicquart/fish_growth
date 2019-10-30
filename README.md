# **Reef fish growth dataset: annual otolith sagittal growth for Pacific coral reef fishes**



**This repository contains code and data presented in the article**:

Morat, F., Wicquart, J., de Synéty, G., Bienvenu, J., Brandl, S. J., Carlot, J., Casey, J. M., Degregori, S., Mercière, A., Fey, P., Galzin, R., Letourneur, Y., Sasal, P., Schiettekatte, N. M. D., Vii, J., Parravicini, V. (2019). Reef fish growth dataset: annual otolith sagittal growth for Pacific coral reef fishes. _Ecology_, submitted.



## 1. How to download this project?



On the project main page on GitHub, click on the green button `clone or download` and then click on `Download ZIP`



## 2. Description of the project



### 2.1 Project organization

This project is divided in three folder:

* `R` folder contains three script and the `functions` folder. The two scripts are 01_clean_otolithometry.Rmd (combine otolithometry and morphometric data files), 02_back_calculation.Rmd (back-calculation of size-at-age) and 03_exploratory_analysis.Rmd (exploratory analysis). The _.Rmd_ format was choosed because it allows to keep a track of intermediate results through _.html_ files.  The functions folder contains all the functions specifically developed for the study.
* `data` folder contains all the data files used to produce the final data file associated with the article. Note that data used for the first R script (01_clean_otolithometry.Rmd) are not available on Github because we state that the data cleaning is not interesting for the data user
* `stan` folder contains the stan script used in the back-calculation procedure



### 2.2 Dataset description

The dataset **_coral_reef_fishes_data_** contains the following variables:

- `family` Family
- `genus` Genus
- `species` Species
- `id` ID of the fish
- `agei` Age *i* (*years*)
- `radi` Otolith radius at age *i* (*mm*)
- `agecap` Age of the fish at capture (*years*)
- `radcap` Radius of the otolith at capture (*mm*)
- `lencap` Length of the fish at capture (*total length, mm*)
- `l0p` Length of the fish at hatching (*mm*)
- `r0p` Radius of the fish at hatching (*mm*)
- `li` Length of the fish at age *i* (*mm*)
- `biomass` Biomass of the fish (*wet biomass, g*)
- `location` Location of the sampling
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



### 2.4 How to use the final dataset?

The dataset associated to the article (**_size_at_age_coral_reef_fishes_data_**) can be used for two purpose:

1. **Estimation of growth parameters and growth curves**. Growth parameters are essential for [...]. The variables and 

2. **Estimation of length-weight relationship**. The relationship $W = aL^b$ can be used to estimate the biomass of a fish from its length. To do so the parameters _a_ and _b_ need to be previously obtained using several individuals of a given species. Our dataset provide such data and make it possible to estimate _a_ and _b_ parameters. The variables ``



## 3. Reproducibility parameters



