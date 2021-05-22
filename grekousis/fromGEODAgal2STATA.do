clear all

* Install spwmatrix package to import gdal files
ssc install spwmatrix
* ssc install sppack
* ssc install xsmle


* Import .gal file and export it as .txt matrix
spwmatrix import using "WqueenGeoda.gal", wname(WqueenGeoda) xport(WqueenGeoda, txt) replace

* Load .txt matrix
*insheet using "weights.txt", delimiter(" ")  clear
import delimited "WqueenGeoda.txt",  delimiter(space) clear

* Remove first row and last column, which only indicates the number of spatial units
drop if _n == 1
drop v1
rename v# v#, renumber


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

* Save  as .dta file
save "WqueenGeoda.dta", replace
