log using "O:\Fall 2021\U of A\MET HW\Final Project\Adopo_Jeffries_Final_log"

/* READ ME

University of Arkansas, Fayetteville, Arkansas
Walton Graduate School of Business
ECON 5783, Applied Microeconometrics

For: Course Project
Written by: Daryl Adopo & Robby Jeffries
Date: 17 December 2021

*/





**#
// ---------------------------------------------------- (0) Installing packages and graph schemes

local install = 1 // Change this to 1 to download packages/schemes for this project

if `install' == 1 {
	ssc install rdrobust, replace // Includes many useful commands for RDD
	ssc install estout, replace // For storing and outputting results
	net install rddensity, from("https://raw.githubusercontent.com/rdpackages/rddensity/master/stata") replace
	net install lpdensity, from("https://raw.githubusercontent.com/nppackages/lpdensity/master/stata") replace
	net install rdpower, from("https://raw.githubusercontent.com/rdpackages/rdpower/master/stata") replace


		/* Note on Schemes: The default graphing options in STATA are ugly.
			A user-developed package called schemepack includes many more
			visually appealing schemes. The code below installs that package
			and sets the scheme to one I like, but you should check out the
			github page and pick one for yourself
			
			https://github.com/asjadnaqvi/Stata-schemes */
			
	ssc install schemepack, replace // Appealing graph schemes (optional)
	set scheme white_tableau // Add ", perm" after this command to lock change in
}

******************************************************************************************




**#
// ----------------------------------------------------- (1) Loading data and initial exploration
import delimited using "O:\Fall 2021\U of A\MET HW\Final Project\county_census_vax.csv", clear

// NOTE: Our COVID data is from one day, 11/16/2020. 

* First thing to do is get a sense of our variables
summarize _all, sep(0)

* Convert string to float
destring perc, replace force

// Often RDDs are motivated by a simple scatterplot with the running variable on the x-axis and outcome on the y.
// Try making such a scatter plot here.
twoway scatter case_rate perc, xline(0.5) // Make a simple scatterplot

label variable perc "Percent Republican"
gen bin = floor(perc*100) // Creating bins of each percentage
replace bin = bin + 1 if bin >= 0 // Personal preference not to have a 0 bin
bysort bin: egen avg_deaths = mean(death_rate) // Average death rate by bin
twoway scatter avg_deaths bin, xline(50) // Make a simple scatterplot

******************************************************************************************





**#
// ---------------------------------------------------- (2) Testing for gaming, heaping and power
* We need to check for a few issues that might undermine the continuity assumption.
* Firstly, do we see evidence that people "gamed" the cutoff to try to get on one side?
bysort bin: egen count = count(bin)
twoway bar count bin, xline(50)


* Testing for gaming of the cutoff
rddensity perc, c(0.5) plot ///
cirl_opt(color(blue%0)) cirr_opt(color(red%0)) /// left and right confidence interval
esll_opt(color(blue%0)) eslr_opt(color(red%0)) /// left and right line
histl_opt(color(blue%30) barwidth(.009)) /// left histogram
histr_opt(color(red%30) barwidth(.007)) // right histogram



* Testing for statistical power (benchmark of 0.8)
rdpow case_rate perc, c(0.5) // What effect size are we powered to detect?



******************************************************************************************





**#
// --------------------------------------------------- (3a) Estimation via OLS and interpretation
gen treat = perc > 0.5 // Define a treatment variable
label variable treat "Treatment"

* Generate new variables for regressions
gen perc_std = perc - 0.5 // normalize the percent around 0
gen treat_perc = treat * perc_std // interaction term
gen perc_std2 = perc_std * perc_std	// for quadratic regression
gen treat_perc2 = treat_perc * perc_std2 // for quadratic regression
gen bins = round(perc_std, 0.01) // Creating bins of each percentage
replace bins = bins + .01 if bins >= 0 // Personal preference not to have a 0 bin
bysort bins: egen avg_deaths2 = mean(death_rate) // Average death rate by bin
bysort bins: egen avg_cases = mean(case_rate) // Average death rate by bin
bysort bins: egen avg_vax = mean(series_complete_18pluspop_pct) // Average death rate by bin

* Label Variables
la var death_rate "Death Rate"
la var case_rate "Case Rate"
la var series_complete_18pluspop_pct "Vax Rate 18+"
la var perc_std "% Republican Linear"
la var treat_perc "Treatment x % Rep."
la var perc_std2 "% Rep. Quadratic"
la var treat_perc2 "Treat x % Rep. Sqrd."

* Regressions on death rate
eststo reg_d1: qui areg death_rate treat perc_std, robust absorb(state) // linear regression without interaction term
eststo reg_d2: qui areg death_rate treat perc_std treat_perc, robust absorb(state) // linear regression with interaction term
eststo reg_d3: qui areg death_rate treat perc_std perc_std2 treat_perc treat_perc2, robust absorb(state) // quadratic regression

* Regressions on case rate
eststo reg_c1: qui areg case_rate treat perc_std, robust absorb(state) // linear regression without interaction term
eststo reg_c2: qui areg case_rate treat perc_std treat_perc, robust absorb(state) // linear regression with interaction term
eststo reg_c3: qui areg case_rate treat perc_std perc_std2 treat_perc treat_perc2, robust absorb(state) // quadratic regression

* Regressions on vaccination rate
eststo reg_v1: qui areg series_complete_18pluspop_pct treat perc_std, robust absorb(state) // linear regression without interaction term
eststo reg_v2: qui areg series_complete_18pluspop_pct treat perc_std treat_perc, robust absorb(state) // linear regression with interaction term
eststo reg_v3: qui areg series_complete_18pluspop_pct treat perc_std perc_std2 treat_perc treat_perc2, robust absorb(state) // quadratic regression

* Generate table with both linear and quadratic regressions
esttab reg_d*, se label
esttab reg_c*, se label
esttab reg_v*, se label





**#
// --------------------------------------------------- (4) BANDWIDTH TEST on RUNNING VARIABLE



est clear // clear any existing estimations



* Death Rate Bandwidth - Linear Fit
forvalues h = 0.4(-0.1)0.1 {
	qui areg death_rate treat perc_std treat_perc if abs(perc_std) <= `h', robust absorb(state) // linear regression without interaction term
	tempvar i
	gen i = `h'*10
	eststo regd1_`i'
	drop i
}	
esttab regd1_*, keep(treat) ti("Death Rates Across Multiple Bandwidths - Linear Fit") mtitles("+-40%" "+-30%" "+-20%" "+-10%") se label

* Death Rate Bandwidth - Quadratic Fit
forvalues h = 0.4(-0.1)0.1 {
	qui areg death_rate treat perc_std perc_std2 treat_perc treat_perc2 if abs(perc_std) <= `h', robust absorb(state) // linear regression without interaction term
	tempvar i
	gen i = `h'*10
	eststo regd2_`i'
	drop i
}	
esttab regd2_*, keep(treat) ti("Death Rates Across Multiple Bandwidths - Quadratic Fit") mtitles("+-40%" "+-30%" "+-20%" "+-10%") se label






* Case Rate Bandwidth - Linear Fit
forvalues h = 0.4(-0.1)0.1 {
	qui areg case_rate treat perc_std treat_perc if abs(perc_std) <= `h', robust absorb(state) // linear regression without interaction term
	tempvar i
	gen i = `h'*10
	eststo regc1_`i'
	drop i
}	
esttab regc1_*, keep(treat) ti("Case Rates Across Multiple Bandwidths - Linear Fit") mtitles("+-40%" "+-30%" "+-20%" "+-10%") se label

* Case Rate Bandwidth - Quadratic Fit
forvalues h = 0.4(-0.1)0.1 {
	qui areg case_rate treat perc_std perc_std2 treat_perc treat_perc2 if abs(perc_std) <= `h', robust absorb(state) // linear regression without interaction term
	tempvar i
	gen i = `h'*10
	eststo regc2_`i'
	drop i
}	
esttab regc2_*, keep(treat) ti("Case Rates Across Multiple Bandwidths - Quadratic Fit") mtitles("+-40%" "+-30%" "+-20%" "+-10%") se label





* Vaccination Rate Bandwidth - Linear Fit
forvalues h = 0.4(-0.1)0.1 {
	qui areg series_complete_18pluspop_pct treat perc_std treat_perc if abs(perc_std) <= `h', robust absorb(state) // linear regression without interaction term
	tempvar i
	gen i = `h'*10
	eststo regv1_`i'
	drop i
}	
esttab regv1_*, keep(treat) ti("Vaccination Rates Across Multiple Bandwidths - Linear Fit") mtitles("+-40%" "+-30%" "+-20%" "+-10%") se label

* Vaccination Rate Bandwidth - Quadratic Fit
forvalues h = 0.4(-0.1)0.1 {
	qui areg series_complete_18pluspop_pct treat perc_std perc_std2 treat_perc treat_perc2 if abs(perc_std) <= `h', robust absorb(state) // linear regression without interaction term
	tempvar i
	gen i = `h'*10
	eststo regv2_`i'
	drop i
}	
esttab regv2_*, keep(treat) ti("Vaccination Rates Across Multiple Bandwidths - Quadratic Fit") mtitles("+-40%" "+-30%" "+-20%" "+-10%") se label


******************************************************************************************




**#
// --------------------------------------------------- (5) Sharp RDD Visualizations

// Figure of Linear Regression -- Death Rate
	#delimit ;
	twoway (lfit death_rate perc_std if perc_std<0,clcolor(gs4) lpattern(dash)) 
	(lfit death_rate perc_std if perc_std>=0,clcolor(gs4) lpattern(dash)) 
	(scatter avg_deaths2 bins, msize(medsmall) msymbol(circle) mfcolor(white) mlcolor(black) mlwidth(thin) xline(0, lcolor(cranberry) lpattern(dash))), 
	ytitle("Death Rate as of 11/16/2020", size(medsmall) margin(small)) ylabel(,labsize(medsmall)  format(%10.7e)) xtitle("Distance to cutoff", size(medsmall) margin(small)) xlabel( -.50(.1).50, labsize(medsmall)) 
	graphregion(fcolor(white) lcolor(white)) legend(order(2 "Linear fit" 3 "Percentage bin") size(medlarge)) plotregion(lcolor(black) lwidth(thin));
	#delimit cr
	graph export "O:\Fall 2021\U of A\MET HW\Final Project\Figures, with Vax\LinearRegDeath.png", width(1000) replace
	
// Figure of Quadratic Regression -- Death Rate
	#delimit ;
	twoway (qfit death_rate perc_std if perc_std<0,clcolor(gs4) lpattern(dash)) 
	(qfit death_rate perc_std if perc_std>=0,clcolor(gs4) lpattern(dash)) 
	(scatter avg_deaths2 bins, msize(medsmall) msymbol(circle) mfcolor(white) mlcolor(black) mlwidth(thin) xline(0, lcolor(cranberry) lpattern(dash))), 
	ytitle("Death Rate as of 11/16/2020", size(medsmall) margin(small)) ylabel(,labsize(medsmall)  format(%10.7e)) xtitle("Distance to cutoff", size(medsmall) margin(small)) xlabel( -.50(.1).50, labsize(medsmall)) 
	graphregion(fcolor(white) lcolor(white)) legend(order(2 "Quadratic fit" 3 "Percentage bin") size(medlarge)) plotregion(lcolor(black) lwidth(thin));
	#delimit cr
	graph export "O:\Fall 2021\U of A\MET HW\Final Project\Figures, with Vax\QuadraticRegDeath.png", width(1000) replace
	
	
// Figure of Linear Regression -- Case Rate
	#delimit ;
	twoway (lfit case_rate perc_std if perc_std<0,clcolor(gs4) lpattern(dash)) 
	(lfit case_rate perc_std if perc_std>=0,clcolor(gs4) lpattern(dash)) 
	(scatter avg_cases bins, msize(medsmall) msymbol(circle) mfcolor(white) mlcolor(black) mlwidth(thin) xline(0, lcolor(cranberry) lpattern(dash))), 
	ytitle("Case Rate as of 11/16/2020", size(medsmall) margin(small)) ylabel(,labsize(medsmall)  format(%9.2f)) xtitle("Distance to cutoff", size(medsmall) margin(small)) xlabel( -.50(.1).50, labsize(medsmall)) 
	graphregion(fcolor(white) lcolor(white)) legend(order(2 "Linear fit" 3 "Percentage bin") size(medlarge)) plotregion(lcolor(black) lwidth(thin));
	#delimit cr
	graph export "O:\Fall 2021\U of A\MET HW\Final Project\Figures, with Vax\LinearRegCase.png", width(1000) replace
	
// Figure of Quadratic Regression -- Case Rate
	#delimit ;
	twoway (qfit case_rate perc_std if perc_std<0,clcolor(gs4) lpattern(dash)) 
	(qfit case_rate perc_std if perc_std>=0,clcolor(gs4) lpattern(dash)) 
	(scatter avg_cases bins, msize(medsmall) msymbol(circle) mfcolor(white) mlcolor(black) mlwidth(thin) xline(0, lcolor(cranberry) lpattern(dash))), 
	ytitle("Case Rate as of 11/16/2020", size(medsmall) margin(small)) ylabel(,labsize(medsmall)  format(%9.2f)) xtitle("Distance to cutoff", size(medsmall) margin(small)) xlabel( -.50(.1).50, labsize(medsmall)) 
	graphregion(fcolor(white) lcolor(white)) legend(order(2 "Quadratic fit" 3 "Percentage bin") size(medlarge)) plotregion(lcolor(black) lwidth(thin));
	#delimit cr
	graph export "O:\Fall 2021\U of A\MET HW\Final Project\Figures, with Vax\QuadraticRegCase.png", width(1000) replace
	
	
// Figure of Linear Regression -- Vaccination Rate
	#delimit ;
	twoway (lfit series_complete_18pluspop_pct perc_std if perc_std<0,clcolor(gs4) lpattern(dash)) 
	(lfit series_complete_18pluspop_pct perc_std if perc_std>=0,clcolor(gs4) lpattern(dash)) 
	(scatter avg_vax bins, msize(medsmall) msymbol(circle) mfcolor(white) mlcolor(black) mlwidth(thin) xline(0, lcolor(cranberry) lpattern(dash))), 
	ytitle("Vaccination Rate as of 05/31/2021", size(medsmall) margin(small)) ylabel(,labsize(medsmall)  format(%9.2f)) xtitle("Distance to cutoff", size(medsmall) margin(small)) xlabel( -.50(.1).50, labsize(medsmall)) 
	graphregion(fcolor(white) lcolor(white)) legend(order(2 "Linear fit" 3 "Percentage bin") size(medlarge)) plotregion(lcolor(black) lwidth(thin));
	#delimit cr
	graph export "O:\Fall 2021\U of A\MET HW\Final Project\Figures, with Vax\LinearRegVax.png", width(1000) replace
	
// Figure of Quadratic Regression -- Vaccination Rate
	#delimit ;
	twoway (qfit series_complete_18pluspop_pct perc_std if perc_std<0,clcolor(gs4) lpattern(dash)) 
	(qfit series_complete_18pluspop_pct perc_std if perc_std>=0,clcolor(gs4) lpattern(dash)) 
	(scatter avg_vax bins, msize(medsmall) msymbol(circle) mfcolor(white) mlcolor(black) mlwidth(thin) xline(0, lcolor(cranberry) lpattern(dash))), 
	ytitle("Vaccination Rate as of 05/31/2021", size(medsmall) margin(small)) ylabel(,labsize(medsmall)  format(%9.2f)) xtitle("Distance to cutoff", size(medsmall) margin(small)) xlabel( -.50(.1).50, labsize(medsmall)) 
	graphregion(fcolor(white) lcolor(white)) legend(order(2 "Quadratic fit" 3 "Percentage bin") size(medlarge)) plotregion(lcolor(black) lwidth(thin));
	#delimit cr
	graph export "O:\Fall 2021\U of A\MET HW\Final Project\Figures, with Vax\QuadraticRegVax.png", width(1000) replace

	

*********************
* Housekeeping
*********************

log close

translate "O:\Fall 2021\U of A\MET HW\Final Project\Adopo_Jeffries_Final_log.smcl"  "O:\Fall 2021\U of A\MET HW\Final Project\Adopo_Jeffries_Final_log.pdf"
















