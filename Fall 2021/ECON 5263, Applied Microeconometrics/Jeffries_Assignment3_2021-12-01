log using "O:\Fall 2021\U of A\MET HW\METHW 3\Jeffries_HW3_log"


** ECON 5783, Assignment 3
** Written by: Robby Jeffries
** Date: 11/29/2021





// ------ (1) Install packages

local install = 1 // Change this to 1 to download packages/schemes for this project

if `install' == 1 {
	ssc install ietoolkit
	ssc install estout
}





// ------ (2) Setup environment

clear all

cd "O:\Fall 2021\U of A\MET HW\METHW 3\"
use CA_schools_es.dta

keep if stype == "E"

**Normalize test  scores 

sum mathscore
replace mathscore = (mathscore - r(mean))/r(sd)

sum readingscore
replace readingscore = (readingscore - r(mean))/r(sd)

gen average_score = (mathscore+readingscore)/2





// ------ (3) Generate new variables

gen norm = api_rank - 643

** Generate new variable to distinguish between treatment and control groups **
gen treatment = 0
replace treatment = 1 if api_rank <= 643

** Generate new variable to capture pre/post treatment period status **
gen post = 0
replace post = 1 if year >= 2005

** Generate new variable for the DID interaction term **
gen tr_post = treatment*post

** Generate a numeric school id called, sid **
encode cds, generate(sid)





// ------ (4) Compare baseline school characteristics using a balance table
iebaltab api_rank yrs_teach yrs_dist fte_t fte_a fte_p frl pct_ai asian pct_as pac pct_pi fil pct_fi hisp pct_hi afam pct_aa wht pct_wh mnr pctmnr pct_other percentfrl classsize average_score if year==2003, grpvar(treatment) save("O:\Fall 2021\U of A\MET HW\METHW 3\balancetable.xlsx") replace





// ----- (5) Estimate Treatment Effect

global controls "total yrs_teach yrs_dist fte_t fte_a fte_p pct_ai pct_as pct_pi pct_fi pct_hi pct_aa pct_wh pctmnr pct_other percentfrl classsize"


** Estimate the treatment effects for readingscore and mathscore **
**
** Elementary Schools
eststo regE1: qui reg readingscore treatment post tr_post, vce(cluster cds)
estadd local has_controls "No"
eststo regE2: qui reg readingscore treatment post tr_post $controls, vce(cluster cds)
estadd local has_controls "Yes"
eststo regE3: qui reg mathscore treatment post tr_post, vce(cluster cds)
estadd local has_controls "No"
eststo regE4: qui reg mathscore treatment post tr_post $controls, vce(cluster cds)
estadd local has_controls "Yes"
esttab regE*, se ti("Elementary Schools") drop($controls) stats(has_controls N r2 r2_a)





// ----- (6) Estimate Treatment Effect with Smaller Bandwidths

** Estimate the treatment effects for readingscore for Elementary Schools
** Bandwidth of 100
eststo regBR1: qui reg readingscore treatment post tr_post if abs(norm) < 100, vce(cluster cds)
estadd local has_controls "No"
eststo regBR2: qui reg readingscore treatment post tr_post $controls if abs(norm) < 100, vce(cluster cds)
estadd local has_controls "Yes"
** Bandwidth of 50
eststo regBR3: qui reg readingscore treatment post tr_post if abs(norm) < 50, vce(cluster cds)
estadd local has_controls "No"
eststo regBR4: qui reg readingscore treatment post tr_post $controls if abs(norm) < 50, vce(cluster cds)
estadd local has_controls "Yes"
** Bandwidth of 20
eststo regBR5: qui reg readingscore treatment post tr_post if abs(norm) < 20, vce(cluster cds)
estadd local has_controls "No"
eststo regBR6: qui reg readingscore treatment post tr_post $controls if abs(norm) < 20, vce(cluster cds)
estadd local has_controls "Yes"
esttab regBR*, se ti("Elementary Schools Reading Scores") drop($controls) stats(has_controls N r2 r2_a)

** Estimate the treatment effects for mathscore for Elementary Schools
** Bandwidth of 100
eststo regBM1: qui reg mathscore treatment post tr_post if abs(norm) < 100, vce(cluster cds)
estadd local has_controls "No"
eststo regBM2: qui reg mathscore treatment post tr_post $controls if abs(norm) < 100, vce(cluster cds)
estadd local has_controls "Yes"
** Bandwidth of 50
eststo regBM3: qui reg mathscore treatment post tr_post if abs(norm) < 50, vce(cluster cds)
estadd local has_controls "No"
eststo regBM4: qui reg mathscore treatment post tr_post $controls if abs(norm) < 50, vce(cluster cds)
estadd local has_controls "Yes"
** Bandwidth of 20
eststo regBM5: qui reg mathscore treatment post tr_post if abs(norm) < 20, vce(cluster cds)
estadd local has_controls "No"
eststo regBM6: qui reg mathscore treatment post tr_post $controls if abs(norm) < 20, vce(cluster cds)
estadd local has_controls "Yes"
esttab regBM*, se ti("Elementary Schools Math Scores") drop($controls) stats(has_controls N r2 r2_a)





// ----- (7) Test the Parallel Trends Assumption

** Generate new variable to capture pre/post treatment period status **
gen post2 = 0
replace post2 = 1 if year >= 2006

** Generate new variable for the DID interaction term **
gen tr_post2 = treatment*post2




************************************* ELEMENTARY SCHOOLS *************************************
didregress (readingscore) (tr_post2), group(sid) time(year), if year >= 2003
estat trendplots
estat ptrends // passes parallel trends test

didregress (mathscore) (tr_post2), group(sid) time(year), if year >= 2003
estat trendplots
estat ptrends // fails parallel trends test

**********************************************************************************************

* We're going to store the coefficients and standard errors from a regression
	gen coef = . // Empty coefficient variable
	gen se = . // Empty standard error variable
	
	* Now let's repeat our regression, 
	* Add the coeflegend option to see how results are labeled by Stata.
	reg readingscore treatment##b2004.year, vce(cluster sid) coeflegend
	
	* Let's use a for loop to populate those empty coef and se variables
	levelsof year, l(times)
	foreach t in `times' {
		replace coef = _b[1.treatment#`t'.year] if year == `t' // coefficients
		replace se = _se[1.treatment#`t'.year] if year == `t' // standard errors
	}
	
	* A little bit more cleaning before graphing
	*keep year coef se // Keep just the variables we need
	duplicates drop year, force // And one obs per year
	sort year // Sorting by year
	
	* Make some 95% confidence intervals
	gen ci_top = coef+(1.96*se)
	gen ci_bottom = coef-(1.96*se)
	
	* Time for out nice graph!
	#delimit ;
	twoway (rcap ci_top ci_bottom year, lcolor(red%70) xline(12) yline(0)) ||
		(scatter coef year, connect(line) lcolor(black) mcolor(black)
		ytitle("Reading Scores") xtitle("Year")
		legend(lab(1 "95% Confidence Interval") lab(2 "Point Estimate") pos(6) row(1)));
	#delimit cr
	
	
//// UNCOMMENT THIS SECTION TO PRODUCE A PRE-TRENDS GRAPH FOR ELEMENTARY SCHOOL MATH SCORES
//
// * We're going to store the coefficients and standard errors from a regression
// 	gen coef = . // Empty coefficient variable
// 	gen se = . // Empty standard error variable
//	
// 	* Now let's repeat our regression, 
// 	* Add the coeflegend option to see how results are labeled by Stata.
// 	reg mathscore treatment##b2004.year, vce(cluster sid) coeflegend
//	
// 	* Let's use a for loop to populate those empty coef and se variables
// 	levelsof year, l(times)
// 	foreach i in `times' {
// 		replace coef = _b[1.treatment#`i'.year] if year == `i' // coefficients
// 		replace se = _se[1.treatment#`i'.year] if year == `i' // standard errors
// 	}
//	
// 	* A little bit more cleaning before graphing
// 	* keep year coef se // Keep just the variables we need
// 	duplicates drop year, force // And one obs per year
// 	sort year // Sorting by year
//	
// 	* Make some 95% confidence intervals
// 	gen ci_top = coef+(1.96*se)
// 	gen ci_bottom = coef-(1.96*se)
//	
// 	* Time for out nice graph!
// 	#delimit ;
// 	twoway (rcap ci_top ci_bottom year, lcolor(red%70) xline(12) yline(0)) ||
// 		(scatter coef year, connect(line) lcolor(black) mcolor(black)
// 		ytitle("Math Scores") xtitle("Year")
// 		legend(lab(1 "95% Confidence Interval") lab(2 "Point Estimate") pos(6) row(1)));
// 	#delimit cr

*********************
* Housekeeping
*********************

log close

translate "O:\Fall 2021\U of A\MET HW\METHW 3\Jeffries_HW3_log.smcl"  "O:\Fall 2021\U of A\MET HW\\METHW 3\Jeffries_HW3_log.pdf"