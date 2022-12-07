* aed_ch08.do March 2021 For Stata version 16

log using aed_ch08.txt, text replace

********** OVERVIEW OF aed_ch08.do **********

* STATA Program 
* copyright C 2021 by A. Colin Cameron
* Used for "Analyis of Economics Data: An Introduction to Econometrics"
* by A. Colin Cameron (2021) W.W. Norton

* To run you need file
*   AED_HEALTH2009.DTA
*   AED_CAPM.DTA
*   AED_GDPUNEMPLOY.DTA
* in your directory

********** SETUP **********

set more off
* version 16
clear all
set scheme s1manual  /* Graphics scheme */

************

* This STATA does analysis for Chapter 8
*  8.1 HEALTH OUTCOMES ACROSS COUNTRIES
*  8.2 HEALTH EXPENDITURES ACROSS COUNTRIES
*  8.3 CAPM MODEL
*  8.4 OUTPUT AND UMEMPLOYMENT IN THE U.S.

********** 8.1 HEALTH OUTCOMES ACROSS COUNTRIES

* Read in data
clear
use AED_HEALTH2009.DTA
describe
summarize
list in 1, clean

*** Summary statistics
summarize gdppc hlthpc hlthgdp lifeexp infmort

* List data
list country gdppc hlthpc hlthgdp lifeexp infmort, clean

* Table 8.1: Summary statistics
summarize gdppc lifeexp infmort
regress lifeexp hlthpc

** Figure 8.1 - first panel
twoway (scatter lifeexp hlthpc, mlabel(code)) (lfit lifeexp hlthpc)
* graph export aed08fig1.wmf, replace

regress lifeexp hlthpc, vce(robust)

* Regression without U.S.
regress lifeexp hlthpc if code!="USA"
regress lifeexp hlthpc if code!="USA", vce(robust)

*** Relationship between infant mortality and spending
regress infmort hlthpc
regress infmort hlthpc, vce(robust)
** Figure 8.1 - second panel   
twoway (scatter infmort hlthpc, mlabel(code)) (lfit infmort hlthpc)

********** 8.2 HEALTH EXOENDITURES ACROSS COUNTRIES

clear
use AED_HEALTH2009.DTA

** Table 8.2: Summary statistics
summarize gdppc hlthpc

* Linear regression
regress hlthpc gdppc
regress hlthpc gdppc, vce(robust)

* Regression without U.S.
regress hlthpc gdppc if (code!="USA" & code!="LUX")
regress hlthpc gdppc if (code!="USA" & code!="LUX"), vce(robust)

** Figure 8.2 - first panel
twoway (scatter hlthpc gdppc, mlabel(code)) (lfit hlthpc gdppc)

* Log-linear regression
regress lnhlthpc lngdppc
test lngdppc = 1
regress lnhlthpc lngdppc, vce(robust)

** Figure 8.2 - second panel
twoway (scatter lnhlthpc lngdppc, mlabel(code)) (lfit lnhlthpc lngdppc)

********** 8.3 CAPM MODEL

* Read in data
clear
use AED_CAPM.DTA
summarize
describe
list in 1, clean

* Table 8.3:  Summary statistics
summarize date rm rf rko rtgt rwmt rm_rf rko_rf rtgt_rf rwmt_rf  

* Coca Cola
regress rko_rf rm_rf 
test rm_rf = 1

** Figure 8.3 - first panel uses just the last 20% of the sample
twoway (tsline rko_rf if date > 564) (tsline rm_rf if date > 564)
twoway (line rko_rf date if date > 564) (line rm_rf date if date > 564)
** Figure 8.3 - second panel
twoway (scatter rko_rf rm_rf) (lfit rko_rf rm_rf) (lpoly rko_rf rm_rf, deg(1))

* Other standard errors
regress rko_rf rm_rf, vce(robust)
predict rko_res, res
correlate rko_res l.rko_res
newey rko_rf rm_rf, lag(13)

**** OUTPUT AND UMEMPLOYMENT IN THE U.S.

* Read in data
clear
use AED_GDPUNEMPLOY.DTA
describe
summarize
list in 1, clean

* Table 8.4: Summary statistics
summarize rgdpgrowth uratechange

* Regression 
regress rgdpgrowth uratechange
test uratechange = -2
predict pgrowth

** Figure 8.4 - first and second panels
twoway (scatter rgdpgrowth uratechange) (lfit rgdpgrowth uratechange)
twoway (line rgdpgrowth year) (line pgrowth year)

* Correlation for levels
correlate rgdp l.rgdp
corrgram rgdp, lag(10)
* Corrgram for changes
correlate rgdpgrowth l.rgdpgrowth 
corrgram rgdpgrowth, lag(10)

* HAC standard errors
newey rgdpgrowth uratechange, lag(5)
* Het robust standard errors 
regress rgdpgrowth uratechange, vce(robust)

********** CLOSE OUTPUT
log close
