clear all

* Install spwmatrix package to import gdal files
ssc install spwmatrix
* ssc install sppack
* ssc install xsmle


* Import .gal file and export it as .txt matrix
spwmatrix import using "Wqueen.gal", wname(weights) xport(weights, txt) replace

* Load .txt matrix
*insheet using "weights.txt", delimiter(" ")  clear
import delimited "weights.txt",  delimiter(space) clear

* Remove first row and last column, which only indicates the number of spatial units
drop if _n == 1
drop v1
rename v# v#, renumber

* Save .txt matrix as .dta file
save "weightsFile.dta", replace

* Generate IDs for spatial units
gen id = _n
order id, first

* Rename the columns of the weights matrix
rename v(#) m(#)
rename v(##) m(##)
rename v(###) m(###)

* Check: Usually the IDs are wrong! They are in the opposite order
** Let's correct the IDs
gsort -id
drop id

gen id = _n
order id, first
drop id
