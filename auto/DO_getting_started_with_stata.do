* clear memory
clear all
macro drop _all
set more off

* import and format the data
*import excel "auto.xlsx", sheet("Sheet1") firstrow
*format %14.3f gear_ratio
*label define foreign 0 "domestic" 1 "foreign"
*label values foreign foreign

* alternative import the formated data
use "https://github.com/quarcs-lab/data-open/raw/master/auto/auto.dta", clear

* transform the data
generate kpl = mpg *0.425
label variable kpl "Kilometers per liter"

* explore the data
describe

summarize
sum, detail

histogram mpg
histogram mpg, normal
histogram mpg, kdensity kdenopts(gaussian)

graph pie, over(foreign)

graph box mpg, over(foreign)
graph hbox mpg, over(foreign)

* regression
regress mpg weight foreign

* regression with interactions
regress mpg c.weight##i.foreign
margins foreign, at(weight=(2000 2500 3000 3500 4000) )
marginsplot
