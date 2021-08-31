/* ------------------------------------------------------------------------------ */
/*                                                                                */
/* This program estimates the demand for cigarettes                               */
/* Because of heteroskedasticity, estimation is performed with OLS, WLS, and FGLS */
/*                                                                                */
/* ------------------------------------------------------------------------------ */

* Install the package that allows Wooldridge data to be read directly from Boston College

  ssc install bcuse


* Load Wooldridge's smoke.csv data from BC

  bcuse smoke

* Use an OLS regression to estimate daily cigaratte consumption

  regress cigs lincome lcigpric educ age agesq restaurn


* Generate a scatter plot of residuals against fitteed values (adding a horizontal line at 0)

  rvfplot, yline(0)

* Plot residuals against a predictor (educ, in this case)

  rvpplot lincome, yline(0)


* The first plot strongly suggests heteroskedasticity; formally test with Bruesch-Pagan test

  hettest

* Due to heteroskedasticity OLS standard errors are biased, so tests based on them will be wrong

  * Solution:  Take the heteroskedasticity into account in the regression
  
     * Use "corrected" (robust) standard errors
     * If the heteroskedastic covariance matrix is known, use generalized least squares (GLS)
	   * WLS is special case of GLS
	 * If the covariance matrix is unknown, estimate it as part of feasible generalized least squares (FGLS)

* White's heteroskedastic robust var-cov matrix

  regress cigs lincome lcigpric educ age agesq restaurn, vce(robust)
  matrix list e(V)
  
  * White's test for heteroskedasticity
  
    estat imtest, white
	
* Nonparametric bootstrap to estimate a heteroskedasticty robust covariance matrix

  regress cigs lincome lcigpric educ age agesq restaurn, vce(bootstrap, rep(500))
  matrix list e(V)

  * 'estat imtest' performs the Cameron-Trivedi provides decomposition for heteroskedasticity, skew, and kurtosis
  * White's test for heteroskedasticity (a specialized form of 'hettest') is requested with the option 'white'
  
    estat imtest, white

* Perform weighted least squares (WLS) using wls0
  * The command wls0 allows the following weighting schemes: 1) abse - absolute value of residual, 
  * 2) e2 - residual squared, 3) loge2 - log residual squared, and 4) xb2 - fitted value squared
  
  * Could also use 'regress' with the analytical weights options
  
* Install wls0 if needed -- run the follow command, then follow the instructions
 
  * search wls0
  
* Use a WLS regression to estimate daily cigaratte consumption

  wls0 cigs lincome lcigpric educ age agesq restaurn, wvar(lincome lcigpric) type(abse) graph

* Feasible Generalized Least Squares (FGLS)

  * FGLS transforms the data to ameliorate heteroskedastity and then runs a regression on the transformed data
  
    * Estimate the model with OLS and save the resiudals
	* Use OLS residuals to estimate a regression for the error variance and predict the individual variances, w
	* Perform a linear regression using the weights 1/w

    regress cigs lincome lcigpric educ age agesq restaurn  // Estimate the regression model by OLS
    
	predict e, residual  // Save the residuals in the variable e

    generate loge2 = log(e^2) // Generate the log of the squared residual

    regress loge2 lincome lcigpric educ age agesq restaurn // Use the logged squared residuals to estimate a regression model for the error variance

    predict u2_resid  // Predict the residuals of the variance regression

    generate w = exp(u2_resid)

    regress cigs lincome lcigpric educ age agesq restaurn [aweight = 1/w] // perform a linear regression using the weights
