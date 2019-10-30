# **Reef fish growth dataset: annual otolith sagittal growth for Pacific coral reef fishes**



**This repository contains code and data presented in the article**:

Morat, F., Wicquart, J., de Synéty, G., Bienvenu, J., Brandl, S. J., Carlot, J., Casey, J. M., Degregori, S., Mercière, A., Fey, P., Galzin, R., Letourneur, Y., Sasal, P., Schiettekatte, N. M. D., Vii, J., Parravicini, V. (2019). Reef fish growth dataset: annual otolith sagittal growth for Pacific coral reef fishes. _Ecology_, submitted.



## 1. How to download this project?



On the project main page on GitHub, click on the green button `clone or download` and then click on `Download ZIP`



## 2. Description of the project



### 2.1 Project organization

This project is divided in three folder:

* `R` folder contains two script and the `functions` folder. The two scripts are 01_clean_otolithometry.Rmd (combine otolithometry and morphometric data files) and 02_back_calculation.Rmd (back-calculation of size-at-age). The _.Rmd_ format was choosed because it allows to keep a track of intermediate results through _.html_ files.  The functions folder contains all the functions specifically developed for the study.
* `data` folder contains all the data files used to produce the final data file associated with the article
* `stan` folder contains the stan script used in the back-calculation procedure



### 2.2 Dataset description



### 2.3 How to reproduce the final dataset?



### 2.4 How to use the final dataset?

The dataset associated to the article contains the following variables:

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



## 3. Reproducibility parameters



