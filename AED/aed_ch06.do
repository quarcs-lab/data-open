* aed_ch06.do March 2021 for Stata version 16

capture log close   // capture means program continues even if no log file open
log using aed_ch06.txt, text replace

********** OVERVIEW OF aed_ch06.do **********

* STATA Program 
* copyright C 2021 by A. Colin Cameron
* Used for "Analyis of Economics Data: An Introduction to Econometrics"
* by A. Colin Cameron (2021) 

* To run you need file
*   AED_GENERATEDDATA.DTA
*   AED_GENERATEDREGRESSION.DTA
*   AED_CENSUSREGRESSIONSDTA
* in your directory

********** SETUP **********

set more off
* version 16
clear all
set scheme s1manual  /* Graphics scheme */

************

* This STATA does analysis for Chapter 6
*  6.1 POPULATION AND SAMPLE
*  6.2 EXAMPLES OF SAMPLING FROM A POPULATION
*  6.3 PROPERTIES OF THE LEAST SQUARES ESTIMATOR
*  6.4 ESTIMATORS OF MODEL PARAMETERS

********** DATA DESCRIPTION

* Two datasets are generated
* The third comes from analysis of the 1880 U.S. Census

****  6.1 POPULATION AND SAMPLE

* Figure 6.1 compares error and residual - uses no data

****  6.2 EXAMPLES OF SAMPLING FROM A POPULATION

clear 
use AED_GENERATEDDATA.DTA 
describe 
summarize

* Table 6.1
list

/* Aside; This is how the data were generated ...
clear
set obs 5
set rng kiss32   // This uses the old Stata random number generator
generate x = _n  // This sets x to requal the observation number
generate Eygivenx = 1 + 2*x
set seed 123456
generate u = rnormal(0,2)
generate y = ygivenx + u
list
*/

regress y x

* Figure 6.2 - simple version
* Pamel A
twoway (scatter y x) (lfit Eygivenx x), title("Population line")
* graph export aed06fig1.wmf, replace
* panel B
twoway (scatter y x) (lfit y x), title("Regression line")

* Three regressions from the same model
clear
set obs 30
set seed 12345
generate x1 = rnormal(3,1)
generate u1 = rnormal(0,2)
generate y1 = 1 + 2*x1 + u1
generate x2 = rnormal(3,1)
generate u2 = rnormal(0,2)
generate y2 = 1 + 2*x2 + u2
generate x3 = rnormal(3,1)
generate u3 = rnormal(0,2)
generate y3 = 1 + 2*x3 + u3
regress y1 x1, noheader
regress y2 x2, noheader
regress y3 x3, noheader

* Figure 6.3 - simple version
graph twoway (scatter y1 x1) (lfit y1 x1), saving(graph1, replace)
graph twoway (scatter y2 x2) (lfit y2 x2), saving(graph2, replace)
graph twoway (scatter y3 x3) (lfit y3 x3), saving(graph3, replace)
graph combine graph1.gph graph2.gph graph3.gph, ysize(2) xsize(6) rows(1) ycommon xcommon

* Generated data: results of regression on 400 samples of size 30
clear 
use AED_GENERATEDREGRESSIONS.DTA
describe
summarize

* Figure 6.4: simple version
histogram slope, kdensity saving(graph1, replace)
histogram intercept, kdensity saving(graph2, replace)
graph combine graph1.gph graph2.gph, ysize(2.5) xsize(6) rows(1) 

* Census data: results of regression on 400 samples of size 120
clear 
use AED_CENSUSREGRESSIONS.DTA
describe
summarize
list in 1/3, clean

* Figure 6.5: simple version
histogram slope, kdensity saving(graph1, replace)
histogram intercept, kdensity saving(graph2, replace)
graph combine graph1.gph graph2.gph, ysize(2.5) xsize(6) rows(1) 

********** CLOSE OUTPUT
log close

/* Brief Stata for the chapter
* Generated data
clear
set obs 5
set rng kiss32   // use the old Stata random number generator
generate x = _n  // set x to rqual the observation number
generate Eygivenx = 1 + 2*x
set seed 123456
generate u = rnormal(0,2)
generate y = ygivenx + u
list
regress y x
twoway (scatter y x) (lfit y x)
twoway (scatter y x) (lfit ytrue x)
*/
