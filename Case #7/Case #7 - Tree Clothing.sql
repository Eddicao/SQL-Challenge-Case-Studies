/***
Please copy the code below and put in the Query SQL area through the link below - DB Fiddle
to get the results of the code running PostgreSQL with data:
https://www.db-fiddle.com/f/dkhULDEjGib3K58MvDjYJr/8

Remarked Sunday 30 June 2024 - CASE STUDY #7 - Balanced Tree - Tree clothing

***/

/*************************** CASE STUDY QUESTIONS:

The following questions can be considered key business questions and metrics that the Balanced Tree team requires for their monthly reports.

Each question can be answered using a single query - but as you are writing the SQL to solve each individual problem, keep in mind how you would generate all of these metrics in a single SQL script which the Balanced Tree team can run each month.

****************************/

/************** Part A - High Level Sales Analysis *****************************/

-- 1. What was the total quantity sold for all products?

SELECT	p.product_name,
		SUM(s.qty) AS total_quantity
FROM	balanced_tree.sales s
INNER JOIN balanced_tree.product_details p
	ON p.product_id = s.prod_id
GROUP BY p.product_name
ORDER BY 2 desc
;

-- 2. What is the total generated revenue for all products before discounts?

SELECT	p.product_name,
		SUM(s.qty*s.price) AS total_generated_revenue
FROM	balanced_tree.sales s
INNER JOIN balanced_tree.product_details p
	ON p.product_id = s.prod_id
GROUP BY p.product_name
ORDER BY 2 desc 
;

-- 3. What was the total discount amount for all products?
   
SELECT	ROUND(SUM(s.qty*s.price*s.discount*1.0/100.0), 2) AS total_discount_amount,
		SUM(s.qty*s.price) AS total_revenue,
        ROUND( SUM(s.qty*s.price*s.discount*1.0/100.0)/SUM(s.qty*s.price)*100.0 , 2) AS discount_rate
        
FROM	balanced_tree.sales s
;

 /**************** Part B - Transaction Analysis *****************************/
 
-- 1. How many unique transactions were there?

SELECT 	COUNT(DISTINCT s.txn_id) AS number_transactions
FROM	balanced_tree.sales  s
;

-- 2. What is the average unique products purchased in each transaction?
--- unique product -- here are different kind of products

SELECT 	COUNT(s.prod_id) AS total_unique_products,
        COUNT(DISTINCT s.txn_id) AS number_transactions,
        ROUND(COUNT(s.prod_id)*1.0 / COUNT(DISTINCT s.txn_id) * 1.0, 2) AS avg_unique_product
        
FROM	balanced_tree.sales s
;

-- 3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?

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

-- 4. What is the average discount value per transaction?
              
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
              
-- 5. What is the percentage split of all transactions for members vs non-members?
              
SELECT	s.member,
		COUNT(DISTINCT s.txn_id) AS number_transactions,
        ROUND(COUNT(DISTINCT s.txn_id)*1.0/(SELECT COUNT(DISTINCT t.txn_id) FROM balanced_tree.sales t)*100.0, 2) AS percentage_member_split 
        
FROM	balanced_tree.sales s
GROUP BY s.member
;
              
-- 6. What is the average revenue for member transactions and non-member transactions?

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

/************************* Part C - Product Analysis *********************************/

-- 1. What are the top 3 products by total revenue before discount?

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

-- 2. What is the total quantity, revenue and discount for each segment?

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

-- 3. What is the top selling product for each segment?

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

-- 4. What is the total quantity, revenue and discount for each category?

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

-- 5. What is the top selling product for each category?
----- between men & women

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

-- 6. What is the percentage split of revenue by product for each segment?
---- Assumingly the revenue generated before applying the discount

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
    ),
    
CTE_segment_revenue AS (
    SELECT	pd.segment_id, pd.segment_name,
            SUM(s.price*s.qty) AS revenue_segment

    FROM	balanced_tree.sales  s
    INNER JOIN balanced_tree.product_details pd
        ON pd.product_id = s.prod_id
    GROUP BY pd.segment_id, pd.segment_name
    ORDER BY pd.segment_id, pd.segment_name
    )
    
SELECT	sr.segment_id, sr.segment_name,
		pr.product_id, pr.product_name,
        sr.revenue_segment,
        pr.revenue_product,
        ROUND(pr.revenue_product*1.0/sr.revenue_segment*100.0 , 2) AS percentage_split
		
FROM  	CTE_segment_revenue 	sr
INNER JOIN CTE_product_revenue	pr
	ON sr.segment_id = pr.segment_id
; 

---- The below code runs faster with 18ms compared to 24ms (the above code) - also a simpler code
WITH CTE_product_revenue AS (
    SELECT	pd.segment_id, pd.segment_name,
            pd.product_id, pd.product_name,
            SUM(s.price*s.qty) AS revenue_product

    FROM	balanced_tree.sales  s
    INNER JOIN balanced_tree.product_details pd
        ON pd.product_id = s.prod_id       
    GROUP BY    pd.segment_id, pd.segment_name,
                pd.product_id, pd.product_name
    ORDER BY    pd.segment_id, pd.segment_name,
                pd.product_id, pd.product_name
    )

SELECT	cte.segment_id, cte.segment_name,
		cte.product_id, cte.product_name,
        cte.revenue_product,
        SUM(cte.revenue_product) OVER (PARTITION BY cte.segment_id) AS revenue_segment,
        ROUND(cte.revenue_product*1.0/(SUM(cte.revenue_product) OVER (PARTITION BY cte.segment_id) ) * 100.0, 2) AS percentage_split_segment
        
FROM	CTE_product_revenue cte
;

-- 7. What is the percentage split of revenue by segment for each category?

WITH CTE_segment_revenue AS (
    SELECT	pd.category_id, pd.category_name,
  			pd.segment_id, pd.segment_name,
            SUM(s.price*s.qty) AS revenue_segment

    FROM	balanced_tree.sales  s
    INNER JOIN balanced_tree.product_details pd
        ON pd.product_id = s.prod_id       
    GROUP BY   	pd.category_id, pd.category_name,										
                pd.segment_id, pd.segment_name

    ORDER BY 	pd.category_id, pd.category_name,										
                pd.segment_id, pd.segment_name
    )

SELECT	cte.category_id, cte.category_name,							
		cte.segment_id, cte.segment_name,
        cte.revenue_segment,
        SUM(cte.revenue_segment) OVER (PARTITION BY cte.category_id) AS revenue_category,
        ROUND(cte.revenue_segment*1.0/(SUM(cte.revenue_segment) OVER (PARTITION BY cte.category_id) ) * 100.0, 2) AS percentage_split_category
        
FROM	CTE_segment_revenue cte

;

-- 8. What is the percentage split of total revenue by category?

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

-- 9. What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)

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

-- 10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?  --- not yet handled

WITH CTE_products AS (
    SELECT 	s.txn_id,
  			s.prod_id,
            COUNT(*) OVER (PARTITION BY s.txn_id) as product_in_txn
    FROM 	balanced_tree.sales s
)

SELECT 	COUNT(DISTINCT p.txn_id) AS transactions

FROM	CTE_products p
WHERE 	p.product_in_txn > 2
;


WITH CTE_combos AS 
     ( SELECT s.txn_id 
            , STRING_AGG( s.prod_id, ',' ORDER BY s.prod_id ASC ) AS products 
       FROM balanced_tree.sales s 
       GROUP BY s.txn_id 
     )
     
SELECT products 
     , COUNT(*) AS how_often 
  FROM CTE_combos 
GROUP BY products 
ORDER BY how_often DESC
LIMIT 20
;
 


--- use recursive CTE/ Query
/*
with recursive CTE_recur(txn_id, length, combo, lastitem) as (
  SELECT s.txn_id, 1, CAST(s.prod_id as VARCHAR(250)) , s.prod_id 
  	from balanced_tree.sales s
  UNION ALL 
  SELECT (r.txn_id), (length)+1, STRING_AGG(',', s.prod_id  ORDER BY s.prod_id ASC ), s.prod_id
    from CTE_recur r
    JOIN balanced_tree.sales s
      on s.txn_id = r.txn_id
     and s.prod_id > r.lastitem
   where r.length < 4
)

SELECT length, combo, count(*) frequency
  FROM CTE_recur
 group by length, combo
 order by frequency desc
     , length desc
     , combo;
*/

--- CTE recursive to list the Fibonaci
with recursive workingTable ( fibNum, NextNumber, index1)	as
(select 0,1,1
union all
select fibNum+nextNumber,fibNUm,index1+1
from workingTable
where index1<20)

select fibNum from workingTable as fib
;


/*********************** Part C - Reporting Challenge
Write a single SQL script that combines all of the previous questions into a scheduled report that the Balanced Tree team can run at the beginning of each month to calculate the previous month’s values.

    Imagine that the Chief Financial Officer - CFO (which is also Danny) has asked for all of these questions at the end of every month.
    He first wants you to generate the data for January only - but then he also wants you to demonstrate that you can easily run the samne analysis for February without many changes (if at all).
    Feel free to split up your final outputs into as many tables as you need - but be sure to explicitly reference which table outputs relate to which question for full marks :)

*************************/

WITH CTE_sales_month AS (
    SELECT 	s.*,
            date_part('month', s.start_txn_time) as txn_month
    FROM	balanced_tree.sales s
	)

SELECT 	sm.txn_month,
		COUNT(DISTINCT sm.txn_id) AS month_transactions
FROM 	CTE_sales_month sm
--WHERE	sm.txn_month = 1
GROUP BY sm.txn_month

;


/*********************** Part D - Bonus Challenge ***********************************/

-- Use a single SQL query to transform the product_hierarchy and product_prices datasets to the product_details table. Hint: you may want to consider using a recursive CTE to solve this problem!

SELECT *
FROM balanced_tree.product_details pd
;
WITH CTE_product_h1 AS (
    SELECT 	pp.id as style_id,
  			ph.parent_id as segment_id,
  			pp.product_id,
            pp.price,
            ph.level_text as product_name,
            ph.level_name

    FROM	balanced_tree.product_prices pp
    INNER JOIN balanced_tree.product_hierarchy ph
        ON 	pp.id=ph.id
	)

SELECT 	cte.*
 --       ph.level_text as next_name
		
FROM CTE_product_h1 cte
--INNER JOIN balanced_tree.product_hierarchy ph
--    ON 	cte.style_id=ph.parent_id