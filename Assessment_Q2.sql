WITH MonthlyTransactions AS (
    -- Calculate transactions per customer per month
    SELECT
        s.id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS month,
        COUNT(*) AS transactions
    FROM
        savings_savingsaccount AS s
    JOIN
        users_customuser AS u ON s.id = u.id  -- Join with users_customuser
    GROUP BY
        s.id,
        DATE_FORMAT(s.transaction_date, '%Y-%m')
),
AverageMonthlyTransactions AS (
    -- Calculate average transactions per customer
    SELECT
        id,
        AVG(transactions) AS avg_transactions_per_month
    FROM
        MonthlyTransactions
    GROUP BY
        id
),
CategorizedCustomers AS (
    -- Categorize customers based on average transactions
    SELECT
        id,
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month >= 3 AND avg_transactions_per_month <= 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM
        AverageMonthlyTransactions
),
-- Final result: Count customers in each category
FinalResult AS (
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    AVG(avg_transactions_per_month) AS avg_transactions_per_month
FROM
    CategorizedCustomers
GROUP BY
    frequency_category
)
SELECT *
 FROM FinalResult
ORDER BY
    CASE
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
