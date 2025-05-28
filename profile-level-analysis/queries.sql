-- 1. Future Identify Count & Percentage
--    Firstly, I analyzed the data to infer the extraction date for the dataset
WITH extracted AS (
  SELECT
    DATE(
      LAST_SEEN_AT,
      printf('+%d days', INACTIVE_DAYS)
    ) AS extraction_date
  FROM profiles
  WHERE INACTIVE_DAYS >= 0
)
SELECT
  extraction_date,
  COUNT(*) AS profiles_count
FROM extracted
GROUP BY extraction_date
ORDER BY profiles_count DESC;

--    Next, the extraction_date serves as a yardstick for determining the Future Identify Count
--    This counts profiles whose LAST_IDENTIFY_AT is after the snapshot date (2025-05-16).
SELECT
  COUNT(*) AS total_profiles,
  SUM(
    CASE
      WHEN DATE(LAST_IDENTIFY_AT) > DATE('2025-05-16') THEN 1
      ELSE 0
    END
  ) AS future_identify_count,
  ROUND(
    100.0
    * SUM(CASE WHEN DATE(LAST_IDENTIFY_AT) > DATE('2025-05-16') THEN 1 ELSE 0 END)
    / COUNT(*),
    1
  ) AS pct_future_identify
FROM profiles;


-- 2. Negative Inactive Count & Percentage
--    This counts profiles whose INACTIVE_DAYS is negative.
SELECT
  COUNT(*) AS total_profiles,
  SUM(
    CASE
      WHEN INACTIVE_DAYS < 0 THEN 1
      ELSE 0
    END
  ) AS negative_inactive_count,
  ROUND(
    100.0
    * SUM(CASE WHEN INACTIVE_DAYS < 0 THEN 1 ELSE 0 END)
    / COUNT(*),
    1
  ) AS pct_negative_inactive
FROM profiles;