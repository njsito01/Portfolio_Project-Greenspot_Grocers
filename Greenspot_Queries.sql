

# Queries to test that the tables loaded as expected

SELECT *
FROM purchases p
JOIN items i
	ON p.item_number = i.item_number
JOIN vendors v
	ON p.vendor_id = v.vendor_id
;

SELECT *
FROM sales s
JOIN items i
	ON s.item_number = i.item_number
;

# All tables in one query

WITH transactions AS (
	SELECT
		trans_type,
		purchase_id AS trans_num,
		vendor_id AS vendor_or_customer_id,
		item_number,
		date_purchased AS trans_dt,
		quantity_purchased AS quantity,
		cost_per_unit AS amount
	FROM purchases
	UNION ALL
	SELECT
		trans_type,
		sale_id AS trans_num,
		customer_id AS vendor_or_customer_id,
		item_number,
		date_sold AS trans_dt,
		quantity_sold AS quantity,
		price_per_unit AS amount
	FROM sales)
SELECT *
FROM transactions t
JOIN items i
	ON t.item_number = i.item_number
JOIN vendors v
	ON i.vendor_id = v.vendor_id
;



/* 
	Business Questions
    
	1. What are the best selling item types, by volume and by revenue?
    2. Which vendor's products sell the most, by volume and revenue?
    3. Which products from each vendor have the highest profit margin?

*/

# 1. What are the best selling item types, by volume and by revenue?

SELECT *
FROM sales s
JOIN items i
	ON s.item_number = i.item_number
;

SELECT
	i.item_type,
    SUM(s.quantity_sold) AS total_qty_sold,
    SUM(s.quantity_sold * s.price_per_unit) AS total_revenue
FROM sales s
JOIN items i
	ON s.item_number = i.item_number
GROUP BY i.item_type
ORDER BY i.item_type
;

# Canned items sell the highest volume, and Produce sells the highest revenue

# 2. Which vendor's products sell the most, by volume and revenue?

SELECT *
FROM sales s
JOIN items i
	ON s.item_number = i.item_number
JOIN vendors v
	ON i.vendor_id = v.vendor_id
;

# Volume
WITH sales_totals AS (
SELECT
	v.vendor_id,
    v.vendor_name,
    i.item_number,
    i.item_desc,
    SUM(s.quantity_sold) AS total_qty_sold,
    SUM(s.quantity_sold * s.price_per_unit) AS total_revenue
FROM sales s
JOIN items i
	ON s.item_number = i.item_number
JOIN vendors v
	ON i.vendor_id = v.vendor_id
GROUP BY v.vendor_id, i.item_number
)
SELECT
	vendor_name,
    item_desc,
    total_qty_sold
FROM sales_totals
WHERE (vendor_name, total_qty_sold) IN
		(SELECT
			vendor_name,
			MAX(total_qty_sold)
		FROM sales_totals
		GROUP BY vendor_name)
;

# Revenue

WITH sales_totals AS (
SELECT
	v.vendor_id,
    v.vendor_name,
    i.item_number,
    i.item_desc,
    SUM(s.quantity_sold) AS total_qty_sold,
    SUM(s.quantity_sold * s.price_per_unit) AS total_revenue
FROM sales s
JOIN items i
	ON s.item_number = i.item_number
JOIN vendors v
	ON i.vendor_id = v.vendor_id
GROUP BY v.vendor_id, i.item_number
)
SELECT
	vendor_name,
    item_desc,
    total_revenue
FROM sales_totals
WHERE (vendor_name, total_revenue) IN
		(SELECT
			vendor_name,
			MAX(total_revenue)
		FROM sales_totals
		GROUP BY vendor_name)
;

/*
	By Volume:
	Bennet Farms - Bennet Farm free-range eggs
    Freshness, Inc. - Freshness White beans
	Ruby Redd Produce, LLC - Ruby's Organic Kale
    
    By Revenue:
    Bennet Farms - Bennet Farm free-range eggs
    Freshness, Inc. - Freshness White beans
	Ruby Redd Produce, LLC - Ruby's Organic Kale
*/



# 3. Which products from each vendor have the highest profit margin?

# sum the total $ amount of sales by item
# sum the total $ amount for purchases by item? or since the volume sold doesn't equal the volume purchased, maybe average? 


# Revenue

SELECT *
FROM sales
;

SELECT
	item_number,
    SUM(quantity_sold) AS volume_sold,
    SUM(quantity_sold * price_per_unit) AS total_revenue,
    ROUND(SUM(quantity_sold * price_per_unit) / SUM(quantity_sold), 2) AS adj_unit_price
FROM sales
GROUP BY item_number
;


# Cost

SELECT *
FROM purchases
;

SELECT
	item_number,
    SUM(quantity_purchased) AS volume_bought,
    SUM(quantity_purchased * cost_per_unit) AS total_cost,
    ROUND(SUM(quantity_purchased * cost_per_unit) / SUM(quantity_purchased), 2) AS adj_unit_cost
FROM purchases
GROUP BY item_number
;

# Margin

WITH purchase_totals AS (
	SELECT
		item_number,
		SUM(quantity_purchased) AS volume_bought,
		SUM(quantity_purchased * cost_per_unit) AS total_cost,
		ROUND(SUM(quantity_purchased * cost_per_unit) / SUM(quantity_purchased), 2) AS adj_unit_cost
	FROM purchases
	GROUP BY item_number
), margins AS (
	SELECT
		v.vendor_name,
		s.item_number,
		i.item_desc,
		ROUND(SUM(quantity_sold * price_per_unit) / SUM(quantity_sold), 2) AS adj_unit_price,
		pt.adj_unit_cost,
		ROUND(SUM(quantity_sold * price_per_unit) / SUM(quantity_sold), 2) - pt.adj_unit_cost AS profit_margin_per_unit
	FROM sales s
	JOIN purchase_totals pt
	JOIN items i
	JOIN vendors v
		ON s.item_number = pt.item_number
		AND s.item_number = i.item_number
		AND i.vendor_id = v.vendor_id
	GROUP BY s.item_number
)
# items with highest margins, by vendor
SELECT
	vendor_name,
    item_desc,
    profit_margin_per_unit
FROM margins
WHERE (vendor_name, profit_margin_per_unit) IN
	(SELECT
		vendor_name,
        MAX(profit_margin_per_unit)
	FROM margins
    GROUP BY vendor_name)
;

