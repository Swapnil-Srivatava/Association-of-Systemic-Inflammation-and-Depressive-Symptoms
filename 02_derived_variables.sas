
options nodate nonumber nofmterr;
title;

libname proj "C:\Users\swaps\OneDrive\Desktop\EP850\Project\analysis";

/*
1) Formats (readability for outputs)*/
proc format;
  value statusf
    5 = "Premenopausal"
    4 = "Early Perimenopausal"
    other = "Other/Unknown";

  value yesnof
    0 = "No"
    1 = "Yes";
run;

/*
2) Create derived variables (no tertiles yet)
*/
data work.derived_step1;
  set proj.swan_base;

  length meno $10 smoke $10;

  /*
    Exposure: log-CRP */
  if CRPRESU0 > 0 then logcrp = log(CRPRESU0);
  else logcrp = .;

  label
    logcrp = "Log-transformed CRP"
  ;

  /*
    Menopausal status recode
    From your report/code:
      STATUS0=5 -> Premen
      STATUS0=4 -> EarlyPeri */
  if STATUS0 = 5 then meno = "Premen";
  else if STATUS0 = 4 then meno = "EarlyPeri";
  else meno = "Other";

  label meno = "Menopausal status (recode)";


  if SMOKERE0 in (1) then smoke = "Never";
  else if SMOKERE0 in (2) then do;
    if SMOKENO0 in (1) then smoke = "Former";
    else if SMOKENO0 in (2) then smoke = "Current";
    else smoke = "Missing";
  end;
  else smoke = "Missing";

  label smoke = "Smoking status (recode)";

  /*
    Outcome: CES-D score
    CESD = sum of 20 items */
  CESD = sum(of BOTHER0 APPETIT0 BLUES0 GOOD0 KEEPMIN0 DEPRESS0 EFFORT0 HOPEFUL0
               FAILURE0 FEARFUL0 RESTLES0 HAPPY0 TALKLES0 LONELY0 UNFRNDL0
               ENJOY0 CRYING0 SAD0 DISLIKE0 GETGOIN0);

  label CESD = "CES-D depressive symptom score (0–60)";

  /*flag missingness (should be none after 01 exclusions) */
  miss_cesd = missing(CESD);
  miss_crp  = missing(CRPRESU0);

  label
    miss_cesd = "Missing CES-D flag"
    miss_crp  = "Missing CRP flag"
  ;

run;

/*
3) Create CRP tertiles (based on logCRP)  */
proc rank data=work.derived_step1 groups=3 out=work.derived_step2;
  var logcrp;
  ranks crp_tert;
run;

data work.derived_step3;
  set work.derived_step2;

  length crpT $8;

  if crp_tert = 0 then crpT = "T1_Low";
  else if crp_tert = 1 then crpT = "T2_Mid";
  else if crp_tert = 2 then crpT = "T3_High";
  else crpT = "Missing";

  label
    crp_tert = "CRP tertile rank (0=Low,1=Mid,2=High)"
    crpT     = "CRP tertile (log-CRP based)"
  ;

  /*
    Dummy variables for smoking
    Reference category: Never (both dummies = 0) */
  smoke_current = (smoke = "Current");
  smoke_former  = (smoke = "Former");

  label
    smoke_current = "Dummy: Current smoker (1=Yes,0=No)"
    smoke_former  = "Dummy: Former smoker (1=Yes,0=No)"
  ;

  format smoke_current smoke_former yesnof.;

run;

/*
4) Final analysis-ready dataset
   Save as ADSL-like for portfolio consistency */
data proj.adsl_like;
  set work.derived_step3;

  /* Keep commonly used analysis vars up front (optional) */
  retain CESD logcrp CRPRESU0 crp_tert crpT BMI0 smoke smoke_current smoke_former meno STATUS0 AGE0 RACE;

run;

/*
5) QC Checks (recruiter-friendly) */
title1 "QC (02): Derived Variables Dataset";

/* Row count */
proc sql;
  select count(*) as N_Records
  from proj.adsl_like;
quit;

/* Missingness on key variables */
proc means data=proj.adsl_like n nmiss;
  var CESD logcrp CRPRESU0 BMI0 AGE0;
run;

/* Distributions */
proc freq data=proj.adsl_like;
  tables smoke meno crpT / missing;
run;

proc means data=proj.adsl_like mean std median p25 p75 min max nmiss;
  var CRPRESU0 logcrp CESD BMI0;
run;

title;
