* aed_ch01.do February 2021 For Stata version 16 

*log using aed_ch01.txt, text replace

********** OVERVIEW OF aed_ch01.do **********

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
*set scheme s1manual  // Graphics scheme
*set scheme gg_tableau, permanently

************

* This STATA program does analysis for Chapter 1
*  1.3 REGRESSION ANALYSIS

********** DATA DESCRIPTION

* House sale price for 29 houses in Central Davis in 1999
*     29 observations on 9 variables 

****  1.3 REGRESSION ANALYSIS

clear
use AED_HOUSE.DTA
describe
summarize

* Figure 1.1
label variable price "House price (in dollars)"
label variable size  "House size (in square feet)"
graph twoway (scatter price size) (lfit price size)
* graph export aed01fig1.wmf, replace


********** CLOSE OUTPUT

*log close


