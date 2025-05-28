# Data-QA Take-Home - Task 2

## 🔍 What I Discovered
------------------------------------------
I identified several critical event-level data quality issues that compromise the integrity of customer journey tracking, revenue reporting, and user attribution. The most severe issue is the presence of orders with zero or negative total values, which directly impacts financial reporting accuracy. 

## 🔧 How I Discovered It
------------------------------------------
Using a SQL analysis, I aggregated TOTAL (cost per transaction) per user by summing REVENUE + SHIPPING + TAX from the order_completed table and compared it against TOTAL_REVENUE in the profiles table. I found:

 1,125 out of 1,170 orders (96.2%) have calculation errors where TOTAL ≠ REVENUE + TAX + SHIPPING. Only 45 orders (3.8%) have consistent financial calculations

 (Refer to queries.sql for full logic.)

## 📉 Why This Matters
------------------------------------------
This issue has broad downstream implications:

1. Revenue Reporting: 96.2% of orders cannot be reliably used for financial reconciliation

2. Business Intelligence: KPIs like Average Order Value (AOV) calculations are unreliable due to inconsistent totals

3. Financial Reconciliation: Cannot accurately reconcile platform revenue with payment processor data for the vast majority of orders

4. Audit Compliance: Financial audits will flag the massive discrepancy between totals and component calculations

5. Tax Reporting: Tax calculations may be incorrect if the TOTAL field is used instead of component values

6. Data Trust: Stakeholders will lose confidence in financial reporting when 96% of orders fail basic math validation

## 📌 Suggested Follow-Up Questions
------------------------------------------
 1. Which financial field should be considered authoritative - the TOTAL field or the calculated sum of REVENUE + TAX + SHIPPING? What system generates each of these values and at what point in the order lifecycle?

 2. How far back does this calculation inconsistency extend in our historical data, and what is the financial magnitude of the discrepancy across all affected orders?

 3. Which critical business processes, reports, and external systems (payment processors, accounting software, tax systems) currently rely on the TOTAL field versus component calculations?

 4. Are there legitimate business reasons for the discrepancy, such as promotions, discounts, rounding rules, loyalty credits, or fees that are applied to TOTAL but not captured in the component fields?

 5. Are current financial reports, executive dashboards, and regulatory filings using the TOTAL field or calculated components, and do we need to issue corrections for recent reporting periods?

 6. What is the acceptable timeline for resolving this issue, and what resources (engineering, business analysis, audit support) are available for investigating and correcting 96% of our order data?