# Data Dictionary
Dataset: adsl_like
Project: SWAN CRP – Depressive Symptoms
Level: One record per participant
Software: SAS 9.4

---

## Dataset Description

The `adsl_like` dataset is an analysis-ready dataset derived from SWAN baseline data. It includes cleaned source variables and derived variables used for descriptive and regression analyses evaluating the association between CRP and CES-D depressive symptoms.

---

## Key Variables

### Outcome

| Variable | Type | Label | Description |
|--------|------|-------|-------------|
| CESD | Numeric | CES-D score | Sum of 20 CES-D items (range 0–60); higher scores indicate greater depressive symptoms |

---

### Exposure

| Variable | Type | Label | Description |
|--------|------|-------|-------------|
| CRPRESU0 | Numeric | C-reactive protein | Serum CRP (mg/L) |
| logcrp | Numeric | Log-transformed CRP | Natural log of CRPRESU0 |

---

### Derived Exposure Categories

| Variable | Type | Label | Description |
|--------|------|-------|-------------|
| crp_tert | Numeric | CRP tertile rank | 0 = Low, 1 = Mid, 2 = High |
| crpT | Character | CRP tertile | T1_Low, T2_Mid, T3_High |

---

### Covariates

| Variable | Type | Label | Coding |
|--------|------|-------|--------|
| BMI0 | Numeric | Body Mass Index | Continuous (kg/m²) |
| AGE0 | Numeric | Age at baseline | Continuous (years) |
| RACE | Character | Race/Ethnicity | SWAN-coded categories |
| STATUS0 | Numeric | Menopausal status | 5 = Premenopausal, 4 = Early Perimenopausal |

---

### Re-coded Variables

| Variable | Type | Label | Description |
|--------|------|-------|-------------|
| meno | Character | Menopausal status (recode) | Premen, EarlyPeri |
| smoke | Character | Smoking status | Never, Former, Current |

---

### Dummy Variables (for diagnostics)

| Variable | Type | Label | Coding |
|--------|------|-------|--------|
| smoke_current | Numeric | Current smoker dummy | 1 = Current, 0 = Otherwise |
| smoke_former | Numeric | Former smoker dummy | 1 = Former, 0 = Otherwise |

---

## Exclusion Rules (Applied Upstream)

- CRP > 10 mg/L excluded to remove acute inflammatory states
- Participants with missing CES-D items excluded prior to derivation

---

## Dataset Usage by Program

| Program | Purpose |
|-------|---------|
| 01_data_prep.sas | Apply exclusions and create base dataset |
| 02_derived_variables.sas | Construct CES-D, log-CRP, tertiles, recodes |
| 03_descriptive_analysis.sas | Table 1 summaries and visualizations |
| 04_modeling.sas | Regression modeling and diagnostics |

---

## Notes

- Dataset is intended for educational and portfolio demonstration purposes
- Analyses are cross-sectional and observational
- No causal interpretation is implied

---

## Version History

| Version | Description |
|-------|-------------|
| v1.0 | Initial data dictionary |
