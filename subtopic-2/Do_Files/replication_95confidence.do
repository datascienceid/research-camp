clear

cd "~/Data and Code"

use "Dta_Files/data_replication.dta"

local controls "age female muslim income creditlimit i.province sample_before poor_credit_history"



************************************************
*** Direct Financial Incentives: Cash Rebate ***
************************************************

* Footnote

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave `controls' if main_exp == 1, r
nlcom _b[cash_rebate]/_b[moral_rel]




********************************************************
*** Indirect Financial Incentives: Credit Reputation ***
********************************************************

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave `controls' if main_exp == 1, r
nlcom _b[cash_rebate]/_b[credit_rep]

* Footnote

nlcom _b[credit_rep]/_b[moral_rel]



*********************************************
*** Religious Connotation of the Message? ***
*********************************************

* Footnote

reg delinquent moral_rel simple_rem religious_plac credit_rep moral_imp moral_non cash_rebate i.wave `controls' if main_exp == 1, r
nlcom _b[moral_imp]/_b[moral_rel]
nlcom _b[moral_non]/_b[moral_rel]




*********************************************************************
*** Provision of New Information? The Impact of Repeated Messages ***
*********************************************************************

reg delinquent moral_repeated moral_first simple_rem religious_plac credit_rep cash_rebate  i.wave `controls' if (main_exp == 1 | followup_exp == 1), r
nlcom _b[moral_repeated]/_b[moral_first]
