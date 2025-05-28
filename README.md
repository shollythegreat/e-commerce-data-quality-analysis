# Data Quality Analysis for an E-Commerce App

This project investigates the **data quality** of behavioral and transactional datasets from a fictional e-commerce platform. It highlights structural and semantic issues in user profiles and event-level tracking that could impact downstream analytics, segmentation, and revenue attribution.

## 🧪 Objectives

- Detect inconsistencies and anomalies in profile and event datasets.
- Quantify scope and explain potential business impacts.
- Demonstrate practical SQL data quality checks and investigations.

---

## 🔍 Profile-Level Analysis

Located in `profile-level-analysis/`:
- Focus: Integrity of the `profiles.csv` table and its relationship with events.
- Example anomaly: Over- or under-reported revenue due to mismatched identifiers.
- Impact: Skewed customer lifetime value (CLTV), segmentation, and marketing ROI.

## ⚙️ Event-Level Analysis

Located in `event-level-analysis/`:
- Focus: Detecting malformed or missing values in raw events.
- Example anomaly: Missing or null revenue in `order_completed` or `cart_add`.
- Impact: Funnel distortion, revenue misreporting, invalid ML training data.

---

## 🧰 Tech Stack

- SQL (SQLite dialect)
- CSV datasets (no external dependencies)
- Optional: Jupyter/Pandas for inspection

---

## 📁 Folder Structure

├── data/ # Raw event data
├── profile-level-analysis/
├── event-level-analysis/
└── results/