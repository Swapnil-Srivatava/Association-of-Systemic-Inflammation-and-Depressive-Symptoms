
options nodate nonumber nofmterr;
title;

libname proj "C:\Users\swaps\OneDrive\Desktop\EP850\Project\analysis";

/*
Output location  */
%let outpath = C:\Users\swaps\OneDrive\Desktop\EP850\Project\outputs;
%let outfile = &outpath.\03_descriptive_analysis_swan.pdf;

ods graphics on;
ods pdf file="&outfile" style=journal;

/*
Section 1: Snapshot + missingness */
title1 "SWAN Baseline: Systemic Inflammation (CRP) and Depressive Symptoms (CES-D)";
title2 "Dataset Snapshot (Analysis-Ready Dataset: proj.adsl_like)";

proc sql;
  select count(*) as N_Records
  from proj.adsl_like;
quit;

title2 "Missingness Summary (Key Variables)";
proc means data=proj.adsl_like n nmiss;
  var CESD logcrp CRPRESU0 BMI0 AGE0;
run;

title2 "Categorical Distributions (Overall)";
proc freq data=proj.adsl_like;
  tables crpT smoke meno RACE / missing;
run;

/*
Section 2: Table 1 by CRP tertile */
title2 "Table 1: Baseline Characteristics by CRP Tertile (log-CRP based)";

/* Continuous variables by tertile */
title3 "Continuous Variables (Mean/SD; Median/IQR)";
proc means data=proj.adsl_like mean std median p25 p75 n maxdec=2;
  class crpT;
  var AGE0 BMI0 CESD CRPRESU0 logcrp;
run;

/* Categorical variables by tertile */
title3 "Categorical Variables (Count and Row %)";
proc freq data=proj.adsl_like;
  tables crpT*(RACE smoke meno) / norow nocol nocum;
run;

/*
Section 3: Distributions */
title2 "Distributions";

/* CRP raw */
title3 "CRP Distribution (Raw)";
proc sgplot data=proj.adsl_like;
  histogram CRPRESU0;
  density CRPRESU0;
  xaxis label="CRP (mg/L)";
run;

/* logCRP */
title3 "CRP Distribution (Log-transformed)";
proc sgplot data=proj.adsl_like;
  histogram logcrp;
  density logcrp;
  xaxis label="log(CRP)";
run;

/* CES-D */
title3 "CES-D Distribution";
proc sgplot data=proj.adsl_like;
  histogram CESD;
  density CESD;
  xaxis label="CES-D Score (0–60)";
run;

/*
Section 4: Exposure–Outcome visualization */
title2 "Association Visualization: log(CRP) vs CES-D";

/* Scatter + LOESS */
proc sgplot data=proj.adsl_like;
  scatter x=logcrp y=CESD / transparency=0.2;
  loess x=logcrp y=CESD / smooth=0.5;
  xaxis label="log(CRP)";
  yaxis label="CES-D Score";
run;

/*
Close */
ods pdf close;
ods graphics off;
title;
