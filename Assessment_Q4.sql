WITH CustomerTenure AS (
    -- Calculate account tenure in months
    SELECT
        u.id AS customer_id,
        concat(u.first_name, " ",u.last_name) AS name,
        CAST(MAX(s.transaction_date) - (u.date_joined) AS REAL) /12 AS tenure_months -- Approximate months
    FROM
        users_customuser AS u
    JOIN
        savings_savingsaccount AS s ON u.id = s.owner_id
    GROUP BY
        u.id
),
TransactionCounts AS (
    -- Calculate total transactions per customer
    SELECT
        u.id AS customer_id,
        COUNT(s.owner_id) AS total_transactions,
        AVG(s.confirmed_amount) as avg_transaction_value
    FROM
        users_customuser AS u
    JOIN
        savings_savingsaccount AS s ON u.id = s.owner_id
    GROUP BY
        u.id
)
-- Calculate and order CLV
SELECT
 ct.customer_id,
    ct.name,
   ct.tenure_months  as tenure_months,
   tc.total_transactions,
    (tc.total_transactions /ct.tenure_months) * 12 * (0.001 * tc.avg_transaction_value) AS estimated_clv -- 0.1% profit
FROM
    CustomerTenure AS ct
JOIN
    TransactionCounts AS tc ON ct.customer_id = tc.customer_id
ORDER BY
    estimated_clv DESC;
