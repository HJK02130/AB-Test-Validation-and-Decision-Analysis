# Validating A/B Test Results  
**SQL Case Study | Statistical Validation & Decision Support**

This repository contains a complete SQL-based analysis that reproduces the core findings of  
**“Validating A/B Test Results: Answers” (ThoughtSpot SQL Analytics tutorial)**.  
The analysis demonstrates how to validate controlled experiment results, check assumptions, and support product decision-making with data. :contentReference[oaicite:1]{index=1}

---

## 1. Project Overview

In product development, A/B tests are used to measure the impact of changes before rolling them out broadly. This project focuses on validating the results of an A/B test that showed a large increase in user posting activity for a new feature. Rather than accepting the headline result at face value, the goal was to **verify that the observed difference is real, consistent across metrics, and meaningful for product decisions**. :contentReference[oaicite:2]{index=2}

A/B test validation is not purely a technical task—it requires understanding **statistical significance**, **metric relevance**, and **experimental assumptions**. This analysis evaluates multiple success indicators, examines potential methodological biases, and suggests how to refine the experiment to draw reliable conclusions. :contentReference[oaicite:3]{index=3}

---

## 2. Key Analytic Questions

We structured the analysis around the following questions:

- **Are posting rates the right metric of success?**  
  Additional user value metrics should also show positive change. :contentReference[oaicite:4]{index=4}

- **Are the results statistically sound?**  
  Does the analysis hold under different statistical methods and assumptions? :contentReference[oaicite:5]{index=5}

- **Are there experimental design biases?**  
  Could including mixed user cohorts (e.g., new vs. existing users) distort results? :contentReference[oaicite:6]{index=6}

---

## 3. Analysis Workflow

Each step below is implemented via SQL queries in this repository, validating the A/B test results from multiple angles.

### 3.1 Re-evaluating Primary Metrics  
We compare not just average posting rates but also other engagement signals such as login frequency and distinct login days. These help confirm whether the experiment improved user value rather than just encouraging superficial activity. :contentReference[oaicite:7]{index=7}

### 3.2 Testing Robustness  
We explore alternative statistical methods (e.g., one-tailed vs. two-tailed tests, distribution assumptions) to ensure the outcome is not an artifact of a particular analytical approach. :contentReference[oaicite:8]{index=8}

### 3.3 Isolating User Cohorts  
We identify a methodological issue in the original test: mixing new and long-term users dilutes interpretability. By segmenting cohorts and excluding very recent sign-ups, we observe how effect sizes change, which helps diagnose whether the observed uplift is genuine. :contentReference[oaicite:9]{index=9}

---

## 4. Key Findings

- The initial increase in posting activity for the treatment group appears consistent across several engagement-related metrics. :contentReference[oaicite:10]{index=10}  
- Alternative statistical checks do not materially change the inference that the treatment has a positive effect. :contentReference[oaicite:11]{index=11}  
- However, the inclusion of new users with limited exposure time introduces bias; analyzing established users separately narrows the effect size and improves interpretability. :contentReference[oaicite:12]{index=12}

These findings highlight the importance of **testing assumptions and cohorts** when interpreting controlled experiment results. :contentReference[oaicite:13]{index=13}

---

## 5. Recommendations for Product Decisions

This analysis informs better product decisions by ensuring that the A/B test results are reliable *before* acting on them:

- **Refine the metric set:** Choose success metrics that reflect true user value. :contentReference[oaicite:14]{index=14}
- **Control cohort effects:** Consider separate analysis for new vs. existing users to avoid exposure bias. :contentReference[oaicite:15]{index=15}
- **Ensure experiment integrity:** Check randomization and treatment assignment to avoid confounding factors. :contentReference[oaicite:16]{index=16}

    ├── charts/
    └── query_results/
