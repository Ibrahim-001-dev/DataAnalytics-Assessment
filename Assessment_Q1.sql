SELECT
   u.id AS owner_id,
    concat(first_name, " ",last_name) AS name,
    COUNT(DISTINCT CASE WHEN p_savings.is_regular_savings = 1 THEN p_savings.id ELSE NULL END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p_savings.is_a_fund  = 1 THEN p_savings.id ELSE NULL END) AS investment_count,
    SUM(s.confirmed_amount) AS total_deposits
FROM
    users_customuser as u
JOIN
   savings_savingsaccount AS s ON u.id = s.owner_id
JOIN
    plans_plan AS p_savings ON u.id = p_savings.id -- Join for savings plans
JOIN
    plans_plan AS p_investment ON u.id = p_investment.owner_id -- Join for investment plans
GROUP BY
    u.id, u.NAME
ORDER BY
total_deposits DESC;

