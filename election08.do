clear

set more off

use W11A6 W11WS3 W11U1 W11V3 WGTREGION W1STATE DER* CPQ* CASEID using "C:\Users\Anna\Desktop\ECON452\election study\STATA\29182-0001-Data.dta"

drop if DER08W9 == -6

drop CPQ2_OTHER

// cleaning household income var
drop if DER06 <0

// cleaning race var
drop if DER04 <0


//recode Obamada = 1, McCain = 0
recode W11A6 (18=1) (13=0) 
drop if W11A6 < 0
drop if W11A6 > 1 


//*cleaning the economic vars: W11WS3 Approve or disapprove gwb handling of the economy? Mention the other economic variables are explained by this
drop if W11WS3 <0 

//cleaning: W11U1 Compared to 2001, would you say the economy is now...?
//drop if W11U1 <0 

//cleaning: W11V3 Is economy much better or worse than 1 year ago?
//drop if W11V3 < 0 
//logit W11A6 i.W11WS3 i.W11U1 i.W11V3


//incomplete model
replace DER06 = 0 if DER06<12

replace DER06=1 if DER06>=12

//cleaning the rest of the data

drop if DER07<0
drop if DER01 <0

drop if DER08W11<0
// complete model # 1: econ proxy, race, income, gender, political id, residence, home ownership

//drop if CPQ15 <0

//replace CPQ15 = 2 if CPQ15 > 12
//replace CPQ15 = 1 if CPQ15 == 12
//replace CPQ15 =0 if CPQ15 < 12
drop if CPQ12<0 



//test for collinearity between political id and party id: regression + VIF

reg W11A6 DER08W11 DER09W11
estat vif


//run a probit with dummy marital status (married=1) with median income

gen marital = 0

replace marital = 1 if CPQ12 == 1


gen educ = 1
replace educ = 0 if CPQ15 <11


asdoc sum W11A6 i.W11WS3 i.DER04 i.DER06 i.DER01 i.DER08W11 i.DER09W11 i.WGTREGION i.DER07 educ marital, save(summary.doc)
//without education
asdoc probit W11A6 i.W11WS3 i.DER04 i.DER06 i.DER01 i.DER08W11 i.DER09W11 i.WGTREGION i.DER07 marital, save(Table 4.doc)
//with education
asdoc probit W11A6 i.W11WS3 i.DER04 i.DER06 i.DER01 i.DER08W11 i.DER09W11 i.WGTREGION i.DER07 educ marital, save(Table 5.doc)

// nested model for party id

// dummy party id
gen partyid = 0
replace partyid = 1 if DER08W11 < 4
asdoc probit partyid marital educ i.DER04 i.DER06 i.DER01 i.DER09W11 i.WGTREGION, save(Nested.doc)


//predict vote
//twoway scatter vote W11A6 W11WS3




