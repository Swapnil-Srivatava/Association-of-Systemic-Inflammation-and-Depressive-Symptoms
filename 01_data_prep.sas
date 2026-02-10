
options nodate nonumber mprint nofmterr;
title;

/* Source data */
libname swan "C:\Users\swaps\OneDrive\Desktop\EP850\Project";

/* Project output */
libname proj "C:\Users\swaps\OneDrive\Desktop\EP850\Project\analysis";

/*
2) CREATE BASE DATASET
   - Apply key exclusions only
   - No derived variables here */
data proj.swan_base;
  set swan.SWAN_Baseline;

  /* Exclusion: acute inflammation */
  if CRPRESU0 > 10 then delete;

  /* Exclusion: missing CES-D components (outcome) */
  if missing(BOTHER0) or missing(APPETIT0) or missing(BLUES0) or
     missing(GOOD0) or missing(KEEPMIN0) or missing(DEPRESS0) or
     missing(EFFORT0) or missing(HOPEFUL0) or missing(FAILURE0) or
     missing(FEARFUL0) or missing(RESTLES0) or missing(HAPPY0) or
     missing(TALKLES0) or missing(LONELY0) or missing(UNFRNDL0) or
     missing(ENJOY0) or missing(CRYING0) or missing(SAD0) or
     missing(DISLIKE0) or missing(GETGOIN0) then delete;

  label
    CRPRESU0 = "C-reactive protein (mg/L)"
    BMI0     = "Body Mass Index (kg/m^2)"
    STATUS0  = "Menopausal status at baseline"
    SMOKERE0 = "Ever smoker indicator"
    SMOKENO0 = "Current smoking status"
    AGE0     = "Age at baseline (years)"
    RACE     = "Race / Ethnicity"
  ;
run;

/*
3) QC CHECKS – BASE DATASET*/
title1 "QC (01): SWAN Base Dataset";

/* Row count */
proc sql;
  select count(*) as N_Records
  from proj.swan_base;
quit;

/* Key missingness snapshot */
proc means data=proj.swan_base n nmiss;
  var CRPRESU0 BMI0 AGE0 STATUS0 SMOKERE0 SMOKENO0;
run;

/* Categorical distributions */
proc freq data=proj.swan_base;
  tables STATUS0 SMOKERE0 RACE / missing;
run;

title;
