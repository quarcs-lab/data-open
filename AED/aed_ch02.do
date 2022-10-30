* aed_ch02.do February 2021 For Stata version 16 

*log using aed_ch02.txt, text replace

********** OVERVIEW OF aed_ch02.do **********

* STATA Program 
* copyright C 2021 by A. Colin Cameron
* Used for "Analyis of Economics Data: An Introduction to Econometrics"
* by A. Colin Cameron (2021) 

* To run you need file
*   AED_EARNINGS.DTA
*   AED_REALGDPPC.DTA  
*   AED_HEALTHCATEGORIES.DTA
*   AED_FISHING.DTA
*   AED_MONTHLYHOMESALES.DTA
* in your directory

********** SETUP **********

set more off
* version 16
clear all
*set scheme s1manual  /* Graphics scheme */

************

* This STATA does analysis for Chapter 2
*   2.1 SUMMARY STATISTICS FOR NUMERICAL DATA 
*   2.2 CHARTS FOR NUMERICAL DATA
*   2.3 CHARTS FOR NUMERICAL DATA BY CATEGORY
*   2.4 SUMMARY AND CHARTS FOR CATEGORICAL DATA
*   2.5 DATA TRANSFORMATION
*   2.6 DATA TRANSFORMATION FOR TIME SERIES DATA
 
********** DATA DESCRIPTION

* (1) Annual Earnings for 191 women aged 30 years in 2010 Full-time workers
*     191 observations on 4 variables
* (2) U.S. quarterly GDP and related data from 1959Q1 to 2020Q1
*     245 Observations on 11 variables
* (3) U.S. Health Expenditures in 2018
*     11 Observations on 2 variables
* (4) Fishing site data 
*     1182 observations on 17 variables
* (5) Monthly existing home sales in the U.S. 1999 - 2015 
*     193 observations on several variables

****   2.1 SUMMARY STATISTICS FOR NUMERICAL DATA 

* Read in data
clear
use AED_EARNINGS.DTA
describe
summarize

* Table 2.1 
summarize earnings, detail

* Figure 2.1 - skip as lengthy code

* Figure 2.2
label variable earnings "Annual earnings (in dollars)"
graph box earnings
graph box earnings, scale(1.3)    // increase scale makes easier to read
* graph export aed02fig1.wmf, replace

* Figure 2.3 - skip as lengthy code

**** 2.2  CHARTS FOR NUMERICAL DATA 

* Table 2.2
tabulate earnings
generate earningsrange = int(earnings/15000)
tabulate earningsrange

* Figure 2.4
histogram earnings              // default plotsd the density so area is one
histogram earnings, frequency   // instead plot the frequency
histogram earnings, start(0) width(15000) frequency  // set bin width
histogram earnings, start(0) width(7500) frequency   // set narrower bin width

* Figure 2.5
kdensity earnings               // default window width
kdensity earnings, bwidth(5000) // set bin width 

* Read in data for Figure 2.6
clear 
use AED_REALGDPPC
describe
summarize

line realgdppc quarter   // default gives number of quarters on horizontal axis

* Figure 2.6 - requires special Stata format command for horizontal axis
format quarter %tqCCYY   // This will just print the year
line realgdppc quarter, xtitle("Year")

* Equivalent using tsline which assumes data is Stata xtset
tsline realgdppc, xtitle("Year") 

**** 2.3  CHARTS FOR NUMERICAL DATA BY CATEGORY

* Read in data for Figure 2.7
clear
use AED_HEALTHCATEGORIES
summarize

* Table 2.3
list

* Figure 2.7
graph bar expenditures, over(category)  // default is hard to read
graph bar expenditures, over(category, label(angle(45)) sort(expenditures) descending) ///
   ytitle("Expenditures (in $ billions)") 

* Figure 2.8 - more complicated as uses Stata spatial data commands

**** 2.4 SUMMARY AND CHARTS FOR CATEGORICAL DATA

* Read in data for Figure 2.9
clear
use AED_FISHING.DTA
describe
summarize

* Table 2.4
tabulate mode

* Figure 2.9
graph pie one, over(mode)  // default
graph pie one, over(mode) plabel(_all name) plabel(_all percent, gap(8))

**** 2.5 DATA TRANSFORMATION

* Read in data for Figure 2.10
clear
use AED_EARNINGS.DTA
generate lnearns = ln(earnings)

** Figure 2.10
graph twoway (histogram earnings)
graph twoway (histogram lnearns)

histogram earnings
histogram earnings

* Following combines into one figure with two panels
graph twoway (histogram earnings), saving(graph1, replace)
graph twoway (histogram lnearns), saving(graph2, replace)
graph combine graph1.gph graph2.gph, iscale(1.2) ysize(2.5) xsize(6) rows(1)

**** 2.6 DATA TRANSFORMATIONS FOR TIME SERIES DATA 

* Read in data for Figure 2.11
clear
use AED_MONTHLYHOMESALES.DTA
describe
summarize
keep if year >= 2005

** Figure 2.11 
graph twoway (tsline exsales, lwidth(medthick)) (tsline exsales_ma11)
graph twoway (tsline exsales, lwidth(medthick))

* Read in data for Figure 2.12
clear
use AED_REALGDPPC.DTA
describe
summarize

** Table 2.5 data 
list gdp realgdp gdppc realgdppc gdpdef pop year in 1, clean
list gdp realgdp gdppc realgdppc gdpdef pop year in l, clean

** Figure 2.12
graph twoway (tsline gdp realgdp)     // default
graph twoway (tsline gdppc realgdppc) // default
format quarter %tqCCYY                // to print year on horizontal axis  
graph twoway (tsline gdp) (tsline realgdp)
graph twoway (tsline gdppc) (tsline realgdppc)

********** CLOSE OUTPUT

*log close
