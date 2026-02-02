/*
======================================================================

Project : Personal Finance Analytics
Author  : Rituraj Singh
Database : personal_finance_db

=====================================================================
*/


create database personal_finance_db;
USE personal_finance_db;
 
create table finance_transactions(
transactions_id int auto_increment primary key,
transaction_date date,
description varchar(255),
category varchar(50),
amount decimal(10,2),
abs_amount decimal(10,2),
transaction_type varchar(20),
txn_year int,
txn_month varchar(20),
years_month varchar(20)
);


-- 1. Total number of transactions

SELECT COUNT(*) AS total_transactions
FROM finance_transactions;


-- 2. Total expense amount

SELECT 
    SUM(abs_amount) AS total_expense
FROM finance_transactions
WHERE transaction_type = 'expense';


-- 3. Total income amount

SELECT 
    SUM(abs_amount) AS total_income
FROM finance_transactions
WHERE transaction_type = 'income';



-- 4. Monthly expense trend

SELECT 
    txn_year,
    txn_month,
    SUM(abs_amount) AS monthly_expense
FROM finance_transactions
WHERE transaction_type = 'expense'
GROUP BY txn_year, txn_month
ORDER BY txn_year, txn_month;



-- 5. Top 5 spending categories

SELECT 
    category,
    SUM(abs_amount) AS total_spent
FROM finance_transactions
WHERE transaction_type = 'expense'
GROUP BY category
ORDER BY total_spent DESC
LIMIT 5;



-- 6. Month with highest expense

SELECT 
    txn_year,
    txn_month,
    SUM(abs_amount) AS total_expense
FROM finance_transactions
WHERE transaction_type = 'expense'
GROUP BY txn_year, txn_month
ORDER BY total_expense DESC
LIMIT 1;



-- 7. Average monthly expense

SELECT 
    AVG(monthly_total) AS avg_monthly_expense
FROM (
    SELECT 
        txn_year,
        txn_month,
        SUM(abs_amount) AS monthly_total
    FROM finance_transactions
    WHERE transaction_type = 'expense'
    GROUP BY txn_year, txn_month
) t;


-- 8. Month-over-Month (MoM) Expense

SELECT 
    years_month,
    total_expense,
    total_expense -
    LAG(total_expense) OVER (ORDER BY years_month) AS mom_change
FROM (
    SELECT 
        years_month,
        SUM(abs_amount) AS total_expense
    FROM finance_transactions
    WHERE transaction_type = 'expense'
    GROUP BY years_month
) t;
