
options nodate nonumber nofmterr;
title;

libname proj "C:\Users\swaps\OneDrive\Desktop\EP850\Project\analysis";

/*
Output location */
%let outpath = C:\Users\swaps\OneDrive\Desktop\EP850\Project\outputs;
%let outfile = &outpath.\04_modeling_swan.pdf;

ods graphics on;
ods pdf file="&outfile" style=journal;

/*
Analysis dataset */
data work.ana;
  set proj.adsl_like;

  /* Keep complete cases for primary models*/
  if missing(CESD) then delete;
  if missing(logcrp) then delete;
  if missing(BMI0) then delete;
  if smoke = "Missing" then delete;
  if meno  = "Other" then delete;
run;

title1 "SWAN Baseline Modeling: log(CRP) and Depressive Symptoms (CES-D)";
title2 "Analysis Dataset (Complete Cases for Key Variables)";
proc sql;
  select count(*) as N_Analysis
  from work.ana;
quit;

/*
Model 0: Unadjusted (PROC REG)
CESD = logCRP */
title2 "Model 0 (Unadjusted): CES-D = log(CRP)";
proc reg data=work.ana;
  model CESD = logcrp / clb;
run; quit;

/*
Model 1: Adjusted + BMI (PROC REG)
CESD = logCRP + BMI */
title2 "Model 1: CES-D = log(CRP) + BMI";
proc reg data=work.ana;
  model CESD = logcrp BMI0 / clb;
run; quit;

/*
Model 2: Adjusted + BMI + Smoking (PROC GLM)
Class variable: smoke */
title2 "Model 2: CES-D = log(CRP) + BMI + Smoking";
proc glm data=work.ana;
  class smoke;
  model CESD = logcrp BMI0 smoke / solution clparm;
run; quit;

/*
Model 3: Fully Adjusted + BMI + Smoking + Menopausal status (PROC GLM)
Class: smoke, meno */
title2 "Model 3 (Fully Adjusted): CES-D = log(CRP) + BMI + Smoking + Menopausal Status";
proc glm data=work.ana;
  class smoke meno;
  model CESD = logcrp BMI0 smoke meno / solution clparm;
run; quit;

/*
Stratified analyses 
A) By menopausal status
B) By smoking status grouping */
title2 "Stratified Analysis: Premenopausal Only (CES-D = log(CRP))";
proc reg data=work.ana;
  where meno = "Premen";
  model CESD = logcrp / clb;
run; quit;

title2 "Stratified Analysis: Early Perimenopausal Only (CES-D = log(CRP))";
proc reg data=work.ana;
  where meno = "EarlyPeri";
  model CESD = logcrp / clb;
run; quit;

/* Smoking grouping: Never/Former vs Current */
data work.ana2;
  set work.ana;
  length smoke2 $12;
  if smoke in ("Never","Former") then smoke2 = "Never/Former";
  else if smoke = "Current" then smoke2 = "Current";
run;

title2 "Stratified Analysis: Never/Former Smokers (CES-D = log(CRP))";
proc reg data=work.ana2;
  where smoke2 = "Never/Former";
  model CESD = logcrp / clb;
run; quit;

title2 "Stratified Analysis: Current Smokers (CES-D = log(CRP))";
proc reg data=work.ana2;
  where smoke2 = "Current";
  model CESD = logcrp / clb;
run; quit;

/*
CRP Tertiles Model (categorical exposure) + LSMeans & pairwise comparisons
*/
title2 "Categorical Exposure Model: CRP Tertiles (Adjusted LSMeans)";
title3 "Model: CES-D = CRP Tertile + BMI + Smoking + Menopausal Status";

proc glm data=work.ana;
  class crpT smoke meno;
  model CESD = crpT BMI0 smoke meno / solution;
  lsmeans crpT / pdiff cl;
run; quit;

/*
Interaction models
A) logCRP × menopausal status
B) logCRP × smoking */
title2 "Interaction Test: log(CRP) × Menopausal Status";
proc glm data=work.ana;
  class smoke meno;
  model CESD = logcrp BMI0 smoke meno logcrp*meno / solution;
run; quit;

title2 "Interaction Test: log(CRP) × Smoking";
proc glm data=work.ana;
  class smoke meno;
  model CESD = logcrp BMI0 smoke meno logcrp*smoke / solution;
run; quit;

/*
Diagnostics (VIF + influence) using smoking dummiesere, .
*/
title2 "Diagnostics (PROC REG): VIF + Influence (Using Smoking Dummies)";

proc reg data=work.ana plots(only)=diagnostics;
  model CESD = logcrp BMI0 smoke_current smoke_former STATUS0 / vif;
  output out=work.diag_out
    rstudent=rstud
    cookd=cookd
    p=pred
    r=resid;
run; quit;

title3 "Potential Influential Points (|RStudent| > 3 OR Cook's D > 0.1)";
data work.influential;
  set work.diag_out;
  if abs(rstud) > 3 or cookd > 0.1;
run;

proc print data=work.influential noobs;
  var rstud cookd pred resid CESD logcrp BMI0 smoke_current smoke_former STATUS0;
run;

/*
Close */
ods pdf close;
ods graphics off;
title;
