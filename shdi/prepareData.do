cls
**=====================================================
** Program Name: Remove unnecesary variables and add regional identifiers
** Author: Carlos Mendez
** Date: 2022-05-08
** --------------------------------------------------------------------------------------------
** Inputs/Ouputs:
* Data files used:

* Data files created as intermediate product:

* Data files created as final product:

**=====================================================

** 0. Change working directory
cd "/Users/carlos/Github/QuaRCS-lab/data-open/shdi"

** 1. Setup
clear all
macro drop _all
capture log close
set more off
version 15

** 2. Open log file
log using "prepareData.txt", text replace

** 3. Install modules
*ssc install estout, replace all
*ssc install outreg2, replace all
*ssc install reghdfe, replace all * INFO: http://scorreia.com/software/reghdfe/
*net install gr0009_1, from (http://www.stata-journal.com/software/sj10-1) replace all
*net install tsg_schemes, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace all
*set scheme white_tableau, permanently
*set scheme gg_tableau, permanently


** 4. Import data
*use  , clear
import delimited "SHDI-SGDI-Total 5.0.csv", case(preserve) clear
destring , replace

describe
summarize

** Drop unnecesary variables
drop sgdi shdif shdim healthindexf healthindexm incindexf incindexm edindexf edindexm eschf eschm mschf mschm lifexpf lifexpm gnicf gnicm lgnicf lgnicm mfsel

** Add corrected continent identifiers
kountry country, from(other) geo(un)


** Rename variables 
rename GDLCODE GDLcode
rename GEO continent2
rename NAMES_STD country2

** Replace missing observations in continent2
replace continent2 = continent if missing(continent2) 
replace continent2 = "Americas" if continent == "America"

** Order variables
order continent2, after(GDLcode)
order country2, after(continent)

** Add labels
label variable shdi "Subnational human development index"
label variable lifexp "Life expectancy at birth"
label variable msch "Mean years of schooling of adults 25+"
label variable esch "Expected years of schooling of children aged 6"
label variable gnic "Gross national income per capita (PPP2011)"
label variable lgnic "Log gross national income per capita (PPP2011)"
label variable healthindex "Health index"
label variable incindex "Income index"
label variable edindex "Education index"
label variable pop "Population"

** X. Save dataset
save             "SHDI.dta", replace
export delimited "SHDI.csv", replace

** 99. Close log file
log close

**====================END==============================
 