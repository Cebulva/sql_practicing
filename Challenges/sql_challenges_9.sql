/******************************************************************************
*******************************************************************************

SQL CHALLENGES 9

*******************************************************************************
******************************************************************************/


USE publications;


-- 1. Add a column showing how many characters are in each author's last name

SELECT LENGTH(au_lname) AS last_name_characters
FROM authors;

-- 2. What is the first name of each author in uppercase?

SELECT UPPER(au_fname) AS first_name_uppercase
FROM authors;

-- 3. Combine first and last names of authors into a single column.

SELECT CONCAT (au_fname, " ", au_lname)
FROM authors;

-- 4. Show the current date in a column called 'today'.

SELECT CURRENT_DATE() AS today
FROM authors;

-- 5. Calculate the difference in days between a book's publication date and today's date.

SELECT pubdate, DATEDIFF( CURRENT_DATE(), pubdate) AS difference
FROM titles;

-- 6. How many years has it been since each title was published?

SELECT pubdate, TIMESTAMPDIFF(YEAR, pubdate, CURRENT_DATE()) AS time_difference
FROM titles;     
    
-- 7. Find the publication year and month of each title in 'YYYY-MM' format.   

SELECT pubdate, DATE_FORMAT(pubdate, "%Y-%m") AS formatted_date
FROM titles;

-- 8. Concatenate the publisher's name and city into a single column. Separate them with a comma.

SELECT CONCAT(pub_name, " , ", city) AS name_city
FROM publishers;

-- 9. What is the longest title of a book?

SELECT MAX(LENGTH(title)) AS longest_title
FROM titles;
-- There are two titles with the same length so this is not a good solution

SELECT title, LENGTH(title) AS longest_title
FROM titles
ORDER BY longest_title DESC
LIMIT 2;

-- 10. Display the publication date of each title in 'Day-Month-Year' format. For example, '12-June-1991'.
 
 SELECT pubdate, DATE_FORMAT(pubdate, "%d-%m-%Y") AS formatted_pubdate
 FROM titles;
    
-- 11. List authors whose last name starts with 'C' and show the first 5 characters of their address.
    
 SELECT au_lname, address, SUBSTRING(address, 1, 5) AS short_address
 FROM authors
 WHERE au_lname LIKE "C%";

-- 12. Return the difference in days between the current date and the publication date of titles where the difference is greater than 1000 days.

SELECT DATEDIFF(CURRENT_DATE, pubdate) AS formatted_date
FROM titles
WHERE DATEDIFF(CURRENT_DATE, pubdate) > 1000;

/* Alternative with subquery which calculate the formatted_date in an earlier step, making it available for the WHERE clause of the outer query. 
This is often the preferred method for readability and maintainability, especially for complex queries.*/
SELECT formatted_date
FROM (SELECT DATEDIFF(CURRENT_DATE, pubdate) AS formatted_date FROM titles) AS date_diffs
WHERE formatted_date > 1000;

-- 13. Find the titles where the length of the title name is greater than the average length of all titles.

SELECT title
FROM titles
WHERE Length(title) > (SELECT AVG(LENGTH(title))FROM titles);

-- 14. Get the authors whose first name length is equal to their last name length.
    
SELECT au_fname, au_lname
FROM authors
WHERE LENGTH(au_fname) = LENGTH(au_lname);

-- 15. Find the longest city name among the authors' addresses.

SELECT city
FROM authors
WHERE LENGTH(city) = (SELECT MAX(LENGTH(city)) FROM authors)
LIMIT 1;

-- Better solution -> faster duration 1/3
SELECT city
FROM authors
ORDER BY LENGTH(city) DESC
LIMIT 1;

-- 16. Display titles and their publication dates formatted as 'Day of the Week, Month Day, Year'. For example, 'Wednesday, June 12, 1991'.
    
SELECT title, DATE_FORMAT(pubdate, "%W , %M %d, %Y") AS formatted_date
FROM titles;

-- 17. Calculate the difference in days between the first and last publication date for each author.

SELECT a.au_fname, a.au_lname, (SELECT DATEDIFF(MAX(pubdate), MIN(pubdate))) AS diff
FROM authors a
JOIN titleauthor ta USING (au_id)
JOIN titles t USING (title_id)
GROUP BY a.au_fname, a.au_lname;

