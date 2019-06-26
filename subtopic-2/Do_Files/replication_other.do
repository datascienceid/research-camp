clear

version 15

cd "~/Data and Code"

use "Dta_Files/data_replication.dta"

********************
*** Introduction ***
********************

* Footnote

local controls "age female muslim income creditlimit i.province sample_before poor_credit_history"

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
foreach m in 1 2 3 {
count if treatment == "ctrl" & default_sample == 0 & wave == `m'
local n_ex `r(N)'
count if treatment == "ctrl" & ctrl_extra_weight == 1 & wave == `m'
local n_in `r(N)'
replace weight = (`n_in'+`n_ex')/`n_in' if (treatment == "ctrl" & ctrl_extra_weight == 1 & wave == `m')
}

*** Estimate probability of default and split sample by credit risk
* Estimate model of default using customers in control group
regress default i.wave `controls' [pw=weight] if (default_sample == 1 & ctrl == 1)
* Split the sample on credit risk
predict prediction

* Split the sample on credit risk
_pctile prediction [pw=weight] if default_sample == 1, p(50 75 90 95)
local i = 1
foreach k in 50 75 90 95 {
local p_`k' = r(r`i')
generate high_credit_risk_`k' = (prediction > `p_`k'') if default_sample == 1
local i = `i' + 1
}

foreach k in 90 75 50 {
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & high_credit_risk_`k' == 1)
regress default moral_rel credit_rep simple_rem religious_plac [pw=weight] if (default_sample == 1 & high_credit_risk_`k' == 1), r
}

***********************************************
*** Sample Population and Random Assignment ***
***********************************************

codebook randomcardnumber

display _N

tab type_obs if wave == 2

count if main_exp == 1

codebook randomcardnumber if main_exp == 1

tab type_obs if main_exp == 1

count if followup_exp == 1

tab treatment_repeated

* Footnote

duplicates report randomcardnumber

* Footnote

duplicates report randomcardnumber if main_exp == 1

* Footnote

count if time_lag_first_moral == 2
count if time_lag_first_moral >= 8 & time_lag_first_moral <= 14

*******************************
*** Experimental Treatments ***
*******************************

count if ctrl == 1 & main_exp == 1

count if moral_rel == 1 & main_exp == 1

count if moral_imp == 1 & main_exp == 1

count if moral_non == 1 & main_exp == 1

count if cash_rebate == 1 & main_exp == 1

count if credit_rep == 1 & main_exp == 1

count if simple_rem == 1 & main_exp == 1

count if religious_plac == 1 & main_exp == 1

* Footnote
tab credit_rep_version

***********************************
*** Data and Summary Statistics ***
***********************************

centile age if main_exp == 1
centile female if main_exp == 1
generate monthly_income = income/12
centile monthly_income if main_exp == 1
centile creditlimit if main_exp == 1
centile outstanding if main_exp == 1

* Footnote
codebook randomcardnumber if savings_account == 1 & main_exp == 1 & inlist(wave,1,2,3,4) == 1

* Footnote
preserve
clear
use "Dta_Files/survey_june15treated.dta"
tab answered_survey_jun15_treated
clear
use "Dta_Files/survey_june15general.dta"
tab answered_survey_jun15_general
clear
use "Dta_Files/survey_april16.dta"
tab answered_survey_april16
clear
use "Dta_Files/survey_april17.dta"
tab answered_survey_april17
restore

***********************************************
*** Benchmarking the Moral Incentive Effect ***
***********************************************

sum cash_rebate_amount, detail
* Monthly income in Million Rp
sum monthly_income, detail

sum cash_rebate_amount if delinquent == 0, detail

*Footnote
preserve
clear
use "Dta_Files/survey_april17.dta"
tab wtp_survey_april17
sum wtp_survey_april17, detail
restore

***********************************
*** Ruling Out Other Mechanisms ***
***********************************

preserve
clear
use "Dta_Files/survey_april16.dta"
merge 1:1 randomcardnumber wave using "Dta_Files/data_replication.dta", keep(3) keepusing(treatment ctrl simple_rem moral_all)
tab bank_committed_survey_april16 if ctrl == 1
tab bank_committed_survey_april16 if simple_rem == 1
tab bank_committed_survey_april16 if moral_all == 1
regress bank_committed_survey_april16 ctrl simple_rem moral_all, noconst r
test _b[ctrl] == _b[simple_rem] == _b[moral_all]
test _b[ctrl] == _b[moral_all]
restore

*********************************************
*** Disutility from Receiving the Message ***
*********************************************

preserve
clear
use "Dta_Files/survey_april16.dta"
merge 1:1 randomcardnumber wave using "Dta_Files/data_replication.dta", keep(3) keepusing(treatment ctrl simple_rem moral_all)
tab message_again_survey_april16 if simple_rem == 1
tab message_again_survey_april16 if moral_all == 1
restore

ttest amount_spent_next1month if inlist(wave,1,2,3,4) == 1 & main_exp == 1 & inlist(treatment,"ctrl","moral_rel","moral_imp","moral_non") == 1, by(ctrl)
ttest p_usage_next1month if inlist(wave,1,2,3,4) == 1 & main_exp == 1 & inlist(treatment,"ctrl","moral_rel","moral_imp","moral_non") == 1, by(ctrl)


********************************
*** Interpreting the Results ***
********************************

preserve
clear
use "Dta_Files/survey_june15general.dta"
append using "Dta_Files/survey_june15treated.dta"
keep if answered_survey_jun15_treated == 1 | answered_survey_jun15_general == 1

tab qst_5 if qst_5 != "NA"

* Footnote

display _N
count if answered_survey_jun15_treated == 1
count if answered_survey_jun15_general == 1
restore

* Footnote
reg delinquent moral_repeated if ((moral_repeated == 1 | ctrl == 1) & followup_exp == 1 & inlist(wave,5,6) == 1) & time_lag_first_moral > 2, r
reg delinquent moral_repeated if ((moral_repeated == 1 | ctrl == 1) & followup_exp == 1 & inlist(wave,5,6) == 1) & time_lag_first_moral == 2, r

* Footnote
ttest late_2016 if inlist(wave,1,2,3,4)==1 & (ctrl == 1 | moral_rel == 1 | moral_imp == 1 | moral_non == 1) & main_exp == 1, by(ctrl)


*****************************************
*** Additional Results and Extensions ***
*****************************************

sum amount_repaid if main_exp == 1 & inlist(wave,1,2,3) == 1 & ctrl == 1

sum amount_repaid if main_exp == 1 & inlist(wave,1,2,3) == 1 & moral_rel == 1

sum amount_repaid if main_exp == 1 & inlist(wave,1,2,3) == 1 & credit_rep == 1

ttest amount_repaid if main_exp == 1 & inlist(wave,1,2,3) == 1 & (moral_rel == 1 | credit_rep == 1), by(moral_rel)

ttest repaid_twice_min  if main_exp == 1 & inlist(wave,1,2,3) == 1 & (moral_rel == 1 | credit_rep == 1) & amount_repaid > 0, by(moral_rel)

tab savings_account if main_exp == 1 & inlist(wave,1,2,3,4) == 1

ttest savings_reduced if savings_account == 1 & main_exp == 1 & inlist(wave,1,2,3,4) == 1, by(delinquent)

* Footnote
sum amount_repaid if main_exp == 1 & ctrl == 1

sum amount_repaid if main_exp == 1 & moral_rel == 1
