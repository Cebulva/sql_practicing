/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 8

*******************************************************************************
*******************************************************************************


In the exercises below you will need to use the clauses you used in the
previous SQL Challenges, plus the following clauses:
    - Subqueries

*/

USE publications;

/*******************************************************************************
Subqueries

https://dev.mysql.com/doc/refman/8.4/en/subqueries.html
*******************************************************************************/


-- 1. Find the name of the publisher with the highest advance.

SELECT p.pub_name, t.advance
FROM publishers p
JOIN titles t USING(pub_id)
WHERE advance = (SELECT MAX(advance) FROM titles);

-- 2. List the titles of books published by publishers based in 'Boston'.


SELECT t.title, p.pub_name AS publisher, p.city AS city
FROM titles t
LEFT JOIN publishers p USING(pub_id)
WHERE p.city = (SELECT city FROM publishers WHERE city = "Boston");

-- Without a subquery
SELECT t.title, p.pub_name AS publisher, p.city AS city
FROM titles t
LEFT JOIN publishers p USING(pub_id)
WHERE p.city = "Boston";

-- 3. Find the authors who have written more than one book.

SELECT au_id, au_fname, au_lname
FROM authors
WHERE au_id IN
( 	
	SELECT au_id
	FROM titleauthor
	GROUP BY au_id
	HAVING COUNT(title_id) > 1
);

SELECT *
FROM titles;
SELECT *
FROM titleauthor;
SELECT *
FROM authors;

-- 4. List all authors and the number of books they have written.

SELECT au_fname, au_lname, 
(SELECT COUNT(*) FROM titleauthor ta WHERE ta.au_id = a.au_id) AS book_count 
FROM authors a;

-- 5. Find the titles with a price higher than the average price.

SELECT title, price
FROM titles
WHERE price > (SELECT AVG(price) FROM titles);

-- 6. Find the name of the publisher who has published the most books.

SELECT pub_name, (SELECT COUNT(pub_id) FROM titles t WHERE t.pub_id = p.pub_id ) AS pub_counter
FROM publishers p
ORDER BY pub_counter DESC
LIMIT 1;

SELECT *
FROM publishers;
-- 7. List the titles that have never been sold.

SELECT title, title_id
FROM titles
WHERE title_id NOT IN (SELECT title_id From sales);

-- 8. List all titles along with their publisher's name.

SELECT title, (SELECT pub_name FROM publishers p WHERE t.pub_id = p.pub_id) AS publisher_name
FROM titles t;


-- 9. List the employees who have the same job as 'Helen Bennett'.

SELECT fname, lname
FROM employee e
WHERE job_id IN (SELECT job_id FROM employee WHERE fname = "Helen" AND lname = "Bennett")
AND (fname != 'Helen' AND lname != 'Bennett');