# Data-QA Take-Home - Task 1

## 🔍 What I Discovered
- ========================================
I uncovered two profile-level data quality issues in the profiles table (5,780 total profiles):
	1.	Future Identify Timestamps: 2,367 profiles (41.0 %) have LAST_IDENTIFY_AT after the snapshot date of 2025-05-16.
	2.	Negative Inactivity Gaps: 2,372 profiles (41.0 %) show INACTIVE_DAYS < 0, meaning the “days inactive” calculation is inverted.


## 🔧 How I Discovered It
- ========================================
I ran two simple SQL queries against profiles.csv (see task_1/queries.sql):
	1.	The snippet below gives insights into the Future Identify Count:
SELECT
  COUNT(*) AS total_profiles,
  SUM(CASE WHEN DATE(LAST_IDENTIFY_AT) > DATE('2025-05-16') THEN 1 ELSE 0 END)
    AS future_identify_count,
  ROUND(
    100.0 * SUM(CASE WHEN DATE(LAST_IDENTIFY_AT) > DATE('2025-05-16') THEN 1 ELSE 0 END)
    / COUNT(*),
    1
  ) AS pct_future_identify
FROM profiles;

	2.	The snippet below provides context about the Negative Inactive Count:
SELECT
  COUNT(*) AS total_profiles,
  SUM(CASE WHEN INACTIVE_DAYS < 0 THEN 1 ELSE 0 END) AS negative_inactive_count,
  ROUND(
    100.0 * SUM(CASE WHEN INACTIVE_DAYS < 0 THEN 1 ELSE 0 END)
    / COUNT(*),
    1
  ) AS pct_negative_inactive
FROM profiles;


## 📉 Why This Matters
- ========================================
This issue has broad downstream implications:

1.	Retention & Churn: Inverted inactivity days and future-dated identifies break accurate churn and re-activation analyses.

2.	Segmentation Errors: Marketing or product segments based on “last seen” will include incorrect audiences.

3.	Time-Series Distortion: Future timestamps skew trend analyses, seasonality, and forecasting models.

4.	Cohort Integrity: Negative gaps invalidate cohorts defined by days since last activity.

5.	Data Trust: With ~41 % of profiles flawed, stakeholders may lose confidence in all downstream metrics.


## 📌 Suggested Follow-Up Questions
- ========================================
1.	How does the ETL pipeline compute LAST_IDENTIFY_AT, and why are future timestamps slipping in?

2.	Is INACTIVE_DAYS calculated as FIRST_SEEN_AT – LAST_SEEN_AT (wrong order) instead of LAST – FIRST?

3.	Are any business rules allowing legitimate future-dated identify events (e.g., backfilled data)?

4.	What historical windows are affected—should we reprocess past snapshots?

5.	Should we enforce a non-negative constraint on INACTIVE_DAYS or flag anomalies for manual review?

6.	Which downstream reports, dashboards, or ML models rely on these fields and need to be re-validated?