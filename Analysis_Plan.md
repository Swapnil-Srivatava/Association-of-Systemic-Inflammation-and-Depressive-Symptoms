# Analysis Plan
Project: Systemic Inflammation and Depressive Symptoms (SWAN)
Outcome: CES-D score (continuous)
Primary Exposure: Log-transformed C-reactive protein (log-CRP)
Software: SAS 9.4

---

## 1. Background and Rationale

Systemic inflammation has been implicated in the development and persistence of depressive symptoms. C-reactive protein (CRP), a commonly measured biomarker of inflammation, has shown mixed associations with depression in prior epidemiologic studies. In midlife women, the menopausal transition represents a period of biological and psychosocial change that may influence both inflammatory processes and mood.

This analysis evaluates the cross-sectional association between CRP and depressive symptoms at baseline in the Study of Women’s Health Across the Nation (SWAN), with careful attention to confounding, effect modification, and model diagnostics using a structured statistical programming workflow.

---

## 2. Objectives

### Primary Objective
- To assess the unadjusted and adjusted association between log-transformed CRP and CES-D depressive symptom scores.

### Secondary Objectives
- To evaluate confounding by body mass index (BMI), smoking status, and menopausal status
- To assess effect modification by menopausal status and smoking
- To compare continuous and categorical exposure modeling (CRP tertiles)
- To evaluate model assumptions, multicollinearity, and influential observations

---

## 3. Study Design and Data Source

This is a cross-sectional analysis using baseline data from the Study of Women’s Health Across the Nation (SWAN), a multi-site longitudinal cohort of midlife women in the United States.

Baseline data were collected during in-person clinic visits and include standardized questionnaires, anthropometric measurements, and laboratory biomarkers.

---

## 4. Analysis Population

### Inclusion Criteria
- Participation in the SWAN baseline visit
- Availability of CRP biomarker data
- Availability of CES-D depressive symptom items

### Exclusion Criteria
- CRP > 10 mg/L (to exclude acute inflammatory states)
- Missing CES-D items required to compute total CES-D score
- Missing key covariates for multivariable modeling

---

## 5. Variable Definitions

### Outcome
- **CES-D score**: Continuous depressive symptom score (0–60), computed as the sum of 20 CES-D items.

### Primary Exposure
- **CRP**: Serum C-reactive protein (mg/L)
- **log-CRP**: Natural log transformation of CRP to address right-skewness

### Covariates
- **BMI**: Body mass index (kg/m²), continuous
- **Smoking status**: Never, Former, Current
- **Menopausal status**: Premenopausal, Early Perimenopausal
- **Race/Ethnicity**
- **Age**

---

## 6. Statistical Methods

### 6.1 Descriptive Analysis
- Continuous variables summarized using mean, standard deviation, median, and interquartile range
- Categorical variables summarized using counts and percentages
- Baseline characteristics described overall and by CRP tertiles

### 6.2 Regression Modeling

#### Unadjusted Model
- Linear regression: CES-D ~ log-CRP

#### Sequentially Adjusted Models
- Model 1: CES-D ~ log-CRP + BMI
- Model 2: CES-D ~ log-CRP + BMI + smoking
- Model 3: CES-D ~ log-CRP + BMI + smoking + menopausal status

### 6.3 Categorical Exposure Analysis
- CRP tertiles derived from the distribution of log-CRP
- Adjusted least-squares means estimated using linear regression with pairwise comparisons

### 6.4 Effect Modification
- Interaction terms tested:
  - log-CRP × menopausal status
  - log-CRP × smoking status
- Stratified analyses conducted where appropriate

### 6.5 Model Diagnostics
- Residual diagnostics to assess linearity and homoscedasticity
- Variance Inflation Factors (VIF) to assess multicollinearity
- Influence diagnostics (studentized residuals, Cook’s distance)

---

## 7. Missing Data

Patterns of missingness are assessed using descriptive summaries. Because missingness is minimal and exclusions are limited, primary analyses are conducted using complete-case data. Multiple imputation is explored as a sensitivity analysis to characterize missing-data behavior.

---

## 8. Outputs

- Analysis-ready dataset (`adsl_like`)
- Descriptive summary tables (Table 1–style)
- Regression model summaries
- Adjusted LSMeans for CRP tertiles
- Diagnostic and influence plots

---

## 9. Interpretation and Limitations

Results are interpreted in the context of observational, cross-sectional data. Causal inference is not implied. Potential residual confounding and self-reported outcome measurement are acknowledged limitations.

---

## 10. Version History

- v1.0 – Initial analysis plan for portfolio demonstration
