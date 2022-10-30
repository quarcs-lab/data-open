* aed_ch07.do March 2021 For Stata version 16 

capture log close   // capture means program continues even if no log file open
log using aed_ch07.txt, text replace

********** OVERVIEW OF aed07.do **********

* STATA Program 
* copyright C 2021 by A. Colin Cameron
* Used for "Analyis of Economics Data: An Introduction to Econometrics"
* by A. Colin Cameron (2021) 

* To run you need file
*   AED_HOUSE.DTA
*   AED_REALGDPPC
* in your directory

********** SETUP **********

set more off
* version 16
clear all
set scheme s1manual  // Graphics scheme

************`'

* This STATA does analysis for Chapter 7
*   7.1 EXAMPLE: HOUSE PRICE AND SIZE
*   7.2 THE T STATISTIC
*   7.3 CONFIDENCE INTERVALS
*   7.4 TESTS OF STATISTICAL SIGNIFICANCE
*   7.5 TWO-SIDED HYPOTHESIS TESTS
*   7.6 ONE-SIDED DIRECTIONAL HYPOTHESIS TESTS
*   7.7 ROBUST STANDARD ERRORS

********** DATA DESCRIPTION

* House sale price for 29 houses in Central Davis in 1999
*     29 observations on 9 variables 

**** 7.1 EXAMPLE: HOUSE PRICE AND SIZE

clear
use AED_HOUSE.DTA
summarize

* Table 7.1
regress price size

**** 7.3 CONFIDENCE INTERVALS

* Example with artifical data
clear
input x y 
 1 1
 2 2
 3 2
 4 2
 5 3
end
regress y x

***** 7.4 TESTS OF STATISTICAL SIGNIFICNACE

clear
use AED_HOUSE.DTA
regress price size

**** 7.5 TWO-SIDED HYPOTHESIS TESTS

regress price size
test size = 90

* Compute manually
scalar t = (_b[size] - 90)/_se[size]
scalar pvalue = 2*ttail(27,abs(t))
scalar critvalue = invttail(27,.025)
display "t = " t "  p = " pvalue "  critical value = " critvalue

* Figure 7.1 - generated elsewhere is similar to Figure 4.3 

**** 7.6 ONE-SIDED HYPOTHESIS TESTS

clear
use AED_HOUSE.DTA
regress price size
ttest size = 90
* Halve the two-sided p-value provided  
* t>0 for an upper one-tailed alternativ
* t<0 for a lower one-tailed alternativ

****  7.7 ROBUST STANDARD ERRORS

* Heteroskedastic robust
regress price size, vce(robust)

********** CLOSE OUTPUT

log close
