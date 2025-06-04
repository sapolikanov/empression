*change directory in second line
 
version 11.2
cd "XX"
clear matrix
clear mata
clear
set mem 50m
set more off
do "Finkel Gehlbach Olsen CPS replication merge"


****SAMPLE

*Earlier reform, no population data
drop if name == "Estonia" | name == "Kurliandia" | name == "Livonia"
*Later reform
drop if name == "Kutaisi" | name == "Tiflis" | name == "Bessarabia"
*Later reform, no population data
drop if name == "Erivan" | name == "Dagestan"
*No population data
drop if name == "Stavropol"


****DESCRIPTIVE DATA

sum cr cs cl ce co if period == 0
sum cr cs cl ce co if period == 1
sum cr cs cl ce co if period == 2

*Bar charts
graph bar (mean) cr cs cl ce co, over(period) stack saving(ca2, replace) legend(label(1 "L/P Relations  ") label(2 "Serf Status") label(3 "Liberation") label(4 "Estate") label(5 "Other") cols(1) pos(3) order(6 5 4 3 2 1)) ytitle("Disturbances per region-year" " ") scheme(s2mono) title("All Peasants") 
graph bar (mean) cr_serf cs_serf cl_serf ce_serf co_serf, over(period) stack saving(ca2, replace) legend(label(1 "L/P Relations  ") label(2 "Serf Status") label(3 "Liberation") label(4 "Estate") label(5 "Other") cols(1) pos(3) order(6 5 4 3 2 1)) ytitle("Disturbances per region-year" " ") scheme(s2mono) title("Current and Former Landowner Peasants") 
graph bar (mean) cr_other cs_other cl_other ce_other co_other, over(period) stack saving(ca2, replace) legend(label(1 "L/P Relations  ") label(2 "Serf Status") label(3 "Liberation") label(4 "Estate") label(5 "Other") cols(1) pos(3) order(6 5 4 3 2 1)) ytitle("Disturbances per region-year" " ") scheme(s2mono) title("State and Appanage Peasants") 
erase ca2.gph


****LIBERATION, SOIL TYPE, PEASANT ORGANIZATION

keep if trans == 1
egen cl_serf_sum = total(cl_serf), by(gub)
keep if start == 1861
replace totserf = totserf/100000
gen cl_serf_pc = cl_serf_sum/totserf

*liberation-related disturbances
reg cl_serf_pc barshchinashare settlementsize goodsoil 
outreg2 using table3, bdec(3) noaster replace
nbreg cl_serf_sum barshchinashare settlementsize goodsoil , exposure(totserf)
outreg2 using table3, bdec(3) noaster

*robustness to defining good soil as chernozem only
reg cl_serf_pc barshchinashare settlementsize blacksoil
nbreg cl_serf_sum barshchinashare settlementsize blacksoil, exposure(totserf)

*robustness to controlling for inventory reform
reg cl_serf_pc barshchinashare settlementsize goodsoil  inventory
nbreg cl_serf_sum barshchinashare settlementsize goodsoil  inventory, exposure(totserf)


****OTHER ANALYSIS

use event_data.dta, clear
*drop regions not in sample
drop if gub == 6 | gub == 50 | gub == 55 | gub == 52 | gub == 38 | gub == 3 | gub == 54 | gub == 57
keep if startyear == 1861 | startyear == 1862

*which liberation-related grievances?
tab cl15 if (peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999) & cl_serf == 1, missing

*which actions for peasants who were upset by liberation
replace ac_serf = 0 if ac_serf == .
replace ar_serf = 0 if ar_serf == .
replace at_serf = 0 if at_serf == .
replace ag_serf = 0 if ag_serf == .
replace cl_serf = 0 if cl_serf == .
sum ac_serf ar_serf at_serf ag_serf if (peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999) & cl_serf == 1
sum ac_serf ar_serf at_serf ag_serf if (peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999) & cl_serf == 0
graph bar (mean) ac_serf ar_serf at_serf ag_serf if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999, over(cl_serf) stack


****HOUSEKEEPING
erase gub_startyear.dta
erase gub3.dta
erase gub2.dta
erase temp.dta
erase soilspct.dta
erase soils.dta
erase serf.dta
erase rye.dta
erase peasantpopn.dta
erase peasantcensus.dta
erase gub_soils.dta
erase event.dta
erase event_data.dta
erase event_data_gubyr.dta
erase table3.txt

