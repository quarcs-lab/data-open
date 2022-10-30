* aed_ch11.do March 2021 for Stata version 16

capture log close   // capture means program continues even if no log file open
log using aed11.txt, text replace

********** OVERVIEW OF aed_ch11.do **********

* STATA Program 
* copyright C 2021 by A. Colin Cameron
* Used for "Analyis of Economics Data: An Introduction to Econometrics"
* by A. Colin Cameron (2021) 

* To run you need file
*   AED_HOUSE.DTA
* in your directory

********** SETUP **********

set more off
* version 16
clear all
set scheme s1manual  /* Graphics scheme */

************

* This STATA does analysis for Chapter 11
*  11.1 PROPERTIES OF THE LEAST SQUARES ESTIMATOR
*  11.2 ESTIMATORS OF MODEL PARAMETERS
*  11.3 CONFIDENCE INTERVALS
*  11.4 HYPOTHESIS TESTS ON A SINGLE PARAMETER
*  11.5 JOINT HYPOTHESIS TESTS
*  11.6 F STATISTIC UNDER ASSUMPTIONS 1-4
*  11.7 PRESENTATION OF REGRESSION RESULTS

********** DATA DESCRIPTION

* House sale price for 29 houses in Central Davis in 1999
*     29 observations on 9 variables 

****  11.1 - 11.4 EXAMPLE: HOUSE PRICE AND CHARACTERISTICS

use AED_HOUSE.DTA
describe
summarize price size bedrooms bathroom lotsize age monthsold

* Table 11.1 - not produced by statistical package

* Table 11.2
* Multiple regression
regress price size bedrooms bathroom lotsize age monthsold

* Test that beta_size = 50
test size = 50
display "tstatistic = " sqrt(r(F))

* Test manually
scalar tstatistic = (_b[size] - 50)/_se[size]
display "tstatistic = " tstatistic " and p-value = " 2*ttail(e(df_r),tstatistic)

****  11.5 JOINT HYPOTHESIS TESTS

* Generate F data
clear
global nobs = 1000
set obs $nobs
generate x = 8*_n/$nobs
generate F3_30 = Fden(3,30,x)
generate F10_30 = Fden(10,30,x)

* Figure 11.1
graph twoway (line F3_30 x) (line F10_30 x, lpattern(dash))
* graph export aed11fig1.wmf, replace

* Table 11.3
display "Row 1: " invFtail(1,30,.10)  "  " invFtail(2,30,.10)  "  "        ///
    invFtail(3,30,.10) "  " invFtail(10,30,.10)  "  "  invFtail(20,30,.10)
display "Row 2: " invFtail(1,10000,.10)  "  " invFtail(2,10000,.10)  "  "  ///
    invFtail(3,10000,.10) " " invFtail(10,10000,.10)  "  "  invFtail(20,10000,.10)
display "Row 3: " invFtail(1,30,.05)  "  " invFtail(2,30,.05)  "  "        ///
    invFtail(3,30,.05)  " invFtail(10,30,.05)  "  "  invFtail(20,30,.05)
display "Row 4: " invFtail(1,10000,.05)  "  " invFtail(2,10000,.05)  "  "  ///
    invFtail(3,10000,.05) " " invFtail(10,10000,.05)  "  "  invFtail(20,10000,.05)
display "Row 5: " invFtail(1,30,.01)  "  " invFtail(2,30,.01)  "  "        ///
    invFtail(3,30,.01)  " invFtail(10,30,.01)  "  "  invFtail(20,30,.01)
display "Row 6: " invFtail(1,10000,.01)  "  " invFtail(2,10000,.01)  "  "  ///
    invFtail(3,10000,.01) " " invFtail(10,10000,.01)  "  "  invFtail(20,10000,.01)

clear
use AED_HOUSE.DTA

* Overall F test can be read directly using output
quietly regress price size bedrooms bathroom lotsize age monthsold
test bedrooms bathroom lotsize age monthsold

* Subset test can be done using command test
quietly regress price size bedrooms bathroom lotsize age monthsold
test bedrooms bathroom lotsize age monthsold

* Single coefficient can be tested using command test
quietly regress price size bedrooms bathroom lotsize age monthsold
test bedrooms
display "Square root of F(1,n-k) equals t-test: " sqrt(r(F))

*  11.6 F STATISTIC UNDER ASSUMPTIONS 1-4

* Overall F test manually
quietly regress price size bedrooms bathroom lotsize age monthsold
scalar Foverall = (e(mss)/e(df_m)) / (e(rss)/e(df_r))
display "F overall = " Foverall " with p = " Ftail(e(df_m),e(df_r),Foverall) 

* Subset test done manually
quietly regress price size bedrooms bathroom lotsize age monthsold
scalar RSSu = e(rss)
scalar ku = e(df_m) + 1
scalar nminusku = e(df_r)
quietly regress price size
scalar RSSr = e(rss)
scalar kr = e(df_m) + 1
scalar Fsubset = ((RSSr-RSSu)/(ku-kr)) / (RSSu/nminusku)
display "F subset = " Fsubset " with p = " Ftail(ku-kr,nminusku,Fsubset) " and (q,n-k) = " ku-kr " , " nminusku

*  11.7 PRESENTATION OF REGRESSION RESULTS

* Table 10.4
regress price size bedrooms
estimates store OUTPUT
estimates table OUTPUT, b(%11.2f) se(%11.2f) stats(r2 N)
estimates table OUTPUT, b(%11.2f) t(%11.2f) stats(r2 N)
estimates table OUTPUT, b(%11.2f) p(%11.3f) stats(r2 N)
estimates table OUTPUT, b(%11.2f) star(.10 .05 .01) stats(r2 N)

********** CLOSE OUTPUT
log close
