WITH LastTransactionDates AS (
    -- Find the last transaction date for each account
    SELECT
        p.id AS plan_id,
        p.owner_id AS owner_id,
        p.description AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM
        plans_plan AS p
    LEFT JOIN
        savings_savingsaccount AS s ON p.id = s.plan_id
    GROUP BY p.id, p.owner_id, p.description
),
InactivityDays AS (
    -- Calculate inactivity days for each account
    SELECT
        plan_id,
        owner_id,
        type,
        last_transaction_date,
        CASE
            WHEN last_transaction_date IS NULL THEN 366  -- handles null case
            ELSE DATEDIFF(CURDATE(), last_transaction_date)
        END AS inactivity_days
    FROM
        LastTransactionDates
)
-- Select accounts with no transactions in the last year
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM
    InactivityDays
WHERE
    inactivity_days > 365;
