/******************************************************************************
*******************************************************************************

SQL CHALLENGES 10

*******************************************************************************
******************************************************************************/


USE publications;


-- 1. What's the difference between highest and lowest price of titles
    
    SELECT MAX(price) - MIN(price) AS price_diff
    FROM titles;
    
-- 2. Find titles where the total number of books sold is an even number.

SELECT*
FROM titles;
SELECT *
FROM sales;

SELECT title, qty
FROM sales s
JOIN titles t USING (title_id)
WHERE qty % 2 = 0;
-- There are multiple rows for the same title_id so this doesn't work

SELECT title
FROM sales s
JOIN titles t USING (title_id)
GROUP BY t.title
HAVING SUM(qty) % 2 = 0;

-- 3. Calculate the total revenue by multiplying the quantity sold by the price for each title.

SELECT title, SUM(qty * price) AS total_revenue
FROM sales s
JOIN titles t USING (title_id)
GROUP BY title;

-- 4. Cheryl Carson and Charlene Locksley got married, what is their collective revenue?

SELECT SUM(price * (royalty / 100) * ytd_sales * (royaltyper / 100)) AS total_revenue
FROM authors a
JOIN titleauthor ta USING (au_id)
JOIN titles t USING (title_id)
WHERE au_fname = "Cheryl" AND au_lname = "Carson" OR au_fname = "Charlene" AND au_lname = "Locksley";
  
SELECT *
FROM authors a
JOIN titleauthor ta USING (au_id)
JOIN titles t USING (title_id); 

-- 5. Calculate the total number of books published by the publishers '0736' and '0877':

SELECT COUNT(pub_id) AS total_number
FROM publishers p
JOIN titles t USING(pub_id)
WHERE pub_id = "0736" OR pub_id = "0877";

SELECT pub_id, COUNT(pub_id) AS total_number
FROM publishers p
JOIN titles t USING(pub_id)
WHERE pub_id = "0736" OR pub_id = "0877"
GROUP BY pub_id;

-- 6. Find all of the books that are more than 10% above the average price of a book in the dataset

SELECT title, price
FROM titles
WHERE price > (SELECT AVG(price) * 1.1 FROM titles);
