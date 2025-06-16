/*
This routine implements the Oaxaca estimator of treatment effects 
used in Kline and Moretti (2013). The routine allows for clustering 
or for standard errors based upon the spatial HAC method of Conley (1999). 
It is based on Tim Conley's Stata routine x_ols and prior code for 
Kline's (2011) implementation of the Oaxaca estimator of average treatment 
effects. This implementation is vectorized in Mata which makes it substantially 
faster than Conley's original code.

Example syntax for OLS estimation with Conley standard errors is:

x_ols Y $X, lat(latitude) long(longitud) cut1(200) cut2(200)

where lat() and long() give the latitude and longitude of each unit and 
cut1() cut2() define the bandwidth for the HAC estimator of spatial dependence 
in terms of miles.

Example syntax for Oaxaca estimate of treatment on the treated with Conley 
standard errors is:

x_ols Y $X, lat(latitude) long(longitud) cut1(200) cut2(200) bo(D)

where D is an indicator that equals one for treated units.

Example syntax for Oaxaca estimation with clustering is of the form:

x_ols Y $X, cluster(state) bo(D)


Two caveats for researchers hoping to adapt this code to other purposes:

1) Do not use weights with this routine unless you know what you are doing. 
We have not tested this feature.

2) The Oaxaca standard errors implemented here will tend to be mildly 
conservative (i.e. larger than necessary) for two reasons. First, they assume 
the treated and control units are statistically independent. If they are instead 
positively correlated, which can occur with clustering or spatial HAC, then the 
true variance will be smaller because the difference of means will involve a 
-2*Cov term. Second, these standard errors treat the mean of X in the treatment 
group as fixed. It can be shown analytically (see Kline, 2013) that accounting 
for this additional uncertainty will again tend to reduce the variance. We used 
these conservative assumptions for TVA because spatial HAC's are likely to 
undercover in practice, even with a large bandwidth. We have also computed 
variance estimates that allow for treatment / control dependence and uncertainty 
in the mean treated X's -- these yield slightly smaller standard errors. For 
example, column 5 of Table III-Panel A in Kline and Moretti (2013) yields a HAC
standard error on the manufacturing impact of 0.023. Allowing for T/C dependence 
and uncertainty in the mean X's yields a HAC standard error of .018.


References:
Conley, Timothy G. 1999. "GMM estimation with cross sectional dependence." 
Journal of econometrics 92(1): 1-45.
Kline, Patrick. 2011. "Oaxaca-Blinder as a reweighting estimator." 
American Economic Review 101(3): 532-37.
Kline, Patrick. 2013. "A Note on Variance Estimation for the Oaxaca Estimator of
Average Treatment Effects." working paper.
Kline, Patrick, and Enrico Moretti. 2013. "Local economic development, 
agglomeration economies and the big push: 100 years of evidence from the 
Tennessee Valley Authority." NBER WP #19293.
*/


clear mata
version 10

*******************************************************
*******************************************************
mata:
real matrix distance(string scalar latvar, string scalar longvar, string scalar s, scalar coord) 
 { 
   
   real colvector latitude
   real colvector longitude
   real colvector dlat
   real colvector dlong
   real colvector R
   real colvector V
   real colvector lati
   real colvector latj
   real colvector a
   real colvector d
   real colvector min
   real colvector c
   real colvector D
   
   latitude =st_data(., latvar,s)*pi()/180
   
      
   R=3963 - 13*sin(latitude[1])
   V = J(rows(latitude),rows(latitude),1)
     
   if (coord==1){
		dlat =  latitude:*V-latitude':*V
		a = sin(dlat:/2):^2 
   }
  
   if (coord==2){
		lati = latitude:*V
		latj = latitude':*V
		longitude=st_data(.,longvar,s)*pi()/180
		dlong = longitude:*V-longitude':*V
		a= cos(lati):*cos(latj):*sin(dlong:/2):^2
   }
  
   R=3963 - 13*sin(latitude[1])
   
   d     = sqrt(a)
   min   = (d:<=1):*d + (d:>1)
   c     = 2*asin(min)
   D     = R*c
   
   return(D)
}
end

*******************************************************
*******************************************************

mata:
real matrix window(matrix dis1, matrix dis2, scalar cut1, scalar cut2) 
{
   real colvector window1 
   real colvector window2 
   real colvector window
  
   V = J(rows(dis1),rows(dis1),1)
  
   window1 = V
   window1=window1:*(V-dis1/cut1)
   window1=window1:*(dis1:<cut1)  

   window2=window1:*(V-dis2/cut2)
   window2=window2:*(dis2:<cut2)
   window=window2
   return(window)
}
end

*****************************
*****************************
mata:
real matrix cov(matrix X, matrix W, vector epsilon, vector weight)
{
   	real colvector N 
   	real colvector xreg
   	real colvector XUUk 
   	real colvector XUUX1
   	real colvector XUUX
   	real colvector k
   	real colvector XUUK
   	real colvector x1
	real colvector x2
	real colvector invXX
	real colvector cov
	N = rows(epsilon)
	xreg = rows(X')
	XUUK = J(N,xreg,0)
	XUUX=J(xreg,xreg,0)

	for (k=1; k<=xreg; k++){
		x1 = epsilon*(X[.,k])'
		x2 = (epsilon:*W)'
		XUUk = x1:*x2
		XUUX1 = cross(XUUk,weight,X)/N
		XUUX[k,.] = colsum(XUUX1:*weight)
	}

invXX = invsym(cross(X,weight,X)/N)
cov = invXX*XUUX*invXX'/(N-xreg)
return(cov)
}
end


*************************************************************************************************
*************************************************************************************************

*! matnames 1.01 11july2009 took out eval =
*! matnames 1.0 16apr2009
*! Program to put row and column names in r()
*! posted to Statalist by Austin Nichols 16 April 2009
cap program drop matnames
prog matnames, rclass
 version 9.2
 syntax anything [, *]
 cap conf matrix `anything'
 if _rc {
  di as err "matrix `anything' not found"
  error 198
  }
 forv i=1/`=rowsof(`anything')' {
  mata: getRNames("`anything'",`i')
  loc r `"`r' `"`r1':`r2'"'"'
  }
 forv i=1/`=colsof(`anything')' {
  mata: getCNames("`anything'",`i')
  loc c `"`c' `"`r1':`r2'"'"'
  }
 return local r `"`r'"'
 return local c `"`c'"'
end
version 9.2
mata:
 void getRNames(string scalar b, real scalar i)
 {
   r=st_matrixrowstripe(b)
   st_local("r1", r[i,1])
   st_local("r2", r[i,2])
 }
 void getCNames(string scalar b, real scalar i)
 {
   c=st_matrixcolstripe(b)
   st_local("r1", c[i,1])
   st_local("r2", c[i,2])
 }
end

*****************************
*****************************
capture program drop x_ols_JP
program x_ols_JP, eclass
version  10.0

syntax varlist(min=1) [if] [aweight pweight fweight], lat(varname) long(varname) cut1(real) cut2(real) [NOCONStant]
 
local i = 0
tempvar _sample
qui gen `_sample' = 1 `if'
qui replace `_sample'= 0 if `_sample'==. 

** noconstant option 
if ("`noconstant'"!="") {
	local noconstant noconstant
}

*weights

if "`weight'"==""{
	tempvar _ones
	gen `_ones'=1
	local weight="aweight"
	local exp = "= `_ones'"
}

local weightvar = substr("`exp'",3,.)

* Save coeff estimates - assume always there's a constant

qui regress `varlist' `if' [`weight' `exp'], `noconstant'
matrix b = e(b)

* Take the missing values out of the sample
replace `_sample'=0 if e(sample)==0

qui count if `_sample'==1
local N = r(N)

* weights - normalize so as they always sum 1.
tempvar _weight
qui gen `_weight' = 1/`N'

if "`weight'"!="" {
qui sum `weightvar' if `_sample'==1
qui replace `_weight'= `weightvar'/r(sum)
}

tempvar epsilon
predict `epsilon', residuals

* Start regressors as constant

foreach v of local varlist {
	if `i' == 0{
		tempvar Y 
		local Y	= "`v'"
		local X =""
	}	 	 
	else if `i'==1{
		mata: X = st_data(.,"`v'","`_sample'")
		local X_`i'="`v'"
		local X = "`X' `v'"
	}
	else{
		mata: Xk = st_data(.,"`v'","`_sample'")
		mata: X = (X,Xk)
		local X_`i'="`v'"
		local X = "`X' `v'"
	}
	local i = `i'+1
}


if ("`noconstant'"=="") {
	mata: C = J(`N',1,1)
	mata: X = (X,C)
}

mata: epsilon = st_data(.,"`epsilon'","`_sample'")
mata: weight = st_data(.,"`_weight'","`_sample'")
*distance in each coordinate:
mata: D1 = distance("`lat'","`long'","`_sample'",1)
mata: D2 = distance("`lat'","`long'","`_sample'",2)
mata: W = window(D1,D2,`cut1',`cut2')
mata: Vs = cov(X,W,epsilon,weight)
mata: st_matrix("e(Vs)",Vs)
mat Vs=e(Vs)
matnames b
matrix rownames Vs = `r(c)'
matrix colnames Vs = `r(c)'
ereturn repost V=Vs
reg

end


*************************************************************************************************
** Based on Matias Busso's BO routine 
*************************************************************************************************
cap program drop bo_x
program define bo_x, eclass

syntax varlist(ts) [if/] [aweight pweight fweight], Treatment(varname) [lat(varname)] [long(varname)] [cut1(real 1)] [cut2(real 1)] [cluster(varname)]
 
 ***-control of varlist
   tokenize `varlist'
   local Y = "`1'"
   macro shift
   local X "`*'"
   
 ***-control of option if
   if "`if'"=="" local if = ""
   if "`if'"!="" local andif = "& `if'"
   if "`if'"!="" local if = "if `if'"
 
  tempvar _sample
  qui gen `_sample' = 1 `if'
  qui replace `_sample'= 0 if `_sample'==. 
   
 ***-control weight option 

 *** - NOTE: this part is new

 if "`weight'"==""{
	tempvar _ones
	qui gen `_ones'=1
	local weight="aweight"
	local exp = "= `_ones'"
} 

	local weightvar = substr("`exp'",3,.)
	tempvar _weight
	qui gen `_weight'= `weightvar'

 ***-control of treatment
   local T = "`treatment'"

 ***-Interact Xs
  cap drop _C_*
    foreach x in `X'{
      qui gen _C_`x' = `x'*(1-`T') `if'
   }
 
  qui gen _C_=1-`T' `if'

  if "`cluster'"==""{
  qui x_ols_JP `Y' _C_* `T' `if' [`weight' `exp'], lat(`lat') long(`long') cut1(`cut1') cut2(`cut2') nocons 
  }
  else{
  qui reg `Y' _C_* `T' `if' [`weight' `exp'], nocons cluster(`cluster')
  }



  mat b=e(b)
  mat V=e(V)

  order `X'
  qui local K: word count `X'
  
  di "`X'"
  di "`K'"
  di "`T'"

  * NOTE: Dummy variable of Treated & Sample (if)
  
  cap drop _Ts
  qui gen _Ts = `T'*`_sample'
  
  mata: x=st_data(.,1..`K',"_Ts")
  mata: D=J(rows(x),1,1)
  mata: X=(x, D)

  mata: b=st_matrix("b")
  mata: b0=b[.,1..`K'+1]
  mata: mu1=b[.,`K'+2]
   
  * NOTE: Weight for Treated & Sample (if)

  mata: W = st_data(.,"`_weight'","_Ts")
	  
  * NOTE: previous code was mata: mu0=D'*X*b0'/(D'*D)
  * NOTE: Weighted average predicted value of treated with Control's payoffs
  
  mata: mu0=W'*X*b0'/sum(W)

  * NOTE: mu1 already includes the weights since it's the outcome of the regression that includes the weights

  mata: delt=mu1-mu0

  mata: V=st_matrix("V")
  mata: V0=V[1..`K'+1,1..`K'+1]  
  
  * NOTE: V0 is the var/covar matrix of the interacted X*C
  * NOTE: v0 is the variance of mu0
  * NOTE: previous code was mata: v0=D'*X*V0*X'*D/(D'*D)^2
  
  mata: v0=W'*X*V0*X'*W/(sum(W))^2
  mata: v1=V[`K'+2,`K'+2]
  mata: se=sqrt(v1+v0)
  
  mata: st_numscalar("delt",delt)
  mata: st_numscalar("serr",se)

  qui reg `Y' `T' if e(sample), nocons
  mat bnew=delt
  mat Vnew=serr^2
  ereturn repost b=bnew V=Vnew
  reg
end
 
*****************************
*****************************
capture program drop x_ols
program x_ols, eclass
version  10.0

syntax varlist(min=1) [if] [aweight pweight fweight] [,lat(varname) long(varname) cut1(real 999999999999) cut2(real 999999999999) bo(varname) cluster(varname)]

	
if "`bo'"==""{
	if "`cluster'"==""{
		if ("`lat'"==""){ 
		di as err "lat option needed if not using bo"
		exit 198
		}
		
		if ("`long'"==""){ 
		di as err "long option needed if not using bo"
		exit 198
		}

		if ("`cut1'"=="999999999999"){ 
		di as err "cut1 option needed if not using bo"
		exit 198
		}
	
		if ("`cut2'"=="999999999999"){ 
		di as err "cut2 option needed if not using bo"
		exit 198
		}
		x_ols_JP `varlist' `if' [`weight' `exp'], lat(`lat') long(`long') cut1(`cut1') cut2(`cut2')	
	
	}
	else {
		di as err "cluster option is not valid"
		exit 198
		}
	
}

else{
	if "`cluster'"==""{
		if ("`lat'"==""){ 
		di as err "lat option needed if not using cluster"
		exit 198
		}
		
		if ("`long'"==""){ 
		di as err "long option needed if not using cluster"
		exit 198
		}

		if ("`cut1'"=="999999999999"){ 
		di as err "cut1 option needed if not using cluster"
		exit 198
		}
	
		if ("`cut2'"=="999999999999"){ 
		di as err "cut2 option needed if not using cluster"
		exit 198
		}	
	
		bo_x `varlist' `if' [`weight' `exp'], treatment(`bo') lat(`lat') long(`long') cut1(`cut1') cut2(`cut2')
	}
	
	else{
		if ("`lat'"!=""){ 
		di as err "lat option not allowed if using cluster"
		exit 198
		}
		
		if ("`long'"!=""){ 
		di as err "long option not allowed if using cluster"
		exit 198
		}

		if ("`cut1'"!="999999999999"){ 
		di as err "cut1 option not allowed if using cluster"
		exit 198
		}
	
		if ("`cut2'"!="999999999999"){ 
		di as err "cut2 option not allowed if using cluster"
		exit 198
		}
		bo_x `varlist' `if' [`weight' `exp'], treatment(`bo') cluster(`cluster')
	}
}

end

	
