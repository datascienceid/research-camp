clear

version 15

cd "~/Data and Code"

use "Dta_Files/data_replication.dta"

************************************************
*** Table 1: Balance and Treatment Cell Size ***
************************************************

*** Panel A1: Waves I, II, and III Balance of Covariates

* Column (1) Full Sample
sum age female muslim income creditlimit if (main_exp == 1 & inlist(wave,1,2,3) == 1)
* Columns (2)-(6) Treatments
foreach v of var moral_rel simple_rem religious_plac credit_rep ctrl {
sum age female muslim income creditlimit if ((main_exp == 1 & inlist(wave,1,2,3) == 1) & `v' == 1)
}
* Column (7) p-values
foreach v of var age female muslim income creditlimit {
regress `v' moral_rel simple_rem religious_plac credit_rep ctrl if (main_exp == 1 & inlist(wave,1,2,3) == 1), r nocons
test _b[moral_rel] = _b[simple_rem] = _b[religious_plac] = _b[credit_rep] = _b[ctrl]
}

*** Panel A2: Waves I, II, and III Treatment Cell Size

tab wave treatment if (main_exp == 1 & inlist(wave,1,2,3) == 1)

*** Panel B1: Wave IV Balance of Covariates

* Column (1) Full Sample
sum age female muslim income creditlimit if (main_exp == 1 & inlist(wave,4) == 1)
* Columns (2)-(6) Treatments
foreach v of var moral_rel moral_imp moral_non cash_rebate ctrl {
sum age female muslim income creditlimit if ((main_exp == 1 & inlist(wave,4) == 1) & `v' == 1)
}
* Column (7) p-values
foreach v of var age female muslim income creditlimit {
regress `v' moral_rel moral_imp moral_non cash_rebate ctrl if (main_exp == 1 & inlist(wave,4) == 1), r nocons
test _b[moral_rel] = _b[moral_imp] = _b[moral_non] = _b[cash_rebate] = _b[ctrl]
}

*** Panel B2: Wave IV Treatment Cell Size

tab wave treatment if (main_exp == 1 & inlist(wave,4) == 1)

*** Panel C1: Waves V and VI Balance of Covariates

* Column (1) Full Sample
sum age female muslim income creditlimit if (main_exp == 1 & inlist(wave,5,6) == 1)
* Columns (2)-(6) Treatments
foreach v of var moral_rel moral_imp moral_non simple_rem ctrl {
sum age female muslim income creditlimit if ((main_exp == 1 & inlist(wave,5,6) == 1) & `v' == 1)
}
* Column (7) p-values
foreach v of var age female muslim income creditlimit {
regress `v' moral_rel moral_imp moral_non simple_rem ctrl if (main_exp == 1 & inlist(wave,5,6) == 1), r nocons
test _b[moral_rel] = _b[moral_imp] = _b[moral_non] = _b[simple_rem] = _b[ctrl]
}

*** Panel C2: Waves V and VI Treatment Cell Size

tab wave treatment if (main_exp == 1 & inlist(wave,5,6) == 1)




*****************************************
*** Table 2: Moral Incentives Effects ***
*****************************************

local controls "age female muslim income creditlimit i.province sample_before poor_credit_history"

mean delinquent if (ctrl == 1 & main_exp == 1)

* Column (1)

reg delinquent moral_rel if ((moral_rel == 1 | ctrl == 1) & main_exp == 1), r

* Column (2)

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave if main_exp == 1, r

* Column (3)

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave `controls' if main_exp == 1, r




***********************************************************
*** Table 3: Benchmarking Moral Incentives: Cash Rebate ***
***********************************************************

mean delinquent if (ctrl == 1 & main_exp == 1 & wave == 4)

mean delinquent if (ctrl == 1 & main_exp == 1)

* Column (1)

reg delinquent moral_rel cash_rebate if ((moral_rel == 1 | cash_rebate == 1 | ctrl == 1) & main_exp == 1 & wave == 4), r
reg delinquent moral_rel ctrl if ((moral_rel == 1 | cash_rebate == 1 | ctrl == 1) & main_exp == 1 & wave == 4), r

* Column (2)

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave if main_exp == 1, r
reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non ctrl i.wave if main_exp == 1, r

* Column (3)

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave `controls' if main_exp == 1, r
reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non ctrl i.wave `controls' if main_exp == 1, r




******************************************
*** Table 4: Credit Reputation Effects ***
******************************************

mean delinquent if (ctrl == 1 & main_exp == 1 & inlist(wave,1,2,3) == 1)

mean delinquent if (ctrl == 1 & main_exp == 1)

* Column (1)

reg delinquent moral_rel credit_rep if ((moral_rel == 1 | credit_rep == 1 | ctrl == 1) & main_exp == 1 & inlist(wave,1,2,3) == 1), r
reg delinquent moral_rel ctrl if ((moral_rel == 1 | credit_rep == 1 | ctrl == 1) & main_exp == 1 & inlist(wave,1,2,3) == 1), r

* Column (2)

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave if main_exp == 1, r
reg delinquent moral_rel simple_rem religious_plac ctrl moral_imp moral_non cash_rebate i.wave if main_exp == 1, r

* Column (3)

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave `controls' if main_exp == 1, r
reg delinquent moral_rel simple_rem religious_plac ctrl moral_imp moral_non cash_rebate i.wave `controls' if main_exp == 1, r





******************************************
*** Table 5: Ruling Out Other Channels ***
******************************************

mean delinquent if (ctrl == 1 & main_exp == 1 & inlist(wave,1,2,3) == 1)

mean delinquent if (ctrl == 1 & main_exp == 1)

* Column (1)

reg delinquent moral_rel simple_rem religious_plac if ((moral_rel == 1 | simple_rem == 1 | religious_plac == 1 | ctrl == 1) & main_exp == 1 & inlist(wave,1,2,3) == 1), r
reg delinquent moral_rel religious_plac ctrl if ((moral_rel == 1 | simple_rem == 1 | religious_plac == 1 | ctrl == 1) & main_exp == 1 & inlist(wave,1,2,3) == 1), r
reg delinquent moral_rel simple_rem ctrl if ((moral_rel == 1 | simple_rem == 1 | religious_plac == 1 | ctrl == 1) & main_exp == 1 & inlist(wave,1,2,3) == 1), r

* Column (2)

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave if main_exp == 1, r
reg delinquent moral_rel ctrl religious_plac credit_rep moral_imp moral_non cash_rebate i.wave if main_exp == 1, r
reg delinquent moral_rel simple_rem ctrl credit_rep moral_imp moral_non cash_rebate i.wave if main_exp == 1, r


* Column (3)

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave `controls' if main_exp == 1, r
reg delinquent moral_rel ctrl religious_plac credit_rep moral_imp moral_non cash_rebate i.wave `controls' if main_exp == 1, r
reg delinquent moral_rel simple_rem ctrl credit_rep moral_imp moral_non cash_rebate i.wave `controls' if main_exp == 1, r




********************************************************************
*** Table 6: What Drives the Moral Appeal? Religious Connotation ***
********************************************************************

mean delinquent if (ctrl == 1 & main_exp == 1 & inlist(wave,4,5,6) == 1)

mean delinquent if (ctrl == 1 & main_exp == 1)

* Column (1)

reg delinquent moral_rel moral_imp moral_non if ((moral_rel == 1 | moral_imp == 1 | moral_non == 1 | ctrl == 1) & main_exp == 1 & inlist(wave,4,5,6) == 1), r
reg delinquent moral_rel ctrl moral_non if ((moral_rel == 1 | moral_imp == 1 | moral_non == 1 | ctrl == 1) & main_exp == 1 & inlist(wave,4,5,6) == 1), r
reg delinquent moral_rel moral_imp ctrl if ((moral_rel == 1 | moral_imp == 1 | moral_non == 1 | ctrl == 1) & main_exp == 1 & inlist(wave,4,5,6) == 1), r


* Column (2)

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave if main_exp == 1, r
reg delinquent moral_rel simple_rem religious_plac credit_rep ctrl moral_non cash_rebate i.wave if main_exp == 1, r
reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp ctrl cash_rebate i.wave if main_exp == 1, r


* Column (3)

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave `controls' if main_exp == 1, r
reg delinquent moral_rel simple_rem religious_plac credit_rep ctrl moral_non cash_rebate i.wave `controls' if main_exp == 1, r
reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp ctrl cash_rebate i.wave `controls' if main_exp == 1, r




******************************************************
*** Table 7: The Effect of Repeated Moral Messages ***
******************************************************

mean delinquent if (ctrl == 1 & followup_exp == 1 & inlist(wave,5,6) == 1)

mean delinquent if ctrl == 1

* Column (1)

reg delinquent moral_repeated if ((moral_repeated == 1 | ctrl == 1) & followup_exp == 1 & inlist(wave,5,6) == 1), r


* Column (2)

reg delinquent moral_repeated i.wave if ((moral_repeated == 1 | ctrl == 1) & followup_exp == 1 & inlist(wave,5,6) == 1), r


* Column (3)

reg delinquent moral_repeated i.wave `controls' if ((moral_repeated == 1 | ctrl == 1) & followup_exp == 1 & inlist(wave,5,6) == 1), r


* Columns (4)

reg delinquent moral_repeated moral_first simple_rem religious_plac credit_rep cash_rebate  i.wave `controls' if (main_exp == 1 | followup_exp == 1), r
reg delinquent moral_repeated ctrl simple_rem religious_plac credit_rep cash_rebate  i.wave `controls' if (main_exp == 1 | followup_exp == 1), r




**********************************
*** Table 8: Effect on Default ***
**********************************

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
_pctile prediction [pw=weight] if default_sample == 1, p(90)
local p_90 = r(r1)
generate high_credit_risk = (prediction > `p_90') if default_sample == 1
generate low_credit_risk = (prediction <= `p_90') if default_sample == 1

mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1)

* Column (1)
regress delinquent moral_rel credit_rep simple_rem religious_plac [pw=weight] if default_sample == 1


* Column (2)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if default_sample == 1


mean delinquent [pw=weight] if (default_sample == 1 & high_credit_risk == 1 & ctrl == 1)

* Column (3)
regress delinquent moral_rel credit_rep simple_rem religious_plac [pw=weight] if (default_sample == 1 & high_credit_risk == 1)


* Column (4)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & high_credit_risk == 1)


mean delinquent [pw=weight] if (default_sample == 1 & low_credit_risk == 1 & ctrl == 1)

* Column (5)
regress delinquent moral_rel credit_rep simple_rem religious_plac [pw=weight] if (default_sample == 1 & low_credit_risk == 1)


* Column (6)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & low_credit_risk == 1)


mean default [pw=weight] if (default_sample == 1 & ctrl == 1)

* Column (7)
regress default moral_rel credit_rep simple_rem religious_plac [pw=weight] if default_sample == 1


* Column (8)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if default_sample == 1


mean default [pw=weight] if (default_sample == 1 & high_credit_risk == 1 & ctrl == 1)

* Column (9)
regress default moral_rel credit_rep simple_rem religious_plac [pw=weight] if (default_sample == 1 & high_credit_risk == 1)


* Column (10)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & high_credit_risk == 1)


mean default [pw=weight] if (default_sample == 1 & low_credit_risk == 1 & ctrl == 1)

* Column (11)
regress default moral_rel credit_rep simple_rem religious_plac [pw=weight] if (default_sample == 1 & low_credit_risk == 1)


* Column (12)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & low_credit_risk == 1)



**************************************
*** Table A.1: Sample Size by Wave ***
**************************************

tab wave type_obs




*******************************************************************************
*** Table A.2: Repeated Message Experiment: Balance and Treatment Cell Size ***
*******************************************************************************

*** Panel A: Balance of Covariates

* Column (1) Full Sample
sum age female muslim income creditlimit if (followup_exp == 1 & inlist(wave,5,6) == 1)
* Columns (2)-(3) Treatments
foreach v of var moral_repeated ctrl {
sum age female muslim income creditlimit if ((followup_exp == 1 & inlist(wave,5,6) == 1) & `v' == 1)
}
* Column (4) p-values
foreach v of var age female muslim income creditlimit {
regress `v' moral_repeated ctrl if (followup_exp == 1 & inlist(wave,5,6) == 1), r nocons
test _b[moral_repeated] = _b[ctrl]
}

*** Panel A2: Waves I, II, and III Treatment Cell Size

tab wave treatment_repeated if (followup_exp == 1 & inlist(wave,5,6) == 1)




*****************************************************
*** Table A.3: Heterogeneity of Treatment Effects ***
*****************************************************

* Generate Local Religiousity Measure
preserve
clear
use "Dta_Files/survey_june15general.dta"
append using "Dta_Files/survey_june15treated.dta"
keep if answered_survey_jun15_treated == 1 | answered_survey_jun15_general == 1
generate religious_respondent = (qst_1_1st_survey_jun15_treated == "Religion" & qst_2_survey_jun15_treated == "5" & qst_4_survey_jun15_treated == "5") | (qst_1_1st_survey_jun15_general == "Religion" & qst_2_survey_jun15_general == "5" & qst_4_survey_jun15_general == "5")
collapse (count) obs = religious_respondent (sum) religious_respondent, by(province_name)
generate share_religious_respondent = religious_respondent/obs
egen p50 = pctile(share_religious_respondent), p(50)
generate religious_province = (share_religious_respondent >= p50)
tempfile religious_province
save `religious_province', replace
restore
merge m:1 province_name using `religious_province', keepusing(religious_province) nogenerate
generate religious_province_moral = religious_province*moral_all if ((ctrl == 1 | moral_all == 1) & main_exp == 1)

* Column (1)

regress delinquent male_moral moral_all male i.wave `controls' if ((moral_first == 1 | ctrl == 1) & main_exp == 1), r


* Column (2)

regress delinquent old_moral moral_all old i.wave `controls' if ((moral_first == 1 | ctrl == 1) & main_exp == 1), r


* Column (3)

regress delinquent muslim_moral moral_all muslim i.wave `controls' if ((moral_first == 1 | ctrl == 1) & main_exp == 1), r


* Column (4)

regress delinquent religious_province_moral moral_all religious_province i.wave `controls' if ((moral_first == 1 | ctrl == 1) & main_exp == 1), r


* Column (5)

regress delinquent debt_to_income_moral moral_all debt_to_income i.wave `controls' if ((moral_first == 1 | ctrl == 1) & main_exp == 1), r


* Column (6)

regress delinquent poor_credit_history_moral moral_all poor_credit_history i.wave `controls' if ((moral_first == 1 | ctrl == 1) & main_exp == 1), r




**********************************************************************
*** Table A.4: First Three Waves Including Crowding-Out Experiment ***
**********************************************************************

mean delinquent if (((main_exp == 1 | crowding_out_exp == 1) & inlist(wave,1,2,3)==1) & ctrl == 1)

* Column (1)
regress delinquent moral_rel simple_rem religious_plac credit_rep credit_rep_plus_moral_rel simple_rem_plus_due_date_message if ((main_exp == 1 | crowding_out_exp == 1) & inlist(wave,1,2,3)==1), r


* Column (2)
regress delinquent moral_rel simple_rem religious_plac credit_rep credit_rep_plus_moral_rel simple_rem_plus_due_date_message i.wave if ((main_exp == 1 | crowding_out_exp == 1) & inlist(wave,1,2,3)==1), r


* Column (3)
regress delinquent moral_rel simple_rem religious_plac credit_rep credit_rep_plus_moral_rel simple_rem_plus_due_date_message i.wave `controls' if ((main_exp == 1 | crowding_out_exp == 1) & inlist(wave,1,2,3)==1), r




*************************************************
*** Table A.5: First Time and Repeated Sample ***
*************************************************

*** Panel A: Balance of Covariates

* Columns (1) and (2)
foreach v of var main_exp followup_exp {
sum age female muslim income creditlimit poor_credit_history sample_before if ((main_exp == 1 | followup_exp == 1) & `v' == 1)
}
* Column (3) p-values
foreach v of var age female muslim income creditlimit poor_credit_history sample_before {
regress `v' main_exp followup_exp if (main_exp == 1 | followup_exp == 1), r nocons
test _b[main_exp] = _b[followup_exp]
}

*** Panel B: Treatment Cell Size

tab wave followup_exp if (main_exp == 1 | followup_exp == 1)




******************************************************
*** Table A.6: Effect on Default: Robustness Check ***
******************************************************

* Split the sample on credit risk
_pctile prediction [pw=weight] if default_sample == 1, p(50 75 90 95)
local i = 1
foreach k in 50 75 90 95 {
local p_`k' = r(r`i')
generate high_credit_risk_`k' = (prediction > `p_`k'') if default_sample == 1
local i = `i' + 1
}

* Column (1)
mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1 & high_credit_risk_95 == 1)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & high_credit_risk_95 == 1), r


* Column (2)
mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1 & high_credit_risk_90 == 1)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & high_credit_risk_90 == 1), r


* Column (3)
mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1 & high_credit_risk_75 == 1)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & high_credit_risk_75 == 1), r


* Column (4)
mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1 & high_credit_risk_50 == 1)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & high_credit_risk_50 == 1), r


* Column (5)
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & high_credit_risk_95 == 1)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & high_credit_risk_95 == 1), r


* Column (6)
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & high_credit_risk_90 == 1)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & high_credit_risk_90 == 1), r


* Column (7)
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & high_credit_risk_75 == 1)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & high_credit_risk_75 == 1), r


* Column (8)
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & high_credit_risk_50 == 1)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & high_credit_risk_50 == 1), r


********************************************************
*** Table A.7: Effect on Default: Machine Learning I ***
********************************************************

* Save Data for Machine Learning Prediction
export delimited "Csv_Files/default_sample.csv" if default_sample == 1, replace
export delimited "Dta_Files/default_sample.dta" if default_sample == 1, replace


* For generating the Machine Learning predictions for Tables A.7 and A.8 run "R_Files/machine_learning_predictions.R" on R
* The predictions are saved in "Dta_Files/machine_learning_predictions.dta"

merge 1:1 randomcardnumber wave using "Dta_Files/machine_learning_predictions.dta", nogenerate keepusing(gbm regression_tree)


* Split the sample on credit risk (using gbm)
_pctile gbm [pw=weight] if default_sample == 1, p(50 75 90 95)
local i = 1
foreach k in 50 75 90 95 {
local p_`k' = r(r`i')
generate gbm_high_credit_risk_`k' = (gbm > `p_`k'') if default_sample == 1
local i = `i' + 1
}

* Column (1)
mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1 & gbm_high_credit_risk_95 == 1)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & gbm_high_credit_risk_95 == 1), r


* Column (2)
mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1 & gbm_high_credit_risk_90 == 1)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & gbm_high_credit_risk_90 == 1), r


* Column (3)
mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1 & gbm_high_credit_risk_75 == 1)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & gbm_high_credit_risk_75 == 1), r


* Column (4)
mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1 & gbm_high_credit_risk_50 == 1)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & gbm_high_credit_risk_50 == 1), r


* Column (5)
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & gbm_high_credit_risk_95 == 1)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & gbm_high_credit_risk_95 == 1), r


* Column (6)
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & gbm_high_credit_risk_90 == 1)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & gbm_high_credit_risk_90 == 1), r


* Column (7)
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & gbm_high_credit_risk_75 == 1)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & gbm_high_credit_risk_75 == 1), r


* Column (8)
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & gbm_high_credit_risk_50 == 1)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & gbm_high_credit_risk_50 == 1), r



*********************************************************
*** Table A.8: Effect on Default: Machine Learning II ***
*********************************************************

* Split the sample on credit risk (using regression_tree)
_pctile regression_tree [pw=weight] if default_sample == 1, p(50 75 90 95)
local i = 1
foreach k in 50 75 90 95 {
local p_`k' = r(r`i')
generate reg_high_credit_risk_`k' = (regression_tree > `p_`k'') if default_sample == 1
local i = `i' + 1
}

* Column (1)
mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1 & reg_high_credit_risk_95 == 1)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & reg_high_credit_risk_95 == 1), r


* Column (2)
mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1 & reg_high_credit_risk_90 == 1)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & reg_high_credit_risk_90 == 1), r


* Column (3)
mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1 & reg_high_credit_risk_75 == 1)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & reg_high_credit_risk_75 == 1), r


* Column (4)
mean delinquent [pw=weight] if (default_sample == 1 & ctrl == 1 & reg_high_credit_risk_50 == 1)
regress delinquent moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & reg_high_credit_risk_50 == 1), r


* Column (5)
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & reg_high_credit_risk_95 == 1)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & reg_high_credit_risk_95 == 1), r


* Column (6)
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & reg_high_credit_risk_90 == 1)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & reg_high_credit_risk_90 == 1), r


* Column (7)
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & reg_high_credit_risk_75 == 1)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & reg_high_credit_risk_75 == 1), r


* Column (8)
mean default [pw=weight] if (default_sample == 1 & ctrl == 1 & reg_high_credit_risk_50 == 1)
regress default moral_rel credit_rep simple_rem religious_plac i.wave `controls' [pw=weight] if (default_sample == 1 & reg_high_credit_risk_50 == 1), r



******************************************************
*** Table A.9: Simple Reminder as Comparison Group ***
******************************************************

mean delinquent if (main_exp == 1 & inlist(wave,1,2,3) == 1 & simple_rem == 1)

* Column (1)

regress delinquent moral_rel credit_rep religious_plac ctrl if (main_exp == 1 & inlist(wave,1,2,3) == 1), r


* Column (2)

regress delinquent moral_rel credit_rep religious_plac ctrl i.wave if (main_exp == 1 & inlist(wave,1,2,3) == 1), r


* Column (3)

regress delinquent moral_rel credit_rep religious_plac ctrl i.wave `controls' if (main_exp == 1 & inlist(wave,1,2,3) == 1), r


mean default [pw=weight] if (default_sample == 1 & simple_rem == 1 & high_credit_risk == 1)

* Column (4)

regress default moral_rel credit_rep religious_plac ctrl [pw=weight] if (default_sample == 1 & high_credit_risk == 1), r


* Column (5)

regress default moral_rel credit_rep religious_plac ctrl i.wave [pw=weight] if (default_sample == 1 & high_credit_risk == 1), r


* Column (6)

regress default moral_rel credit_rep religious_plac ctrl i.wave `controls' [pw=weight] if (default_sample == 1 & high_credit_risk == 1), r
