* Import data
import delimited "https://github.com/quarcs-lab/data-open/raw/master/isds/jtrain0.csv", case(preserve) clear

* Generate change variable
gen change = SR88 - SR87

* Descriptive statistics
sum

* Confidence interval 
ci mean change


![](https://github.com/quarcs-lab/data-open/raw/master/isds/img/ci_mean.png)
