# Bundy Victimology – CHAID Analysis

## Project Overview
This project applies a CHAID (Chi-square Automatic Interaction Detection) decision tree
to analyze and predict the U.S. state in which a crime occurred,
based on victim characteristics and contextual information.

The goal is not pure prediction performance,
but interpretability and understanding which variables
are most strongly associated with the crime location.

## Dataset
The dataset contains documented victims linked to Ted Bundy,
with the following variables:

- Victim name
- Age
- Date of disappearance
- Location (city + state)
- Notes describing the context of disappearance

### Feature Engineering
- `State` extracted from Location (target variable)
- `AgeGroup` created from Age
- `Month` extracted from Date
- Keywords extracted from Notes (school, sorority, abducted, home, etc.)

All predictors are categorical, making CHAID an appropriate method.

## Methodology
- CHAID decision tree
- Chi-square tests used for variable selection and splits
- Small-node thresholds adjusted due to limited sample size

## Interpretation of the CHAID Tree
- The root node is **Month**, indicating that the month of disappearance
  is the most statistically discriminant variable for predicting the state.
- Certain months (e.g. June, December) are strongly associated with
  specific states such as Utah and Washington.
- Other months show a geographically dispersed distribution,
  indicating weaker predictive power.
- This highlights temporal patterns rather than demographic dominance.

## Key Insight
The model emphasizes interpretability over prediction.
It shows how temporal and contextual indicators
interact to explain geographic crime patterns.

## Tools
- R
- CHAID package
- Basic text feature extraction

## Limitations
- Small dataset
- Historical and case-specific data
- Results should be interpreted analytically, not operationally


