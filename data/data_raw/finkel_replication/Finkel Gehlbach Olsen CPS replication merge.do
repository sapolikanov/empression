**ACTIONS AND CAUSES.

use 2014.07.12.dta, clear
save event.dta, replace
use archive_source, clear
merge 1:1 masterid using event
drop _m

*count observations in final sample
preserve
drop if guberniya1 == 6 & guberniya2 == .
drop if guberniya1 == 50 & guberniya2 == .
drop if guberniya1 == 55 & guberniya2 == .
drop if guberniya1 == 52 & guberniya2 == .
drop if guberniya1 == 38 & guberniya2 == .
drop if guberniya1 == 3 & guberniya2 == .
drop if guberniya1 == 54 & guberniya2 == .
drop if guberniya1 == 57 & guberniya2 == .
drop if guberniya1 == 53 & guberniya2 == .
tab guberniya2
list guberniya* if guberniya2 == 6
drop if guberniya2 == 6
tab guberniya3
*drop missing region
drop if guberniya1==9999
sum masterid
restore

gen ar1=1 if peasantaction1==1
gen ar2=1 if peasantaction1==2
gen ar3=1 if peasantaction1==3
gen ar4=1 if peasantaction1==4
gen ar5=1 if peasantaction1==5
gen ar6=1 if peasantaction1==6
gen ar7=1 if peasantaction1==7
gen ar8=1 if peasantaction1==8
gen ar9=1 if peasantaction1==9
gen ar10=1 if peasantaction1==10
gen ar34=1 if peasantaction1==34
gen ar39=1 if peasantaction1==39
gen ac11=1 if peasantaction1==11
gen ac12=1 if peasantaction1==12
gen ac13=1 if peasantaction1==13
gen ac14=1 if peasantaction1==14
gen ac15=1 if peasantaction1==15
gen ac16=1 if peasantaction1==16
gen ac17=1 if peasantaction1==17
gen ac18=1 if peasantaction1==18
gen at20=1 if peasantaction1==20
gen at21=1 if peasantaction1==21
gen at22=1 if peasantaction1==22
gen at23=1 if peasantaction1==23
gen at24=1 if peasantaction1==24
gen at25=1 if peasantaction1==25
gen at26=1 if peasantaction1==26
gen at27=1 if peasantaction1==27
gen at28=1 if peasantaction1==28
gen at30=1 if peasantaction1==30
gen at35=1 if peasantaction1==35
gen at36=1 if peasantaction1==36
gen at37=1 if peasantaction1==37
gen ag31=1 if peasantaction1==31
gen ag33=1 if peasantaction1==33
*three events with this code, but this is the only with with peasant action (Note: "ACTION OTHER.  Peasants refuse to sign contract b/c rumors of land being given to them")
gen ar9999=1 if masterid == 3595 

replace ar1=1 if peasantaction2==1
replace ar2=1 if peasantaction2==2
replace ar3=1 if peasantaction2==3
replace ar4=1 if peasantaction2==4
replace ar5=1 if peasantaction2==5
replace ar6=1 if peasantaction2==6
replace ar7=1 if peasantaction2==7
replace ar8=1 if peasantaction2==8
replace ar9=1 if peasantaction2==9
replace ar10=1 if peasantaction2==10
replace ar34=1 if peasantaction2==34
replace ar39=1 if peasantaction2==39
replace ac11=1 if peasantaction2==11
replace ac12=1 if peasantaction2==12
replace ac13=1 if peasantaction2==13
replace ac14=1 if peasantaction2==14
replace ac15=1 if peasantaction2==15
replace ac16=1 if peasantaction2==16
replace ac17=1 if peasantaction2==17
replace ac18=1 if peasantaction2==18
replace at20=1 if peasantaction2==20
replace at21=1 if peasantaction2==21
replace at22=1 if peasantaction2==22
replace at23=1 if peasantaction2==23
replace at24=1 if peasantaction2==24
replace at25=1 if peasantaction2==25
replace at26=1 if peasantaction2==26
replace at27=1 if peasantaction2==27
replace at28=1 if peasantaction2==28
replace at30=1 if peasantaction2==30
replace at35=1 if peasantaction2==35
replace at36=1 if peasantaction2==36
replace at37=1 if peasantaction2==37
replace ag31=1 if peasantaction2==31
replace ag33=1 if peasantaction2==33

replace ar1=1 if peasantaction3==1
replace ar2=1 if peasantaction3==2
replace ar3=1 if peasantaction3==3
replace ar4=1 if peasantaction3==4
replace ar5=1 if peasantaction3==5
replace ar6=1 if peasantaction3==6
replace ar7=1 if peasantaction3==7
replace ar8=1 if peasantaction3==8
replace ar9=1 if peasantaction3==9
replace ar10=1 if peasantaction3==10
replace ar34=1 if peasantaction3==34
replace ar39=1 if peasantaction3==39
replace ac11=1 if peasantaction3==11
replace ac12=1 if peasantaction3==12
replace ac13=1 if peasantaction3==13
replace ac14=1 if peasantaction3==14
replace ac15=1 if peasantaction3==15
replace ac16=1 if peasantaction3==16
replace ac17=1 if peasantaction3==17
replace ac18=1 if peasantaction3==18
replace at20=1 if peasantaction3==20
replace at21=1 if peasantaction3==21
replace at22=1 if peasantaction3==22
replace at23=1 if peasantaction3==23
replace at24=1 if peasantaction3==24
replace at25=1 if peasantaction3==25
replace at26=1 if peasantaction3==26
replace at27=1 if peasantaction3==27
replace at28=1 if peasantaction3==28
replace at30=1 if peasantaction3==30
replace at35=1 if peasantaction3==35
replace at36=1 if peasantaction3==36
replace at37=1 if peasantaction3==37
replace ag31=1 if peasantaction3==31
replace ag33=1 if peasantaction3==33

replace ar1=1 if peasantaction4==1
replace ar2=1 if peasantaction4==2
replace ar3=1 if peasantaction4==3
replace ar4=1 if peasantaction4==4
replace ar5=1 if peasantaction4==5
replace ar6=1 if peasantaction4==6
replace ar7=1 if peasantaction4==7
replace ar8=1 if peasantaction4==8
replace ar9=1 if peasantaction4==9
replace ar10=1 if peasantaction4==10
replace ar34=1 if peasantaction4==34
replace ar39=1 if peasantaction4==39
replace ac11=1 if peasantaction4==11
replace ac12=1 if peasantaction4==12
replace ac13=1 if peasantaction4==13
replace ac14=1 if peasantaction4==14
replace ac15=1 if peasantaction4==15
replace ac16=1 if peasantaction4==16
replace ac17=1 if peasantaction4==17
replace ac18=1 if peasantaction4==18
replace at20=1 if peasantaction4==20
replace at21=1 if peasantaction4==21
replace at22=1 if peasantaction4==22
replace at23=1 if peasantaction4==23
replace at24=1 if peasantaction4==24
replace at25=1 if peasantaction4==25
replace at26=1 if peasantaction4==26
replace at27=1 if peasantaction4==27
replace at28=1 if peasantaction4==28
replace at30=1 if peasantaction4==30
replace at35=1 if peasantaction4==35
replace at36=1 if peasantaction4==36
replace at37=1 if peasantaction4==37
replace ag31=1 if peasantaction4==31
replace ag33=1 if peasantaction4==33

replace ar1=1 if peasantaction5==1
replace ar2=1 if peasantaction5==2
replace ar3=1 if peasantaction5==3
replace ar4=1 if peasantaction5==4
replace ar5=1 if peasantaction5==5
replace ar6=1 if peasantaction5==6
replace ar7=1 if peasantaction5==7
replace ar8=1 if peasantaction5==8
replace ar9=1 if peasantaction5==9
replace ar10=1 if peasantaction5==10
replace ar34=1 if peasantaction5==34
replace ar39=1 if peasantaction5==39
replace ac11=1 if peasantaction5==11
replace ac12=1 if peasantaction5==12
replace ac13=1 if peasantaction5==13
replace ac14=1 if peasantaction5==14
replace ac15=1 if peasantaction5==15
replace ac16=1 if peasantaction5==16
replace ac17=1 if peasantaction5==17
replace ac18=1 if peasantaction5==18
replace at20=1 if peasantaction5==20
replace at21=1 if peasantaction5==21
replace at22=1 if peasantaction5==22
replace at23=1 if peasantaction5==23
replace at24=1 if peasantaction5==24
replace at25=1 if peasantaction5==25
replace at26=1 if peasantaction5==26
replace at27=1 if peasantaction5==27
replace at28=1 if peasantaction5==28
replace at30=1 if peasantaction5==30
replace at35=1 if peasantaction5==35
replace at36=1 if peasantaction5==36
replace at37=1 if peasantaction5==37
replace ag31=1 if peasantaction5==31
replace ag33=1 if peasantaction5==33

*do not include complaint to unknown (ac18)---not obviously a complaint to a person, just coded when peasants were specific in what they wanted
egen ac = rowmax(ac11 ac12 ac13 ac14 ac15 ac16 ac17)
egen ar = rowmax(ar1 ar2 ar3 ar4 ar5 ar6 ar7 ar8 ar9 ar10 ar34 ar39 ar9999)
egen at = rowmax(at20 at21 at22 at23 at24 at25 at26 at27 at28 at30 at35 at36 at37)
egen ag = rowmax(ag31 ag33)
egen a = rowmax(ac11 ac12 ac13 ac14 ac15 ac16 ac17 ar1 ar2 ar3 ar4 ar5 ar6 ar7 ar8 ar9 ar10 ar34 ar39 ar9999 at20 at21 at22 at23 at24 at25 at26 at27 at28 at30 at35 at36 at37 ag31 ag33)
 
***
 
*when both "serf" and non-"serf" (9, 11), include in each count; exclude rebel detachments (7) and soliders (10)
*include "unknown" (9999) as "serf" 
egen ac_serf = rowmax(ac11 ac12 ac13 ac14 ac15 ac16 ac17) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999
egen ac_other = rowmax(ac11 ac12 ac13 ac14 ac15 ac16 ac17) if peasanttype == 1 | peasanttype == 2 | peasanttype == 5 | peasanttype == 6 | peasanttype == 9 | peasanttype == 11 | peasanttype == 12 
egen ar_serf = rowmax(ar1 ar2 ar3 ar4 ar5 ar6 ar7 ar8 ar9 ar10 ar34 ar39 ar9999) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999
egen ar_other = rowmax(ar1 ar2 ar3 ar4 ar5 ar6 ar7 ar8 ar9 ar10 ar34 ar39 ar9999) if peasanttype == 1 | peasanttype == 2 | peasanttype == 5 | peasanttype == 6 | peasanttype == 9 | peasanttype == 11 | peasanttype == 12 
egen at_serf = rowmax(at20 at21 at22 at23 at24 at25 at26 at27 at28 at30 at35 at36 at37) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999
egen at_other = rowmax(at20 at21 at22 at23 at24 at25 at26 at27 at28 at30 at35 at36 at37) if peasanttype == 1 | peasanttype == 2 | peasanttype == 5 | peasanttype == 6 | peasanttype == 9 | peasanttype == 11 | peasanttype == 12
egen ag_serf = rowmax(ag31 ag33) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999
egen ag_other = rowmax(ag31 ag33) if peasanttype == 1 | peasanttype == 2 | peasanttype == 5 | peasanttype == 6 | peasanttype == 9 | peasanttype == 11 | peasanttype == 12
egen a_serf = rowmax(ac11 ac12 ac13 ac14 ac15 ac16 ac17 ar1 ar2 ar3 ar4 ar5 ar6 ar7 ar8 ar9 ar10 ar34 ar39 ar9999 at20 at21 at22 at23 at24 at25 at26 at27 at28 at30 at35 at36 at37 ag31 ag33) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999
egen a_other = rowmax(ac11 ac12 ac13 ac14 ac15 ac16 ac17 ar1 ar2 ar3 ar4 ar5 ar6 ar7 ar8 ar9 ar10 ar34 ar39 ar9999 at20 at21 at22 at23 at24 at25 at26 at27 at28 at30 at35 at36 at37 ag31 ag33) if peasanttype == 1 | peasanttype == 2 | peasanttype == 5 | peasanttype == 6 | peasanttype == 9 | peasanttype == 11 | peasanttype == 12 

*do not include "unknown" (9999) as "serf" 
egen ac_serf_no9999 = rowmax(ac11 ac12 ac13 ac14 ac15 ac16 ac17) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13
egen ar_serf_no9999 = rowmax(ar1 ar2 ar3 ar4 ar5 ar6 ar7 ar8 ar9 ar10 ar34 ar39 ar9999) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13
egen at_serf_no9999 = rowmax(at20 at21 at22 at23 at24 at25 at26 at27 at28 at30 at35 at36 at37) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13
egen ag_serf_no9999 = rowmax(ag31 ag33) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13

*only events in which military response
gen ac_serf_mil = ac_serf if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen ac_other_mil = ac_other if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen ar_serf_mil = ar_serf if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen ar_other_mil = ar_other if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen at_serf_mil = at_serf if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen at_other_mil = at_other if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen ag_serf_mil = ag_serf if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen ag_other_mil = ag_other if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen a_serf_mil = a_serf if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen a_other_mil = a_other if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4

*only events in tsgaor
replace tsgaor = 0 if tsgaor == .
gen ac_serf_tsgaor = ac_serf*tsgaor
gen ac_other_tsgaor = ac_other*tsgaor
gen ar_serf_tsgaor = ar_serf*tsgaor
gen ar_other_tsgaor = ar_other*tsgaor
gen at_serf_tsgaor = at_serf*tsgaor
gen at_other_tsgaor = at_other*tsgaor
gen ag_serf_tsgaor = ag_serf*tsgaor
gen ag_other_tsgaor = ag_other*tsgaor
gen a_serf_tsgaor = a_serf*tsgaor
gen a_other_tsgaor = a_other*tsgaor

*only "large" events
gen large = 0
replace large = 1 if (numvillage > 1 & numvillage < 9999) | (numuyezd > 1 & numuyezd < 9999)
gen ac_serf_large = ac_serf*large
gen ac_other_large = ac_other*large
gen ar_serf_large = ar_serf*large
gen ar_other_large = ar_other*large
gen at_serf_large = at_serf*large
gen at_other_large = at_other*large
gen ag_serf_large = ag_serf*large
gen ag_other_large = ag_other*large
gen a_serf_large = a_serf*large
gen a_other_large = a_other*large

*classify "unspecified unrest" (30) as refusal
egen ar_serf_volnenie = rowmax(ar1 ar2 ar3 ar4 ar5 ar6 ar7 ar8 ar9 ar10 ar34 ar39 ar9999 at30) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999
egen ar_other_volnenie = rowmax(ar1 ar2 ar3 ar4 ar5 ar6 ar7 ar8 ar9 ar10 ar34 ar39 ar9999 at30) if peasanttype == 1 | peasanttype == 2 | peasanttype == 5 | peasanttype == 6 | peasanttype == 9 | peasanttype == 11 | peasanttype == 12
egen at_serf_volnenie = rowmax(at20 at21 at22 at23 at24 at25 at26 at27 at28 at35 at36 at37) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999
egen at_other_volnenie = rowmax(at20 at21 at22 at23 at24 at25 at26 at27 at28 at35 at36 at37) if peasanttype == 1 | peasanttype == 2 | peasanttype == 5 | peasanttype == 6 | peasanttype == 9 | peasanttype == 11 | peasanttype == 12

gen cr1=1 if peasantcause1==1
gen cr2=1 if peasantcause1==2
gen cr3=1 if peasantcause1==3
gen cr4=1 if peasantcause1==4
gen cr5=1 if peasantcause1==5
gen cr6=1 if peasantcause1==6
gen cr7=1 if peasantcause1==7
gen cr8=1 if peasantcause1==8
gen cr9=1 if peasantcause1==9
gen cr23=1 if peasantcause1==23
gen cs10=1 if peasantcause1==10
gen cs11=1 if peasantcause1==11
gen cs12=1 if peasantcause1==12
gen cl13=1 if peasantcause1==13
gen cl14=1 if peasantcause1==14
gen cl15=1 if peasantcause1==15
gen cl28=1 if peasantcause1==28
gen cr16=1 if peasantcause1==16
gen cr17=1 if peasantcause1==17
gen cr18=1 if peasantcause1==18
gen cr22=1 if peasantcause1==22
gen cr24=1 if peasantcause1==24
gen ce19=1 if peasantcause1==19
gen ce20=1 if peasantcause1==20
gen ce21=1 if peasantcause1==21
gen ce26=1 if peasantcause1==26
gen co27=1 if peasantcause1==27

replace cr1=1 if peasantcause2==1
replace cr2=1 if peasantcause2==2
replace cr3=1 if peasantcause2==3
replace cr4=1 if peasantcause2==4
replace cr5=1 if peasantcause2==5
replace cr6=1 if peasantcause2==6
replace cr7=1 if peasantcause2==7
replace cr8=1 if peasantcause2==8
replace cr9=1 if peasantcause2==9
replace cr23=1 if peasantcause2==23
replace cs10=1 if peasantcause2==10
replace cs11=1 if peasantcause2==11
replace cs12=1 if peasantcause2==12
replace cl13=1 if peasantcause2==13
replace cl14=1 if peasantcause2==14
replace cl15=1 if peasantcause2==15
replace cl28=1 if peasantcause2==28
replace cr16=1 if peasantcause2==16
replace cr17=1 if peasantcause2==17
replace cr18=1 if peasantcause2==18
replace cr22=1 if peasantcause2==22
replace cr24=1 if peasantcause2==24
replace ce19=1 if peasantcause2==19
replace ce20=1 if peasantcause2==20
replace ce21=1 if peasantcause2==21
replace ce26=1 if peasantcause2==26
replace co27=1 if peasantcause2==27

replace cr1=1 if peasantcause3==1
replace cr2=1 if peasantcause3==2
replace cr3=1 if peasantcause3==3
replace cr4=1 if peasantcause3==4
replace cr5=1 if peasantcause3==5
replace cr6=1 if peasantcause3==6
replace cr7=1 if peasantcause3==7
replace cr8=1 if peasantcause3==8
replace cr9=1 if peasantcause3==9
replace cr23=1 if peasantcause3==23
replace cs10=1 if peasantcause3==10
replace cs11=1 if peasantcause3==11
replace cs12=1 if peasantcause3==12
replace cl13=1 if peasantcause3==13
replace cl14=1 if peasantcause3==14
replace cl15=1 if peasantcause3==15
replace cl28=1 if peasantcause3==28
replace cr16=1 if peasantcause3==16
replace cr17=1 if peasantcause3==17
replace cr18=1 if peasantcause3==18
replace cr22=1 if peasantcause3==22
replace cr24=1 if peasantcause3==24
replace ce19=1 if peasantcause3==19
replace ce20=1 if peasantcause3==20
replace ce21=1 if peasantcause3==21
replace ce26=1 if peasantcause3==26
replace co27=1 if peasantcause3==27

replace cr1=1 if peasantcause4==1
replace cr2=1 if peasantcause4==2
replace cr3=1 if peasantcause4==3
replace cr4=1 if peasantcause4==4
replace cr5=1 if peasantcause4==5
replace cr6=1 if peasantcause4==6
replace cr7=1 if peasantcause4==7
replace cr8=1 if peasantcause4==8
replace cr9=1 if peasantcause4==9
replace cr23=1 if peasantcause4==23
replace cs10=1 if peasantcause4==10
replace cs11=1 if peasantcause4==11
replace cs12=1 if peasantcause4==12
replace cl13=1 if peasantcause4==13
replace cl14=1 if peasantcause4==14
replace cl15=1 if peasantcause4==15
replace cl28=1 if peasantcause4==28
replace cr16=1 if peasantcause4==16
replace cr17=1 if peasantcause4==17
replace cr18=1 if peasantcause4==18
replace cr22=1 if peasantcause4==22
replace cr24=1 if peasantcause4==24
replace ce19=1 if peasantcause4==19
replace ce20=1 if peasantcause4==20
replace ce21=1 if peasantcause4==21
replace ce26=1 if peasantcause4==26
replace co27=1 if peasantcause4==27

replace cr1=1 if peasantcause5==1
replace cr2=1 if peasantcause5==2
replace cr3=1 if peasantcause5==3
replace cr4=1 if peasantcause5==4
replace cr5=1 if peasantcause5==5
replace cr6=1 if peasantcause5==6
replace cr7=1 if peasantcause5==7
replace cr8=1 if peasantcause5==8
replace cr9=1 if peasantcause5==9
replace cr23=1 if peasantcause5==23
replace cs10=1 if peasantcause5==10
replace cs11=1 if peasantcause5==11
replace cs12=1 if peasantcause5==12
replace cl13=1 if peasantcause5==13
replace cl14=1 if peasantcause5==14
replace cl15=1 if peasantcause5==15
replace cl28=1 if peasantcause5==28
replace cr16=1 if peasantcause5==16
replace cr17=1 if peasantcause5==17
replace cr18=1 if peasantcause5==18
replace cr22=1 if peasantcause5==22
replace cr24=1 if peasantcause5==24
replace ce19=1 if peasantcause5==19
replace ce20=1 if peasantcause5==20
replace ce21=1 if peasantcause5==21
replace ce26=1 if peasantcause5==26
replace co27=1 if peasantcause5==27

egen cr = rowmax(cr1 cr2 cr3 cr4 cr5 cr6 cr7 cr8 cr9 cr23 cr16 cr17 cr18 cr22 cr24)
egen cs = rowmax(cs10 cs11 cs12)
egen cl = rowmax(cl13 cl14 cl15 cl28)
egen ce = rowmax(ce19 ce20 ce21 ce26)
egen co = rowmax(co27)

*when both "serf" and non-"serf" (9, 11), include in each count; exclude rebel detachments (7) and soliders (10)
*include "unknown" (9999) as "serf" 
egen cr_serf = rowmax(cr1 cr2 cr3 cr4 cr5 cr6 cr7 cr8 cr9 cr23 cr16 cr17 cr18 cr22 cr24) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999
egen cr_other = rowmax(cr1 cr2 cr3 cr4 cr5 cr6 cr7 cr8 cr9 cr23 cr16 cr17 cr18 cr22 cr24) if peasanttype == 1 | peasanttype == 2 | peasanttype == 5 | peasanttype == 6 | peasanttype == 9 | peasanttype == 11 | peasanttype == 12 
egen cs_serf = rowmax(cs10 cs11 cs12) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999
egen cs_other = rowmax(cs10 cs11 cs12) if peasanttype == 1 | peasanttype == 2 | peasanttype == 5 | peasanttype == 6 | peasanttype == 9 | peasanttype == 11 | peasanttype == 12 
egen cl_serf = rowmax(cl13 cl14 cl15 cl28) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999
egen cl_other = rowmax(cl13 cl14 cl15 cl28) if peasanttype == 1 | peasanttype == 2 | peasanttype == 5 | peasanttype == 6 | peasanttype == 9 | peasanttype == 11 | peasanttype == 12 
egen ce_serf = rowmax(ce19 ce20 ce21 ce26) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999
egen ce_other = rowmax(ce19 ce20 ce21 ce26) if  peasanttype == 1 | peasanttype == 2 | peasanttype == 5 | peasanttype == 6 | peasanttype == 9 | peasanttype == 11 | peasanttype == 12
egen co_serf = rowmax(co27) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13 | peasanttype == 9999
egen co_other = rowmax(co27) if  peasanttype == 1 | peasanttype == 2 | peasanttype == 5 | peasanttype == 6 | peasanttype == 9 | peasanttype == 11 | peasanttype == 12

*do not include "unknown" (9999) as "serf" 
egen cr_serf_no9999 = rowmax(cr1 cr2 cr3 cr4 cr5 cr6 cr7 cr8 cr9 cr23 cr16 cr17 cr18 cr22 cr24) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13
egen cs_serf_no9999 = rowmax(cs10 cs11 cs12) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13
egen cl_serf_no9999 = rowmax(cl13 cl14 cl15 cl28) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13
egen ce_serf_no9999 = rowmax(ce19 ce20 ce21 ce26) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13
egen co_serf_no9999 = rowmax(co27) if peasanttype == 3 | peasanttype == 4 | peasanttype == 8 | peasanttype == 9 | peasanttype == 11 | peasanttype == 13

*only events in which military response
gen cr_serf_mil = cr_serf if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen cr_other_mil = cr_other if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen cs_serf_mil = cs_serf if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen cs_other_mil = cs_other if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4gen cl_serf_mil = cl_serf if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen cl_other_mil = cl_other if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4gen ce_serf_mil = ce_serf if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen ce_other_mil = ce_other if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4gen co_serf_mil = co_serf if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4
gen co_other_mil = co_other if govtresponse1 == 1 | govtresponse1 == 4 | govtresponse2 == 1 | govtresponse2 == 4

*only events in tsgaor
gen cr_serf_tsgaor = cr_serf*tsgaor
gen cr_other_tsgaor = cr_other*tsgaor
gen cs_serf_tsgaor = cs_serf*tsgaor
gen cs_other_tsgaor = cs_other*tsgaor
gen cl_serf_tsgaor = cl_serf*tsgaor
gen cl_other_tsgaor = cl_other*tsgaor
gen ce_serf_tsgaor = ce_serf*tsgaor
gen ce_other_tsgaor = ce_other*tsgaor
gen co_serf_tsgaor = co_serf*tsgaor
gen co_other_tsgaor = co_other*tsgaor

*only "large" events
gen cr_serf_large = cr_serf*large
gen cr_other_large = cr_other*large
gen cs_serf_large = cs_serf*large
gen cs_other_large = cs_other*large
gen cl_serf_large = cl_serf*large
gen cl_other_large = cl_other*large
gen ce_serf_large = ce_serf*large
gen ce_other_large = ce_other*large
gen co_serf_large = co_serf*large
gen co_other_large = co_other*large

save event_data.dta, replace

*Which types of events provide data on proximate cause?

gen period = 0
replace period = 1 if startyear >= 1861

gen temp = 1
replace temp = 0 if peasantcause1 == 9999
tab large temp, row
tab a_serf temp, row missing
tab ar temp, row
tab at temp, row
tab period temp, row

drop period temp


**STACK THE OBSERVATIONS THAT OCCURRED IN MULTIPLE GUBERNIYAS

keep masterid id volume pagenum startmonth startyear endmonth endyear eventtimeframe guberniya1 guberniya2 guberniya3 numuyezd numvillage numestate peasanttype ar1-co_other_large uyezdnum villagenum pubnum notable pubcause estatenum
order guberniya1 guberniya2 guberniya3 masterid id, first
rename guberniya1 guberniya
save temp.dta, replace

drop if guberniya2==.
drop guberniya guberniya3
rename guberniya2 guberniya
order guberniya, first
save gub2.dta, replace

use temp.dta, clear
drop if guberniya3==.
drop guberniya guberniya2
rename guberniya3 guberniya
order guberniya, first
save gub3.dta, replace

use temp.dta, clear
order guberniya2 guberniya3, last
order guberniya, first
append using gub2.dta, generate(append)
*browse guberniya guberniya2 guberniya3 append
drop append

append using gub3.dta, generate(append)
*browse guberniya guberniya2 guberniya3 append 
drop append guberniya2 guberniya3
*drop Suwalki -- in Poland, event just spilled over from neighboring regions
drop if gub == 35
*drop missing region
drop if gub==9999
*merge Ufa into Orenburg
replace gub = 22 if gub==58
save event_data.dta, replace


**COLLAPSE DATA INTO REGION-YEAR.

collapse (sum) ar1-co_other_large, by(gub startyear)
sort gub startyear
rename guberniya gub

lab var ar1 "R Refusal to accept terms of liberation (general)" 
lab var ar2 "R Refusal to obey (general)" 
lab var ar3 "R Refusal to provide obligations" 
lab var ar4 "R Refusal to pay for land" 
lab var ar5 "R Refusal to pay obrok" 
lab var ar6 "R Refusal to pay tax" 
lab var ar7 "R Refusal to provide barshchina" 
lab var ar8 "R Refusal to purchase (other)" 
lab var ar9 "R Refusal to purchase lumber" 
lab var ar10 "R Refusal to purchase/drink alcohol" 
lab var ac11 "C Complaint to governor" 
lab var ac12 "C Complaint to grand duke" 
lab var ac13 "C Complaint to justice minister" 
lab var ac14 "C Complaint to minister of internal affairs" 
lab var ac15 "C Complaint to police" 
lab var ac16 "C Complaint to tsar" 
lab var ac17 "C Complaint to other" 
lab var ac18 "C Complaint to unknown" 
lab var at20 "TV Prisoners freed" 
lab var at21 "TV Seizure of landowner's property (forest/lumber)" 
lab var at22 "TV Seizure of public property" 
lab var at23 "TV Seizure of landowner's property (general)" 
lab var at24 "TV Violence against landlord/family" 
lab var at25 "TV Violence against landlord/family (murder)" 
lab var at26 "TV Violence against management" 
lab var at27 "TV Violence against management (murder)" 
lab var at28 "TV (Attempted) destruction of landowner's property" 
lab var at30 "TV Unspecified unrest" 
lab var ag31 "GOV Change in estate administration" 
lab var ag33 "GOV Change in municipal administration" 
lab var ar34 "R Unauthorized leave" 
lab var at35 "TV (Attempted) destruction of public property" 
lab var at36 "TV Violence against public authority" 
lab var at37 "TV (Attempted) destruction of pub (lavka)" 
lab var ar39 "R Refusal to elect representatives" 
lab var ar9999 "R Other refusal"

lab var ar "Refusal"
lab var ac "Complaint"
lab var at "Theft/Violence"
lab var ag "Governance"

lab var ar_serf "Refusal serf"
lab var ar_other "Refusal other"
lab var ac_serf "Complaint serf"
lab var ac_other "Complaint other"
lab var at_serf "Theft/Violence serf"
lab var at_other "Theft/Violence other"
lab var ag_serf "Governance serf"
lab var ag_other "Governance other"

lab var cr1 "LPR Barshchina"
lab var cr2 "LPR Brutal treatment"
lab var cr3 "LPR Provisioning/compensation (from landlord to peasants)"
lab var cr4 "LPR Debts"
lab var cr5 "LPR Dissatisfaction with land allotment"
lab var cr6 "LPR Military enlistment"
lab var cr7 "LPR Obrok"
lab var cr8 "LPR Taxes"
lab var cr9 "LPR Violation of inventory/regulatory charter"
lab var cs10 "S Desire to be state peasant"
lab var cs11 "S Desire to be released from serf status"
lab var cs12 "S Serf status"
lab var cl13 "L Anticipation of (second) liberation"
lab var cl14 "L Rumors of liberation"
lab var cl15 "L Terms of liberation"
lab var cr16 "LPR Eviction"
lab var cr17 "LPR Seizure of crops/livestock"
lab var cr18 "LPR Seizure of land"
lab var ce19 "ES Dissatisfaction with management"
lab var ce20 "ES Dissatisfaction with municipal government"
lab var ce21 "ES Transfer of estate ownership"
lab var cr22 "LPR Resettlement"
lab var cr23 "LPR Sale of peasants"
lab var cr24 "LPR Imprisonment"
lab var ce26 "ES Dissatisfaction with alcohol prices"
lab var co27 "Other"
lab var cl28 "L Printed materials dealing with liberation"

lab var cr "Landlord/Peasant Relations"
lab var cs "Serf Status"
lab var cl "Liberation"
lab var ce "Estate"
lab var co "Other"

lab var cr_serf "Landlord/Peasant Relations serf"
lab var cr_other "Landlord/Peasant Relations other"
lab var cs_serf "Serf Status serf"
lab var cs_other "Serf Status other"
lab var cl_serf "Liberation serf"
lab var cl_other "Liberation other"
lab var ce_serf "Estate serf"
lab var ce_other "Estate other"
lab var co_serf "Other serf"
lab var co_other "Other other"

save event_data_gubyr.dta, replace


**IMPORT GUB-YEAR FILE & MERGE EVENT DATA.

use gubyr, clear
sort gub startyear
save gub_startyear.dta, replace
merge 1:m gub startyear using event_data_gubyr.dta
drop _merge

mvencode a, mv(.=0) override
mvencode ac*, mv(.=0) override
mvencode ar*, mv(.=0) override
mvencode at*, mv(.=0) override
mvencode ag*, mv(.=0) override
mvencode a_*, mv(.=0) override
mvencode cr*, mv(.=0) override
mvencode cs*, mv(.=0) override
mvencode cl*, mv(.=0) override
mvencode ce*, mv(.=0) override
mvencode co*, mv(.=0) override

save event_data_gubyr.dta, replace


**MERGE PEASANT POPULATION DATA (FROM BUSHEN)

use Bushen, clear
keep gub name state* udel* field* house*
replace state_m = 0 if state_m == .
replace state_f = 0 if state_f == .
replace udel_m = 0 if udel_m == .
replace udel_f = 0 if udel_f == .
replace fieldserfs_m = 0 if fieldserfs_m == .
replace fieldserfs_f = 0 if fieldserfs_f == .
replace houseserfs_m = 0 if houseserfs_m == .
replace houseserfs_f = 0 if houseserfs_f == .
save peasantpopn, replace

use event_data_gubyr.dta, clear
merge m:1 gub using peasantpopn
drop _merge
save event_data_gubyr.dta, replace


**MERGE CENSUS DATA (FROM TROINITSKII)

use peasantcensus, clear
*drop Ufa -- no data, already rolled into Orenburg
drop if gub == 58
save peasantcensus.dta, replace

use event_data_gubyr.dta, clear
merge m:1 gub using peasantcensus.dta
*household and non-household serfs lumped together under non-household serfs for Kutaisi and Tiflis; only interested in total, so recode household == 0
replace comhm = 0 if guberniya == "Kutaisi"
replace comhf = 0 if guberniya == "Kutaisi"
replace comhm = 0 if guberniya == "Tiflis"
replace comhf = 0 if guberniya == "Tiflis"
drop _merge
save event_data_gubyr.dta, replace


**MERGE SOIL DATA (COMPUTED FROM FAO SHAPEFILE)

use soils, clear
keep russia1d_i name su_sym90 areasqkm soilarea prcntsoilt
rename soilarea soilareakm
rename prcntsoilt prcntsoilt_old
rename name name_gis
sort russia1d_i
save soils.dta, replace

use gub_id, clear
merge 1:m russia1d_i using soils.dta
drop if _merge == 2 & name_gis ~= "Ufa"
drop _merge
drop name

*Merge Ufa and Orenburg.
replace gub=22 if name_gis == "Ufa"
replace  russia1d_i=62 if name_gis == "Ufa"
replace name_gis = "Orenburg" if name_gis == "Ufa"
*Area of Ufa = 122024; Area of Orenburg = 176746; Total = 298770.
replace  areasqkm = 298770 if russia1d_i==62

gen prcntsoilt =  (soilareakm/areasqkm)*100
collapse (max) russia1d_i gub areasqkm (sum) prcntsoilt soilareakm, by(su_sym90 name)
drop areasqkm soilareakm
*drop if su_sym90==""
replace su_sym90 = "OTHER" if su_sym90 == ""
save gub_soils.dta, replace

drop name_gis russia1d_i
reshape wide prcntsoilt, i(gub) j(su_sym90, string)
sort gub
save soilspct.dta, replace

use event_data_gubyr.dta, clear
merge m:1 gub using soilspct.dta
drop _merge

mvencode prcntsoil*, mv(.=0) override
save event_data_gubyr.dta, replace


**MERGE GRAIN PRICE DATA
*within sample, have unbalanced panel for 45 regions: missing Saratov

use Rye, clear
*drop Ufa
drop if gub == 58
reshape long rye, i(gub) j(startyear)
drop if startyear == 1850
drop guberniya
sort gub startyear
save rye.dta, replace

use event_data_gubyr.dta, clear
merge 1:1 gub startyear using rye.dta
drop _merge

save event_data_gubyr.dta, replace


**MERGE 1893 SETTLEMENT DATA (Stat yearbook, TsSK)
*beyond missing data for a few provinces (dropped below), have missing data for some districts that were renamed (thus not missing) and for Pechorskii district in Arkhangel'sk
use settlements, clear
rename communesettlements_1893 settlements
*impute number of settlements for Pechorskii based on relationship elsewhere in Arkhangel'sk
reg settlements communes_1893 communehhs_1893 if provincenumber == 1
replace settlements = -3.46282*25 + .0890578*3694 -24.12485 if masterid == 6
replace settlements = round(settlements)
keep province settlements
replace province = "Orenburg" if province == "Ufa"
collapse (sum) settlements, by(province)
drop if settlements == 0
sort province

rename province name
replace name = "Arkhangelsk" if name == "Arkhangel'sk"
replace name = "Yekaterinoslav" if name == "Ekaterinoslav'"
replace name = "Hrodna" if name == "Grodnno"
replace name = "Yaroslavl" if name == "Iaroslav'"
replace name = "Kaluga" if name == "Kaluzha"
replace name = "Kharkov" if name == "Khar'kov"
replace name = "Nizhni Novgorod" if name == "Nizhegorod"
replace name = "Orel" if name == "Orlov"
replace name = "Penza" if name == "Penzen"
replace name = "Podolia" if name == "Podol'sk"
replace name = "Ryazan" if name == "Riazan"
replace name = "Petersburg" if name == "Sankt-Peterburg"
replace name = "Taurida" if name == "Tavrich"
replace name = "Tula" if name == "Tul'a"
replace name = "Vyatka" if name == "Viatka"
replace name = "Vilna" if name == "Vilno"
replace name = "Vologda" if name == "Vologoda"
replace name = "Volhynia" if name == "Volyna"
sort name
save temp, replace

use event_data_gubyr.dta, clear
merge m:1 name using temp
drop _m
save event_data_gubyr.dta, replace


**MERGE DATA ON OBROK/BARSHCHINA SHARE (Skrebnitiskii, 3rd volume)
*Note decimal places in Orlov data because imputed from province-level data
use obrok_barshchina, clear
drop if masterid == .
rename householdserfs_1859 household
rename barshchinaserfs_1859 barshchina
rename obrokserfs_1859 obrok
keep province household barshchina obrok
replace province = "Orenburg" if province == "Ufa"
collapse (sum) household barshchina obrok, by(province)
drop if household == 0
sort province

rename province name
replace name = "Arkhangelsk" if name == "Arkhangel'sk"
replace name = "Yekaterinoslav" if name == "Ekaterinoslav'"
replace name = "Hrodna" if name == "Grodnno"
replace name = "Yaroslavl" if name == "Iaroslav'"
replace name = "Kaluga" if name == "Kaluzha"
replace name = "Kharkov" if name == "Khar'kov"
replace name = "Nizhni Novgorod" if name == "Nizhegorod"
replace name = "Orel" if name == "Orlov"
replace name = "Penza" if name == "Penzen"
replace name = "Podolia" if name == "Podol'sk"
replace name = "Ryazan" if name == "Riazan"
replace name = "Petersburg" if name == "Sankt-Peterburg"
replace name = "Taurida" if name == "Tavrich"
replace name = "Tula" if name == "Tul'a"
replace name = "Vyatka" if name == "Viatka"
replace name = "Vilna" if name == "Vilno"
replace name = "Vologda" if name == "Vologoda"
replace name = "Volhynia" if name == "Volyna"
replace name = "Don Voisko" if name == "Zemlia voiska donskogo"
sort name
save temp, replace

use event_data_gubyr.dta, clear
merge m:1 name using temp
drop _m
save event_data_gubyr.dta, replace


**HOUSEKEEPING

gen gisid=.
replace gisid=56 if gub==1
replace gisid=68 if gub==2
replace gisid=28 if gub==3
replace gisid=41 if gub==4
replace gisid=21 if gub==50
replace gisid=75 if gub==57
replace gisid=67 if gub==56
replace gisid=78 if gub==54
replace gisid=19 if gub==6
replace gisid=24 if gub==7
replace gisid=39 if gub==8
replace gisid=60 if gub==9
replace gisid=44 if gub==10
replace gisid=29 if gub==11
replace gisid=30 if gub==12
replace gisid=54 if gub==13
replace gisid=22 if gub==14
replace gisid=42 if gub==15
replace gisid=73 if gub==52
replace gisid=20 if gub==55
replace gisid=25 if gub==16
replace gisid=31 if gub==17
replace gisid=51 if gub==49
replace gisid=59 if gub==18
replace gisid=36 if gub==19
replace gisid=35 if gub==20
replace gisid=40 if gub==21
replace gisid=62 if gub==22
replace gisid=65 if gub==23
replace gisid=58 if gub==24
replace gisid=34 if gub==25
replace gisid=27 if gub==26
replace gisid=43 if gub==27
replace gisid=33 if gub==28
replace gisid=50 if gub==29
replace gisid=63 if gub==30
replace gisid=66 if gub==32
replace gisid=64 if gub==33
replace gisid=38 if gub==34
replace gisid=70 if gub==53
replace gisid=48 if gub==36
replace gisid=46 if gub==37
replace gisid=74 if gub==38
replace gisid=49 if gub==39
replace gisid=37 if gub==40
*replace gisid=61 if gub==58
replace gisid=23 if gub==41
replace gisid=32 if gub==42
replace gisid=52 if gub==43
replace gisid=26 if gub==44
replace gisid=55 if gub==51
replace gisid=47 if gub==45
replace gisid=57 if gub==46
replace gisid=53 if gub==47
replace gisid=45 if gub==48

save serf.dta, replace


**VARIABLE CONSTRUCTION

*population variables
gen totserf = fieldserfs_m + fieldserfs_f + houseserfs_m + houseserfs_f
gen totother = state_male + state_female + udel_m + udel_f
gen lntotserf = ln(totserf)
gen lntotother = ln(totother)

*Average settlement size
gen settlementsize = (totserf + totother)/(settlements*1000)

*Obrok and barshchina shares
gen obrokshare = obrok/(obrok + barshchina + household)
gen barshchinashare = barshchina/(obrok + barshchina + household)

*Proportion household serfs
gen hh_total = (houseserfs_m + houseserfs_f) / totserf

*soil type (note: percentages do not total to 100 due to non-soil units [urban, inland water, rock debris, etc.])
gen goodsoil = (prcntsoiltCH + prcntsoiltGR + prcntsoiltHS + prcntsoiltKS + prcntsoiltPH + prcntsoiltVR)/100
gen blacksoil = prcntsoiltCH/100

*treatment variables
gen eman = 0
replace eman = 1 if start >= 1861
gen trans = 0
replace trans = 1 if start == 1861 | start == 1862
gen posttrans = 0
replace posttrans = 1 if start >= 1863

*periods
gen period=0
replace period = 1 if start==1861 | start == 1862
replace period = 2 if start >= 1863

label define period 0 "Pre" 1 "Transition" 2 "Post"
label values period period

*regions involved in Polish rebellion
gen polish = 0
replace polish = 1 if name == "Vilna" | name == "Kovno" | name == "Hrodna" | name =="Minsk" | name == "Mogilev" | name == "Vitebsk" | name == "Kiev" | name == "Podolia" | name == "Volhynia"

*other non-Russian
gen nonrussian = 0
replace nonrussian = 1 if name == "Chernigov" | name == "Kharkov" | name == "Kherson" | name == "Poltava" | name == "Taurida" | name == "Yekaterinoslav" 

*Russian
gen russian = 1
replace russian = 0 if polish == 1 | nonrussian == 1

*Inventory reform
gen inventory = 0
replace inventory = 1 if gub == 12 | gub == 26 | gub == 44



