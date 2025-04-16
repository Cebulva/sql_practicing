/******************************************************************************
*******************************************************************************

SQL CHALLENGES bonus 2

*******************************************************************************
*******************************************************************************/

USE publications;

-- 1. Using LEFT JOIN: in which cities has "Is Anger the Enemy?" been sold?

SELECT *
FROM stores;

SELECT *
FROM sales;

-- using CASE doesn't make sense here, because I don't need a new column for cities
SELECT
CASE
	WHEN title = "Is Anger the Enemy?" THEN st.city
    ELSE "none"
END AS city_anger
FROM stores st
LEFT JOIN sales sa ON st.stor_id = sa.stor_id
JOIN  titles t  USING (title_id)
GROUP BY city_anger
HAVING city_anger != "none";

-- Without CASE
SELECT st.city
FROM stores st
-- LEFT JOIN sales sa ON st.stor_id = sa.stor_id
JOIN sales sa USING (stor_id)
JOIN  titles t  USING (title_id)
WHERE title = "Is Anger the Enemy?";

/* 2. Select all the book titles that have a link to the employee Howard Snyder 
    (he works for the publisher that has published those books). */

SELECT t.title
FROM titles t
JOIN employee e ON t.pub_id = e.pub_id
WHERE e.fname = "Howard" AND e.lname = "Snyder";

-- It's more secure to join the publishers table inbetween two before joining the employee table
SELECT t.title
FROM titles t
JOIN publishers p ON t.pub_id = p.pub_id
JOIN employee e ON t.pub_id = e.pub_id
WHERE e.fname = "Howard" AND e.lname = "Snyder";

SELECT *
FROM titles;
SELECT *
FROM publishers;
SELECT *
FROM employee;

/* 3. Using the JOIN of your choice: Select the book title with highest number of 
   sales (qty) */

SELECT title, SUM(qty) AS total_sales
FROM sales
JOIN titles USING (title_id)
GROUP BY title
ORDER BY total_sales DESC
LIMIT 1;

/* 4. Select all book titles and the full name of their author(s).
      
      - If a book has multiple authors, all authors must be displayed (in 
      multiple rows).
      
      - Books with no authors and authors with no books should not be displayed.
*/

SELECT t.title, a.au_fname, a.au_lname
FROM titles t
LEFT JOIN titleauthor ta USING (title_id)
JOIN authors a USING (au_id);

SELECT *
FROM titleauthor;

/* 5. Select the full name of authors of Psychology books

   Bonus hint: if you want to prevent duplicates but allow authors with shared
   last names to be displayed, you can concatenate the first and last names
   with CONCAT(), and use the DISTINCT clause on the concatenated names. */

SELECT au_fname, au_lname
FROM authors
LEFT JOIN titleauthor USING (au_id)
JOIN titles t USING (title_id)
WHERE t.type = "psychology"
GROUP BY au_fname, au_lname;

SELECT
DISTINCT CONCAT(a.au_fname, " ", a.au_lname) AS full_name
FROM authors a
LEFT JOIN titleauthor USING (au_id)
JOIN titles t USING (title_id)
WHERE t.type = "psychology";

/* 6. Explore the table roysched and try to grasp the meaning of each column. 
   The notes below will help:
   
   - "Royalty" means the percentage of the sale price paid to the author(s).
   
   - Sometimes, the royalty may be smaller for the first few sales (which have
     to cover the publishing costs to the publisher) but higher for the sales 
     above a certain threshold.
     
   - In the "roysched" table each title_id can appear multiple times, with
     different royalty values for each range of sales.
     
   - Select all rows for particular title_id, for example "BU1111", and explore
	 the data. */

SELECT *
FROM roysched
WHERE title_id = "BU1111";


/* 7. Select all the book titles and the maximum royalty they can reach.
    Display only titles that are present in the roysched table. */
    
SELECT t.title, t.title_id, MAX(r.royalty) AS max_royalty
FROM roysched r
JOIN titles t USING(title_id)
GROUP BY t.title, t.title_id
ORDER BY max_royalty DESC;


SELECT *
FROM titles;
SELECT *
FROM roysched;
