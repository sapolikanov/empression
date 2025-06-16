
*** TO PERFORM REPLICATION:
***** 1. make a replication directory, put all replication data files in it, create a sub-directory "results"
***** 2. change a path to the replication directory here and then run this do file:
local replication_dir ~/Dropbox/Serfdom/Accepted/replication/


set matsize 800
set mem 100000 
set more off
clear 


cd `replication_dir'

local outputdirectory `replication_dir'/results/

adopath + "`replication_dir'"


****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****                   PROVINCE - LEVEL ANALYSIS
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************


use `replication_dir'replication_province_Serfdom, clear

************************************************************
** generate synthetic Land reform instrument
************************************************************

foreach var in pcollate1858pc{ 
 egen v`var'=max(`var') , by (id) 
 gen `var'post1862=v`var' if year>=1862
replace `var'post1862=0 if year<1862
 }
 
gen IVland=1 if year>=1882
 replace IVland=0 if year<=1861
 replace IVland=(1-pcollate1858pcpost1862) if year==1862
 replace IVland=(1-pcollate1858pcpost1862)+(pcollate1858pcpost1862)/20 if year==1863
 replace IVland=(1-pcollate1858pcpost1862)+2*(pcollate1858pcpost1862)/20 if year==1864
 replace IVland=(1-pcollate1858pcpost1862)+3*(pcollate1858pcpost1862)/20 if year==1865
 replace IVland=(1-pcollate1858pcpost1862)+4*(pcollate1858pcpost1862)/20 if year==1866
 replace IVland=(1-pcollate1858pcpost1862)+5*(pcollate1858pcpost1862)/20 if year==1867
 replace IVland=(1-pcollate1858pcpost1862)+6*(pcollate1858pcpost1862)/20 if year==1868
 replace IVland=(1-pcollate1858pcpost1862)+7*(pcollate1858pcpost1862)/20 if year==1869
 replace IVland=(1-pcollate1858pcpost1862)+8*(pcollate1858pcpost1862)/20 if year==1870
 replace IVland=(1-pcollate1858pcpost1862)+9*(pcollate1858pcpost1862)/20 if year==1871
 replace IVland=(1-pcollate1858pcpost1862)+10*(pcollate1858pcpost1862)/20 if year==1872
 replace IVland=(1-pcollate1858pcpost1862)+11*(pcollate1858pcpost1862)/20 if year==1873
 replace IVland=(1-pcollate1858pcpost1862)+12*(pcollate1858pcpost1862)/20 if year==1874
 replace IVland=(1-pcollate1858pcpost1862)+13*(pcollate1858pcpost1862)/20 if year==1875
 replace IVland=(1-pcollate1858pcpost1862)+14*(pcollate1858pcpost1862)/20 if year==1876
 replace IVland=(1-pcollate1858pcpost1862)+15*(pcollate1858pcpost1862)/20 if year==1877
 replace IVland=(1-pcollate1858pcpost1862)+16*(pcollate1858pcpost1862)/20 if year==1878
 replace IVland=(1-pcollate1858pcpost1862)+17*(pcollate1858pcpost1862)/20 if year==1879
 replace IVland=(1-pcollate1858pcpost1862)+18*(pcollate1858pcpost1862)/20 if year==1880
 replace IVland=(1-pcollate1858pcpost1862)+19*pcollate1858pcpost1862/20 if year==1881
 replace IVland=0 if id==7 | id==8 | id==9
 replace IVland=1 if year>=1863 & west==1
 
************************************************************
**** MAIN TABLES
************************************************************


************************************************************
** table 1 Sumstats
************************************************************

* serfdom

*** generate free population for sumstats
gen sh_freepop=1-sh_serfs_postEmancip-sh_stpeasants1858post1866- sh_royal1858post1859
replace sh_freepop=. if year!=1870
label var sh_freepop "share of free population"

sum sh_serfs_postEmancip sh_stpeasants1858post1866 sh_freepop if year==1870  & nobaltics

* land reform
sum sh_serfs1858p1861sh_buyout   if nobaltics & (year>=1862 & year<=1882)

* development outcomes
sum grain_prod ln_indoutput_adinf  if nobaltics
sum height if nobaltics

*instruments
sum sh_nat_monasterialpost1861 if year==1862 & nobaltics
sum IVland if nobaltics & (year>=1862 & year<=1882) & sh_serfs1858p1861sh_buyout!=.
sum pcollate1858pc if year==1858 & nobaltics

* other important variables
sum Charters1863 repartition  if year==1870 & nobaltics
sum sh_wgrains if nobaltics
sum dist_Moscowpost1861 median_suitabilitypost1861 if year==1870 & nobaltics
sum temp_mean_e400km  if nobaltics &grain_prod !=.
sum lagryewheatdutchpriceratio if id==20 & sh_wgrains!=.
sum lagryeoatpricerrratio if nobaltics & sh_wgrains!=.

************************************************************
* table 2 
************************************************************


set more off
xtset id year
   
xtreg grain_prod  sh_serfs_postEmancip i.year if nobaltics, fe cl(idref) nonest	
	outreg2 using "`outputdirectory'table2.xls",  bdec(2) bra label replace  keep(sh_serfs_postEmancip) ctitle(grain_prod, panel_A)

xtreg grain_prod  sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics, fe cl(idref)	nonest
outreg2 using "`outputdirectory'table2.xls",  bdec(2) bra label  keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel_A)
cap drop grain_sample
gen grain_sample=e(sample)

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year i.id year_Iid*  if nobaltics & grain_sample ,  cl(idref)
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
 	outreg2 using "`outputdirectory'table2.xls",  bdec(2) bra label   addstat(F1_stat, statistic1) keep(sh_nat_monasterialpost1861 sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_serfs_postEmancip, panel_B)

ivregress 2sls grain_prod  (sh_serfs_postEmancip=sh_nat_monasterialpost1861)  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.year i.id year_Iid* if nobaltics,  cl(idref)	
 	outreg2 using "`outputdirectory'table2.xls",  bdec(2) bra label   addstat(F1_stat, statistic1) keep( sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel_A)

xtreg grain_prod  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics, fe cl(idref)	nonest
	outreg2 using "`outputdirectory'table2.xls",  bdec(2) bra label   keep( sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel_A)

xtreg grain_prod  sh_serfs_1861_1870 sh_serfs_1871_1900 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'table2.xls",  bdec(2) bra label    keep( sh_serfs_1861_1870 sh_serfs_1871_1900 lndist_MoscowDemeanpost1861  median_suitabilityDemeanpost1861) ctitle(grain_prod, panel_A)

	
xtreg grain_prod  sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics, fe cl(idref)	nonest
	outreg2 using "`outputdirectory'table2.xls",  bdec(2) bra label   keep(sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) 	ctitle(grain_prod, panel_A) 

	cap drop grain_land_sample
	gen grain_land_sample=e(sample)
reg sh_serfs_postEmancip sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year i.id year_Iid* if nobaltics & grain_land_sample ,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
     outreg2 using "`outputdirectory'table2.xls",  bdec(2) bra label  addstat(F1_stat, statistic1, F2_stat, statistic2)  keep(sh_nat_monasterialpost1861 IVland  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_serfs_postEmancip, panel_B)
reg sh_serfs1858p1861sh_buyout sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year i.id year_Iid*  if nobaltics & grain_land_sample ,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
     outreg2 using "`outputdirectory'table2.xls",  bdec(2) bra label  addstat(F1_stat, statistic1, F2_stat, statistic2)   keep(sh_nat_monasterialpost1861 IVland  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)   ctitle(sh_serfs1858p1861sh_buyout, panel_B)

ivregress 2sls grain_prod  (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout=sh_nat_monasterialpost1861 IVland) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id i.year year_Iid* if nobaltics,  cl(idref)	
	outreg2 using "`outputdirectory'table2.xls",  bdec(2) bra label  keep(sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) 	 ctitle(grain_prod, panel_A) 

**** Spatial adjustment for grain

local covariates "lndist_Moscowpost1861 median_suitability"

cap drop fid fyear 
cap drop const
gen fid=1
gen fyear=1
gen const=1

local dcutoff 900
local lcutoff 0
local beta_cutoff .3

global x_ols_option lat(latitude) long(longitude) cut1(`dcutoff') cut2(`dcutoff')

reg grain_prod i.year year_Iid* if nobaltics
cap drop grain_prod_macro
predict grain_prod_macro if e(sample), resid

cap drop grain_prod_macro_av* diff_grain_prod
egen grain_prod_macro_av_post=mean(grain_prod_macro) if year>=1861, by(id)
egen grain_prod_macro_av_pre=mean(grain_prod_macro) if year<1861, by(id)

egen grain_prod_macro_av_post_max=max(grain_prod_macro_av_post), by(id)
egen grain_prod_macro_av_pre_max=max(grain_prod_macro_av_pre), by(id)

gen diff_grain_prod=grain_prod_macro_av_post_max-grain_prod_macro_av_pre_max

*** cross-section:

x_ols diff_grain_prod sh_serfs_postEmancip `covariates' if nobaltics & year==1870, $x_ols_option
	outreg2 using "`outputdirectory'table2.xls",  bdec(2) bra label    ctitle(diff_grain_prod, panel_C) 

reg diff_grain_prod sh_serfs_postEmancip `covariates' if nobaltics & year==1870
cap drop _dfbeta*
cap drop beta*
dfbeta
gen beta=round(_dfbeta_1*100)/100

x_ols diff_grain_prod sh_serfs_postEmancip `covariates' if nobaltics & year==1870, $x_ols_option

mat mcoeff = e(b)
mat var = e(V) 
scalar sterr = round(sqrt(var[1,1])*100)/100
scalar coef = round(mcoeff[1,1]*100)/100
scalar tstat = round((mcoeff[1,1])/(sqrt(var[1,1]))*100)/100
scalar pval = ttail(462,abs(coef/sterr))*2

local myNote = "coef="+string(coef) + ";   Conley (1999) adjusted se="+ string(sterr) + ";   t=" + string(tstat) 

************************************************************
* Figure A6 and Continuation of Table 2
************************************************************

avplot sh_serfs_postEmancip, mlabel(beta) msize(small) subtitle(Scatter plot conditional on log distance from Moscow and suitability) title(Change in grain productivity) ytitle("Change in detrended gain productivity, before-after 1861") xtitle(Share of serfs in 1858) caption(DFBeta presented for each observation) note(`myNote')
graph save  "`outputdirectory'figureA6.gph", replace 
graph export "`outputdirectory'figureA6.eps", replace

x_ols diff_grain_prod sh_serfs_postEmancip `covariates' if nobaltics & year==1870 & abs(_dfbeta_1)<`beta_cutoff', $x_ols_option
	outreg2 using "`outputdirectory'table2.xls",  bdec(2) bra label   ctitle(diff_grain_prod, panel_C) 

************************************************************
* table 3   
************************************************************

set more off
xtreg grain_prod  sh_serfs_postEmancip sh_serfs1858p1861sh_buyout  shserf1858p1861shbuy_RC lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'table3.xls",  bdec(3) bra label replace keep(sh_serfs_postEmancip sh_serfs1858p1861sh_buyout  shserf1858p1861shbuy_RC lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) 

	test sh_serfs1858p1861sh_buyout + shserf1858p1861shbuy_RC=0
	
xtreg grain_prod  sh_serfs_postEmancip sh_serfs1858p1861sh_buyout sh_serfs1858p1861Chartp63 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'table3.xls",  bdec(3) bra label  keep(sh_serfs_postEmancip sh_serfs1858p1861sh_buyout sh_serfs1858p1861Chartp63 shserf1858p1861shbuy_RC lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) 

xtreg sh_wgrains sh_serfs_postEmancip  lagtempDemagrsh_pr1858post1861  lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics , fe cl(idref) nonest
	outreg2 using "`outputdirectory'table3.xls",  bdec(3) bra label keep(sh_serfs_postEmancip  lagtempDemagrsh_pr1858post1861  lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

xtreg sh_wgrains sh_serfs_postEmancip  sh_serfs1858p1861_lag_rye_wheat lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics , fe cl(idref) nonest
	outreg2 using "`outputdirectory'table3.xls",  bdec(3) bra label keep(sh_serfs_postEmancip sh_serfs1858p1861_lag_rye_wheat lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

xtreg sh_wgrains sh_serfs_postEmancip  sh_serfs1858p1861_lag_rye_wheat lagtempDemagrsh_pr1858post1861  lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics , fe cl(idref) nonest
	outreg2 using "`outputdirectory'table3.xls",  bdec(3) bra label keep(sh_serfs_postEmancip sh_serfs1858p1861_lag_rye_wheat lagtempDemagrsh_pr1858post1861  lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

xtreg sh_wgrains sh_serfs_postEmancip  sh_serfs1858p1861_lag_rye_oats lagryeoatpricerrratiodemean sh_serfs1858_lag_rye_oats lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics , fe cl(idref) nonest
	outreg2 using "`outputdirectory'table3.xls",  bdec(3) bra label keep( sh_serfs_postEmancip  sh_serfs1858p1861_lag_rye_oats  sh_serfs1858_lag_rye_oats  lagryeoatpricerrratiodemean sh_serfs1858_lag_rye_oats lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

xtreg sh_wgrains sh_serfs_postEmancip sh_serfs1858p1861_lag_rye_oats  lagryeoatpricerrratiodemean sh_serfs1858_lag_rye_oats lagtempDemagrsh_pr1858post1861  lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics , fe cl(idref) nonest
	outreg2 using "`outputdirectory'table3.xls",  bdec(3) bra label keep(sh_serfs_postEmancip sh_serfs1858p1861_lag_rye_oats lagryeoatpricerrratiodemean sh_serfs1858_lag_rye_oats  lagtempDemagrsh_pr1858post1861  lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

	 
************************************************************
* table 4 	
************************************************************

xtreg ln_indoutput_adinf  sh_serfs_postEmancip  i.year if nobaltics, cl(idref) nonest fe
	outreg2 using "`outputdirectory'table4.xls", replace bdec(2) bra label keep(sh_serfs_postEmancip)

xtreg ln_indoutput_adinf  sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year  l5trend* if nobaltics, cl(idref)  nonest fe
	outreg2 using "`outputdirectory'table4.xls", append bdec(2) bra label keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)
cap drop industry_sample
	gen industry_sample=e(sample)

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year i.id l5trend*  if nobaltics&industry_sample,  cl(idref)   
test sh_nat_monasterialpost1861
scalar statistic = r(F)
	outreg2 using "`outputdirectory'table4.xls", bdec(2) bra label addstat(F_stat, statistic)	keep(sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

ivregress 2sls  ln_indoutput_adinf  (sh_serfs_postEmancip=sh_nat_monasterialpost1861) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.year i.id l5trend*  if  nobaltics,  cl(idref)
	outreg2 using "`outputdirectory'table4.xls", bdec(2) bra label addstat(F_stat, statistic)	keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

xtreg  ln_indoutput_adinf  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year l5trend* if nobaltics, cl(idref)   nonest fe
	outreg2 using "`outputdirectory'table4.xls", bdec(2) bra label keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

************************************************************
* Figure A7
************************************************************

reg ln_indoutput_adinf sh_serfs1858 if year==1856&nobaltics, r
cap drop sample_ind56
gen sample_ind56=e(sample)
cap drop max_sample_ind56
egen max_sample_ind56=max(sample_ind56), by(id)
reg ln_indoutput_adinf sh_serfs1858  if year==1885&nobaltics&max_sample_ind56, r

twoway (scatter ln_indoutput_adinf sh_serfs1858 if year==1856&nobaltics , mlabel(id) msize(tiny) note("coef.=0.47, robust SE=0.87, t=0.54, R2=0.008")) || (lfit ln_indoutput_adinf sh_serfs1858 if year==1856&nobaltics), legend(off) title(1856)
graph save "figureA7_illust_pre", replace

twoway (scatter ln_indoutput_adinf sh_serfs1858 if year==1885&nobaltics&max_sample_ind56 , mlabel(id) msize(tiny) note("coef.=1.35, robust SE=0.76, t=1.79, R2=0.081")) || (lfit ln_indoutput_adinf sh_serfs1858 if year==1885&nobaltics), legend(off) title(1885)
graph save "figureA7_illust_post", replace

graph combine "figureA7_illust_pre" "figureA7_illust_post", title("Industrial production and the pre-emancipation share of serfs")  ycommon l1("Log industrial output")  b1("balanced sample, observations are marked with province ids")
graph save "`outputdirectory'figureA7", replace
graph export "`outputdirectory'figureA7.eps", replace

erase figureA7_illust_post.gph 
erase figureA7_illust_pre.gph

***** spatial adjustment for industry
	
local dcutoff 900
local lcutoff 0
local beta_cutoff .3

global x_ols_option lat(latitude) long(longitude) cut1(`dcutoff') cut2(`dcutoff')
	

reg ln_indoutput_adinf i.year l5trend* if nobaltics

predict ln_indoutput_macro if e(sample), resid

egen ln_indoutput_macro_av_post=mean(ln_indoutput_macro) if year>=1861, by(id)
egen ln_indoutput_macro_av_pre=mean(ln_indoutput_macro) if year<1861, by(id)

egen ln_indoutput_macro_av_post_max=max(ln_indoutput_macro_av_post), by(id)
egen ln_indoutput_macro_av_pre_max=max(ln_indoutput_macro_av_pre), by(id)

gen diff_ln_indoutput=ln_indoutput_macro_av_post_max-ln_indoutput_macro_av_pre_max


x_ols diff_ln_indoutput sh_serfs_postEmancip `covariates' if nobaltics & year==1870, $x_ols_option
	outreg2 using "`outputdirectory'table4.xls", bdec(2) bra label
	
reg diff_ln_indoutput sh_serfs_postEmancip `covariates' if nobaltics & year==1870
cap drop _dfbeta* 
cap drop beta
dfbeta
gen beta=round(_dfbeta_1*100)/100

x_ols diff_ln_indoutput sh_serfs_postEmancip `covariates' if nobaltics & year==1870, $x_ols_option

mat mcoeff = e(b)
mat var = e(V) 
scalar sterr = round(sqrt(var[1,1])*100)/100
scalar coef = round(mcoeff[1,1]*100)/100
scalar tstat = round((mcoeff[1,1])/(sqrt(var[1,1]))*100)/100
scalar pval = ttail(462,abs(coef/sterr))*2

local myNote = "coef="+string(coef) + ";   Conley (1999) adjusted se="+ string(sterr) + ";   t=" + string(tstat) 

avplot sh_serfs_postEmancip, mlabel(beta) msize(small) subtitle(Scatter plot conditional on log distance from Moscow and suitability) title("Change in log industrial output") ytitle("Change in log industrial output, before-after 1861") xtitle(Share of serfs in 1858) caption(DFBeta presented for each observation) note(`myNote')

************************************************************
* Figure A8 and continuation of Table 4
************************************************************
graph save  "`outputdirectory'figureA8.gph", replace
graph export "`outputdirectory'figureA8.eps", replace

x_ols diff_ln_indoutput sh_serfs_postEmancip `covariates' if nobaltics & year==1870 & abs(_dfbeta_1)<`beta_cutoff', $x_ols_option
	outreg2 using "`outputdirectory'table4.xls", bdec(2) bra label


************************************************************
* table 5  
************************************************************

xtreg  height  sh_serfs_postEmancip i.year if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'table5.xls",   bdec(2) bra label replace keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

xtreg  height  sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.year if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'table5.xls",   bdec(2) bra label append keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)
cap drop height_sample
gen height_sample=e(sample)	
reg sh_serfs_postEmancip sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year i.id if nobaltics&height_sample,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
	outreg2 using "`outputdirectory'table5.xls",  bdec(2) bra label  addstat(F1_stat, statistic1)  append keep(sh_nat_monasterialpost1861 sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

ivregress 2sls height  (sh_serfs_postEmancip =sh_nat_monasterialpost1861) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year i.id if nobaltics,  cl(idref)	
  outreg2 using "`outputdirectory'table5.xls",  bdec(2) bra label  addstat(F1_stat, statistic1) append keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)


****** spatial adjustment for height
	
local dcutoff 900
local lcutoff 0
local beta_cutoff .3

global x_ols_option lat(latitude) long(longitude) cut1(`dcutoff') cut2(`dcutoff')
	
reg height i.year if nobaltics
predict height_macro if e(sample), resid	

egen height_macro_av_post=mean(height_macro) if year>=1861, by(id)
egen height_macro_av_pre=mean(height_macro) if year<1861, by(id)

egen height_macro_av_post_max=max(height_macro_av_post), by(id)
egen height_macro_av_pre_max=max(height_macro_av_pre), by(id)

gen diff_height=height_macro_av_post_max-height_macro_av_pre_max
x_ols diff_height sh_serfs_postEmancip `covariates' if nobaltics & year==1864, $x_ols_option
outreg2 using "`outputdirectory'table5.xls",  bdec(2) bra label  

reg diff_height sh_serfs_postEmancip `covariates' if nobaltics & year==1864
cap drop _dfbeta* 
cap drop beta
dfbeta
gen beta=round(_dfbeta_1*100)/100

x_ols diff_height sh_serfs_postEmancip `covariates' if nobaltics & year==1864, $x_ols_option

mat mcoeff = e(b)
mat var = e(V) 
scalar sterr = round(sqrt(var[1,1])*100)/100
scalar coef = round(mcoeff[1,1]*100)/100
scalar tstat = round((mcoeff[1,1])/(sqrt(var[1,1]))*100)/100
scalar pval = ttail(462,abs(coef/sterr))*2

local myNote = "coef="+string(coef) + ";   Conley (1999) adjusted se="+ string(sterr) + ";   t=" + string(tstat) 

************************************************************
* figure A10A and continuation of Table 5
************************************************************
avplot sh_serfs_postEmancip, mlabel(beta) msize(small) subtitle(Scatter plot conditional on log distance from Moscow and suitability) title("Change in draftees' height, by province") ytitle("Change in detrended height by province, before-after 1861") xtitle(Share of serfs in 1858) caption(DFBeta presented for each observation) note(`myNote')
graph save  "`outputdirectory'/figureA10A.gph", replace
graph export "`outputdirectory'figureA10A.eps", replace

x_ols diff_height sh_serfs_postEmancip `covariates' if nobaltics & year==1864 & abs(_dfbeta_1)<`beta_cutoff', $x_ols_option
outreg2 using "`outputdirectory'table5.xls",  bdec(2) bra label  

************************************************************
**** MAIN FIGURES
************************************************************

************************************************************
* figure 4
************************************************************
reg sh_serfs_postEmancip  sh_nat_monasterialpost1861 lndist_Moscowpost1861 median_suitabilitypost1861 if year==1870 & nobaltics & id!=44, r
  avplot (sh_nat_monasterialpost1861),  msize(small) msymbol(circle) title(Conditional scatter plot and fitted line) subtitle(Controls: log distance from Moscow and land suitability) ytitle("Share of serfs in 1858") xtitle("Share of monasterial serfs before nationalization")
graph save `outputdirectory'figure4, replace 
graph export "`outputdirectory'figure4.eps", replace

************************************************************
* figure 5
************************************************************

reg sh_serfs1858p1861sh_buyout IVland  lndist_Moscowpost1861 median_suitabilitypost1861 if year==1872 & nobaltics & id!=44, r
  avplot (IVland),  msize(small) msymbol(circle) title(Conditional scatter plot and fitted line) subtitle(Controls: log distance from Moscow and land suitability) ytitle("Share of peasants with buyout contract signed in 1872") xtitle("Non-indebtedness instrument in 1872")
graph save `outputdirectory'figure5, replace 
graph export "`outputdirectory'figure5.eps", replace

************************************************************
* figure 6
************************************************************


preserve

xtile terc_1 = sh_serfs1858 if  grain_prod!= . & nobaltics &year==1861, nq(3)
egen terc=max(terc_1), by(id)

collapse (mean) grain_prod if terc==1  &  grain_prod!= . & nobaltics   , by(year)

drop if grain_prod == .
rename grain_prod grain_prod_below

gen intervales=int((year-1)/10)*10+5

collapse (mean) grain_prod , by(intervales)
gen year=intervales
tsset year
tempfile grain_prod_below
save "`grain_prod_below'", replace

restore

preserve
xtile terc_1 = sh_serfs1858 if  grain_prod != .& nobaltics &year==1861, nq(3)
egen terc=max(terc_1), by(id)

collapse (mean) grain_prod if terc==3  &  grain_prod != .  & nobaltics   , by(year)

drop if grain_prod == .

gen intervales=int((year-1)/10)*10+5

collapse (mean) grain_prod , by(intervales)
gen year=intervales
tsset year

rename grain_prod grain_prod_above

tempfile grain_prod_above
save "`grain_prod_above'", replace

restore

preserve
xtile terc_1 = sh_serfs1858 if  grain_prod != .& nobaltics &year==1861, nq(3)
egen terc=max(terc_1), by(id)

collapse (mean) grain_prod if terc==2   &  grain_prod != .  & nobaltics   , by(year)

drop if grain_prod == .
rename grain_prod grain_prod_middle


gen intervales=int((year-1)/10)*10+5

collapse (mean) grain_prod , by(intervales)
gen year=intervales
tsset year

merge 1:1 year using "`grain_prod_below'"

drop _merge 

merge 1:1 year using "`grain_prod_above'"
drop _merge 

tsset year
tsline grain_prod_below grain_prod_middle grain_prod_above if year>1840&year<1890 , recast(connected) xline(1861) ytitle("Grain productivity, decade averages, raw data" )  legend(order(1 "1st terc: r(0.1%-40%), m 17%" 2 "2nd terc: r(41%-57%), m 50%" 3 "3rd terc:, r(60%-83%), m 69%" )) xsc(r(1845  1885)) xlabel(1845(10)1885) xtitle(Year) title("Productivity in provinces by terciles" "of the share of serfs and the emancipation") yscale(r(2.5 4.5))
graph save "`outputdirectory'figure_6", replace
graph export "`outputdirectory'figure_6.eps", replace

restore



************************************************************
* figure 7 and part of Table A3 for provinces
************************************************************


**** generate interactions with time periods:


gen sh_serfs1858_1840=sh_serfs1858 if year>=1841 & year<=1850
replace sh_serfs1858_1840=0 if sh_serfs1858_1840==. &sh_serfs1858!=.
replace sh_serfs1858_1840=0 if year<1841

gen sh_serfs1858_185155=sh_serfs1858 if year>=1851 & year<=1855
replace sh_serfs1858_185155=0 if sh_serfs1858_185155==. & sh_serfs1858!=.
replace sh_serfs1858_185155=0 if year<1851

gen sh_serfs1858_185660=sh_serfs1858 if year>=1856 & year<=1860
replace sh_serfs1858_185660=0 if sh_serfs1858_185660==. & sh_serfs1858!=.
replace sh_serfs1858_185660=0 if year<1856

gen sh_serfs1858_186165=sh_serfs_postEmancip if year>=1861 & year<=1865
replace sh_serfs1858_186165=0 if sh_serfs1858_186165==. & sh_serfs_postEmancip!=.

gen sh_serfs1858_186670=sh_serfs_postEmancip if year>=1866 & year<=1870
replace sh_serfs1858_186670=0 if sh_serfs1858_186670==. & sh_serfs_postEmancip!=.

gen sh_serfs1858_187175=sh_serfs_postEmancip if year>=1871 & year<=1875
replace sh_serfs1858_187175=0 if sh_serfs1858_187175==. & sh_serfs_postEmancip!=.

gen sh_serfs1858_187680=sh_serfs_postEmancip if year>=1876 & year<=1880
replace sh_serfs1858_187680=0 if sh_serfs1858_187680==. & sh_serfs_postEmancip!=.

gen sh_serfs1858_188185=sh_serfs_postEmancip if year>=1881 & year<=1885
replace sh_serfs1858_188185=0 if sh_serfs1858_188185==. & sh_serfs_postEmancip!=.

gen sh_serfs1858_188690=sh_serfs_postEmancip if year>=1886 & year<=1890
replace sh_serfs1858_188690=0 if sh_serfs1858_188690==. & sh_serfs_postEmancip!=.

gen sh_serfs1858_189195=sh_serfs_postEmancip if year>=1891 & year<=1895 
replace sh_serfs1858_189195=0 if sh_serfs1858_189195==. & sh_serfs_postEmancip!=.

gen sh_serfs1858_1896=sh_serfs_postEmancip if year>=1896
replace sh_serfs1858_1896=0 if sh_serfs1858_1896==. & sh_serfs_postEmancip!=.



	capture drop D1-D11
	capture drop D1-D7
	capture drop time
	capture drop coef low high
	capture label drop ti

	gen D1=sh_serfs1858_1840
	gen D2=sh_serfs1858_185155
	gen D3=sh_serfs1858_185660
	gen D4=sh_serfs1858_186165
	gen D5=sh_serfs1858_186670
	gen D6=sh_serfs1858_187175
	gen D7=sh_serfs1858_187680
	gen D8=sh_serfs1858_188185
	gen D9=sh_serfs1858_188690
	gen D10=sh_serfs1858_189195
	gen D11=sh_serfs1858_1896
	
	gen time=0
	replace time=.5 if year>=1830 & year<=1840
	replace time=1 if year>=1841 & year<=1850
	replace time=2 if year>=1851 & year<=1855
	replace time=3 if year>=1856 & year<=1860
	replace time=4 if year>=1861 & year<=1865
	replace time=5 if year>=1866 & year<=1870
	replace time=6 if year>=1871 & year<=1875
	replace time=7 if year>=1876 & year<=1880
	replace time=8 if year>=1881 & year<=1885
	replace time=9 if year>=1886 & year<=1890
	replace time=10 if year>=1891 & year<=1895
	replace time=11 if year>=1896 & year<=1900
	replace time=11.5 if year>=1900 

	label def ti 1 "41-50" 2 "51-55" 3 "56-60" 4 "61-65" 5 "66-70" 6 "71-75" 7 "76-80" 8 "81-85" 9 "86-90" 10 "90-95" 11 "post 96"  
	label values time ti

xtreg grain_prod D1 D2 D3 D4 D5  D6 D7 D8 D9 D10 D11 sh_stpeasants1858post1866 sh_royal1858post1859  median_suitabilityDemeanpost1861 lndist_MoscowDemeanpost1861 i.year l5trend* if nobaltics, fe  cl(idref) nonest
	outreg2 using "`outputdirectory'tableA3_provinces.xls", bdec(2) bra label replace

	gen coef =.
	gen low=.
	gen high =.

	forval k=1/11 {
	replace coef = _b[D`k'] if time==`k'
	replace low = _b[D`k']-1.64*_se[D`k'] if time==`k'
	replace high = _b[D`k']+1.64*_se[D`k'] if time==`k'
	}

	preserve

	collapse (mean) coef high low, by(time)
	keep if time<=11.5
	keep if time>0

	twoway (scatter coef t, connect(l) lwidth(medthick) lcolor(blue) mcolor(blue) msize(medium) ) (line high t, lpattern(dash) lcolor(gray) lwidth(medthin)) (line low t, lpattern(dash) lcolor(gray) lwidth(medthin)), title("Grain productivity")  subtitle("(relative to years 1795-1829)") xline(3.5, lcolor(red) lwidth(medthick)) yline(0, lcolor(black) lwidth(medthin)) xlabel( 1 2 3 4 5 6 7 8 9 10 11 , valuelabel labsize(small)) xtitle(Time) ytitle(Coefficient) legend(off)  graphregion(fcolor(white))
	graph export `outputdirectory'figure7.eps, replace 
	graph save `outputdirectory'figure7, replace 

	restore
    capture drop coef high low

********************************************************
***** figure 8 and part of Table A3 for provinces
********************************************************
	
* years 1795 1849 1856 1858 1882 1883 1885 1897 
capture drop time
gen time=0

replace time=49 if year==1849 
replace time=56 if year==1856 | year==1858
replace time=82 if year==1882 | year==1883
replace time=85 if year==1885 | year==1897
replace time=97 if year==1897 
replace time=100 if year==1899

capture label drop ti
label def ti 35 "" 49 "1849" 56 "56,58" 82 "82,83" 85 "85"  97 "1897" 
label values time ti
capture drop D*

gen D49 = sh_serfs1858
replace D49=0 if year!=1849
replace D49=0 if year!=1849
gen D56=sh_serfs1858
replace D56=0 if year!=1856 & year!=1858
gen D82=sh_serfs1858
replace D82=0 if year!=1882 & year!=1883
gen D85=sh_serfs1858
replace D85=0 if year!=1885 
gen D97=sh_serfs1858
replace D97=0 if year!=1897

xtreg ln_indoutput_adinf D49 D56 D82 D85 D97  sh_stpeasants1858post1866 sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.year l5trend* if nobaltics ,  cl(idref) fe nonest
outreg2 using "`outputdirectory'tableA3_provinces.xls", bdec(2) bra label append

capture drop coef high low

gen coef =.
gen low=.
gen high =.

foreach k in 49 56 82 85 97 {
replace coef = _b[D`k'] if time==`k'
replace low = _b[D`k']-1.64*_se[D`k'] if time==`k'
replace high = _b[D`k']+1.64*_se[D`k'] if time==`k'
}

preserve

collapse (mean) coef high low, by(time)
keep if time<=100
keep if time>38


twoway (scatter coef t, connect(l) lwidth(medthick) lcolor(blue) mcolor(blue) msize(medium) ) (line high t, lpattern(dash) lcolor(gray) lwidth(medthin)) (line low t, lpattern(dash) lcolor(gray) lwidth(medthin)), title("Log industrial output")  subtitle("(relative to the year 1795)") xline(61, lcolor(red) lwidth(medthick)) yline(0, lcolor(black) lwidth(medthin)) xlabel( 49 56 82 85 97 , valuelabel labsize(small)) xtitle(Time) ytitle(Coefficient) legend(off)  graphregion(fcolor(white))
graph export `outputdirectory'figure8.eps, replace 
graph save `outputdirectory'figure8, replace 

restore

capture drop coef high low

********************************************************
* figure 9 and part of Table A3 for provinces
********************************************************

* years 1853-66 1873
capture drop time
gen time=.
replace time=1 if year==1855 
replace time=2 if year==1857
replace time=3 if year==1859
replace time=4 if year==1861
replace time=5 if year==1863 
replace time=6 if year==1865

capture label drop ti
label def ti 1 "55-56" 2 "57-58" 3 "59-60" 4 "61-62" 5 "63-64" 6 "65-66"  
label values time ti
capture drop D*


foreach year in 55 56 57 58 59 60 61 62 63 64 65 66{
gen d_Iyear_18`year'=1 if year==18`year'
replace d_Iyear_18`year'=0 if d_Iyear_18`year'==.
label var  d_Iyear_18`year' "year==18`year'"
}


gen D1=sh_serfs1858*d_Iyear_1855+sh_serfs1858*d_Iyear_1856
gen D2=sh_serfs1858*d_Iyear_1857+sh_serfs1858*d_Iyear_1858
gen D3=sh_serfs1858*d_Iyear_1859+sh_serfs1858*d_Iyear_1860
gen D4=sh_serfs1858*d_Iyear_1861+sh_serfs1858*d_Iyear_1862
gen D5=sh_serfs1858*d_Iyear_1863+sh_serfs1858*d_Iyear_1864
gen D6=sh_serfs1858*d_Iyear_1865+sh_serfs1858*d_Iyear_1866

xtreg  height D1 D2 D3 D4 D5 D6   lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year if nobaltics , fe   cl(idref) nonest
  outreg2 using "`outputdirectory'tableA3_provinces.xls", bdec(2) bra label append
	
capture drop coef high low

gen coef =.
gen low=.
gen high =.

forval k=1/6 {
replace coef = _b[D`k'] if time==`k'
replace low = _b[D`k']-1.64*_se[D`k'] if time==`k'
replace high = _b[D`k']+1.64*_se[D`k'] if time==`k'
}

preserve

collapse (mean) coef high low, by(time)
keep if time!=.

twoway (scatter coef t, connect(l) lwidth(medthick) lcolor(blue) mcolor(blue) msize(medium)) (line high t, lpattern(dash) lcolor(gray) lwidth(medthin)) (line low t, lpattern(dash) lcolor(gray) lwidth(medthin)), title("Draftees' height by province, cohorts 1853-1866")  subtitle("(relative to cohorts of 1853-1854)") xline(3.5, lcolor(red) lwidth(medthick))  yline(0, lcolor(black) lwidth(medthin)) xlabel(1 2 3 4 5 6 , valuelabel labsize(small)) xtitle(Birth cohorts) ytitle(Coefficient) legend(off)  graphregion(fcolor(white))
graph export `outputdirectory'figure9.eps, replace 
graph save `outputdirectory'figure9, replace 

restore

capture drop coef high low

**********************************************************************************************************************************
* Appendix Tables
**********************************************************************************************************************************

********************************************************
* table A4 
********************************************************

xtreg grain_prod  sh_serfs_postEmancip  lndMsh_serfs_postEmancip  median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics, fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA4.xls",  bdec(2) bra label replace  keep (sh_serfs_postEmancip lndMsh_serfs_postEmancip median_suitabilityDemeanpost1861) ctitle(grain_prod)
xtreg grain_prod  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859  lndMsh_serfs_postEmancip median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics,  fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA4.xls",  bdec(2) bra label  keep (sh_serfs_postEmancip lndMsh_serfs_postEmancip median_suitabilityDemeanpost1861) ctitle(grain_prod)

********************************************************
* table A5
********************************************************

*** WLS by grain_harvest
 
reg grain_prod  sh_serfs_postEmancip i.id i.year [aweight=lngrain_harvest_uni] if nobaltics,  cl(idref) 	
	outreg2 using "`outputdirectory'tableA5.xls",  bdec(2) bra label replace  keep (sh_serfs_postEmancip) ctitle(grain_prod, panel A)

reg grain_prod  sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_* [aweight=lngrain_harvest_uni] if nobaltics, cl(idref)
	outreg2 using "`outputdirectory'tableA5.xls",  bdec(2) bra label  keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel A)

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_* [aweight=lngrain_harvest_uni] if nobaltics & grain_prod!=. ,  cl(idref)
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
 	outreg2 using "`outputdirectory'tableA5.xls",  bdec(2) bra label   addstat(F1_stat, statistic1) keep (sh_nat_monasterialpost1861) ctitle(sh_serfs_postEmancip, panel B)

ivregress 2sls grain_prod  (sh_serfs_postEmancip=sh_nat_monasterialpost1861)  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id i.year year_* [aweight=lngrain_harvest_uni] if nobaltics,  cl(idref)	
 	outreg2 using "`outputdirectory'tableA5.xls",  bdec(2) bra label   addstat(F1_stat, statistic1) keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel A)

reg grain_prod  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_* [aweight=lngrain_harvest_uni] if nobaltics, cl(idref)
	outreg2 using "`outputdirectory'tableA5.xls",  bdec(2) bra label keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel A)  

reg grain_prod  sh_serfs_1861_1870 sh_serfs_1871_1900 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_* [aweight=lngrain_harvest_uni] if nobaltics, cl(idref)
	outreg2 using "`outputdirectory'tableA5.xls",  bdec(2) bra label  keep ( sh_serfs_1861_1870 sh_serfs_1871_1900 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel A)

reg grain_prod  sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_*  [aweight=lngrain_harvest_uni] if nobaltics, cl(idref)
	outreg2 using "`outputdirectory'tableA5.xls",  bdec(2) bra label keep (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel A)  	 

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_* [aweight=lngrain_harvest_uni] if nobaltics & grain_prod!=. & sh_serfs1858p1861sh_buyout!=. ,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
     outreg2 using "`outputdirectory'tableA5.xls",  bdec(2) bra label  addstat(F1_stat, statistic1, F2_stat, statistic2) keep (sh_nat_monasterialpost1861 IVland) ctitle(sh_serfs_postEmancip, panel B)
reg sh_serfs1858p1861sh_buyout sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_* [aweight=lngrain_harvest_uni] if nobaltics & grain_prod!=. & sh_serfs_postEmancip!=. ,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
     outreg2 using "`outputdirectory'tableA5.xls",  bdec(2) bra label  addstat(F1_stat, statistic1, F2_stat, statistic2)  keep (sh_nat_monasterialpost1861 IVland) ctitle(sh_serfs_postEmancip, panel B)

ivregress 2sls grain_prod  (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout=sh_nat_monasterialpost1861 IVland) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_* [aweight=lngrain_harvest_uni] if nobaltics,  cl(idref)	
	outreg2 using "`outputdirectory'tableA5.xls",  bdec(2) bra label keep (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel A)  	   

********************************************************
* table A6
********************************************************

xtreg lncultivated  sh_serfs_postEmancip lndist_MoscowDemeanpost1861  median_suitabilityDemeanpost1861 i.year l5trend* if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA6.xls",  bdec(2) bra label replace keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(lncultivated)

reg sh_serfs_postEmancip sh_nat_monasterialpost1861  lndist_MoscowDemeanpost1861  median_suitabilityDemeanpost1861  i.id i.year l5trend* if nobaltics & lncultivated!=.,  cl(idref)
		test sh_nat_monasterialpost1861
		scalar statistic = r(F)
	outreg2 using "`outputdirectory'tableA6.xls",  bdec(2) bra label addstat(F_stat, statistic)	keep(sh_nat_monasterialpost1861  lndist_MoscowDemeanpost1861  median_suitabilityDemeanpost1861) ctitle(sh_serfs_postEmancip)

ivregress 2sls lncultivated  (sh_serfs_postEmancip=sh_nat_monasterialpost1861) lndist_MoscowDemeanpost1861  median_suitabilityDemeanpost1861  i.id i.year l5trend* if nobaltics,  cl(idref)
	outreg2 using "`outputdirectory'tableA6.xls",  bdec(2) bra label addstat(F_stat, statistic) keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(lncultivated)

xtreg  lncultivated  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year l5trend* if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA6.xls",  bdec(2) bra label keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(lncultivated)

********************************************************
* table A9
********************************************************

*** generate interactions
gen lndist_MoscowDemeanpost1862=lndist_MoscowDemean if year>=1862
replace lndist_MoscowDemeanpost1862=0 if year<1862
label var lndist_MoscowDemeanpost1862 "Demeaned log distance from Moscow X post-1862"


gen lndist_MoscowDemeanpost1864=lndist_MoscowDemeanpost1861 if year>=1864 
replace lndist_MoscowDemeanpost1864=0 if year<1864
label var  lndist_MoscowDemeanpost1864  "Demeaned log distance from Moscow X post-1864" 

gen median_suitabilityDemeanpost1862=median_suitabilityDemean if year>=1862
replace median_suitabilityDemeanpost1862=0 if year<1862
label var  median_suitabilityDemeanpost1862 "Demeaned crop suitability X post-1862" 


gen median_suitabilityDemeanpost1864=median_suitabilityDemeanpost1861 if year>=1864
replace median_suitabilityDemeanpost1864=0 if year<1864
label var  median_suitabilityDemeanpost1864 "Demeaned crop suitability X post-1864" 

gen sh_serfs1858post1862=sh_serfs1858 if year>=1862
replace sh_serfs1858post1862=0 if year<1862
label var  sh_serfs1858post1862 "Share of serfs X Post-1862"

gen sh_serfs1858post1864=sh_serfs1858 if year>=1864
replace sh_serfs1858post1864=0 if year<1864
label var  sh_serfs1858post1864 "Share of serfs X Post-1864"


xtreg   height  sh_serfs1858post1862 lndist_MoscowDemeanpost1862 median_suitabilityDemeanpost1862   i.year if nobaltics  & year>1860 & year<1864, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA9.xls", append  bdec(2) bra label keep(sh_serfs1858post1862 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) replace

xtreg   height  sh_serfs1858post1864  lndist_MoscowDemeanpost1864 median_suitabilityDemeanpost1864   i.year if nobaltics  & year>1862, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA9.xls",  bdec(2) bra label keep(sh_serfs1858post1864 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

xtreg   height  sh_serfs1858post1864   lndist_MoscowDemeanpost1864 median_suitabilityDemeanpost1864  i.year if nobaltics  & year>1860 & (year==1861 | year>=1864), fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA9.xls",  bdec(2) bra label keep(sh_serfs1858post1864 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

xtreg   height_unadj  sh_serfs1858post1862 lndist_MoscowDemeanpost1862 median_suitabilityDemeanpost1862  i.year if nobaltics  & year>1860 & year<1864, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA9.xls", append  bdec(2) bra label keep(sh_serfs1858post1862 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

xtreg   height_unadj  sh_serfs1858post1864   lndist_MoscowDemeanpost1864 median_suitabilityDemeanpost1864  i.year if nobaltics  & year>1862, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA9.xls",  bdec(2) bra label keep(sh_serfs1858post1864 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

xtreg   height_unadj  sh_serfs1858post1864   lndist_MoscowDemeanpost1864 median_suitabilityDemeanpost1864  i.year if nobaltics  & year>1860 & (year==1861 | year>=1864), fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA9.xls",  bdec(2) bra label keep(sh_serfs1858post1864 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

********************************************************
* table A10
********************************************************

xtreg  height_unadj  sh_serfs_postEmancip  i.year if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA10.xls", replace  bdec(2) bra label keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

xtreg  height_unadj  sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA10.xls", append  bdec(2) bra label keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

cap drop height_unadj_sample
gen height_unadj_sample=e(sample)	

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.year i.id if nobaltics&height_unadj_sample, cl(idref) 
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
	outreg2 using "`outputdirectory'tableA10.xls",  bdec(2) bra label  addstat(F1_stat, statistic1)  keep(sh_nat_monasterialpost1861 sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

ivregress 2sls height_unadj  (sh_serfs_postEmancip =sh_nat_monasterialpost1861) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.year i.id if nobaltics, cl(idref) 
  outreg2 using "`outputdirectory'tableA10.xls",  bdec(2) bra label  addstat(F1_stat, statistic1) keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

	
local dcutoff 900
local lcutoff 0
local beta_cutoff .3

global x_ols_option lat(latitude) long(longitude) cut1(`dcutoff') cut2(`dcutoff')
	
reg height_unadj i.year if nobaltics
predict height_unadj_macro if e(sample), resid

egen height_unadj_macro_av_post=mean(height_unadj_macro) if year>=1861, by(id)
egen height_unadj_macro_av_pre=mean(height_unadj_macro) if year<1861, by(id)

egen height_unadj_macro_av_post_max=max(height_unadj_macro_av_post), by(id)
egen height_unadj_macro_av_pre_max=max(height_unadj_macro_av_pre), by(id)

gen diff_height_unadj=height_unadj_macro_av_post_max-height_unadj_macro_av_pre_max
x_ols diff_height_unadj sh_serfs_postEmancip `covariates' if nobaltics & year==1864, $x_ols_option
outreg2 using "`outputdirectory'tableA10.xls",  bdec(2) bra label  

reg diff_height_unadj sh_serfs_postEmancip `covariates' if nobaltics & year==1864
cap drop _dfbeta* 
cap drop beta
dfbeta
gen beta=round(_dfbeta_1*100)/100

x_ols diff_height_unadj sh_serfs_postEmancip `covariates' if nobaltics & year==1864, $x_ols_option

mat mcoeff = e(b)
mat var = e(V) 
scalar sterr = round(sqrt(var[1,1])*100)/100
scalar coef = round(mcoeff[1,1]*100)/100
scalar tstat = round((mcoeff[1,1])/(sqrt(var[1,1]))*100)/100
scalar pval = ttail(462,abs(coef/sterr))*2

local myNote = "coef="+string(coef) + ";   Conley (1999) adjusted se="+ string(sterr) + ";   t=" + string(tstat) 

avplot sh_serfs_postEmancip, mlabel(beta) msize(small) subtitle(Scatter plot conditional on log distance from Moscow and suitability) title("Change in draftees' height, by province") ytitle("Change in detrended height by province, before-after 1861") xtitle(Share of serfs in 1858) caption(DFBeta presented for each observation) note(`myNote')
*graph save  "`outputdirectory'/height_beta_no_bobrujsk.gph", replace


x_ols diff_height_unadj sh_serfs_postEmancip `covariates' if nobaltics & year==1864 & abs(_dfbeta_1)<`beta_cutoff', $x_ols_option
outreg2 using "`outputdirectory'tableA10.xls",  bdec(2) bra label  


********************************************************
* table A11 
********************************************************

xtreg grain_prod  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 lnrail temp_mean_e400km_decade  judicialreform zemstvoaverage18681903prc1858  i.year year_Iid* if nobaltics, fe  cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA11.xls",  bdec(2) bra label replace keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 temp_mean_e400km_decade lnrail  zemstvoaverage18681903prc1858 judicialreform) ctitle(grain_prod)  	   

foreach var in lnrail temp_mean_e400km_decade judicialreform zemstvoaverage18681903prc1858 {
xtreg grain_prod  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 `var' i.year year_Iid* if nobaltics, fe cl(idref) nonest	
	outreg2 using "`outputdirectory'tableA11.xls",  bdec(2) bra label keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 `var') ctitle(grain_prod)  	   
	}

********************************************************
* table A12 
********************************************************

xtreg ln_indoutput_adinf sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 lnrail temp_mean_e400km_decade judicialreform zemstvoaverage18681903prc1858 i.year l5trend*  if nobaltics, fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA12.xls",  bdec(2) bra label  replace keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 temp_mean_e400km_decade lnrail  zemstvoaverage18681903prc1858 judicialreform) ctitle(ln_indoutput_adinf)  	   
foreach var in lnrail temp_mean_e400km_decade judicialreform zemstvoaverage18681903prc1858 {
xtreg ln_indoutput_adinf  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 `var' i.year l5trend*  if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA12.xls",  bdec(2) bra label  keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 `var') ctitle(ln_indoutput_adinf)  	   
}
********************************************************
* table A13 
********************************************************

xtreg height sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 lnrail temp_mean_e400km_decade judicialreform zemstvoaverage18681903prc1858 i.year if nobaltics, fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA13.xls",  bdec(2) bra label  replace keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 temp_mean_e400km_decade lnrail  zemstvoaverage18681903prc1858 judicialreform) ctitle(height)  	   
foreach var in lnrail temp_mean_e400km_decade judicialreform zemstvoaverage18681903prc1858  {
xtreg height  sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 `var' i.year if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA13.xls",  bdec(2) bra label  keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 `var') ctitle(height)  	   
}

********************************************************
* table A14 
********************************************************
xtreg grain_prod  sh_serfs_postEmancip i.year if nobaltics & !(west==1 & year<1843), fe cl(idref) nonest	
	outreg2 using "`outputdirectory'tableA14.xls",  bdec(2) bra label  replace keep (sh_serfs_postEmancip) ctitle(grain_prod, panel A)  	   

xtreg grain_prod  sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics & !(west==1 & year<1843), fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA14.xls",  bdec(2) bra label  keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel A)  	   

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_Iid* if nobaltics & grain_prod!=. & !(west==1 & year<1843),  cl(idref)
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
 	outreg2 using "`outputdirectory'tableA14.xls",  bdec(2) bra label keep (sh_nat_monasterialpost1861) ctitle(sh_serfs_postEmancip, panel B)  	    

ivregress 2sls grain_prod  (sh_serfs_postEmancip=sh_nat_monasterialpost1861)  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_Iid* if nobaltics & !(west==1 & year<1843),  cl(idref)	
 	outreg2 using "`outputdirectory'tableA14.xls",  bdec(2) bra label   addstat(F1_stat, statistic1) keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel A)  	   

xtreg grain_prod  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics & !(west==1 & year<1843), fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA14.xls",  bdec(2) bra label  keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel A)  	   

xtreg grain_prod  sh_serfs_1861_1870 sh_serfs_1871_1900 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics & !(west==1 & year<1843), fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA14.xls",  bdec(2) bra label  keep (sh_serfs_1861_1870 sh_serfs_1871_1900 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel A)  	   

xtreg grain_prod  sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics & !(west==1 & year<1843), fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA14.xls",  bdec(2) bra label  keep (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel A)  	   

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_Iid* if nobaltics & grain_prod!=. & sh_serfs1858p1861sh_buyout!=. & !(west==1 & year<1843),  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
     outreg2 using "`outputdirectory'tableA14.xls",  bdec(2) bra label  addstat(F1_stat, statistic1, F2_stat, statistic2) keep (sh_nat_monasterialpost1861 IVland) ctitle(sh_serfs_postEmancip, panel B)  	   
reg sh_serfs1858p1861sh_buyout sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_Iid* if nobaltics & grain_prod!=. & sh_serfs1858p1861sh_buyout!=. & !(west==1 & year<1843),  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
     outreg2 using "`outputdirectory'tableA14.xls",  bdec(2) bra label  addstat(F1_stat, statistic1, F2_stat, statistic2) keep (sh_nat_monasterialpost1861 IVland) ctitle(sh_serfs1858p1861sh_buyout, panel B)  	    

ivregress 2sls grain_prod  (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout=sh_nat_monasterialpost1861 IVland) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_Iid* if nobaltics & !(west==1 & year<1843),  cl(idref)	
	outreg2 using "`outputdirectory'tableA14.xls",  bdec(2) bra label  keep (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod, panel A)  	   

********************************************************
**** Table A15 
********************************************************

xtreg grain_prod  sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics & GreatRus, fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA15.xls",  bdec(2) bra label replace keep (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod)  	     	 

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id i.year year_Iid*  if nobaltics & GreatRus & grain_prod!=.,  cl(idref)
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
    	outreg2 using "`outputdirectory'tableA15.xls",  bdec(2) bra label  addstat(F1_stat, statistic1, F2_stat, statistic2) keep (sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_serfs_postEmancip)  	     	 

reg  sh_serfs1858p1861sh_buyout sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id i.year year_Iid*  if nobaltics & GreatRus & grain_prod!=. ,  cl(idref)
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
   	outreg2 using "`outputdirectory'tableA15.xls",  bdec(2) bra label  addstat(F1_stat, statistic1, F2_stat, statistic2) keep (sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_serfs1858p1861sh_buyout)  	     	 

ivregress 2sls grain_prod  (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout=sh_nat_monasterialpost1861 IVland) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id i.year year_Iid*  if nobaltics & GreatRus,  cl(idref)
	outreg2 using "`outputdirectory'tableA15.xls",  bdec(2) bra label keep (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod)  	     	 	

xtreg grain_prod  sh_serfs_postEmancip  Land_cuts_post1863  sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics & GreatRus, fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA15.xls",  bdec(2) bra label keep (sh_serfs_postEmancip Land_cuts_post1863  sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod)  	     	 	

xtreg grain_prod  sh_serfs_postEmancip  Land_cuts_post1863  sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics, fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA15.xls",  bdec(2) bra label  keep (sh_serfs_postEmancip Land_cuts_post1863  sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod)  	     	 	  	 

xtreg grain_prod  sh_serfs_postEmancip sh_serfs1858p1861sh_buyout  lestate_sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics, fe cl(idref)nonest
	outreg2 using "`outputdirectory'tableA15.xls",  bdec(2) bra label keep (sh_serfs_postEmancip lestate_sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod)  	     	 	   	 
	
xtreg grain_prod  sh_serfs_postEmancip sh_serfs1858p1861sh_buyout   sh_obrok1858Post1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics, fe cl(idref)nonest
	outreg2 using "`outputdirectory'tableA15.xls",  bdec(2) bra label keep (sh_serfs_postEmancip  sh_obrok1858Post1861 sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod)  	     	 	   	 
	   	 

********************************************************
* Table A16
********************************************************
**** normalized by prices of rye:	

xtreg  ln_indoutput_prye  sh_serfs_postEmancip i.year if nobaltics,  cl(idref)   nonest fe
	outreg2 using "`outputdirectory'tableA16.xls", bdec(2) bra label replace  keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)
		
xtreg  ln_indoutput_prye  sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year l5trend* if nobaltics,  cl(idref) nonest fe
	outreg2 using "`outputdirectory'tableA16.xls", bdec(2) bra label append keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

	cap drop industry_rye_sample
	gen industry_rye_sample=e(sample)
	
reg sh_serfs_postEmancip sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year i.id l5trend*  if nobaltics&industry_rye_sample ,  cl(idref)
test sh_nat_monasterialpost1861
scalar statistic = r(F)
	outreg2 using "`outputdirectory'tableA16.xls", bdec(2) bra label addstat(F_stat, statistic)	keep(sh_nat_monasterialpost1861 sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)
ivregress 2sls  ln_indoutput_prye   (sh_serfs_postEmancip=sh_nat_monasterialpost1861) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.year i.id l5trend*  if  nobaltics,  cl(idref)
	outreg2 using "`outputdirectory'tableA16.xls", bdec(2) bra label addstat(F_stat, statistic)	keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)
xtreg  ln_indoutput_prye  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year i.id l5trend* if nobaltics, cl(idref) nonest fe
	outreg2 using "`outputdirectory'tableA16.xls", bdec(2) bra label keep(sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861)

********************************************************
* table A17  
********************************************************

xtreg grain_prod  sh_serfs1857post1861 i.year if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA17.xls",  bdec(2) bra label replace keep (sh_serfs1857post1861) ctitle(grain_prod panel A)  	     	 	   	  
		 
xtreg grain_prod  sh_serfs1857post1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA17.xls",  bdec(2) bra label keep (sh_serfs1857post1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		    
reg sh_serfs1857post1861 sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_Iid* if nobaltics & grain_prod!=. ,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
     outreg2 using "`outputdirectory'tableA17.xls",  bdec(2) bra label  addstat(F1_stat, statistic1) keep (sh_nat_monasterialpost1861) ctitle(sh_serfs1857post1861 panel B)  	     	 	   	  	   
ivregress 2sls grain_prod  (sh_serfs1857post1861= sh_nat_monasterialpost1861)  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id i.year year_Iid* if nobaltics,  cl(idref)	
	outreg2 using "`outputdirectory'tableA17.xls",  bdec(2) bra label  addstat(F1_stat, statistic1) keep (sh_serfs1857post1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		    
xtreg grain_prod  sh_serfs1857post1861 sh_stpeasants1857post1866  sh_royal1857post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA17.xls",  bdec(2) bra label   keep (sh_serfs1857post1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		    
xtreg grain_prod  sh_serfs1857_1861_1870  sh_serfs1857_1871_1900   lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics, fe cl(idref)nonest
	outreg2 using "`outputdirectory'tableA17.xls",  bdec(2) bra label  keep (sh_serfs1857_1861_1870  sh_serfs1857_1871_1900 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	
xtreg grain_prod  sh_serfs1857post1861 sh_serfs1857p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics, fe cl(idref) nonest	
	outreg2 using "`outputdirectory'tableA17.xls",  bdec(2) bra label keep (sh_serfs1857post1861 sh_serfs1857p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	 
reg sh_serfs1857post1861 sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* if nobaltics & grain_prod!=. & sh_serfs1857p1861sh_buyout!=. ,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
     outreg2 using "`outputdirectory'tableA17.xls",  bdec(2) bra label  addstat(F1_stat, statistic1, F2_stat, statistic2) keep (sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_serfs1857post1861 panel B)  	     	 	   	  		     	   	 
reg sh_serfs1857p1861sh_buyout sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_Iid* if nobaltics & grain_prod!=. & sh_serfs1857p1861sh_buyout!=. ,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
     outreg2 using "`outputdirectory'tableA17.xls",  bdec(2) bra label  addstat(F1_stat, statistic1, F2_stat, statistic2)  keep (sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_serfs1857p1861sh_buyout panel B)  	     	 	   	  		     	   	 
ivregress 2sls grain_prod  (sh_serfs1857post1861 sh_serfs1857p1861sh_buyout=sh_nat_monasterialpost1861 IVland) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id i.year year_Iid* if nobaltics,  cl(idref)	
	outreg2 using "`outputdirectory'tableA17.xls",  bdec(2) bra label  keep (sh_serfs1857post1861 sh_serfs1857p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  

********************************************************
* table A18   
********************************************************

xtreg grain_prod  sh_serfs1857post1861 sh_serfs1857p1861sh_buyout  shserf1857p1861shbuy_RC lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA18.xls",  bdec(2) bra label replace keep (sh_serfs1857post1861 sh_serfs1857p1861sh_buyout shserf1857p1861shbuy_RC lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod)  	     	 	   	  		     	   	  

xtreg grain_prod  sh_serfs1857post1861 sh_serfs1857p1861sh_buyout sh_serfs1857p1861Chartp63 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA18.xls",  bdec(2) bra label keep (sh_serfs1857post1861 sh_serfs1857p1861sh_buyout sh_serfs1857p1861Chartp63 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod)  	     	 	   	  		     	   	  

xtreg sh_wgrains sh_serfs1857post1861  lagtempsh_serfs1857post1861  lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics , fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA18.xls",  bdec(2) bra label keep (sh_serfs1857post1861  lagtempsh_serfs1857post1861  lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_wgrains)  	     	 	   	  		     	   	  

xtreg sh_wgrains sh_serfs1857post1861  sh_serfs1857p1861_lag_rye_wheat lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics , fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA18.xls",  bdec(2) bra label keep (sh_serfs1857post1861  sh_serfs1857p1861_lag_rye_wheat  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_wgrains)  	     	 	   	  		     	   	  

xtreg sh_wgrains sh_serfs1857post1861  sh_serfs1857p1861_lag_rye_wheat lagtempsh_serfs1857post1861  lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics , fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA18.xls",  bdec(2) bra label keep (sh_serfs1857post1861 sh_serfs1857p1861_lag_rye_wheat lagtempsh_serfs1857post1861  lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_wgrains)  	     	 	   	  		     	   	  

xtreg sh_wgrains sh_serfs1857post1861  sh_serfs1857p1861_lag_rye_oats lagryeoatpricerrratiodemean sh_serfs1857_lag_rye_oats lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics , fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA18.xls",  bdec(2) bra label keep (sh_serfs1857post1861 sh_serfs1857p1861_lag_rye_oats lagryeoatpricerrratiodemean sh_serfs1857_lag_rye_oats  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_wgrains)  	     	 	   	  		     	   	  

xtreg sh_wgrains sh_serfs1857post1861 sh_serfs1857p1861_lag_rye_oats  lagryeoatpricerrratiodemean sh_serfs1857_lag_rye_oats lagtempsh_serfs1857post1861 lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid*  if nobaltics , fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA18.xls",  bdec(2) bra label keep (sh_serfs1857post1861 sh_serfs1857p1861_lag_rye_oats  lagryeoatpricerrratiodemean sh_serfs1857_lag_rye_oats lagtempsh_serfs1857post1861  lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_wgrains)  	     	 	   	  		     	   	  



********************************************************
* table A19 
********************************************************
xtreg  ln_indoutput_adinf  sh_serfs1857post1861  i.year  if nobaltics ,  fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA19.xls", replace bdec(2) bra label keep (sh_serfs1857post1861) ctitle(ln_indoutput_adinf panel A)  	     	 	   	  		     	   	  

xtreg  ln_indoutput_adinf  sh_serfs1857post1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year  l5trend*  if nobaltics ,  fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA19.xls", bdec(2) bra label keep (sh_serfs1857post1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(ln_indoutput_adinf panel A)  	     	 	   	  		     	   	  

reg sh_serfs1857post1861 sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year   l5trend* if nobaltics & ln_indoutput_adinf!=.,  cl(idref)
test sh_nat_monasterialpost1861
scalar statistic = r(F)
	outreg2 using "`outputdirectory'tableA19.xls", bdec(2) bra label addstat(F_stat, statistic) keep (sh_nat_monasterialpost1861) ctitle(sh_serfs1857post1861 panel B)  	     	 	   	  		     	   	  

ivregress 2sls  ln_indoutput_adinf  (sh_serfs1857post1861=sh_nat_monasterialpost1861) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id i.year  l5trend* if  nobaltics ,  cl(idref)
	outreg2 using "`outputdirectory'tableA19.xls", bdec(2) bra label addstat(F_stat, statistic) keep (sh_serfs1857post1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(ln_indoutput_adinf panel A)  	     	 	   	  		     	   	  
	
xtreg  ln_indoutput_adinf  sh_serfs1857post1861 sh_stpeasants1857post1866  sh_royal1857post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year l5trend* if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA19.xls", bdec(2) bra label keep (sh_serfs1857post1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(ln_indoutput_adinf panel A)  	     	 	   	  		     	   	  
	
********************************************************
* table A20
********************************************************
xtreg  height  sh_serfs1857post1861 i.year  if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA20.xls", replace  bdec(2) bra label keep (sh_serfs1857post1861) ctitle(height panel A)  	     	 	   	  		     	   	  

xtreg  height  sh_serfs1857post1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year  if nobaltics, fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA20.xls",  bdec(2) bra label keep (sh_serfs1857post1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(height panel A)  	     	 	   	  		     	   	  

reg sh_serfs1857post1861 sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year  if nobaltics & height!=. ,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
	outreg2 using "`outputdirectory'tableA20.xls", bdec(2) bra label addstat(F1_stat, statistic1) keep (sh_nat_monasterialpost1861) ctitle(sh_serfs1857post1861 panel B)  	     	 	   	  		     	   	  	

ivregress 2sls height  (sh_serfs1857post1861 =sh_nat_monasterialpost1861) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id i.year if nobaltics,  cl(idref)	
	outreg2 using "`outputdirectory'tableA20.xls",  bdec(2) bra label  addstat(F1_stat, statistic1) keep (sh_serfs1857post1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(height panel A)  	     	 	   	  		     	   	  

********************************************************
* Table A21   
********************************************************

xtreg grain_prod  sh_serfs_postEmancip i.year if nobaltics & year<=1882 , fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA21.xls",  bdec(2) bra label replace  keep (sh_serfs_postEmancip) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  

xtreg grain_prod  sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics & year<=1882, fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA21.xls",  bdec(2) bra label  keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_Iid* if nobaltics & grain_prod!=. & year<=1882,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  	outreg2 using "`outputdirectory'tableA21.xls",  bdec(2) bra label   addstat(F1_stat, statistic1) keep (sh_nat_monasterialpost1861) ctitle(sh_serfs_postEmancip panel B)  	     	 	   	  		     	   	  

ivregress 2sls grain_prod  (sh_serfs_postEmancip= sh_nat_monasterialpost1861)  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id i.year year_Iid* if nobaltics & year<=1882,  cl(idref)	
  	outreg2 using "`outputdirectory'tableA21.xls",  bdec(2) bra label   addstat(F1_stat, statistic1) keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  

xtreg grain_prod  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics & year<=1882, fe  cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA21.xls",  bdec(2) bra label keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  
 
xtreg grain_prod  sh_serfs_1861_1870 sh_serfs_1871_1900  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics & year<=1882, fe cl(idref)nonest
	outreg2 using "`outputdirectory'tableA21.xls",  bdec(2) bra label   keep (sh_serfs_1861_1870 sh_serfs_1871_1900 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  

xtreg grain_prod  sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* if nobaltics & year<=1882, fe cl(idref)	nonest
	outreg2 using "`outputdirectory'tableA21.xls",  bdec(2) bra label  keep (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_Iid* if nobaltics & grain_prod!=. & sh_serfs1858p1861sh_buyout!=. & year<=1882,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
     outreg2 using "`outputdirectory'tableA21.xls",  bdec(2) bra label addstat(F1_stat, statistic1, F2_stat, statistic2) keep (sh_nat_monasterialpost1861 IVland) ctitle(sh_serfs_postEmancip panel B)  	     	 	   	  		     	   	  
reg sh_serfs1858p1861sh_buyout sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id i.year year_Iid* if nobaltics & grain_prod!=. & sh_serfs1858p1861sh_buyout!=. & year<=1882 ,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
    outreg2 using "`outputdirectory'tableA21.xls",  bdec(2) bra label addstat(F1_stat, statistic1, F2_stat, statistic2) keep (sh_nat_monasterialpost1861 IVland) ctitle(sh_serfs1858p1861sh_buyout panel B)  	     	 	   	  		     	   	  

ivregress 2sls grain_prod  (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout=sh_nat_monasterialpost1861 IVland) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id i.year year_Iid* if nobaltics & year<=1882,  cl(idref)	
    outreg2 using "`outputdirectory'tableA21.xls",  bdec(2) bra label addstat(F1_stat, statistic1, F2_stat, statistic2) keep (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  

********************************************************
* table A22 
********************************************************

*** generate interactions with baltics

gen lndist_MoscowDpostemanbaltic=lndist_MoscowDemeanpost1861
replace lndist_MoscowDpostemanbaltic=0 if !(id==7 | id==8 | id==9) 
label var lndist_MoscowDpostemanbaltic "Demeaned log distance from Moscow X Baltic provinces X Post-1820"

gen lndist_MoscowDpostemannotbalt=lndist_MoscowDemeanpost1861
replace lndist_MoscowDpostemannotbalt=0 if (id==7 | id==8 | id==9) 
label var lndist_MoscowDpostemannotbalt "Demeaned log distance from Moscow X Not Baltic provinces X Post-1820"

gen median_suitDpostemanbaltic=median_suitabilityDemeanpost1861 
replace median_suitDpostemanbaltic=0 if !(id==7 | id==8 | id==9) 
label var median_suitDpostemanbaltic "Demeaned crop suitability X Baltic provinces X Post-1820"

gen median_suitDpostemannotbalt=median_suitabilityDemeanpost1861
replace median_suitDpostemannotbalt=0 if (id==7 | id==8 | id==9) 
label var median_suitDpostemannotbalt "Demeaned crop suitability X Not Baltic provinces X Post-1820"


gen sh_serfs1858post1820baltic=sh_serfs_postEmancip
replace sh_serfs1858post1820baltic=0 if !(id==7 | id==8 | id==9) 
label var  sh_serfs1858post1820baltic "Share of serfs X Post 1820 X Baltic provinces"

gen sh_serfs1858post1861notbalt=sh_serfs_postEmancip
replace sh_serfs1858post1861notbalt=0 if (id==7 | id==8 | id==9)
label var sh_serfs1858post1861notbalt "Share of serfs X Post-1861 X non-Baltic provinces"


*** make a table

xtreg grain_prod  sh_serfs_postEmancip  lndist_MoscowDpostemanbaltic lndist_MoscowDpostemannotbalt median_suitDpostemanbaltic median_suitDpostemannotbalt i.year year_Iid* , fe cl(idref) nonest	
   outreg2 using "`outputdirectory'tableA22.xls",  bdec(2) bra label replace keep (sh_serfs_postEmancip lndist_MoscowDpostemanbaltic lndist_MoscowDpostemannotbalt median_suitDpostemanbaltic median_suitDpostemannotbal) ctitle(grain_prod)  	     	 	   	 

xtreg grain_prod  sh_serfs_postEmancip  sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDpostemanbaltic lndist_MoscowDpostemannotbalt median_suitDpostemanbaltic median_suitDpostemannotbalt i.year year_Iid* , fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA22.xls",  bdec(2) bra label keep (sh_serfs_postEmancip lndist_MoscowDpostemanbaltic lndist_MoscowDpostemannotbalt median_suitDpostemanbaltic median_suitDpostemannotbal) ctitle(grain_prod)  	     	 	   	 

xtreg grain_prod  sh_serfs1858post1861notbalt sh_serfs1858post1820baltic lndist_MoscowDpostemanbaltic lndist_MoscowDpostemannotbalt median_suitDpostemanbaltic median_suitDpostemannotbalt i.year year_Iid*, fe cl(idref) nonest 	
   outreg2 using "`outputdirectory'tableA22.xls",  bdec(2) bra label  keep (sh_serfs1858post1861notbalt sh_serfs1858post1820baltic lndist_MoscowDpostemanbaltic lndist_MoscowDpostemannotbalt median_suitDpostemanbaltic median_suitDpostemannotbal) ctitle(grain_prod)  	     	 	   	 

xtreg grain_prod  sh_serfs1858post1861notbalt sh_serfs1858post1820baltic sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDpostemanbaltic lndist_MoscowDpostemannotbalt median_suitDpostemanbaltic median_suitDpostemannotbalt i.year year_Iid* , fe cl(idref) nonest
	outreg2 using "`outputdirectory'tableA22.xls",  bdec(2) bra label keep (sh_serfs1858post1861notbalt sh_serfs1858post1820baltic lndist_MoscowDpostemanbaltic lndist_MoscowDpostemannotbalt median_suitDpostemanbaltic median_suitDpostemannotbal) ctitle(grain_prod)  	     	 	   	 

********************************************************
* table A23 
********************************************************

reg grain_prod  sh_serfs_postEmancip i.id  i.year [aweight=lnpop1858] if nobaltics,  cl(idref) 	
	outreg2 using "`outputdirectory'tableA23.xls",  bdec(2) bra label replace  keep (sh_serfs_postEmancip ) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  


reg grain_prod  sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics,  cl(idref)
	outreg2 using "`outputdirectory'tableA23.xls",  bdec(2) bra label keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics & grain_prod!=. ,  cl(idref)
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
 	outreg2 using "`outputdirectory'tableA23.xls",  bdec(2) bra label   addstat(F1_stat, statistic1) keep (sh_nat_monasterialpost1861) ctitle(sh_serfs_postEmancip panel B)  	     	 	   	  		     	   	  
  
ivregress 2sls grain_prod  (sh_serfs_postEmancip=sh_nat_monasterialpost1861)  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics,  cl(idref)	
 	outreg2 using "`outputdirectory'tableA23.xls",  bdec(2) bra label   addstat(F1_stat, statistic1) keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  
  	
reg grain_prod  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics, cl(idref)
	outreg2 using "`outputdirectory'tableA23.xls",  bdec(2) bra label   keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  

xtreg grain_prod  sh_serfs_1861_1870 sh_serfs_1871_1900  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.year year_Iid* [aweight=lnpop1858] if nobaltics, fe cl(idref)nonest
	outreg2 using "`outputdirectory'tableA23.xls",  bdec(2) bra label keep (sh_serfs_1861_1870 sh_serfs_1871_1900 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  

reg grain_prod  sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics, cl(idref)
	outreg2 using "`outputdirectory'tableA23.xls",  bdec(2) bra label  keep (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics & grain_prod!=. & sh_serfs1858p1861sh_buyout!=. ,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
     outreg2 using "`outputdirectory'tableA23.xls",  bdec(2) bra label  addstat(F1_stat, statistic1, F2_stat, statistic2) keep (sh_nat_monasterialpost1861 IVland) ctitle(sh_serfs_postEmancip panel B)  	     	 	   	  		     	   	  
reg sh_serfs1858p1861sh_buyout sh_nat_monasterialpost1861 IVland lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics & grain_prod!=. & sh_serfs1858p1861sh_buyout!=. ,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
  test IVland
  scalar statistic2 = r(F)
     outreg2 using "`outputdirectory'tableA23.xls",  bdec(2) bra label  addstat(F1_stat, statistic1, F2_stat, statistic2)  keep (sh_nat_monasterialpost1861 IVland) ctitle(sh_serfs1858p1861sh_buyout panel B)  	     	 	   	  		     	   	   

ivregress 2sls grain_prod  (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout=sh_nat_monasterialpost1861 IVland) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics,  cl(idref)	
	outreg2 using "`outputdirectory'tableA23.xls",  bdec(2) bra label keep (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod panel A)  	     	 	   	  		     	   	  

********************************************************
* table A24 
********************************************************

reg grain_prod  sh_serfs_postEmancip sh_serfs1858p1861sh_buyout  shserf1858p1861shbuy_RC lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics, cl(idref)
	outreg2 using "`outputdirectory'tableA24.xls",  bdec(2) bra label replace keep (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout  shserf1858p1861shbuy_RC lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod)  	     	 	   	  		     	   	  
	
reg grain_prod  sh_serfs_postEmancip sh_serfs1858p1861sh_buyout sh_serfs1858p1861Chartp63 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics, cl(idref)
	outreg2 using "`outputdirectory'tableA24.xls",  bdec(2) bra label keep (sh_serfs_postEmancip sh_serfs1858p1861sh_buyout  sh_serfs1858p1861Chartp63 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(grain_prod)  	     	 	   	  		     	   	  

reg sh_wgrains sh_serfs_postEmancip  lagtempDemagrsh_pr1858post1861  lagtemp_mean_e400kmDemean  lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics , cl(idref)
	outreg2 using "`outputdirectory'tableA24.xls",  bdec(2) bra label keep (sh_wgrains sh_serfs_postEmancip  lagtempDemagrsh_pr1858post1861  lagtemp_mean_e400kmDemean lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_wgrains)  	     	 	   	  		     	   	  

reg sh_wgrains sh_serfs_postEmancip  sh_serfs1858p1861_lag_rye_wheat lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics , cl(idref)
	outreg2 using "`outputdirectory'tableA24.xls",  bdec(2) bra label keep (sh_wgrains sh_serfs_postEmancip sh_serfs1858p1861_lag_rye_wheat lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_wgrains)  	     	 	   	  		     	   	  

reg sh_wgrains sh_serfs_postEmancip  sh_serfs1858p1861_lag_rye_wheat lagtempDemagrsh_pr1858post1861  lagtemp_mean_e400kmDemean lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics , cl(idref) 
	outreg2 using "`outputdirectory'tableA24.xls",  bdec(2) bra label keep (sh_wgrains sh_serfs_postEmancip sh_serfs1858p1861_lag_rye_wheat lagtempDemagrsh_pr1858post1861  lagtemp_mean_e400kmDemean lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_wgrains)  	     	 	   	  		     	   	  

reg sh_wgrains sh_serfs_postEmancip  sh_serfs1858p1861_lag_rye_oats lagryeoatpricerrratiodemean sh_serfs1858_lag_rye_oats lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics , cl(idref)
	outreg2 using "`outputdirectory'tableA24.xls",  bdec(2) bra label keep (sh_wgrains sh_serfs_postEmancip sh_serfs1858p1861_lag_rye_oats lagryeoatpricerrratiodemean sh_serfs1858_lag_rye_oats lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_wgrains)  	     	 	   	  		     	   	  

reg sh_wgrains sh_serfs_postEmancip  sh_serfs1858p1861_lag_rye_oats lagryeoatpricerrratiodemean sh_serfs1858_lag_rye_oats lagtempDemagrsh_pr1858post1861  lagtemp_mean_e400kmDemean lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year year_Iid* [aweight=lnpop1858] if nobaltics , cl(idref) 
	outreg2 using "`outputdirectory'tableA24.xls",  bdec(2) bra label keep (sh_wgrains sh_serfs_postEmancip sh_serfs1858p1861_lag_rye_oats lagryeoatpricerrratiodemean sh_serfs1858_lag_rye_oats lagtempDemagrsh_pr1858post1861  lagtemp_mean_e400kmDemean lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_wgrains)  	     	 	   	  		     	   	  

	
********************************************************
* table A25 
********************************************************

reg  ln_indoutput_adinf  sh_serfs_postEmancip  i.id  i.year  [aweight=lnpop1858] if nobaltics,  cl(idref) 
	outreg2 using "`outputdirectory'tableA25.xls", replace bdec(2) bra label keep (sh_serfs_postEmancip) ctitle(ln_indoutput_adinf panel A)  	     	 	   	  		     	   	  
		
reg  ln_indoutput_adinf  sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year l5trend* [aweight=lnpop1858] if nobaltics,  cl(idref) 
	outreg2 using "`outputdirectory'tableA25.xls", bdec(2) bra label keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(ln_indoutput_adinf panel A)  	     	 	   	  		     	   	  

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year l5trend* [aweight=lnpop1858] if nobaltics & ln_indoutput_adinf!=.,  cl(idref)
test sh_nat_monasterialpost1861
scalar statistic = r(F)
	outreg2 using "`outputdirectory'tableA25.xls", bdec(2) bra label addstat(F_stat, statistic) keep (sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_serfs_postEmancip panel B)  	     	 	   	  		     	   	  

ivregress 2sls  ln_indoutput_adinf  (sh_serfs_postEmancip=sh_nat_monasterialpost1861) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861  i.id  i.year l5trend* [aweight=lnpop1858] if nobaltics,  cl(idref)
	outreg2 using "`outputdirectory'tableA25.xls", bdec(2) bra label addstat(F_stat, statistic) keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(ln_indoutput_adinf panel A)  	     	 	   	  		     	   	  
	
reg  ln_indoutput_adinf  sh_serfs_postEmancip sh_stpeasants1858post1866  sh_royal1858post1859 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year l5trend* [aweight=lnpop1858] if nobaltics ,  cl(idref)
	outreg2 using "`outputdirectory'tableA25.xls", bdec(2) bra label keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(ln_indoutput_adinf panel A)  	     	 	   	  		     	   	  
	
********************************************************
* table A26 
********************************************************

reg  height  sh_serfs_postEmancip i.id  i.year [aweight=lnpop1858] if nobaltics, cl(idref) 
	outreg2 using "`outputdirectory'tableA26.xls", replace  bdec(2) bra label keep (sh_serfs_postEmancip) ctitle(height panel A)  	     	 	   	  		     	   	  

reg  height  sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year [aweight=lnpop1858] if nobaltics, cl(idref) 
	outreg2 using "`outputdirectory'tableA26.xls", bdec(2) bra label keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(height panel A)  	     	 	   	  		     	   	  

reg sh_serfs_postEmancip sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year [aweight=lnpop1858] if nobaltics &  height!=. ,  cl(idref)	
  test sh_nat_monasterialpost1861
  scalar statistic1 = r(F)
	outreg2 using "`outputdirectory'tableA26.xls",  bdec(2) bra label  addstat(F1_stat, statistic1)  append keep (sh_nat_monasterialpost1861 lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(sh_serfs_postEmancip panel A)  	     	 	   	  		     	   	  

ivregress 2sls height  (sh_serfs_postEmancip =sh_nat_monasterialpost1861) lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861 i.id  i.year [aweight=lnpop1858] if nobaltics,  cl(idref)	
	outreg2 using "`outputdirectory'tableA26.xls",  bdec(2) bra label  addstat(F1_stat, statistic1) append keep (sh_serfs_postEmancip lndist_MoscowDemeanpost1861 median_suitabilityDemeanpost1861) ctitle(height panel A)  	     	 	   	  		     	   	  


**********************************************************************************************************************************
* Appendix Figures
**********************************************************************************************************************************


********************************************************
* figure A2
********************************************************

reg sh_serfs_postEmancip dist_Moscowpost1861 if year==1870 & nobaltics
graph twoway  (scatter sh_serfs_postEmancip dist_Moscowpost1861 if year==1870 & nobaltics , mlabel (province_name)  msize(small) msymbol(circle)) (lfit sh_serfs_postEmancip dist_Moscowpost1861 if year==1870 & id!=7 & id!=8 & id!=9, ytitle(The share of serfs in 1858))
	  graph save `outputdirectory'figureA2, replace 
	  graph export `outputdirectory'figureA2.eps, replace 
	  
********************************************************
* figure A5A A5B A5C
********************************************************
reg pcollate1858pserf grain_prod if year==1858 & nobaltics 
avplot (grain_prod),  msize(small) msymbol(circle) title(Scatter plot and fitted line) ytitle("Share of serfs used as collateral for loans in 1858") xtitle("Grain productivity in 1858")
graph save `outputdirectory'figureA5A, replace 
graph export `outputdirectory'figureA5A.eps, replace 

foreach year in 58 53{
gen grain_prod`year'=grain_prod if year==18`year'
}

egen maxgrain_prod58=max(grain_prod58), by (id)
egen maxgrain_prod53=max(grain_prod53), by (id)
gen difgrain_prod5358=maxgrain_prod58 - maxgrain_prod53


reg pcollate1858pserf difgrain_prod5358 if year==1858 & nobaltics
avplot (difgrain_prod5358),  msize(small) msymbol(circle) title(Scatter plot and fitted line) ytitle("Share of serfs used as collateral for loans in 1858") xtitle("Difference in grain productivity between 1858 and 1853")
graph save `outputdirectory'figureA5B, replace 
graph export `outputdirectory'figureA5B.eps, replace 

reg pcollate1858pserf sh_barshina1858_2 if year==1858 & nobaltics 
avplot (sh_barshina1858_2),  msize(small) msymbol(circle) title(Scatter plot and fitted line) ytitle("Share of serfs used as collateral for loans in 1858") xtitle("Share of peasants on corvee in 1858")
graph save `outputdirectory'figureA5C, replace
graph export `outputdirectory'figureA5C.eps, replace  

********************************************************
*** figure A11 
********************************************************


foreach const in 1800 1806 1810 1815 1820 1825 1830 1832 1835 1840 1845  1847 1849 1850 1851 1853 1854 1855 1856 1857 1858 1859 1860  {
gen sh_serfs1858placebo`const'=0
replace sh_serfs1858placebo`const'=  sh_serfs1858 if  year>=`const'

gen lndist_MoscowDemeanplacebo`const'=0
replace lndist_MoscowDemeanplacebo`const'=ln(dist_Moscow+1)-.498305 if  year>=`const'

gen med_suitDemeanplacebo`const'=0
replace med_suitDemeanplacebo`const'=median_suitability-2.357143 if  year>=`const'

}

/*
xtreg grain_prod sh_serfs1858placebo* i.year if nobaltics & year<1861 , fe  cl(id) nonest
	outreg2 using "`outputdirectory'figureA11.xls",  bdec(2) bra label replace

foreach const in 1800 1806 1815 1825 1845 1851 1853 1856 1857 1858 1859 1860  {
xtreg grain_prod  sh_serfs1858placebo`const' lndist_MoscowDemeanplacebo`const' med_suitDemeanplacebo`const' i.year if id!=7 & id!=8 & id!=9 & id!=44 & year<1861, fe cl(id) nonest
	outreg2 using "`outputdirectory'figureA11.xls",  bdec(2) bra label   
}
*/


capture drop coef low high

gen coef =.
gen low =.
gen high =.
	
foreach const in 1845 1851 1853 1856 1857 1858 1859 1860 {
xtreg grain_prod sh_serfs1858placebo`const' lndist_MoscowDemeanplacebo`const'   med_suitDemeanplacebo`const' d_Iyear* if nobaltics & year<1861, fe cl(id)

replace coef = _b[sh_serfs1858placebo`const'] if year==`const'
replace low = _b[sh_serfs1858placebo`const'] - 1.96*_se[sh_serfs1858placebo`const'] if year==`const'
replace high = _b[sh_serfs1858placebo`const'] + 1.96*_se[sh_serfs1858placebo`const'] if year==`const'
}
preserve

collapse (mean) coef high low, by(year)

keep if inlist(year, 1845,  1851, 1853, 1856, 1857, 1858, 1859, 1860 )


twoway (rarea low high year if year>=1845 & year<=1860, sort color(gs14)) (scatter coef year if year>=1845 & year<=1860, connect(l) lwidth(medthick) lcolor(maroon) mcolor(maroon) msize(medium)) (scatteri -3 1861 3 1861, lcolor(black) c(l) m(i)) (scatteri 0 1845 0 1860,lcolor(black) c(l) m(i)), xscale(range(1845 1860) titlegap(.05)) xlabel(1845[5]1860) ytitle("Coefficient") legend(off)  graphregion(fcolor(white)) title("Placebos")  xtitle("Year") subtitle("") yline(0,lcolor(black) lwidth(medthin)) xline(1861, lcolor(black) lwidth(medthin))

graph save "`outputdirectory'figureA11", replace 
graph export "`outputdirectory'figureA11.eps", replace 
restore

****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****                   DISTRICT - LEVEL ANALYSIS
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************




use `replication_dir'replication_district_Serfdom, clear

**************************************************************************
**** Table 1
**************************************************************************

sum sh_allserfs if nobaltics& nobaltics & !moscow & alldrafted>30&yearbirth==1862
sum height if  nobaltics & !moscow & alldrafted>30
sum sh_church_1814aver_post1861 if  nobaltics & !moscow & alldrafted>30&yearbirth==1862
sum median_suit if  nobaltics & !moscow & alldrafted>30&yearbirth==1862
sum distance_to_moscow if  nobaltics & !moscow & alldrafted>30&yearbirth==1862
**************************************************************************
**** Table 5
**************************************************************************

xtreg height sh_allserfspost1861  i.yearbirth  if nobaltics & !moscow & alldrafted>30 , cl (iddistref) fe nonest
outreg2 using "`outputdirectory'table5_district.xls",  replace bdec(2) bra label keep(sh_allserfspost1861)

xtreg height sh_allserfspost1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861   i.yearbirth  if nobaltics & !moscow & alldrafted>30 , cl(iddistref) fe nonest
outreg2 using "`outputdirectory'table5_district.xls",  append bdec(2) bra label  keep(sh_allserfspost1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861 )

cap drop height_dist_sample
gen  height_dist_sample=e(sample)

reg  sh_allserfspost1861 sh_church_1814aver_post1861 lndistMoscowDemeanpost1861  median_suitDemeanpost1861 i.iddistrict i.yearbirth  if height_dist_sample&nobaltics & !moscow & alldrafted>30, cl(iddistref)
 test  sh_church_1814aver_post1861
   scalar statistic1 = r(F)
     outreg2 using "`outputdirectory'table5_district.xls",  bdec(2) bra label  addstat(F1_stat, statistic1) keep(sh_church_1814aver_post1861 lndistMoscowDemeanpost1861  median_suitDemeanpost1861)

ivregress 2sls height (sh_allserfspost1861=sh_church_1814aver_post1861) lndistMoscowDemeanpost1861  median_suitDemeanpost1861  i.iddistrict i.yearbirth  if nobaltics & !moscow & alldrafted>30, cl(iddistref) 
 outreg2 using "`outputdirectory'table5_district.xls",  bdec(2) bra label  keep(sh_allserfspost1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861 )

**
local dcutoff 900
local lcutoff 0
local beta_cutoff .3
local covariates lndistMoscowDemean median_suitDemean
global x_ols_option lat(latitude) long(longitude) cut1(`dcutoff') cut2(`dcutoff')

reg height i.yearbirth if nobaltics & !moscow & alldrafted>30 
predict height_macro if e(sample), resid

egen height_macro_av_post=mean(height_macro) if yearbirth>=1861, by(iddistrict)
egen height_macro_av_pre=mean(height_macro) if yearbirth<1861, by(iddistrict)

egen height_macro_av_post_max=max(height_macro_av_post), by(iddistrict)
egen height_macro_av_pre_max=max(height_macro_av_pre), by(iddistrict)

gen diff_height=height_macro_av_post_max-height_macro_av_pre_max
x_ols diff_height sh_allserfspost1861 `covariates' if nobaltics & !moscow & yearbirth==1862  & alldrafted>30 , $x_ols_option
     outreg2 using "`outputdirectory'table5_district.xls",  bdec(4) bra label  

reg diff_height sh_allserfspost1861 `covariates' if nobaltics & !moscow & yearbirth==1862  & alldrafted>30
cap drop _dfbeta* 
cap drop beta
dfbeta
gen beta=round(_dfbeta_1*100)/100

x_ols diff_height sh_allserfspost1861 `covariates' if nobaltics & !moscow & yearbirth==1862  & alldrafted>30, $x_ols_option

mat mcoeff = e(b)
mat var = e(V) 
scalar sterr = round(sqrt(var[1,1])*1000)/1000
scalar coef = round(mcoeff[1,1]*1000)/1000
scalar tstat = round((mcoeff[1,1])/(sqrt(var[1,1]))*100)/100
scalar pval = ttail(462,abs(coef/sterr))*2

local myNote = "coef="+string(coef) + ";   Conley (1999) adjusted se="+ string(sterr) + ";   t=" + string(tstat) 


**************************************************************************
* Figure A10B
**************************************************************************

avplot sh_allserfspost1861, mlabel(beta) msize(small) subtitle(Scatter plot conditional on log distance from Moscow and suitability) title("Change in draftees' height, by district") ytitle("Change in detrended height by district, before-after 1861") xtitle(Share of serfs in 1858) caption(DFBeta presented for each observation) note(`myNote')

graph save  "`outputdirectory'figureA10B.gph", replace
graph export  "`outputdirectory'figureA10B.eps", replace

x_ols diff_height sh_allserfspost1861 `covariates' if nobaltics & !moscow & yearbirth==1862  &  alldrafted>30 & abs(_dfbeta_1) <.15 , $x_ols_option
     outreg2 using "`outputdirectory'table5_district.xls",  bdec(4) bra label 
	 
**************************************************************************
* Figure A4A
**************************************************************************

reg  sh_allserfspost1861 sh_church_1814aver_post1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861 if height!=. & yearbirth==1862 & nobaltics & !moscow, cl (iddistref)
  avplot (sh_church_1814aver_post1861),  msize(small) msymbol(circle) title(Scatter plot conditional on log distance from Moscow) subtitle(Full sample) ytitle("Share of serfs in 1858 by district") xtitle("Share of monasterial serfs before nationalization by district")
graph save `outputdirectory'figureA4A, replace 
graph export `outputdirectory'figureA4A.eps, replace 

**************************************************************************
* Figure A4B
**************************************************************************

reg  sh_allserfspost1861 sh_church_1814aver_post1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861 if sh_church_1814aver_post1861<0.3 & height!=. & yearbirth==1862 & nobaltics & !moscow, cl (iddistref)
  avplot (sh_church_1814aver_post1861),  msize(small) msymbol(circle) title(Scatter plot conditional on log distance from Moscow) subtitle(Subsample of districts with the share of monasterial serfs  < 0.3) ytitle("Share of serfs in 1858 by district") xtitle("Share of monasterial serfs before nationalization by district")
graph save `outputdirectory'figureA4B, replace 
graph export `outputdirectory'figureA4B.eps, replace 


**************************************************************************
* figure A9
*****************************************************************************


capture drop coef high low time

* years 1853-1862
capture drop time
gen time=0
replace time=.7 if yearbirth==1854 
replace time=1 if yearbirth==1855 | yearbirth==1856
replace time=2 if yearbirth==1857 | yearbirth==1858
replace time=3 if yearbirth==1859 | yearbirth==1860 
replace time=4 if yearbirth==1861 | yearbirth==1862 
replace time=5 if yearbirth==1863 | yearbirth==1864
replace time=6 if yearbirth==1865 | yearbirth==1866 
replace time=7 if yearbirth==1875
replace time=7.3 if yearbirth==1876

capture label drop ti
label def ti 1 "55-56" 2 "57-58" 3 "59-60" 4 "61-62" 5 "63" 6 "65-66" 7 "75" 
label values time ti
capture drop D*

gen D1=sh_allserfs
replace D1=0 if yearbirth<1855|yearbirth>1856
gen D2=sh_allserfs
replace D2=0 if yearbirth<1857|yearbirth>1858
gen D3=sh_allserfs
replace D3=0 if yearbirth<1859|yearbirth>1860
gen D4=sh_allserfs
replace D4=0 if yearbirth<1861

label var D1 "Share of Serfs X cohorts 1855 1856"
label var D2 "Share of Serfs X cohorts 1857 1858"
label var D3 "Share of Serfs X cohorts 1859 1860"
label var D4 "Share of Serfs X cohorts 1861 1862"

reg height D1 D2 D3 D4  sh_allserfspost1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861  i.iddistrict i.yearbirth if nobaltics & !moscow & alldrafted>30 , cl (iddistref)
outreg2 using `outputdirectory'Table_A3_district.xls, replace keep(D1 D2 D3 D4  sh_allserfspost1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861) 
gen coef =.
gen low=.
gen high =.

forval k=1/4 {
replace coef = _b[D`k'] if time==`k'
replace low = _b[D`k']-1.64*_se[D`k'] if time==`k'
replace high = _b[D`k']+1.64*_se[D`k'] if time==`k'
}

preserve

collapse (mean) coef high low, by(time)
keep if time<=6
keep if time>0

twoway (scatter coef t, connect(l) lwidth(medthick) lcolor(blue) mcolor(blue) msize(medium) ) (line high t, lpattern(dash) lcolor(gray) lwidth(medthin)) (line low t, lpattern(dash) lcolor(gray) lwidth(medthin)), title("Draftees' height by district, cohorts 1853-1862")  subtitle("(relative to cohorts of 1853-1854)") xline(3.5, lcolor(red) lwidth(medthick)) yline(0, lcolor(black) lwidth(medthin)) xlabel(1 2 3 4 , valuelabel labsize(small)) xtitle(Birth cohorts) ytitle(Coefficient) legend(off)  graphregion(fcolor(white))
graph export `outputdirectory'figureA9.eps, replace 
graph save `outputdirectory'figureA9, replace 

restore

****************************************************************************
* Appendix tables
****************************************************************************

**************************************************************************
* table A7
**************************************************************************


xtreg height sh_allserfspost1861  i.yearbirth  if nobaltics & !moscow & !st_petersburg & alldrafted>30 , cl (iddistref) fe nonest
outreg2 using "`outputdirectory'tableA7.xls", replace bdec(2) bra label keep(sh_allserfspost1861)

xtreg height sh_allserfspost1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861   i.yearbirth  if nobaltics & !moscow & !st_petersburg & alldrafted>30 , cl(iddistref) fe nonest
outreg2 using "`outputdirectory'tableA7.xls",  append bdec(2) bra label  keep(sh_allserfspost1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861 )

cap drop height_dist_sample
gen  height_dist_sample=e(sample)

reg  sh_allserfspost1861 sh_church_1814aver_post1861 lndistMoscowDemeanpost1861  median_suitDemeanpost1861 i.iddistrict i.yearbirth  if height_dist_sample & nobaltics & !moscow & !st_petersburg & alldrafted>30, cl(iddistref)
 test  sh_church_1814aver_post1861
   scalar statistic1 = r(F)
     outreg2 using "`outputdirectory'tableA7.xls",  bdec(2) bra label  addstat(F1_stat, statistic1) keep(sh_church_1814aver_post1861 lndistMoscowDemeanpost1861  median_suitDemeanpost1861)

ivregress 2sls height (sh_allserfspost1861=sh_church_1814aver_post1861) lndistMoscowDemeanpost1861  median_suitDemeanpost1861  i.iddistrict i.yearbirth  if nobaltics & !moscow & !st_petersburg & alldrafted>30, cl(iddistref) 
 outreg2 using "`outputdirectory'tableA7.xls",  bdec(2) bra label  keep(sh_allserfspost1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861 )


****************************************************************************
* table A10
*****************************************************************************

xtreg height_unadj sh_allserfspost1861  i.yearbirth  if nobaltics & !moscow & alldrafted>30 , cl (iddistref) fe nonest
outreg2 using "`outputdirectory'tableA10_district.xls",  replace bdec(2) bra label keep(sh_allserfspost1861)

xtreg height_unadj sh_allserfspost1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861   i.yearbirth  if nobaltics & !moscow & alldrafted>30 , cl(iddistref) fe nonest
outreg2 using "`outputdirectory'tableA10_district.xls",  append bdec(2) bra label  keep(sh_allserfspost1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861 )

cap drop height_dist_sample
gen  height_dist_sample=e(sample)

reg  sh_allserfspost1861 sh_church_1814aver_post1861 lndistMoscowDemeanpost1861  median_suitDemeanpost1861 i.iddistrict i.yearbirth  if height_dist_sample&nobaltics & !moscow & alldrafted>30, cl(iddistref)
 test  sh_church_1814aver_post1861
   scalar statistic1 = r(F)
     outreg2 using "`outputdirectory'tableA10_district.xls",  bdec(2) bra label  addstat(F1_stat, statistic1) keep(sh_church_1814aver_post1861 lndistMoscowDemeanpost1861  median_suitDemeanpost1861)

ivregress 2sls height_unadj (sh_allserfspost1861=sh_church_1814aver_post1861) lndistMoscowDemeanpost1861  median_suitDemeanpost1861  i.iddistrict i.yearbirth  if nobaltics & !moscow & alldrafted>30, cl(iddistref) 
 outreg2 using "`outputdirectory'tableA10_district.xls",  bdec(2) bra label  keep(sh_allserfspost1861 lndistMoscowDemeanpost1861 median_suitDemeanpost1861 )


local dcutoff 900
local lcutoff 0
local beta_cutoff .3
local covariates lndistMoscowDemean median_suitDemean
global x_ols_option lat(latitude) long(longitude) cut1(`dcutoff') cut2(`dcutoff')


reg height_unadj i.yearbirth if nobaltics & !moscow & alldrafted>30
predict height_unadj_macro if e(sample), resid

egen height_unadj_macro_av_post=mean(height_unadj_macro) if yearbirth>=1861, by(iddistrict)
egen height_unadj_macro_av_pre=mean(height_unadj_macro) if yearbirth<1861, by(iddistrict)

egen height_unadj_macro_av_post_max=max(height_unadj_macro_av_post), by(iddistrict)
egen height_unadj_macro_av_pre_max=max(height_unadj_macro_av_pre), by(iddistrict)

gen diff_height_unadj_=height_unadj_macro_av_post_max-height_unadj_macro_av_pre_max
x_ols diff_height_unadj sh_allserfspost1861 `covariates' if nobaltics & !moscow & yearbirth==1862 & alldrafted>30, $x_ols_option
     outreg2 using "`outputdirectory'tableA10_district.xls",  bdec(4) bra label  

reg diff_height_unadj sh_allserfspost1861 `covariates' if nobaltics & !moscow &yearbirth==1862 & alldrafted>30
cap drop _dfbeta* 
cap drop beta
dfbeta
gen beta=round(_dfbeta_1*100)/100

x_ols diff_height_unadj sh_allserfspost1861 `covariates' if nobaltics & !moscow &yearbirth==1862 & alldrafted>30, $x_ols_option

mat mcoeff = e(b)
mat var = e(V) 
scalar sterr = round(sqrt(var[1,1])*1000)/1000
scalar coef = round(mcoeff[1,1]*1000)/1000
scalar tstat = round((mcoeff[1,1])/(sqrt(var[1,1]))*100)/100
scalar pval = ttail(462,abs(coef/sterr))*2

local myNote = "coef="+string(coef) + ";   Conley (1999) adjusted se="+ string(sterr) + ";   t=" + string(tstat) 

x_ols diff_height_unadj sh_allserfspost1861 `covariates' if nobaltics & !moscow &yearbirth==1862 & alldrafted>30& abs(_dfbeta_1) <.15, $x_ols_option
     outreg2 using "`outputdirectory'tableA10_district.xls",  bdec(4) bra label 

****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****                   COUNTRY - LEVEL ANALYSIS
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************
****************************************************************************************************************************************************


	 
	 
use `data_directory'replication_country_Serfdom, clear


tsset year

**************************************************************************
* figure 1
**************************************************************************


tsline rus_av_grain_prod if year<1915, recast(connected) xline(1861) ytitle("Average grain productivity, Russian empire")  xsc(r(1800  1920)) xlabel(1800(20)1920) xtitle(Year) title(Agricultural productivity and the 1861 emancipation reform)
graph save "`outputdirectory'figure1", replace

gen year_sq=year*year
gen year_post61=0
replace year_post61=year if year>=1861

reg rus_av_grain_prod year_sq year
predict det_yeild_quadratic if e(sample), resid 
label var det_yeild_quadratic "Detrended grain productivity (national level), quadratic fit"

gen det_yeild_quadraticPost61=det_yeild_quadratic
replace det_yeild_quadraticPost61=0 if year<1861
label var det_yeild_quadraticPost61 "Detrended grain productivity (national level), quadratic fit X Post 1861"

**************************************************************************
* Table A2
**************************************************************************


reg grain_prod_available det_yeild_quadratic , r
outreg2 using "`outputdirectory'tableA2.xls",  bdec(3) bra label  replace

foreach var in grain_prod_available ind_output_available {
reg `var' det_yeild_quadratic , r
outreg2 using "`outputdirectory'tableA2.xls",  bdec(3) bra label  

reg `var' det_yeild_quadratic det_yeild_quadraticPost61, r
outreg2 using "`outputdirectory'tableA2.xls",  bdec(3) bra label  

reg `var' det_yeild_quadratic year det_yeild_quadraticPost61, r
outreg2 using "`outputdirectory'tableA2.xls",  bdec(3) bra label  

}



