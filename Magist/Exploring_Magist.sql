-- Exploring magist database
USE magist;

-- How many orders are there in the dataset?
SELECT COUNT(order_id) AS order_counter
FROM orders;

-- Are orders actually delivered? 
SELECT order_status, COUNT(order_status) AS order_counter
FROM orders
GROUP BY order_status;

SELECT total_orders, not_delivered_count, (not_delivered_count / total_orders) * 100 AS not_delivered_per 
FROM (
	SELECT
		COUNT(CASE WHEN order_status != "delivered" THEN 1 END) AS not_delivered_count,
        COUNT(order_id) AS total_orders
	FROM orders
    ) AS subquery;
    
-- Is Magist having user growth? 
SELECT order_year, COUNT(order_year) AS year_counter
FROM (
	SELECT
		YEAR(order_purchase_timestamp) AS order_year
	FROM orders
    ) AS subquery
GROUP BY order_year
ORDER BY order_year DESC;

SELECT YEAR(order_purchase_timestamp) AS year_, MONTH(order_purchase_timestamp) AS month_, COUNT(customer_id) AS counter
FROM orders
GROUP BY year_, month_
ORDER BY year_ DESC, month_ DESC;

-- How many products are there on the products table? 

SELECT COUNT(DISTINCT product_id) AS product_counter
FROM products;

-- Which are the categories with the most products? 

SELECT product_category_name, COUNT(product_category_name) AS product_counter
FROM products
GROUP BY product_category_name
ORDER BY product_counter DESC;

-- How many of those products were present in actual transactions? 

SELECT COUNT(DISTINCT p.product_id) AS product_counter_transactions
FROM order_items oi
JOIN products p ON (oi.product_id = p.product_id);

-- What’s the price for the most expensive and cheapest products? 

(SELECT "Most Expensive" AS type, product_id, price
FROM order_items
ORDER BY price DESC
LIMIT 1)

UNION

(SELECT "Cheapest" AS type, product_id, price
FROM order_items
-- GROUP BY product_id, price
ORDER BY price
LIMIT 1);

-- What are the highest and lowest payment values? 
(SELECT "highest payment value" AS `type`, order_id, ROUND(total_payment,2) AS "total payment"
FROM(
SELECT order_id, SUM(payment_value) AS total_payment
FROM order_payments
GROUP BY order_id
	) AS order_totals
WHERE total_payment = (SELECT MAX(total_payment) FROM (
											SELECT SUM(payment_value) AS total_payment
											FROM order_payments
											GROUP BY order_id
														) AS max_total))
                                                        
UNION ALL

(SELECT "lowest payment value" AS `type`, order_id, total_payment
FROM(
SELECT order_id, SUM(payment_value) AS total_payment
FROM order_payments
GROUP BY order_id
	) AS order_totals
WHERE total_payment = (SELECT MIN(total_payment) FROM (
											SELECT SUM(payment_value) AS total_payment
											FROM order_payments
											GROUP BY order_id
														) AS min_total));


-- simpler but will only return one order_id, even if there are multiple order_ids that have the exact same highest total payment.                                               
SELECT order_id, SUM(payment_value) AS total_payment
FROM order_payments
GROUP BY order_id
ORDER BY total_payment DESC
LIMIT 1;


-- How many products does every category have?
SELECT product_category_name_english, COUNT(product_category_name_english) AS counter
FROM product_category_name_translation
JOIN products USING (product_category_name)
GROUP BY product_category_name_english
ORDER BY counter DESC;


-- How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?

-- Filter out the tech categories
SELECT product_category_name, product_category_name_english, COUNT(product_category_name_english) AS counter
FROM product_category_name_translation
JOIN products USING (product_category_name)
GROUP BY product_category_name, product_category_name_english
HAVING product_category_name_english IN ("telephony","electronics","computers_accessories","computers")
ORDER BY counter DESC;

-- Sum up all the tech categories                    
 SELECT SUM(counter) AS tech_product_counter
 FROM 	(
	SELECT product_category_name_english, COUNT(product_category_name_english) AS counter
	FROM product_category_name_translation
	JOIN products USING (product_category_name)
	GROUP BY product_category_name_english
	HAVING product_category_name_english IN ("telephony","electronics","computers_accessories","computers")
		) AS tech_categories_counter;

-- Alternative with using a CASE clause
SELECT
    SUM(CASE
        WHEN pct.product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers") THEN 1
        ELSE 0
    END) AS tech_product_counter
FROM
    product_category_name_translation pct
JOIN
    products p ON pct.product_category_name = p.product_category_name;
                   
-- What percentage does that represent from the overall number of products sold?

SELECT
    COUNT(DISTINCT product_id) AS total_products_count, -- calculates the amount of all products
    SUM(CASE -- calculates the amount of tech products
        WHEN pct.product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers") THEN 1
        ELSE 0
    END) AS tech_products_count, 
    (SUM(CASE -- calculates the percentage value
        WHEN pct.product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers") THEN 1
        ELSE 0
    END) * 100) / COUNT(DISTINCT product_id) AS percentage
FROM
    product_category_name_translation pct
JOIN
    products p ON pct.product_category_name = p.product_category_name;
    
-- More elegant way to avoid repeating the SUM(CASE ... END) clause
SELECT total_products_count, tech_product_count, (tech_product_count / total_products_count) * 100 AS percentage
FROM (
	SELECT COUNT(DISTINCT product_id) AS total_products_count, 
    SUM(CASE
		WHEN pct.product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers") THEN 1
		ELSE 0
    END) AS tech_product_count
    FROM product_category_name_translation pct
    JOIN products p ON pct.product_category_name = p.product_category_name
    ) AS subquery;
    
-- How many products of these tech categories have been sold (within the time window of the database snapshot)?

(SELECT "All products" AS `type`, COUNT(product_category_name_english) AS products_sold
FROM order_items oi
JOIN products p USING (product_id)
JOIN product_category_name_translation USING (product_category_name))
UNION
(SELECT "Tech products" AS `type`, COUNT(product_category_name_english) AS tech_product_sold_counter
FROM order_items oi
JOIN products p USING (product_id)
JOIN product_category_name_translation USING (product_category_name)
WHERE product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers"));


SELECT *
FROM order_items;
-- More elegant way in a single query

SELECT 
	COUNT(CASE
		WHEN product_category_name_english IS NOT NULL THEN 1
        ELSE NULL
			END) AS all_products_sold,
	COUNT(CASE
		WHEN product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers") THEN 1
        ELSE NULL
			END) AS tech_products_sold
FROM order_items oi
JOIN products p USING (product_id)
JOIN product_category_name_translation pct USING (product_category_name);

-- What percentage does that represent from the overall number of products sold?
	
SELECT all_products_sold, tech_products_sold, (tech_products_sold * 100) / all_products_sold AS percentage
FROM 	(
	SELECT 
	COUNT(CASE
		WHEN product_category_name_english IS NOT NULL THEN oi.product_id
        ELSE NULL
			END) AS all_products_sold,
	COUNT(CASE
		WHEN product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers") THEN oi.product_id
        ELSE NULL
		END) AS tech_products_sold
FROM order_items oi
JOIN products p USING (product_id)
JOIN product_category_name_translation pct USING (product_category_name)
		) AS subquery;
        
-- What’s the average price of the products being sold?

SELECT ROUND(AVG(price),2) AS avg_product_price
FROM	(
SELECT product_id, price
FROM products p
JOIN order_items oi USING (product_id)
JOIN product_category_name_translation pct USING (product_category_name)
GROUP BY product_id, price
		) AS subquery;
        
SELECT ROUND(AVG(price),2) AS avg_tech_product_price
FROM (
SELECT product_id, price
FROM products p
JOIN order_items oi USING (product_id)
JOIN product_category_name_translation pct USING (product_category_name)
WHERE product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers")
GROUP BY product_id, price
	) AS subquery;
        
/*
SELECT
    (SELECT ROUND(AVG(oi.price), 2) FROM order_items oi) AS products_avg,
    (SELECT ROUND(AVG(oi.price), 2)
     FROM order_items oi
     JOIN products p ON oi.product_id = p.product_id
     WHERE p.product_category_name IN (SELECT product_category_name FROM product_category_name_translation WHERE product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers"))) AS tech_products_avg
FROM
    (SELECT 1) AS dummy_table;
*/
    
-- Are expensive tech products popular?

-- Getting Max and Min price for tech products    
SELECT MAX(price) AS tech_max_price, Min(price) AS tech_min_price
FROM products p
JOIN order_items oi USING (product_id)
JOIN product_category_name_translation pct USING (product_category_name)
WHERE product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers");

SELECT price_category, COUNT(price_category) AS counter
FROM	(
SELECT
	CASE 
		-- WHEN price BETWEEN 378 AND 702 THEN "+- 30% of avg 540€" 
        WHEN price < 20 THEN "very_low_price 0-20"
		WHEN price < 50 THEN "low_price 20-50"
		WHEN price < 378 THEN "average_price 50-378"
        WHEN price < 702 THEN "30% +- Avg. item price 540€"
        WHEN price < 2000 THEN "high_price 702-2000"
		WHEN price < 6800 THEN "very_high_price 2000-6800"
	END AS price_category
FROM order_items oi
JOIN products p USING(product_id)
JOIN product_category_name_translation pct USING (product_category_name)
WHERE product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers")
		) AS subquery
GROUP BY price_category
ORDER BY counter DESC;


-- Calculating the percentage of our avg item price 

SELECT tech_order_counter, items_in_price_range_counter, (items_in_price_range_counter * 100) / tech_order_counter AS percentage
FROM	(
SELECT
	COUNT(CASE WHEN price BETWEEN 378 AND 702 THEN 1 ELSE NULL END) AS items_in_price_range_counter,
    COUNT(price) AS tech_order_counter
FROM order_items oi
JOIN products p USING(product_id)
JOIN product_category_name_translation pct USING (product_category_name)
WHERE product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers")
		) AS subquery;

-- What's the average order price for orders with tech products in it?
SELECT ROUND(AVG(price),2) AS avg_tech_order_price
FROM 	(
SELECT order_id, price
FROM order_items oi
JOIN products p USING(product_id)
JOIN product_category_name_translation pct USING (product_category_name)
WHERE product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers")
GROUP BY order_id, price
		) AS subquery;
        
-- Check how many tech products got sold within the time window ordered by months

SELECT YEAR(order_purchase_timestamp) AS year_, MONTH(order_purchase_timestamp) AS month_,
	COUNT(CASE
		WHEN product_category_name_english IS NOT NULL THEN 1
        ELSE NULL
			END) AS all_products_sold,
	COUNT(CASE
		WHEN product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers") THEN 1
        ELSE NULL
			END) AS tech_products_sold
FROM order_items oi
JOIN orders o USING (order_id)
JOIN products p USING (product_id)
JOIN product_category_name_translation pct USING (product_category_name)
GROUP BY year_, month_
ORDER BY year_ DESC, month_ DESC;

-- Check for tech product reviews recommendation - review_comment_title

SELECT review_comment_title, COUNT(review_comment_title) AS counter
FROM order_reviews orev
JOIN orders o USING (order_id)
JOIN order_items oi USING (order_id)
JOIN products p USING (product_id)
JOIN product_category_name_translation pct USING (product_category_name)
WHERE product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers") AND review_comment_title IS NOT NULL
GROUP BY review_comment_title
ORDER BY counter DESC;

-- Check for specific words
SELECT
	COUNT(CASE WHEN review_comment_title LIKE "%recomend%" OR review_comment_title LIKE "%ok%" OR review_comment_title LIKE "%Ótimo%" OR review_comment_title LIKE "%bom%"  THEN 1 END) AS positive_review_comments, 
	COUNT(CASE WHEN review_comment_message LIKE "%recomend%" OR review_comment_message LIKE "%ok%" OR review_comment_message LIKE "%Ótimo%" OR review_comment_message LIKE "%bom%"  THEN 1 END) AS positive_review_messages,
    COUNT(CASE WHEN review_comment_title LIKE "%negativ%" OR review_comment_title LIKE "%errado%" OR review_comment_title LIKE "%Péssimo%"  THEN 1 END) AS negative_review_comments,
	COUNT(CASE WHEN review_comment_message LIKE "%negativ%" OR review_comment_message LIKE "%errado%" OR review_comment_message LIKE "%Péssimo%"  THEN 1 END) AS negative_review_messages
FROM order_reviews orev
JOIN orders o USING (order_id)
JOIN order_items oi USING (order_id)
JOIN products p USING (product_id)
JOIN product_category_name_translation pct USING (product_category_name)
WHERE product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers") AND review_comment_title IS NOT NULL;

-- Sum Up positive and negative reviews
SELECT (positive_review_comments + positive_review_comments) AS positive_reviews, (negative_review_comments + negative_review_messages) AS negative_reviews, 
((negative_review_comments + negative_review_messages)*100)/(positive_review_comments + positive_review_comments + negative_review_comments + negative_review_messages) AS negative_percentage
FROM	(
	SELECT
	COUNT(CASE WHEN review_comment_title LIKE "%recomend%" OR review_comment_title LIKE "%ok%" OR review_comment_title LIKE "%Ótimo%" OR review_comment_title LIKE "%bom%"  THEN 1 END) AS positive_review_comments, 
	COUNT(CASE WHEN review_comment_message LIKE "%recomend%" OR review_comment_message LIKE "%ok%" OR review_comment_message LIKE "%Ótimo%" OR review_comment_message LIKE "%bom%"  THEN 1 END) AS positive_review_messages,
    COUNT(CASE WHEN review_comment_title LIKE "%negativ%" OR review_comment_title LIKE "%errado%" OR review_comment_title LIKE "%Péssimo%"  THEN 1 END) AS negative_review_comments,
	COUNT(CASE WHEN review_comment_message LIKE "%negativ%" OR review_comment_message LIKE "%errado%" OR review_comment_message LIKE "%Péssimo%"  THEN 1 END) AS negative_review_messages
	FROM order_reviews orev
	JOIN orders o USING (order_id)
	JOIN order_items oi USING (order_id)
	JOIN products p USING (product_id)
	JOIN product_category_name_translation pct USING (product_category_name)
	WHERE product_category_name_english IN ("telephony", "electronics", "computers_accessories", "computers") AND review_comment_title IS NOT NULL
		) AS subquery;
	