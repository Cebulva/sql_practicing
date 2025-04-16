/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 5

*******************************************************************************
*******************************************************************************

In the exercises below you will need to use the following clauses:
    - GROUP BY
    - HAVING
------------------------------------------------------------------------------------------------

*/

USE publications;

/*******************************************************************************
GROUP BY

https://www.w3schools.com/sql/sql_groupby.asp
*******************************************************************************/

-- 1. Find the total amount of authors for each state

SELECT state, COUNT(*)
FROM authors
GROUP BY state;

/* 2. Find the total amount of authors by each state and order them in 
    descending order */

SELECT state, COUNT(*) AS "state counter"
FROM authors
GROUP BY state
ORDER BY COUNT(*) DESC;

-- 3. What's the price of the most expensive title from each publisher?

SELECT pub_id, MAX(price)
FROM titles
GROUP BY pub_id;

-- 4. Find out the top 3 stores with the most sales

SELECT stor_id, SUM(qty)
FROM sales
GROUP BY stor_id
ORDER BY SUM(qty) DESC
LIMIT 3;

/* 5. Find the average job level for each job_id from the employees table.
    Order the jobs in ascending order by its average job level. */

SELECT job_id, AVG(job_lvl)
FROM employee
GROUP BY job_id
ORDER BY AVG(job_lvl);

/* 6. For each type (business, psychology…), find out how many books each
    publisher has. */

-- How many books does every publisher has
SELECT pub_id, COUNT(*) AS book_amount
FROM titles
WHERE type IN("business","psychology","trad_cook","business","mod_cook","popular_comp","UNDECIDED")
GROUP BY pub_id;

SELECT pub_id, COUNT(type) AS book_amount
FROM titles
GROUP BY pub_id
ORDER BY pub_id;

SELECT *
FROM titles;

-- How many books does each publisher have for each type of book
SELECT pub_id,`type`, COUNT(type) AS amount_of_books
FROM titles
GROUP BY pub_id, `type`
ORDER BY pub_id;

SELECT* 
FROM titles;
Error Code: 1055. Expression #2 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'publications.titles.type' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
Error Code: 1055. Expression #1 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'publications.titles.title' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by


/* 7. Add the average price of each publisher - book type combination from your
   previous query */

SELECT pub_id,`type`, COUNT(*) AS amount_of_books, AVG(price) AS avg_price
FROM titles
GROUP BY pub_id,`type`
ORDER BY pub_id;

/*******************************************************************************
HAVING

https://www.w3schools.com/sql/sql_having.asp
*******************************************************************************/

/* 8. From your previous query, keep only the combinations of publisher - book
   type with an average price higher than 12 */

SELECT pub_id,`type`, COUNT(*) AS amount_of_books, AVG(price) AS avg_price
FROM titles
GROUP BY pub_id, `type`
HAVING avg_price > 12
ORDER BY pub_id;

Error Code: 1055. Expression #1 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'publications.titles.pub_id' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by


/* 9. Order the results of your previous query by these two criteria:
      1. Count of books, descendingly
      2. Average price, descendingly */

SELECT pub_id,`type`, COUNT(*) AS amount_books, AVG(price) AS avg_price
FROM titles
GROUP BY pub_id,`type`
HAVING avg_price > 12
ORDER BY amount_books DESC, avg_price DESC;

/* 10. Some authors have a contract, while others don't - it's indicated in the
     "contract" column of the authors table.
     
     Select all the states and cities where there are 2 or more contracts  contracts >= 2
     overall */

SELECT state, city, SUM(contract) AS enough_contracts
FROM authors
GROUP BY state, city
HAVING enough_contracts >= 2;


-- Showing just the state and the city
SELECT state, city
FROM authors
GROUP BY state, city
HAVING SUM(contract) >= 2;

/* 
The main difference between WHERE and HAVING is that:
    - the WHERE clause is used to specify a condition for filtering most records
    - the HAVING clause is used to specify a condition for filtering values from 
      an aggregate (such as MAX(), AVG(), COUNT() etc...)
 */

