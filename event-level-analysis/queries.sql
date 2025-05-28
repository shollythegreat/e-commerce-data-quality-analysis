-- Identify orders with invalid or missing data that may result in skewed derived financial data based on user events
-- Critical revenue fields should be positive and present
WITH financial_validation AS (
    SELECT 
        ORDER_ID,
        REVENUE,
        TAX,
        SHIPPING,
        TOTAL,
        USER_ID,
        ANONYMOUS_ID,
        CASE WHEN REVENUE IS NULL THEN 1 ELSE 0 END as missing_revenue,
        CASE WHEN REVENUE < 0 THEN 1 ELSE 0 END as negative_revenue,
        CASE WHEN TAX IS NULL THEN 1 ELSE 0 END as missing_tax,
        CASE WHEN TAX < 0 THEN 1 ELSE 0 END as negative_tax,
        CASE WHEN SHIPPING IS NULL THEN 1 ELSE 0 END as missing_shipping,
        CASE WHEN SHIPPING < 0 THEN 1 ELSE 0 END as negative_shipping,
        CASE WHEN TOTAL IS NULL THEN 1 ELSE 0 END as missing_total,
        CASE WHEN TOTAL <= 0 THEN 1 ELSE 0 END as zero_or_negative_total,
        -- Check if TOTAL = REVENUE + TAX + SHIPPING (basic validation)
        CASE WHEN REVENUE IS NOT NULL AND TAX IS NOT NULL AND SHIPPING IS NOT NULL AND TOTAL IS NOT NULL
             AND ABS(TOTAL - (REVENUE + TAX + SHIPPING)) > 1 THEN 1 ELSE 0 END as total_calculation_error
    FROM order_completed
)
SELECT 
    'Invalid Financial Data' as issue_category,
    COUNT(*) as total_orders,
    SUM(missing_revenue) as orders_missing_revenue,
    SUM(negative_revenue) as orders_negative_revenue,
    SUM(missing_total) as orders_missing_total,
    SUM(zero_or_negative_total) as orders_zero_negative_total,
    SUM(total_calculation_error) as orders_total_calc_error,
    ROUND(100.0 * SUM(zero_or_negative_total) / COUNT(*), 2) as pct_invalid_totals,
    ROUND(100.0 * SUM(total_calculation_error) / COUNT(*), 2) as pct_calculation_errors,
    SUM(CASE WHEN zero_or_negative_total = 1 THEN TOTAL ELSE 0 END) as invalid_total_amount
FROM financial_validation;