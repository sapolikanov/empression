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


****REFUSALS

xtset gub start

**Baseline model

constraint define 1 lntotserf = 1
estsimp nbreg ar_serf trans posttrans lntotserf, constraint(1)
outreg2 using table_refusal_top, replace bdec(3) noast
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1 
estsimp nbreg ar_other trans posttrans lntotother, constraint(1)
outreg2 using table_refusal_bottom, replace bdec(3) noast
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**TSGAOR only

constraint define 1 lntotserf = 1
estsimp nbreg ar_serf_tsgaor trans posttrans lntotserf, constraint(1)
outreg2 using table_refusal_top, bdec(3) noast
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg ar_other_tsgaor trans posttrans lntotother, constraint(1)
outreg2 using table_refusal_bottom, bdec(3) noast
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**1858-60 vs. 1861-62

preserve
drop if startyear < 1858
drop if startyear > 1862

constraint define 1 lntotserf = 1
estsimp nbreg ar_serf trans lntotserf, constraint(1)
outreg2 using table_refusal_top, bdec(3) noast
setx lntotserf mean
simqi, fd(ev) changex(trans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg ar_other trans lntotother, constraint(1)
outreg2 using table_refusal_bottom, bdec(3) noast
setx lntotother mean
simqi, fd(ev) changex(trans 0 1)
drop b*

restore

**Linear fixed effects

xtreg ar_serf trans posttrans, fe
outreg2 using table_refusal_top, bdec(3) noast
xtreg ar_other trans posttrans, fe
outreg2 using table_refusal_bottom, bdec(3) noast

**"Fixed effects" model

constraint define 1 lntotserf = 1
xtnbreg ar_serf trans posttrans lntotserf, constraint(1) fe

constraint define 1 lntotother = 1
xtnbreg ar_other trans posttrans lntotother, constraint(1) fe

**Only "large" actions

constraint define 1 lntotserf = 1
estsimp nbreg ar_serf_large trans posttrans lntotserf, constraint(1)
outreg2 using table_refusal_top, bdec(3) noast
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg ar_other_large trans posttrans lntotother, constraint(1)
outreg2 using table_refusal_bottom, bdec(3) noast
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Only actions in which military response

constraint define 1 lntotserf = 1
estsimp nbreg ar_serf_mil trans posttrans lntotserf, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg ar_other_mil trans posttrans lntotother, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Drop western regions

constraint define 1 lntotserf = 1
estsimp nbreg ar_serf trans posttrans lntotserf if polish == 0, constraint(1)
outreg2 using table_refusal_top, bdec(3) noast
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg ar_other trans posttrans lntotother if polish == 0, constraint(1)
outreg2 using table_refusal_bottom, bdec(3) noast
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Drop after 1865

constraint define 1 lntotserf = 1
estsimp nbreg ar_serf trans posttrans lntotserf if start < 1866, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg ar_other trans posttrans lntotother if start < 1866, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b* 

**Drop all non-Russian regions

constraint define 1 lntotserf = 1
estsimp nbreg ar_serf trans posttrans lntotserf if russian == 1, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg ar_other trans posttrans lntotother if russian == 1, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Drop regions one by one

foreach i of numlist 1 2 4 7/30 32/34 36 37 39/49 51 53 56  {
constraint define 1 lntotserf = 1
estsimp nbreg ar_serf trans posttrans lntotserf if gub ~= `i', constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg ar_other trans posttrans lntotother if gub ~= `i', constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*
}

**Linear fixed effects with grain prices as proxy for weather

xtreg ar_serf trans posttrans rye, fe
xtreg ar_other trans posttrans rye, fe
*balanced panel only
egen ryecount = count(rye), by(gub)
xtreg ar_serf trans posttrans rye if ryecount == 21, fe
xtreg ar_other trans posttrans rye if ryecount == 21, fe
*Look at average rye prices around time of Emancipation
sum rye if startyear == 1858 & ryecount == 21
sum rye if startyear == 1859 & ryecount == 21
sum rye if startyear == 1860 & ryecount == 21
sum rye if startyear == 1861 & ryecount == 21
sum rye if startyear == 1862 & ryecount == 21
sum rye if startyear == 1863 & ryecount == 21
sum rye if startyear == 1864 & ryecount == 21
sum rye if startyear == 1865 & ryecount == 21

**Do not code unknown (peasanttype == 9999) as serf

constraint define 1 lntotserf = 1
estsimp nbreg ar_serf_no9999 trans posttrans lntotserf, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg ar_other trans posttrans lntotother, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Reclassify "unspecified unrest" as refusal

constraint define 1 lntotserf = 1
estsimp nbreg ar_serf_volnenie trans posttrans lntotserf, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1 
estsimp nbreg ar_other_volnenie trans posttrans lntotother, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Drop regions with goodsoil > .5

preserve
keep if goodsoil <= .5

constraint define 1 lntotserf = 1
estsimp nbreg ar_serf trans posttrans lntotserf, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1 
estsimp nbreg ar_other trans posttrans lntotother, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

restore


****THEFT AND VIOLENCE

**Baseline model

constraint define 1 lntotserf = 1
estsimp nbreg at_serf trans posttrans lntotserf, constraint(1)
outreg2 using table_theft_top, replace bdec(3) noast
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg at_other trans posttrans lntotother, constraint(1)
outreg2 using table_theft_bottom, replace bdec(3) noast
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**TSGAOR only

constraint define 1 lntotserf = 1
estsimp nbreg at_serf_tsgaor trans posttrans lntotserf, constraint(1)
outreg2 using table_theft_top, bdec(3) noast
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg at_other_tsgaor trans posttrans lntotother, constraint(1)
outreg2 using table_theft_bottom, bdec(3) noast
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**1858-60 vs. 1861-62

preserve
drop if startyear < 1858
drop if startyear > 1862

constraint define 1 lntotserf = 1
estsimp nbreg at_serf trans lntotserf, constraint(1)
outreg2 using table_theft_top, bdec(3) noast
setx lntotserf mean
simqi, fd(ev) changex(trans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg at_other trans lntotother, constraint(1)
outreg2 using table_theft_bottom, bdec(3) noast
setx lntotother mean
simqi, fd(ev) changex(trans 0 1)
drop b*

restore

**Linear fixed effects

xtreg at_serf trans posttrans, fe
outreg2 using table_theft_top, bdec(3) noast
xtreg at_other trans posttrans, fe
outreg2 using table_theft_bottom, bdec(3) noast

**"Fixed effects" model

constraint define 1 lntotserf = 1
xtnbreg at_serf trans posttrans lntotserf, constraint(1) fe

constraint define 1 lntotother = 1
xtnbreg at_other trans posttrans lntotother, constraint(1) fe

**Only "large" actions

constraint define 1 lntotserf = 1
estsimp nbreg at_serf_large trans posttrans lntotserf, constraint(1)
outreg2 using table_theft_top, bdec(3) noast
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg at_other_large trans posttrans lntotother, constraint(1)
outreg2 using table_theft_bottom, bdec(3) noast
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Only actions in which military response

constraint define 1 lntotserf = 1
estsimp nbreg at_serf_mil trans posttrans lntotserf, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg at_other_mil trans posttrans lntotother, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Drop western regions

constraint define 1 lntotserf = 1
estsimp nbreg at_serf trans posttrans lntotserf if polish == 0, constraint(1)
outreg2 using table_theft_top, bdec(3) noast
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg at_other trans posttrans lntotother if polish == 0, constraint(1)
outreg2 using table_theft_bottom, bdec(3) noast
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Drop after 1865

constraint define 1 lntotserf = 1
estsimp nbreg at_serf trans posttrans lntotserf if start < 1866, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg at_other trans posttrans lntotother if start < 1866, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Drop all non-Russian regions

constraint define 1 lntotserf = 1
estsimp nbreg at_serf trans posttrans lntotserf if russian == 1, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg at_other trans posttrans lntotother if russian == 1, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Drop regions one by one

foreach i of numlist 1 2 4 7/30 32/34 36 37 39/49 51 53 56  {
constraint define 1 lntotserf = 1
estsimp nbreg at_serf trans posttrans lntotserf if gub ~= `i', constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg at_other trans posttrans lntotother if gub ~= `i', constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*
}

**Linear fixed effects with grain prices as proxy for weather

xtreg at_serf trans posttrans rye, fe
xtreg at_serf trans posttrans if e(sample), fe
xtreg at_other trans posttrans rye, fe
xtreg at_other trans posttrans if e(sample), fe

**Do not code unknown (peasanttype == 9999) as serf

constraint define 1 lntotserf = 1
estsimp nbreg at_serf_no9999 trans posttrans lntotserf, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg at_other trans posttrans lntotother, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Reclassify "unspecified unrest" as refusal

constraint define 1 lntotserf = 1
estsimp nbreg at_serf_volnenie trans posttrans lntotserf, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1 
estsimp nbreg at_other_volnenie trans posttrans lntotother, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

**Drop regions with goodsoil > .5

preserve
keep if goodsoil <= .5

constraint define 1 lntotserf = 1
estsimp nbreg at_serf trans posttrans lntotserf, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1
estsimp nbreg at_other trans posttrans lntotother, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

restore


****ALL ACTIONS (RECORDED IN FOOTNOTE)

constraint define 1 lntotserf = 1
estsimp nbreg a_serf trans posttrans lntotserf, constraint(1)
setx posttrans 0 lntotserf mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotserf mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*

constraint define 1 lntotother = 1 
estsimp nbreg a_other trans posttrans lntotother, constraint(1)
setx posttrans 0 lntotother mean
simqi, fd(ev) changex(trans 0 1)
setx trans 0 lntotother mean
simqi, fd(ev) changex(posttrans 0 1)
drop b*


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
erase table_refusal_top.txt
erase table_refusal_bottom.txt
erase table_theft_top.txt
erase table_theft_bottom.txt


