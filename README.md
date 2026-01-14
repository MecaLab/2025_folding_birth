# 2025_folding_birth
This repository contains the code developed during our study on the impact of birth on brain folding:

A. Mihailov, A. Pron, J. Lefèvre, C. Deruelle, B. Desnous, F. Bretelle, A. Manchon, M. Milh, F. Rousseau, N. Girard, G. Auzias, “Burst of Gyrification in the Human Brain after Birth,” Communications Biology 8, no. 1 (2025): 1–13, https://doi.org/10.1038/s42003-025-08155-z.

# Code Descriptions

The following scripts were used to run a discontinuity analysis at the moment of birth along the perinatal trajectory of gyrification.

All code is written in R. The discontinuity code is adapted from the rdrobust package in R. Below we provide information on how to choose the optimal bandwidth lengths and how to generate a plot that showcases the bandwidths used in the polynomial regressions on either side of the cut-off. Finally we provide the code to run the regression discontinuity design analysis in all subjects, and per sex.

# Main Citations

* Calonico, S., Cattaneo, M. D., & Titiunik, R. (2015). rdrobust: An R package for robust nonparametric inference in regression-discontinuity designs. The R Journal, 7(1), 38–51. https://doi.org/10.32614/RJ-2015-004

* Calonico, S., Cattaneo, M. D., & Titiunik, R. (2014). Robust nonparametric confidence intervals for regression-discontinuity designs. Econometrica, 82(6), 2295–2326. https://doi.org/10.3982/ECTA11757


# Scripts

* discontinuity_CB.r

	* This code runs the RDD discontinuity analysis using the rdrobust function in R. It runs local polynomial regressions on either side of the cut-off (birth) along the perinatal trajectory of gyrification (and other surface and volumetric features). It generates the effect size, p-value, confidence intervals, standard error, coefficient and bandwidth lengths.

* discontinuity_per_sex_CB.r

	* This code runs the same discontinuity analysis per sex.

* bwselect_optimal_method_CB.r
	
	* Aids in the selection of an optimal bandwidth method to subsequently compute bandwidth lengths on either side of the cut-off. Possible bandwidth selection methods: "mserd", "msetwo", "msesum", "msecomb1", "msecomb2","cerrd", "certwo", "cersum", "cercomb1", "cercomb2".

* Grey_bw_subjects_CB.r

	* Generates a plot with subjects that are used in the RDD analysis coloured in gray (i.e., that fit in the set bandwidth).
