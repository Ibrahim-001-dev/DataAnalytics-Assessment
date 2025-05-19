# DataAnalytics-Assessment
SQL Assessment Submission

This repository contains my submission for the SQL assessment.

# Approach to Assessment_Q1
SELECT
   u.id AS owner_id,
   concat(first_name, " ",last_name) AS name,
   
The above Gets the user's ID and full name.

   COUNT(DISTINCT CASE WHEN p_savings.is_regular_savings = 1 THEN p_savings.id ELSE NULL END) AS savings_count,
   COUNT(DISTINCT CASE WHEN p_savings.is_a_fund = 1 THEN p_savings.id ELSE NULL END) AS investment_count,

Used conditional aggregation to count:
How many regular savings plans the user has (is_regular_savings = 1)
How many investment plans (is_a_fund = 1)
Used DISTINCT to avoid double-counting in case of joins.

SUM(s.confirmed_amount) AS total_deposits
The above query is to get Total confirmed deposits from the savings account.

FROM users_customuser AS u
JOIN savings_savingsaccount AS s ON u.id = s.owner_id
JOIN plans_plan AS p_savings ON u.id = p_savings.id
JOIN plans_plan AS p_investment ON u.id = p_investment.owner_id

# Approach to Assessment_Q2
SELECT s.id, DATE_FORMAT(s.transaction_date, '%Y-%m') AS month, COUNT(*) AS transactions
For each customer, I calculated how many transactions they made each month.
I grouped the data by customer ID and month using DATE_FORMAT.
Note: The join s.id = u.id is likely incorrect unless the s.id represents the user ID; typically, you'd expect something like s.owner_id = u.id.
I calculated the average number of monthly transactions per customer.
This gives a single figure for each customer representing their average monthly activity.
I classified each customer based on their average monthly transactions:
High Frequency: 10 or more
Medium Frequency: 3–9
Low Frequency: Less than 3
Aggregated the data by frequency category:
Counted how many customers fall into each category.
Calculated the average monthly transaction rate within each category.
Ordered the final result logically:
High Frequency first
Medium second
Low last
The modular use of CTEs makes it clear, maintainable, and easy to debug or enhance in future iterations.

# Challenges to Assessment_Q3 and solution

Month formatting	- Used DATE_FORMAT with %Y-%m to consistently group by month.
Accurate categorization	- Used clear thresholds and CASE to ensure proper customer segmentation.

# Approach to Assessment_Q3
To solve this, I structured the query using two Common Table Expressions (CTEs) followed by a final selection:
Retrieve the most recent transaction date for each plan.
Use a LEFT JOIN so that even plans with no transactions are included (returns NULL for such cases).
Group by plan_id, owner_id, and type (description) to ensure each record is distinct per plan.
This handles both active and inactive accounts.

# Challenges to Assessment_Q3 and solution

Plans with no transactions -	Used LEFT JOIN + CASE to assign 366 days inactivity.
Wrong join could exclude data - Ensured join is on p.id = s.plan_id, the correct foreign key.
Misleading transaction dates - Used MAX(s.transaction_date) to reliably pick the latest.
Inconsistent timezones/dates - Used CURDATE() assuming consistent server time.

# Approach to Assessment_Q4
The query aims to estimate the Customer Lifetime Value (CLV) by combining customer tenure, transaction frequency, and average transaction value. This metric is valuable for identifying high-value customers and optimizing marketing, retention, and growth strategies.
Estimated how long a customer has been active in months.
Used MAX(s.transaction_date) as a proxy for "last active date".
Subtracts u.date_joined from that date, and divides by 12 to convert from days to months (rough approximation).
Counted the total number of transactions per customer.
Computed the average value of those transactions to use in CLV calculation.
Estimated Annual Revenue from a customer:
(tc.total_transactions / ct.tenure_months) * 12 gives an annualized transaction count.
Multiplied by average transaction value.
Multiplied by 0.001 (0.1%) as the assumed profit margin per transaction.
This is a simplified predictive model of CLV:
CLV = (Annual Transactions) × (Profit per Transaction)
Assumes stable behavior over time and consistent margins.

# Challenges to Assessment_Q4 and solution
Inexact date-to-month conversion	- Used simple DATEDIFF / 12 approximation; can improve with TIMESTAMPDIFF(MONTH, ...)
Missing transactions for new users - Customers with 0 transactions are naturally excluded due to the JOIN logic.
