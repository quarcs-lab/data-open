cls
**=====================================================
** Program Name: Remove unnecesary variables, add regional identifiers, and compute long-run trends
** Author: Carlos Mendez
** Date: 2022-05-08
** --------------------------------------------------------------------------------------------
** Inputs/Ouputs:
* Data files used:

* Data files created as intermediate product:

* Data files created as final product:

**=====================================================

** 0. Change working directory
*cd "/Users/carlos/Github/QuaRCS-lab/data-open/shdi"
cd "/Users/carlosmendez/Documents/GitHub/data-open/shdi"

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
rename NAMES_STD CountryName_std

** Replace missing observations in continent2
replace continent2 = continent if missing(continent2) 
replace continent2 = "Americas" if continent == "America"

** Order variables
order continent2, after(GDLcode)
order CountryName_std, after(continent)

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


** Add more country identifiers
merge m:1 CountryName_std using "country_identifiers.dta"
drop if _merge == 2

** Add missing identifiers
replace Continent_std = continent2 if missing(Continent_std) 
replace Continent = continent2 if missing(Continent) 

replace SubContinent   = "Middle Africa"            if  country == "Central African Republic CAR" 
replace CountryName    = "Central African Republic" if  country == "Central African Republic CAR" 
replace status         = "Member State"             if  country == "Central African Republic CAR" 
replace iso3           = "CAF"                      if  country == "Central African Republic CAR"
replace POLY_IDcountry =  84                        if  country == "Central African Republic CAR"

replace SubContinent   = "Southern Europe"          if  country == "North Macedonia" 
replace CountryName    = "The former Yugoslav Republic of Macedonia" if  country == "North Macedonia" 
replace status         = "Member State"             if  country == "North Macedonia" 
replace iso3           = "MKD"                      if  country == "North Macedonia"
replace POLY_IDcountry =  15                        if  country == "North Macedonia"

replace SubContinent   = "Southern Africa"          if  country == "Eswatini" 
replace CountryName    = "Swaziland"			    if  country == "Eswatini" 
replace status         = "Member State"             if  country == "Eswatini" 
replace iso3           = "SWZ"                      if  country == "Eswatini"
replace POLY_IDcountry =  127                       if  country == "Eswatini"

replace SubContinent   = "Western Africa"          	if  country == "Cote d'Ivoire" 
replace CountryName    = "CÃ´te d'Ivoire"		    if  country == "Cote d'Ivoire" 
replace status         = "Member State"             if  country == "Cote d'Ivoire" 
replace iso3           = "CIV"                      if  country == "Cote d'Ivoire"
replace POLY_IDcountry =  233                       if  country == "Cote d'Ivoire"

replace SubContinent   = "Northern Europe"          	if  country == "United Kingdom" 
replace CountryName    = "U.K. of Great Britain and Northern Ireland"		    if  country == "United Kingdom" 
replace status         = "Member State"             if  country == "United Kingdom" 
replace iso3           = "GBR"                      if  country == "United Kingdom"
replace POLY_IDcountry =  192                       if  country == "United Kingdom"

replace SubContinent   = "Middle Africa"          if  country == "Congo Democratic Republic" 
replace CountryName    = "Democratic Republic of the Congo"		    if  country == "Congo Democratic Republic" 
replace status         = "Member State"             if  country == "Congo Democratic Republic" 
replace iso3           = "COD"                      if  country == "Congo Democratic Republic"
replace POLY_IDcountry =  209                       if  country == "Congo Democratic Republic"

replace SubContinent   = "South America"            if  country == "Chili" 
replace CountryName    = "Chile"		            if  country == "Chili" 
replace status         = "Member State"             if  country == "Chili" 
replace iso3           = "CHL"                      if  country == "Chili"
replace POLY_IDcountry =  29                        if  country == "Chili"

replace SubContinent   = "Western Asia"             if  country == "Palestine" 
replace CountryName    = "West Bank"		        if  country == "Palestine" 
replace status         = "Occupied Territory"       if  country == "Palestine" 
replace iso3           = "PSE"                      if  country == "Palestine"
replace POLY_IDcountry =  202                       if  country == "Palestine"

replace SubContinent   = "Southern Europe"          if  country == "Kosovo" 
replace CountryName    = "Kosovo"		            if  country == "Kosovo" 
replace status         = "Partially recognised state"       if  country == "Kosovo" 
replace iso3           = "XKO"                      if  country == "Kosovo"
replace POLY_IDcountry =  .                         if  country == "Kosovo"

replace SubContinent   = "Southern Europe"          if  country == "Monte Negro" 
replace CountryName    = "Montenegro"		        if  country == "Monte Negro" 
replace status         = "Member State"             if  country == "Monte Negro" 
replace iso3           = "MNE"                      if  country == "Monte Negro"
replace POLY_IDcountry =  92                        if  country == "Monte Negro"



** Interpolate missing values of population
sort GDLcode year
egen GDLcode_id = group(GDLcode)
order GDLcode_id, after(GDLcode)

xtset GDLcode_id year
ipolate pop year, gen(pop_ip) epolate by (GDLcode_id)
sum


** Compute long-run trends: HP filter with parameters 6.25
gen ln_shdiX100 = ln(100*shdi)

gen ln_healthindexX100 = ln(100*healthindex)
gen ln_incindexX100 = ln(100*incindex)
gen ln_edindexX100 = ln(100*edindex)

gen ln_eschX100 = ln(100*esch)
gen ln_mschX100 = ln(100*msch)
gen ln_lifexpX100 = ln(100*lifexp)

pfilter ln_shdiX100, method(hp) trend(tr6_ln_shdiX100) smooth(6.25)

pfilter ln_healthindexX100, method(hp) trend(tr6_ln_healthindexX100) smooth(6.25)
pfilter ln_incindexX100, method(hp) trend(tr6_ln_incindexX100) smooth(6.25)
pfilter ln_edindexX100 , method(hp) trend(tr6_ln_edindexX100 ) smooth(6.25)

pfilter ln_eschX100, method(hp) trend(tr6_ln_eschX100) smooth(6.25)
pfilter ln_mschX100, method(hp) trend(tr6_ln_mschX100) smooth(6.25)
pfilter ln_lifexpX100, method(hp) trend(tr6_ln_lifexpX100) smooth(6.25)

pfilter lgnic, method(hp) trend(tr6_lgnic) smooth(6.25)


** X. Save dataset
save             "shdi.dta", replace
export delimited "shdi.csv", replace

** 99. Close log file
log close

**====================END==============================
 