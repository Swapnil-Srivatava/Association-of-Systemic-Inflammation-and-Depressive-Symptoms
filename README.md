# Association-of-Systemic-Inflammation-and-Depressive-Symptoms
**Project Overview**

Modular SAS 9.4 programming workflow for observational analysis using SWAN data. Covers data preparation, derivation of analysis-ready variables, descriptive reporting, multivariable regression, diagnostics, and model assessment with reproducible outputs.
Project Overview

This project evaluates the association between systemic inflammation, measured by serum C-reactive protein (CRP), and depressive symptom burden, measured using the Center for Epidemiologic Studies Depression Scale (CES-D), among midlife women participating in the Study of Women’s Health Across the Nation (SWAN).

The primary goal of this project was not only to estimate associations, but to implement a clean, reproducible statistical programming workflow consistent with observational clinical and epidemiologic research practices. Emphasis was placed on data preparation, variable derivation, confounding assessment, effect modification, diagnostics, and clear documentation.

**Objectives**

* Assess the unadjusted association between log-transformed CRP and CES-D scores
* Evaluate confounding by body mass index (BMI), smoking status, and menopausal status
* Examine effect modification by menopausal status and smoking
* Compare continuous and categorical exposure modeling (CRP tertiles)
* Perform regression diagnostics and assess influential observations
* Demonstrate structured, modular SAS programming practices

**Data Source**

Study of Women’s Health Across the Nation (SWAN)

* A large, multi-site longitudinal cohort study of midlife women in the United States.
* Baseline data collected across seven U.S. clinical sites
* Analytic sample includes women with complete CRP and CES-D data
* Participants with CRP >10 mg/L were excluded to remove acute inflammatory states
* All analyses are cross-sectional and use baseline data only

**Variables**

* Outcome
* CES-D score (continuous, 0–60): Higher scores indicate greater depressive symptom burden.
* Primary Exposure
* Log-transformed CRP (log-CRP): CRP was log-transformed due to right-skewed distribution.
Covariates
* Body Mass Index (BMI, continuous)
* Smoking status (Never / Former / Current)
* Menopausal status (Premenopausal / Early Perimenopausal)
* Race/ethnicity

**Statistical Programming Workflow**

The analysis is implemented as a modular SAS pipeline:

**1. Data Preparation**

* Import and clean SWAN baseline data
* Apply exclusion criteria (CRP >10 mg/L, missing CES-D)
* Create analysis dataset

**2. Variable Derivation**

* Log-transformation of CRP
* Construction of CRP tertiles
* Recoding of smoking and menopausal status
* Creation of dummy variables for modeling

**3. Descriptive Analysis**

* Table 1–style summaries overall and by CRP tertile
* Distributional assessment of CRP and CES-D
* Frequency summaries of key covariates

**4. Regression Modeling**

* Unadjusted linear regression (CES-D ~ log-CRP)
* Sequential multivariable models adjusting for BMI, smoking, and menopausal status
* Categorical exposure modeling using CRP tertiles with LSMeans

**5. Effect Modification**

* Stratified analyses by menopausal status and smoking
* Interaction models (log-CRP × menopausal status; log-CRP × smoking)

**6️. Diagnostics and Model Assessment**

* Residual diagnostics and influence statistics
* Variance Inflation Factors (VIF) to assess multicollinearity
* Sensitivity analysis using multiple imputation to evaluate missing-data behavior

**Key Findings (High-Level)**

* Log-CRP was positively associated with CES-D scores in unadjusted models
* Adjustment for BMI substantially attenuated the association, rendering it null
* No meaningful effect modification by menopausal or smoking status was observed
* CRP tertiles showed no significant differences in adjusted CES-D means
* Diagnostics indicated no problematic multicollinearity or influential outliers
* These results suggest that previously observed inflammation–depression associations may be largely explained by confounding from adiposity and related factors.

**Tools & Skills Demonstrated**

* SAS 9.4
* PROC REG, PROC GLM, PROC RANK, PROC FREQ, PROC MEANS
* Linear regression and categorical modeling
* Confounding and effect-modification assessment
* Regression diagnostics and influence analysis
* Structured, modular statistical programming
* Clear documentation and reproducible outputs
