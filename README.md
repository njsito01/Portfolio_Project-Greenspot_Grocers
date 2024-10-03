# Portfolio_Project-Greenspot_Grocers
Design and develop a database for a fictional online grocery store that is growing rapidly and planning a major expansion.


Design and develop a database for a fictional online grocery store that is growing rapidly and planning a major expansion.



## Project Scenario

Greenspot Grocer is a small, family-owned online grocery store. Their current product data is stored in a spreadsheet format that has become unwieldy and will soon be unable to accommodate their growing inventory.



Original project and data can be found on Coursera



## Objectives




Examine the current data and reorganize it into relational tables using the modeling tool in MySQL Workbench.


Create and load the database with the sample data provided.


Test the database design and verify the design by generating SQL JOIN queries.


## Approach


### Database Design

I began this project by reviewing the original spreadsheet to determine how the data could be categorized, and broken into individual tables in a relational database. 


I decided to categorize the data into 4 tables:

- items - data pertaining to the products themselves, including the item reference number, descriptions, type of goods, inventory location, sale unit, and a vendor ID for where the product is sourced from


- sales - data describing individual sales, including a transaction number, customer ID, item reference number, date of sale, quantity of the item sold, the price per unit, and transaction type


- purchases - data regarding individual purchases for sourcing inventory, including a transaction reference number, vendor ID that the items were purchased from, item reference number, date of purchase, quantity purchased, cost per unit, and transaction type


- vendor - data about the vendors, including the vendor ID number, vendor name, and location information like address, city, state, and zip.



### Extended Entity Relationship Diagram

My next step was to model and build out an EER Diagram using MySQL Workbench. By taking the categories I'd previously organized and creating columns for the various data that corresponded to it, I created the following diagram and connected the tables by designating primary and foreign keys between them. Once the database was generated, I entered the data into their various tables and fields.







### Testing

To confirm that the data was input correctly and that the tables connected to each other properly, I developed several queries. Demonstrating best that all of the data can be retreived is the query below:

``` SQL

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
    FROM sales
)

SELECT *
FROM transactions t
JOIN items i
	ON t.item_number = i.item_number
JOIN vendors v
	ON i.vendor_id = v.vendor_id
;

```


The above query produced this result:







## Business Questions

To further test the database, I asked three questions to determine if the structure is applicable to potential business needs:







1. What are the best selling item types, by volume and by revenue?



2. Which vendor's products sell the most, by volume and revenue?



3. Which products from each vendor have the highest profit margin?



### What are the best selling item types, by volume and by revenue?

```SQL

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

```

Results:







item_type 



total_qty_sold



total_revenue





Canned



39



66.19





Dairy



8



44.92





Produce



17



106.83



### Which vendor's products sell the most, by volume and revenue?

By Volume:

```SQL

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
```

Results:







vendor_name



item_desc



total_qty_sold





Bennet Farms



Bennet Farms free-range eggs



8





Freshness, Inc.



Freshness White beans



14





Ruby Redd Produce, LLC



Ruby's Organic Kale



13



By Revenue:

```SQL
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
```

Results:







vendor_name



item_desc



total_revenue





Bennet Farms



Bennet Farm free-range eggs



44.92





Freshness, Inc.



Freshness White beans



20.86





Ruby Redd Produce, LLC



Ruby's Organic Kale



90.87



### Which products from each vendor have the highest profit margin?

```SQL
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
	ROUND(SUM(quantity_sold * price_per_unit) / SUM(quantity_sold), 2) - pt.adj_unit_cost AS       profit_margin_per_unit
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
```

Results:







vendor_name



item_desc



profit_margin_per_unit





Bennet Farms



Bennet Farms



3.27





Freshness, Inc.



Freshness Green beans



1.71





Ruby Redd Produce, LLC



Ruby's Organic Kale



4.80



## Insights and Conclusions

One of the biggest obstacles for this project was that all of the data was tracked in a single file.  There were two major factors that made this approach especially difficult:


Clarity - Without descriptions of the types of transactions, a sale could easily be confused with a stocking purchase, and categorization would rely solely on reviewing individual line items for context


Unwieldiness - Even if that context was added for clarity, it would quickly become such a large single file that it would be difficult to review


By converting the data into a relational database, we save ourselves the trouble of being quickly overwhelmed by an overabundance of information. By introducing reference numbers for sales, purchases, and vendors, we can easily digest the specific data we're seeing, and only pulling in extra data as needed, such as the item descriptions, or vendor addresses.


By separating the data into these categories, we now have built-in context that can allow us to perform specific analyses without extra organization or effort - If we need to analyze sales by product type, we don't need to remove columns having to do with where the products were sourced, or how many are in the inventory. This will also help Greenspot keep their data organized and consistent going forward, as there will be a specific place to input new information as it becomes necessary.



### Suggestions

Depending on business needs, I would suggest the following for next steps:

1. Build and flesh out a table for customer data

2. Create a new table that tracks on-hand inventory


  - This would involve re-designing the items table, such that the stocking location and quantity on hand is stored separately from the item descriptions, but I would suggest holding off until the next suggestion is also being enacted


3. Create procedures that allow a user to input sales or purchase orders

  - A core piece of this functionality would be to automatically create new reference numbers for each transaction

  - Additionally, this could be used to update the on-hand inventory depending on the type of orders input



Thank you!
