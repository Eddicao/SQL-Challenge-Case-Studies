# Case #7: Balanced Tree - Tree Clothing 

Remarked Sunday 30 June 2024 

<img src="" alt="Image" width="500" height="520">

## 📜 Table of Contents
- [Business Task](#business-task)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Key Questions and Analysis](#key-questions-and-analysis)

All the information regarding the SQL case studies have been sourced from the following link: [here](https://8weeksqlchallenge.com/case-study-7/). 

***

## Business Task

Balanced Tree Clothing Company prides themselves on providing an optimised range of clothing and lifestyle wear for the modern adventurer!

Danny, the CEO of this trendy fashion company has asked you to assist the team’s merchandising teams **analyse their sales performance and generate a basic financial report** to share with the wider business.

## Entity Relationship Diagram

<img width="932" alt="image" src="">

**Table 1: `product_details`**

|product_id|price|product_name|category_id|segment_id|style_id|category_name|segment_name|style_name|
|:----|:----|:----|:----|:----|:----|:----|:----|:----|
|c4a632|13|Navy Oversized Jeans - Womens|1|3|7|Womens|Jeans|Navy Oversized|
|e83aa3|32|Black Straight Jeans - Womens|1|3|8|Womens|Jeans|Black Straight|
|e31d39|10|Cream Relaxed Jeans - Womens|1|3|9|Womens|Jeans|Cream Relaxed|
|d5e9a6|23|Khaki Suit Jacket - Womens|1|4|10|Womens|Jacket|Khaki Suit|
|72f5d4|19|Indigo Rain Jacket - Womens|1|4|11|Womens|Jacket|Indigo Rain|
|9ec847|54|Grey Fashion Jacket - Womens|1|4|12|Womens|Jacket|Grey Fashion|
|5d267b|40|White Tee Shirt - Mens|2|5|13|Mens|Shirt|White Tee|
|c8d436|10|Teal Button Up Shirt - Mens|2|5|14|Mens|Shirt|Teal Button Up|
|2a2353|57|Blue Polo Shirt - Mens|2|5|15|Mens|Shirt|Blue Polo|
|f084eb|36|Navy Solid Socks - Mens|2|6|16|Mens|Socks|Navy Solid|


**Table 2: `sales`**

|prod_id|qty|price|discount|member|txn_id|start_txn_time|
|:----|:----|:----|:----|:----|:----|:----|
|c4a632|4|13|17|true|54f307|2021-02-13T01:59:43.296Z|
|5d267b|4|40|17|true|54f307|2021-02-13T01:59:43.296Z|
|b9a74d|4|17|17|true|54f307|2021-02-13T01:59:43.296Z|
|2feb6b|2|29|17|true|54f307|2021-02-13T01:59:43.296Z|
|c4a632|5|13|21|true|26cc98|2021-01-19T01:39:00.345Z|
|e31d39|2|10|21|true|26cc98|2021-01-19T01:39:00.345Z|
|72f5d4|3|19|21|true|26cc98|2021-01-19T01:39:00.345Z|
|2a2353|3|57|21|true|26cc98|2021-01-19T01:39:00.345Z|
|f084eb|3|36|21|true|26cc98|2021-01-19T01:39:00.345Z|
|c4a632|1|13|21|false|ef648d|2021-01-27T02:18:17.164Z|

**Table 3: `product_hierarchy`**

|id|parent_id|level_text|level_name|
|:----|:----|:----|:----|
|1|null|Womens|Category|
|2|null|Mens|Category|
|3|1|Jeans|Segment|
|4|1|Jacket|Segment|
|5|2|Shirt|Segment|
|6|2|Socks|Segment|
|7|3|Navy Oversized|Style|
|8|3|Black Straight|Style|
|9|3|Cream Relaxed|Style|
|10|4|Khaki Suit|Style|

**Table 4: `product_prices`**

|id|product_id|price|
|:----|:----|:----|
|7|c4a632|13|
|8|e83aa3|32|
|9|e31d39|10|
|10|d5e9a6|23|
|11|72f5d4|19|
|12|9ec847|54|
|13|5d267b|40|
|14|c8d436|10|
|15|2a2353|57|
|16|f084eb|36|

***

## Key Questions & Analysis

Please copy the code in *sql file* and put in the Query SQL area through the link below - [DB Fiddle](https://www.db-fiddle.com/f/dkhULDEjGib3K58MvDjYJr/8) to get the results of the code running PostgreSQL with data: 

For my profile and contact: [LinkedIn](https://fi.linkedin.com/in/caoeddi).

### 📊 Part A - High Level Sales Analysis

**A-1. What was the total quantity sold for all products?**

```sql
SELECT	p.product_name,
		SUM(s.qty) AS total_quantity
FROM	balanced_tree.sales s
INNER JOIN balanced_tree.product_details p
	ON p.product_id = s.prod_id
GROUP BY p.product_name
ORDER BY 2 desc
;
```

**📌📌📌**

|product_name|total_quantity|
|:----|:----|
|Grey Fashion Jacket - Womens|3876|
|Navy Oversized Jeans - Womens|3856|
|Blue Polo Shirt - Mens|3819|
|White Tee Shirt - Mens|3800|
|Navy Solid Socks - Mens|3792|
|Black Straight Jeans - Womens|3786|
|Pink Fluro Polkadot Socks - Mens|3770|
|Indigo Rain Jacket - Womens|3757|
|Khaki Suit Jacket - Womens|3752|
|Cream Relaxed Jeans - Womens|3707|
|White Striped Socks - Mens|3655|
|Teal Button Up Shirt - Mens|3646|

***

**A-2. What is the total generated revenue for all products before discounts?**

```sql
SELECT	p.product_name,
		SUM(s.qty*s.price) AS total_generated_revenue
FROM	balanced_tree.sales s
INNER JOIN balanced_tree.product_details p
	ON p.product_id = s.prod_id
GROUP BY p.product_name
ORDER BY 2 desc 
;
```

**📌📌📌**

|product_name|total_generated_revenue|
|:----|:----|
|Blue Polo Shirt - Mens|217683|
|Grey Fashion Jacket - Womens|209304|
|White Tee Shirt - Mens|152000|
|Navy Solid Socks - Mens|136512|
|Black Straight Jeans - Womens|121152|
|Pink Fluro Polkadot Socks - Mens|109330|
|Khaki Suit Jacket - Womens|86296|
|Indigo Rain Jacket - Womens|71383|
|White Striped Socks - Mens|62135|
|Navy Oversized Jeans - Womens|50128|
|Cream Relaxed Jeans - Womens|37070|
|Teal Button Up Shirt - Mens|36460|

***

**A-3. What was the total discount amount for all products?**

```sql
SELECT	ROUND(SUM(s.qty*s.price*s.discount*1.0/100.0), 2) AS total_discount_amount,
		SUM(s.qty*s.price) AS total_revenue,
        ROUND( SUM(s.qty*s.price*s.discount*1.0/100.0)/SUM(s.qty*s.price)*100.0 , 2) AS discount_rate
        
FROM	balanced_tree.sales s
;
```

**📌📌📌**

|total_discount_amount|total_revenue|discount_rate|
|:----|:----|:----|
|156229.14|1289453|12.12|

***

### 📊 Part B - Transaction Analysis

**B-1. How many unique transactions were there?**

```sql
SELECT 	COUNT(DISTINCT s.txn_id) AS number_transactions
FROM	balanced_tree.sales  s
;
```

**📌📌📌**

|number_transactions|
|:----|
|2500|

***

**2. What is the average unique products purchased in each transaction?**

```sql
SELECT 	COUNT(s.prod_id) AS total_unique_products,
        COUNT(DISTINCT s.txn_id) AS number_transactions,
        ROUND(COUNT(s.prod_id)*1.0 / COUNT(DISTINCT s.txn_id) * 1.0, 2) AS avg_unique_product
        
FROM	balanced_tree.sales s
;
```

**📌📌📌**

|total_unique_products|number_transactions|avg_unique_product|
|:----|:----|:----|
|15095|2500|6.04|

***

**B-3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?**

```sql
WITH CTE_revenue AS (
SELECT	s.txn_id,
  		SUM(s.qty*s.price) AS revenue_eachtrans
  
FROM	balanced_tree.sales s
GROUP BY s.txn_id
)

SELECT	ROUND(AVG(r.revenue_eachtrans),2) AS avg_revenue_trans,
        percentile_cont(0.25) WITHIN GROUP(ORDER BY r.revenue_eachtrans) AS percentile25_revenue_eachtrans,
        percentile_cont(0.5) WITHIN GROUP(ORDER BY r.revenue_eachtrans) AS percentile50_revenue_eachtrans,
        percentile_cont(0.75) WITHIN GROUP(ORDER BY r.revenue_eachtrans) AS percentile75_revenue_eachtrans
        
FROM	CTE_revenue r
;
```

**📌📌📌**

|avg_revenue_trans|percentile25_revenue_eachtrans|percentile50_revenue_eachtrans|percentile75_revenue_eachtrans|
|:----|:----|:----|:----|
|515.78|375.75|509.5|647|

***

**B-4. What is the average discount value per transaction?**

```sql
WITH CTE_discount AS (
SELECT	s.txn_id,
  		SUM(s.qty*s.price*s.discount*1.0/100.0) AS discount_eachtrans
  
FROM	balanced_tree.sales s
GROUP BY s.txn_id
)

SELECT	ROUND(AVG(d.discount_eachtrans),2) AS avg_discount_trans,
        percentile_cont(0.25) WITHIN GROUP(ORDER BY d.discount_eachtrans) AS percentile25_discount_eachtrans,
        percentile_cont(0.5) WITHIN GROUP(ORDER BY d.discount_eachtrans) AS percentile50_discount_eachtrans,
        percentile_cont(0.75) WITHIN GROUP(ORDER BY d.discount_eachtrans) AS percentile75_discount_eachtrans
        
FROM	CTE_discount d
;
```

**📌📌📌**

|avg_discount_trans|percentile25_discount_eachtrans|percentile50_discount_eachtrans|percentile75_discount_eachtrans|
|:----|:----|:----|:----|
|62.49|24.9975|54.675|91.375|

**B-5. What is the percentage split of all transactions for members vs non-members?**

```sql
SELECT	s.member,
		COUNT(DISTINCT s.txn_id) AS number_transactions,
        ROUND(COUNT(DISTINCT s.txn_id)*1.0/(SELECT COUNT(DISTINCT t.txn_id) FROM balanced_tree.sales t)*100.0, 2) AS percentage_member_split 
        
FROM	balanced_tree.sales s
GROUP BY s.member
;
```

**📌📌📌**

Members have a transaction count at approx. 60% compared to non-members who account for only 40% of the transactions.

|member|number_transactions|percentage_member_split|
|:----|:----|:----|
|false|995|39.80|
|true|1505|60.20|

***

**B-6. What is the average revenue for member transactions and non-member transactions?**

```sql
WITH CTE_revenue AS (
    SELECT	s.member,
            s.txn_id,
            SUM(s.qty*s.price) AS revenue_eachtrans

    FROM	balanced_tree.sales s
    GROUP BY s.member, s.txn_id
)

SELECT	r.member,
		ROUND(AVG(r.revenue_eachtrans),2) AS avg_revenue_trans
        
FROM	CTE_revenue r
GROUP BY r.member
;
```

**📌📌📌**

The average revenue per transaction for members is about $1.23 higher than non-members.

|member|avg_revenue_trans|
|:----|:----|
|false|515.04|
|true|516.27|

***

### 📊 Part C - Product Analysis

**C-1. What are the top 3 products by total revenue before discount?**

```sql
SELECT 	s.prod_id,
		p.product_name,
		SUM(s.price * s.qty) AS revenue
FROM	balanced_tree.sales s
INNER JOIN balanced_tree.product_details p
	ON	p.product_id = s.prod_id
GROUP BY s.prod_id, p.product_name
ORDER BY	3 desc
LIMIT 3
;
```

**📌📌📌**

|prod_id|product_name|total_revenue|
|:----|:----|:----|
|2a2353|Blue Polo Shirt - Mens|217683|
|9ec847|Grey Fashion Jacket - Womens|209304|
|5d267b|White Tee Shirt - Mens|152000|

***

**C-2. What is the total quantity, revenue and discount for each segment?**

```sql
SELECT 	pd.segment_id,
		pd.segment_name,
		SUM(s.qty) AS total_quantity,
		SUM(s.price * s.qty) AS total_revenue,
        SUM(s.price*s.qty*s.discount*0.01) AS total_discount
        
FROM	balanced_tree.sales s
INNER JOIN balanced_tree.product_details pd
	ON	pd.product_id = s.prod_id
GROUP BY pd.segment_id,	 pd.segment_name
ORDER BY	1,2
;
```

**📌📌📌**

|segment_id|segment_name|total_quantity|total_revenue|total_discount|
|:----|:----|:----|:----|:----|
|3|Jeans|11349|208350|25343.97|
|4|Jacket|11385|366983|44277.46|
|5|Shirt|11265|406143|49594.27|
|6|Socks|11217|307977|37013.44|

***

**C-3. What is the top selling product for each segment?**

```sql
WITH CTE_sellingproduct AS (
SELECT 	pd.segment_id,
		pd.segment_name,
        s.prod_id, pd.product_name,
		SUM(s.qty) AS total_quantity,
		SUM(s.price * s.qty) AS total_revenue,
        SUM(s.price*s.qty*s.discount*0.01) AS total_discount
        
FROM	balanced_tree.sales s
INNER JOIN balanced_tree.product_details pd
	ON	pd.product_id = s.prod_id
GROUP BY pd.segment_id, pd.segment_name,
		 s.prod_id, pd.product_name
)

SELECT 	s.*,
		(ROW_NUMBER() OVER (PARTITION BY s.segment_id, s.segment_name
		 ORDER BY s.total_revenue)) AS rn
         
FROM CTE_sellingproduct s
ORDER BY rn, s.segment_id asc
LIMIT 4
;
```

**📌📌📌**

|segment_id|segment_name|prod_id|product_name|total_quantity|total_revenue|total_discount|rn|
|:----|:----|:----|:----|:----|:----|:----|:----|
|3|Jeans|e31d39|Cream Relaxed Jeans - Womens|3707|37070|4463.40|1|
|4|Jacket|72f5d4|Indigo Rain Jacket - Womens|3757|71383|8642.53|1|
|5|Shirt|c8d436|Teal Button Up Shirt - Mens|3646|36460|4397.60|1|
|6|Socks|b9a74d|White Striped Socks - Mens|3655|62135|7410.81|1|

***

**C-4. What is the total quantity, revenue and discount for each category?**

```sql
SELECT 	pd.category_id,
		pd.category_name,
		SUM(s.qty) AS total_quantity,
		SUM(s.price * s.qty) AS total_revenue,
        SUM(s.price*s.qty*s.discount*0.01) AS total_discount
        
FROM	balanced_tree.sales s
INNER JOIN balanced_tree.product_details pd
	ON	pd.product_id = s.prod_id
GROUP BY pd.category_id,
		 pd.category_name
ORDER BY	1,2
;
```

**📌📌📌**

|category_id|category_name|total_quantity|total_revenue|total_discount|
|:----|:----|:----|:----|:----|
|1|Womens|22734|575333|69621.43|
|2|Mens|22482|714120|86607.71|

***

**C-5. What is the top selling product for each category?**

```sql
WITH CTE_sellingproduct AS (
    SELECT 	pd.category_id,
            pd.category_name,
            s.prod_id, pd.product_name,
            SUM(s.qty) AS total_quantity,
            SUM(s.price * s.qty) AS total_revenue,
            SUM(s.price*s.qty*s.discount*0.01) AS total_discount

    FROM	balanced_tree.sales s
    INNER JOIN balanced_tree.product_details pd
        ON	pd.product_id = s.prod_id
    GROUP BY pd.category_id,
             pd.category_name,
             s.prod_id, pd.product_name
    )

SELECT 	s.*,
		(ROW_NUMBER() OVER (PARTITION BY s.category_id,
		 s.category_name  ORDER BY s.total_revenue)) AS rn
         
FROM 	CTE_sellingproduct s
ORDER BY rn, s.category_id,	 s.category_name asc
LIMIT 2
;
```

**📌📌📌**

|category_id|category_name|prod_id|product_name|total_quantity|total_revenue|total_discount|rn|
|:----|:----|:----|:----|:----|:----|:----|:----|:----|:----|
|1|Womens|e31d39|Cream Relaxed Jeans - Womens|3707|37070|4463.40|1|
|2|Mens|c8d436|Teal Button Up Shirt - Mens|3646|36460|4397.60|1|

***

**C-6. What is the percentage split of revenue by product for each segment?**

```sql
WITH CTE_product_revenue AS (
    SELECT	pd.segment_id, pd.segment_name,
            pd.product_id, pd.product_name,
            SUM(s.price*s.qty) AS revenue_product

    FROM	balanced_tree.sales  s
    INNER JOIN balanced_tree.product_details pd
        ON pd.product_id = s.prod_id       
    GROUP BY pd.segment_id, pd.segment_name,
                pd.product_id, pd.product_name
    ORDER BY pd.segment_id, pd.segment_name,
                pd.product_id, pd.product_name
    )

SELECT	cte.segment_id, cte.segment_name,
		cte.product_id, cte.product_name,
        cte.revenue_product,
        SUM(cte.revenue_product) OVER (PARTITION BY cte.segment_id) AS revenue_segment,
        ROUND(cte.revenue_product*1.0/(SUM(cte.revenue_product) OVER (PARTITION BY cte.segment_id) ) * 100.0, 2) AS percentage_split_segment
        
FROM	CTE_product_revenue cte
;
```

**📌📌📌**

segment_id 	segment_name 	product_id 	product_name 	revenue_product 	revenue_segment 	percentage_split_segment
3 	Jeans 	c4a632 	Navy Oversized Jeans - Womens 	50128 	208350 	24.06
3 	Jeans 	e31d39 	Cream Relaxed Jeans - Womens 	37070 	208350 	17.79
3 	Jeans 	e83aa3 	Black Straight Jeans - Womens 	121152 	208350 	58.15
4 	Jacket 	72f5d4 	Indigo Rain Jacket - Womens 	71383 	366983 	19.45
4 	Jacket 	9ec847 	Grey Fashion Jacket - Womens 	209304 	366983 	57.03
4 	Jacket 	d5e9a6 	Khaki Suit Jacket - Womens 	86296 	366983 	23.51
5 	Shirt 	2a2353 	Blue Polo Shirt - Mens 	217683 	406143 	53.60
5 	Shirt 	5d267b 	White Tee Shirt - Mens 	152000 	406143 	37.43
5 	Shirt 	c8d436 	Teal Button Up Shirt - Mens 	36460 	406143 	8.98
6 	Socks 	2feb6b 	Pink Fluro Polkadot Socks - Mens 	109330 	307977 	35.50
6 	Socks 	b9a74d 	White Striped Socks - Mens 	62135 	307977 	20.18
6 	Socks 	f084eb 	Navy Solid Socks - Mens 	136512 	307977 	44.33

***

**C-7. What is the percentage split of revenue by segment for each category?**

```sql
WITH CTE_segment_revenue AS (
    SELECT	pd.category_id, pd.category_name,
  			pd.segment_id, pd.segment_name,
            SUM(s.price*s.qty) AS revenue_segment

    FROM	balanced_tree.sales  s
    INNER JOIN balanced_tree.product_details pd
        ON pd.product_id = s.prod_id       
    GROUP BY   	pd.category_id, pd.category_name,										pd.segment_id, pd.segment_name

    ORDER BY 	pd.category_id, pd.category_name,										pd.segment_id, pd.segment_name
    )

SELECT	cte.category_id, cte.category_name,							
		cte.segment_id, cte.segment_name,
        cte.revenue_segment,
        SUM(cte.revenue_segment) OVER (PARTITION BY cte.category_id) AS revenue_category,
        ROUND(cte.revenue_segment*1.0/(SUM(cte.revenue_segment) OVER (PARTITION BY cte.category_id) ) * 100.0, 2) AS percentage_split_category
        
FROM	CTE_segment_revenue cte
;
```

**📌📌📌**

category_id 	category_name 	segment_id 	segment_name 	revenue_segment 	revenue_category 	percentage_split_category
1 	Womens 	3 	Jeans 	208350 	575333 	36.21
1 	Womens 	4 	Jacket 	366983 	575333 	63.79
2 	Mens 	5 	Shirt 	406143 	714120 	56.87
2 	Mens 	6 	Socks 	307977 	714120 	43.13

***

**C-8. What is the percentage split of total revenue by category?**

```sql
SELECT 	pd.category_id,
		pd.category_name,
		SUM(s.price * s.qty) AS category_revenue,
        (SELECT SUM(t.price * t.qty) FROM balanced_tree.sales t) AS total_revenue,
        ROUND(SUM(s.price * s.qty)*1.0 / (SELECT SUM(t.price * t.qty) FROM balanced_tree.sales t)*100.0 , 2) AS percentage_split_category
        
FROM	balanced_tree.sales s
INNER JOIN balanced_tree.product_details pd
	ON	pd.product_id = s.prod_id
GROUP BY pd.category_id,
		 pd.category_name
;
```

**📌📌📌**

category_id 	category_name 	category_revenue 	total_revenue 	percentage_split_category
2 	Mens 	714120 	1289453 	55.38
1 	Womens 	575333 	1289453 	44.62

***

**C-9. What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)**

```sql
SELECT	s.prod_id, pd.product_name,
		COUNT(DISTINCT s.txn_id) AS transactions_each_product,
        (SELECT COUNT(DISTINCT s.txn_id) FROM balanced_tree.sales s) AS total_transactions,
        ROUND(COUNT(DISTINCT s.txn_id)*1.0/(SELECT COUNT(DISTINCT s.txn_id) FROM balanced_tree.sales s)*100.0 , 2) AS penetration_product,
        ROW_number() OVER() AS rn

FROM	balanced_tree.sales s
INNER JOIN balanced_tree.product_details pd
	ON pd.product_id = s.prod_id
GROUP BY s.prod_id, pd.product_name
;
```

**📌📌📌**

prod_id 	product_name 	transactions_each_product 	total_transactions 	penetration_product 	rn
2a2353 	Blue Polo Shirt - Mens 	1268 	2500 	50.72 	1
2feb6b 	Pink Fluro Polkadot Socks - Mens 	1258 	2500 	50.32 	2
5d267b 	White Tee Shirt - Mens 	1268 	2500 	50.72 	3
72f5d4 	Indigo Rain Jacket - Womens 	1250 	2500 	50.00 	4
9ec847 	Grey Fashion Jacket - Womens 	1275 	2500 	51.00 	5
b9a74d 	White Striped Socks - Mens 	1243 	2500 	49.72 	6
c4a632 	Navy Oversized Jeans - Womens 	1274 	2500 	50.96 	7
c8d436 	Teal Button Up Shirt - Mens 	1242 	2500 	49.68 	8
d5e9a6 	Khaki Suit Jacket - Womens 	1247 	2500 	49.88 	9
e31d39 	Cream Relaxed Jeans - Womens 	1243 	2500 	49.72 	10
e83aa3 	Black Straight Jeans - Womens 	1246 	2500 	49.84 	11
f084eb 	Navy Solid Socks - Mens 	1281 	2500 	51.24 	12

***

**C-10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?**

```sql

;
```

**📌📌📌**


***

### ☑️☑️☑️ Reporting Challenge

Write a single SQL script that combines all of the previous questions into a scheduled report that the Balanced Tree team can run at the beginning of each month to calculate the previous month’s values.

Imagine that the Chief Financial Officer (which is also Danny) has asked for all of these questions at the end of every month.

He first wants you to generate the data for January only - but then he also wants you to demonstrate that you can easily run the samne analysis for February without many changes (if at all).

Feel free to split up your final outputs into as many tables as you need - but be sure to explicitly reference which table outputs relate to which question for full marks :)

```sql

;
```


***

### 💡💡💡 Bonus Challenge

Use a single SQL query to transform the `product_hierarchy` and `product_prices` datasets to the `product_details` table.

Hint: you may want to consider using a recursive CTE to solve this problem!

***

```sql

;
```

