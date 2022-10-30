* aed_ch09.do March 2021 For Stata version 16

capture log close   // capture means program continues even if no log file open
log using aed_ch09.txt, text replace

********** OVERVIEW OF aed_ch09.do **********

* STATA Program 
* copyright C 2021 by A. Colin Cameron
* Used for "Analyis of Economics Data: An Introduction to Econometrics"
* by A. Colin Cameron (2021) 

* To run you need file
*   AED_EARNINGS.DTA
*   AED_SP500INDEX
* in your directory

********** SETUP **********

set more off
clear all
* version 16
* set linesize 82
set scheme s1mono  /* Graphics scheme */

************

* This STATA does analysis for Chapter 9
*  9.1 NATURAL LOGARITHM FUNCTION
*  9.2 SEMI-ELASTICITIS AND ELASTICITIES
*  9.3 LOG-LINEAR, LOG-LOG AND LINEAR-LOG MODELS
*  9.4 EXAMPLE: EARNINGS AND EDUCATION
*  9.5 FURTHER USES OF THE NATURAL LOGARITHM
*  9.6 EXPONENTIAL FUNCTION 

****  9.1 NATURAL LOGARITHM FUNCTION

* Table 9.1
display "True dx/x  Approximation  Percent error"
display %9.5f (101-100)/100 %12.5f ln(101)-ln(100) %12.3f  ///
    100*((ln(101)-ln(100)) - ((101-100)/100)) /((101-100)/100)
display %9.5f (105-100)/100 %12.5f ln(105)-ln(100) %12.3f  ///
    100*((ln(105)-ln(100)) - ((105-100)/100)) /((105-100)/100)
display %9.5f (110-100)/100 %12.5f ln(110)-ln(100) %12.3f  ///
    100*((ln(110)-ln(100)) - ((110-100)/100)) /((110-100)/100)
display %9.5f (115-100)/100 %12.5f ln(115)-ln(100) %12.3f  ///
    100*((ln(115)-ln(100)) - ((115-100)/100)) /((115-100)/100)
display %9.5f (120-100)/100 %12.5f ln(120)-ln(100) %12.3f  ///
    100*((ln(120)-ln(100)) - ((120-100)/100)) /((120-100)/100)

****  9.2 SEMI-ELASTICITIS AND ELASTICITIES

****  9.3 LOG-LINEAR, LOG-LOG AND LINEAR-LOG MODELS

****  9.4 EXAMPLE: EARNINGS AND EDUCATION

clear
use AED_EARNINGS.DTA
describe
summarize

generate lnearn = ln(earnings)
generate lneduc = ln(education)

* Table 9.2
summarize earnings lnearn education lneduc

* Table 9.3
* Linear Model
regress earnings education
regress earnings education, vce(robust)
* Log-linear Model
regress lnearn education
* Log-log Model
regress lnearn lneduc
* Linear-log Model
regress earnings lneduc

* Figure 9.1 - first and second panels
graph twoway (scatter earnings education) (lfit earnings education)
graph twoway (scatter lnearn education) (lfit lnearn education)
* graph export aed09fig1.wmf, replace

****  9.5 FURTHER USES OF THE NATURAL LOGARITHM

* Table 9.4
display "x        ln(1+x)"
display %9.5f 0.01 %9.5f ln(1+0.01)
display %9.5f 0.05 %9.5f ln(1+0.05)
display %9.5f 0.10 %9.5f ln(1+0.10)
display %9.5f 0.15 %9.5f ln(1+0.15)
display %9.5f 0.20 %9.5f ln(1+0.20)

* Table 9.5
display "r    ln2/ln(1+r/100)   72/r"
display %9.1f "1" %15.2f ln(2)/ln(1+1/100) %9.0f 72/1
display %9.1f "2" %15.2f ln(2)/ln(1+2/100) %9.0f 72/2
display %9.1f "3" %15.2f ln(2)/ln(1+3/100) %9.0f 72/3
display %9.1f "4" %15.2f ln(2)/ln(1+4/100) %9.0f 72/4
display %9.1f "6" %15.2f ln(2)/ln(1+6/100) %9.0f 72/6
display %9.1f "8" %15.2f ln(2)/ln(1+8/100) %9.0f 72/8
display %9.1f "9" %15.2f ln(2)/ln(1+9/100) %9.0f 72/9

clear
use AED_SP500INDEX.DTA
describe
summarize

* To predict exponential growth in the graph in levels
regress lnsp500 year
predict plnsp500
* Correct for retransformation bias - see chapter 15.6
generate psp500 = exp(plnsp500)*exp(e(rmse)^2/2)

** Figure 9.2
graph twoway (line sp500 year) (line psp500 year)
graph twoway (line lnsp500 year) (lfit lnsp500 year)

****  9.6 EXPONENTIAL FUNCTION 

********** CLOSE OUTPUT
log close
