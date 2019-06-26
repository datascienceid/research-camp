clear

set matsize 10000

version 15

set seed 1

* Set number of iterations for permutation text: in the paper we use 10,000 iterations
local n_perm = 10000

cd "~/Data and Code"

use "Dta_Files/data_replication.dta"

**************************************
*** Main Results: Moral Incentives ***
**************************************

reg delinquent moral_rel if ((moral_rel == 1 | ctrl == 1) & main_exp == 1), r
local b_moral_rel = _b[moral_rel]
preserve 
keep if ((moral_rel == 1 | ctrl == 1) & main_exp == 1)
count if moral_rel == 1
local n_moral_rel = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace moral_rel = _n <= `n_moral_rel'
reg delinquent moral_rel
mat R[`row',1] = _b[moral_rel]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_moral_rel')
generate p1 = (abs(R1) > abs(`b_moral_rel'))
sum p1
local section_3_1 = `r(mean)'
clear 
restore




********************************************************
*** Indirect Financial Incentives: Credit Reputation ***
********************************************************

preserve 
keep if ((credit_rep == 1 | ctrl == 1) & main_exp == 1 & inlist(wave,1,2,3) == 1)
reg delinquent credit_rep
local b_credit_rep = _b[credit_rep]
count if credit_rep == 1
local n_credit_rep = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace credit_rep = _n <= `n_credit_rep'
reg delinquent credit_rep
mat R[`row',1] = _b[credit_rep]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_credit_rep')
generate p1 = (abs(R1) > abs(`b_credit_rep'))
sum p1
local section_3_2_2a = `r(mean)'
clear 
restore

preserve 
keep if ((moral_rel == 1 | credit_rep == 1) & main_exp == 1 & inlist(wave,1,2,3) == 1)
reg delinquent credit_rep
local b_credit_rep = _b[credit_rep]
count if credit_rep == 1
local n_credit_rep = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace credit_rep = _n <= `n_credit_rep'
reg delinquent credit_rep
mat R[`row',1] = _b[credit_rep]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_credit_rep')
generate p1 = (abs(R1) > abs(`b_credit_rep'))
sum p1
local section_3_2_2b = `r(mean)'
clear 
restore




***************************
*** Reminding Customers ***
***************************

preserve 
keep if ((moral_rel == 1 | simple_rem == 1) & main_exp == 1 & inlist(wave,1,2,3) == 1)
reg delinquent moral_rel
local b_moral_rel = _b[moral_rel]
count if moral_rel == 1
local n_moral_rel = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace moral_rel = _n <= `n_moral_rel'
reg delinquent moral_rel
mat R[`row',1] = _b[moral_rel]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_moral_rel')
generate p1 = (abs(R1) > abs(`b_moral_rel'))
sum p1
local section_3_3_1a = `r(mean)'
clear 
restore

preserve 
keep if ((ctrl == 1 | simple_rem == 1) & main_exp == 1 & inlist(wave,1,2,3) == 1)
reg delinquent simple_rem
local b_simple_rem = _b[simple_rem]
count if simple_rem == 1
local n_simple_rem = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace simple_rem = _n <= `n_simple_rem'
reg delinquent simple_rem
mat R[`row',1] = _b[simple_rem]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_simple_rem')
generate p1 = (abs(R1) > abs(`b_simple_rem'))
sum p1
local section_3_3_1b = `r(mean)'
clear 
restore




************************
*** Priming Religion ***
************************

preserve 
keep if ((moral_rel == 1 | religious_plac == 1) & main_exp == 1 & inlist(wave,1,2,3) == 1)
reg delinquent moral_rel
local b_moral_rel = _b[moral_rel]
count if moral_rel == 1
local n_moral_rel = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace moral_rel = _n <= `n_moral_rel'
reg delinquent moral_rel
mat R[`row',1] = _b[moral_rel]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_moral_rel')
generate p1 = (abs(R1) > abs(`b_moral_rel'))
sum p1
local section_3_3_2a = `r(mean)'
clear 
restore

preserve 
keep if ((ctrl == 1 | religious_plac == 1) & main_exp == 1 & inlist(wave,1,2,3) == 1)
reg delinquent religious_plac
local b_religious_plac = _b[religious_plac]
count if religious_plac == 1
local n_religious_plac = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace religious_plac = _n <= `n_religious_plac'
reg delinquent religious_plac
mat R[`row',1] = _b[religious_plac]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_religious_plac')
generate p1 = (abs(R1) > abs(`b_religious_plac'))
sum p1
local section_3_3_2b = `r(mean)'
clear 
restore



*********************************************
*** Religious Connotation of the Message? ***
*********************************************

preserve 
keep if ((moral_rel == 1 | moral_non == 1) & main_exp == 1 & inlist(wave,4,5,6) == 1)
reg delinquent moral_rel
local b_moral_rel = _b[moral_rel]
count if moral_rel == 1
local n_moral_rel = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace moral_rel = _n <= `n_moral_rel'
reg delinquent moral_rel
mat R[`row',1] = _b[moral_rel]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_moral_rel')
generate p1 = (abs(R1) > abs(`b_moral_rel'))
sum p1
local section_4_1_1a = `r(mean)'
clear 
restore

preserve 
keep if ((moral_rel == 1 | moral_imp == 1) & main_exp == 1 & inlist(wave,4,5,6) == 1)
reg delinquent moral_rel
local b_moral_rel = _b[moral_rel]
count if moral_rel == 1
local n_moral_rel = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace moral_rel = _n <= `n_moral_rel'
reg delinquent moral_rel
mat R[`row',1] = _b[moral_rel]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_moral_rel')
generate p1 = (abs(R1) > abs(`b_moral_rel'))
sum p1
local section_4_1_1b = `r(mean)'
clear 
restore

preserve 
keep if ((ctrl == 1 | moral_non == 1) & main_exp == 1 & inlist(wave,4,5,6) == 1)
reg delinquent moral_non
local b_moral_non = _b[moral_non]
count if moral_non == 1
local n_moral_non = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace moral_non = _n <= `n_moral_non'
reg delinquent moral_non
mat R[`row',1] = _b[moral_non]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_moral_non')
generate p1 = (abs(R1) > abs(`b_moral_non'))
sum p1
local section_4_1_1c = `r(mean)'
clear
restore

preserve 
keep if ((ctrl == 1 | moral_imp == 1) & main_exp == 1 & inlist(wave,4,5,6) == 1)
reg delinquent moral_imp
local b_moral_imp = _b[moral_imp]
count if moral_imp == 1
local n_moral_imp = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace moral_imp = _n <= `n_moral_imp'
reg delinquent moral_imp
mat R[`row',1] = _b[moral_imp]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_moral_imp')
generate p1 = (abs(R1) > abs(`b_moral_imp'))
sum p1
local section_4_1_1d = `r(mean)'
clear
restore




*********************************************************************
*** Provision of New Information? The Impact of Repeated Messages ***
*********************************************************************

preserve 
keep if ((moral_repeated == 1 | ctrl == 1) & followup_exp == 1 & inlist(wave,5,6) == 1)
reg delinquent moral_repeated
local b_moral_repeated = _b[moral_repeated]
count if moral_repeated == 1
local n_moral_repeated = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace moral_repeated = _n <= `n_moral_repeated'
reg delinquent moral_repeated
mat R[`row',1] = _b[moral_repeated]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_moral_repeated')
generate p1 = (abs(R1) > abs(`b_moral_repeated'))
sum p1
local section_4_1_2a = `r(mean)'
clear 
restore




*************************
*** Impact on Default ***
*************************

*** Re-weighting for default analysis (footnote 12)
* Exclude from sample for default analysis customers who were in the control group in a month and were then randomized in a treatment group before the long term outcome was measured
generate default_sample = 0 if (main_exp == 1 & inlist(wave,1,2,3) == 1)
replace default_sample = 1 if main_exp == 1 & wave == 1 & (treatment_wave2 == "" | treatment_wave2 == "ctrl") & (treatment_wave3 == "" | treatment_wave3 == "ctrl") & (treatment_wave4 == "" | treatment_wave4 == "ctrl")
replace default_sample = 1 if main_exp == 1 & wave == 2 & (treatment_wave3 == "" | treatment_wave3 == "ctrl") & (treatment_wave4 == "" | treatment_wave4 == "ctrl")
replace default_sample = 1 if main_exp == 1 & wave == 3 & (treatment_wave4 == "" | treatment_wave4 == "ctrl")
* Identify customers who were in the control group in a month and were then randomized in the control group
generate ctrl_extra_weight = .
replace ctrl_extra_weight = 1 if treatment == "ctrl" & default_sample == 1 & wave == 1 & ((treatment_wave2 == "ctrl") | (treatment_wave3 == "ctrl") | (treatment_wave4 == "ctrl"))
replace ctrl_extra_weight = 1 if treatment == "ctrl" & default_sample == 1 & wave == 2 & ((treatment_wave3 == "ctrl") | (treatment_wave4 == "ctrl"))
replace ctrl_extra_weight = 1 if treatment == "ctrl" & default_sample == 1 & wave == 3 & (treatment_wave4 == "ctrl")
* Calculate weight for re-weighting
generate weight = 1 if default_sample != .
replace weight = . if (treatment == "ctrl" & default_sample == 0)
count if treatment == "ctrl" & default_sample != .
local n_ctrl `r(N)'
display `n_ctrl'
foreach m in 1 2 3 {
count if treatment == "ctrl" & default_sample == 0 & wave == `m'
local n_ex `r(N)'
display `n_ex'
count if treatment == "ctrl" & ctrl_extra_weight == 1 & wave == `m'
local n_in `r(N)'
display `n_in'
replace weight = (`n_in'+`n_ex')/`n_in' if (treatment == "ctrl" & ctrl_extra_weight == 1 & wave == `m')
}

*** Estimate probability of default and split sample by credit risk
* Estimate model of default using customers in control group
local controls "age female muslim income creditlimit i.province sample_before poor_credit_history"
regress default i.wave `controls' [pw=weight] if (default_sample == 1 & ctrl == 1)
* Split the sample on credit risk
predict prediction
_pctile prediction [pw=weight] if default_sample == 1, p(90)
local p_90 = r(r1)
generate high_credit_risk = (prediction > `p_90') if default_sample == 1

regress default moral_rel credit_rep simple_rem religious_plac [pw=weight] if default_sample == 1

preserve 
keep if  ((ctrl == 1 | moral_rel == 1) & default_sample == 1 & high_credit_risk == 1)
regress default moral_rel [pw=weight]
local b_moral_rel = _b[moral_rel]
count if moral_rel == 1
local n_moral_rel = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace moral_rel = _n <= `n_moral_rel'
reg default moral_rel [pw=weight]
mat R[`row',1] = _b[moral_rel]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_moral_rel')
generate p1 = (abs(R1) > abs(`b_moral_rel'))
sum p1
local section_4_2_1b = `r(mean)'
clear 
restore

preserve 
keep if  ((ctrl == 1 | credit_rep == 1) & default_sample == 1 & high_credit_risk == 1)
regress default credit_rep [pw=weight]
local b_credit_rep = _b[credit_rep]
count if credit_rep == 1
local n_credit_rep = `r(N)'
mat R=J(`n_perm',1,.)
forvalues row=1(1)`n_perm' {
gen r=runiform()
sort r
replace credit_rep = _n <= `n_credit_rep'
reg default credit_rep [pw=weight]
mat R[`row',1] = _b[credit_rep]
drop r
display `row'
}
clear
svmat R
sum R1, detail
count if abs(R1) >= abs(`b_credit_rep')
generate p1 = (abs(R1) > abs(`b_credit_rep'))
sum p1
local section_4_2_1a = `r(mean)'
clear 
restore



***********************************
*** Display All Fisher p-values ***
***********************************

*** Main Results: Moral Incentives
display `section_3_1'
*** Indirect Financial Incentives: Credit Reputation ***
display `section_3_2_2a'
display `section_3_2_2b'
*** Reminding Customers ***
display `section_3_3_1a'
display `section_3_3_1b'
*** Priming Religion ***
display `section_3_3_2a'
display `section_3_3_2b'
*** Religious Connotation of the Message? ***
display `section_4_1_1a'
display `section_4_1_1b'
display `section_4_1_1c'
display `section_4_1_1d'
*** Provision of New Information? The Impact of Repeated Messages ***
display `section_4_1_2a'
*** Impact on Default ***
display `section_4_2_1a'
display `section_4_2_1b'
